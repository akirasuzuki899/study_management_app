<template>
  <v-app>
    <h3>StudyNotes</h3>
    <!-- <div v-for="studynote in studynotes" :key="studynote.id">
      <div>タイトル：{{studynote.title}}</div>
      <div>ページ数：{{studynote.page_number}}</div>
      <div>教材：{{studynote.studymaterial_id}}</div>
      <div>コンテンツ：{{studynote.content}}</div>
    </div> -->

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
export default {
  data() {
    return {
      title: '',
      page_number: '',
      study_material_id: '',
      content: '',
      studynotes: [],
      studymaterials: [],
      sgid: ''
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
              sgid: blob.attachable_sgid,
              ref: "figureElement"
            };
            console.log("アタッチメント")
            // console.log(event.attachment);
            // const attachment = <action-text-attachment sgid="this.sgid"></action-text-attachment>
            // element.editor.setSelectedRange([0, 0]);
            // element.editor.insertHTML("<action-text-attachment></action-text-attachment>");
            // console.log(document.getElementsByTagName('figure'));
            // console.log(document.getElementsByTagName('figure').innerHTML = "<action-text-attachment></action-text-attachment>");
            // document.getElementsByTagName('title').innerHTML = "<action-text-attachment>ssssss</action-text-attachment>";
            event.attachment.setAttributes(attributes);
          }
        });
      // }
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
      .get('/api/v1/study_notes', {
        headers: this.authTokens
      })
      .then(response => {
        this.studynotes = response.data.data.study_notes;
        this.studymaterials = response.data.data.study_materials;
        console.log(this.studymaterials);
        console.log(response);
      });
  },
}
</script>