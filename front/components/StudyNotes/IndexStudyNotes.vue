<template>
  <v-app>
    <h3>StudyNotes</h3>
    <div v-for="studynote in studynotes" :key="studynote.id">
      <img v-bind:src="studynote.study_material_image_url" width="200">
      <div>タイトル：{{studynote.title}}</div>
      <div>ページ数：{{studynote.page_number}}</div>
    </div>
  </v-app>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      studynotes: [],
    }
  },
  created() {
    axios
      .get('/api/v1/study_notes')
      .then(response => {
        console.log(response);
        this.studynotes = response.data.data.study_notes;
      });
  },
}
</script>