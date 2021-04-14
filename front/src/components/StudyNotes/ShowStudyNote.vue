<template>
  <v-app>
    <h3>show study note {{id}}</h3>
    <img v-bind:src="studynote.study_material_image_url" width="200">
    <div>タイトル：{{studynote.title}}</div>
    <div>ページ数：{{studynote.page_number}}</div>
    <body v-html="content"></body>
  </v-app>
</template>

<script>
import axios from "axios";

export default {
  props: ["id"],
  data() {
    return {
      studynote: "",
      content: ""
    }
  },
  computed: {
    authTokens() {
      return this.$store.getters.authTokens;
    }
  },
  created() {
    axios
      .get('/api/v1/study_notes/' + this.id , {
        headers: this.authTokens
      })
      .then(response => {
        console.log(response);
        this.studynote = response.data.data;
        this.content = response.data.data.get_content;
      });
  },
}
</script>