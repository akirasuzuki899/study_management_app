<template>
  <v-app>
    <h1>フォーム</h1>
    <form @submit.prevent="createNotes">
      <div>
        <label id="title">タイトル</label>
        <input v-model="title" type="text">
      </div>
      <div>
        <label>ページ数</label>
        <input v-model="page_number" type="number" min="0">
      </div>
      <div>
        <label>教材</label>
        <v-select 
          :items="studymaterials"
          item-text="title"
          item-value="id"
          v-model="study_material_id" 
        />
      </div>
      <div>
        <label>コンテンツ</label>
        <VueTrix inputId="editor1" @trix-attachment-add="handleAttachmentChanges" v-model="content" placeholder="Enter content" localStorage/>    
      </div>
      <button type="submit">Commit</button>
    </form>
  </v-app>
</template>


<script>
import axios from "axios";
import VueTrix from "vue-trix";
import { DirectUpload } from "@rails/activestorage";
const Host = 'http://localhost:3000/';

export default {
  data() {
    return {
      title: '',
      page_number: '',
      study_material_id: '',
      content: '',
      sgid: '',
      studynotes: [],
      studymaterials: [],
    }
  },
  Components: {
    VueTrix
  },
  methods: {
    handleAttachmentChanges(event) {
        // 1. get file object
      let file = event.attachment.file;
  
      // 2. upload file to remote server with FormData
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
              sgid: blob.attachable_sgid,
              url: Host + "rails/active_storage/blobs/" + blob.signed_id + "/" + blob.filename,
            };
            event.attachment.setAttributes(attributes);
          }
        });
    },
    createNotes() {
      axios
        .post(
          '/api/v1/study_notes', 
          {
            title: this.title,
            page_number: this.page_number,
            study_material_id: this.study_material_id,
            content: this.content
          },
          {
            headers: this.authTokens
          }
        )
        .then(response => {
          console.log(response);
        })
        .catch(error => {
          console.log(error);
        });
    }
  },
  computed: {
    authTokens() {
      return this.$store.getters.authTokens;
    }
  },
  created() {
    axios
      .get('/api/v1/study_materials', {
        headers: this.authTokens
      })
      .then(response => {
        console.log(response);
        this.studymaterials = response.data.data;
      });
  },
}
</script>>