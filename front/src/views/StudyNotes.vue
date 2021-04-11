<template>
  <v-app>
    <h3>StudyNotes</h3>
    <div v-for="studynote in studynotes" :key="studynote.id">
      <!-- <img v-bind:src="studymaterials[studynote.study_material_id].image_url"> -->
      
      <!-- <p>{{studynote.study_material}}</p> -->
      <img v-bind:src="studynote.study_material_image_url" width="200">
      <div>タイトル：{{studynote.title}}</div>
      <div>ページ数：{{studynote.page_number}}</div>
    </div>
  </v-app>
</template>

<script>
import axios from "axios";
// import newStudyNotes from "../components/StudyNotes/newStudyNotes"

export default {
  data() {
    return {
      // img: '',
      // title: '',
      // page_number: '',
      // study_material_id: '',
      studynotes: [],
      studymaterials: [],
    }
  },
  components: {
    // newStudyNotes
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
        console.log(response);
        this.studynotes = response.data.data.study_notes;
        this.studymaterials = response.data.data.study_materials;

      });
  },
}
</script>