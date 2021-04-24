<template>
  <div>
    <h3>StudyMaterials</h3>
    <div v-for="(studymaterial, index) in studymaterials" :key="studymaterial.id">
      <img :src="studymaterial.image_url"  width="200"/>
      <div>タイトル：{{studymaterial.title}}</div>
      <button @click="toggleCompleteStatus(studymaterial, index)">
        {{ studymaterial.is_completed ? '学習中' : '完了' }}
      </button>
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
  methods: {
    toggleCompleteStatus(studymaterial, index){
      axios
        .patch(
          '/api/v1/study_materials/' + studymaterial.id + '/is_complete',
          {
            is_completed: !studymaterial.is_completed
          },
          {
            headers: this.authTokens
          }
        )
        .then(response => {
          this.studymaterials[index].is_completed = !studymaterial.is_completed
          console.log(response.data.data.is_completed);
          console.log(this.studymaterials[index])
        })
        .catch(error => {
          console.log(error);
        });
    }
  },
  created() {
    axios
      .get('/api/v1/study_materials', {
        headers: this.authTokens
      })
      .then(response => {
        this.studymaterials = response.data.data;
        console.log(response);
      });
  }
}
</script>