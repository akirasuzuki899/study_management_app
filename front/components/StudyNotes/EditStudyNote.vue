<template>
  <div>
    <form @submit.prevent="updateNote">
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
        <VueTrix inputId="editor1" @trix-attachment-add="handleAttachmentChanges" v-model="content" placeholder="Enter content"/>    
      </div>
      <button type="submit">Commit</button>
    </form>
  </div>
</template>


<script>
import VueTrix from "vue-trix";
import { DirectUpload } from "@rails/activestorage";
const Host = this.$axios.defaults.baseURL

export default {
  props: ["id"],
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
  components: {
    VueTrix
  },
  methods: {
    handleAttachmentChanges(event) {
      if (event.attachment.file ===  undefined) return;

      // 1. get file object
      let file = event.attachment.file;
  
      // 2. upload file to remote server with FormData
      const upload = new DirectUpload(file, Host + "rails/active_storage/direct_uploads");
      upload.create((error, blob) => {
        if(error){
          console.log(error);
        } else {
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
    updateNote() {
      axios
        .patch(
          '/api/v1/study_notes/' + this.id, 
          {
            title: this.title,
            page_number: this.page_number,
            study_material_id: this.study_material_id,
            content: this.content
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
  created() {
    axios
      .get('/api/v1/study_notes/' + this.id)
      .then(response => {
        this.title = response.data.data.title;
        this.page_number = response.data.data.page_number;
        this.study_material_id = response.data.data.study_material_id;
        this.content = response.data.data.get_trix_content;
      });
    axios
      .get('/api/v1/study_materials')
      .then(response => {
        this.studymaterials = response.data.data;
      });
  },
}
</script>