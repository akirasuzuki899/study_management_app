<template>
  <div>
    <h3>StudyNotes</h3>
    <div v-for="studynote in studynotes" :key="studynote.id">
      <div>タイトル：{{studynote.title}}</div>
    </div>
    <VueTrix @trix-attachment-add="handleAttachmentChanges" v-model="editorContent" placeholder="Enter content" localStorage/>
  </div>
</template>

<script>
import axios from "axios";
import VueTrix from "vue-trix";
import { DirectUpload } from "@rails/activestorage";
export default {
  data() {
    return {
      title: '',
      page_number: '',
      studymaterial_id: '',
      studynotes: []
    }
  },
  components: {
    VueTrix
  },
  methods: {
    handleAttachmentChanges(event) {
        // 1. get file object
      let file = event.attachment.file;
  
      // 2. upload file to remote server with FormData
      // uploadFile = (file) => {
        const upload = new DirectUpload(file, "http://localhost:3000/rails/active_storage/direct_uploads");
        console.log(upload);
        upload.create((error, blob) => {
          if(error){
            console.log(error);
          } else {
            console.log(blob);

            // 3. if upload success, set back the attachment's URL attribute
            // @param object data from remote server response data after upload.
            let attributes = {
              url: blob.path,
              href:  blob.path
            };
            console.log(attributes);
            event.attachment.setAttributes(attributes);
          }
        });
      // }
  
    }
  },
  computed: {
    authTokens() {
      return this.$store.getters.authTokens;
    }
  },
  created() {
    axios
      .get('/api/v1/study_notes', {
        headers: this.authTokens
      })
      .then(response => {
        this.studynotes = response.data.data;
        console.log(response.data.data);
      });
  }
}
</script>