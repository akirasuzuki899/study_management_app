<template>
  <div>
    <h3>StudyMaterials</h3>
    <div v-for="studymaterial in studymaterials" :key="studymaterial.id">
      <div>タイトル：{{studymaterial.title}}</div>
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
    headers() {
      return this.$store.getters.headers;
    }
  },
  created() {
    axios
      .get('/api/v1/study_materials', {
        headers: this.headers
      })
      .then(response => {
        this.studymaterials = response.data.data;
        console.log(response.data.data);
      });
  }
}
</script>