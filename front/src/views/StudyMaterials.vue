<template>
  <div>
    <h3>StudyMaterials</h3>
    <div v-for="studymaterial in studymaterials" :key="studymaterial.id">
      <div>タイトル：{{studymaterial.title}}</div>
      <img :src="studymaterial.image_url" />
    </div>
  </div>
</template>

<script>
import axios from "axios";
export default {
  data() {
    return {
      title: '',
      keyword: '',
      studymaterials: [],
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
        this.studymaterials = response.data.data;
        console.log(response.data.data);
      });
  }
}
</script>