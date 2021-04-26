<template>
  <v-app>
    <h3>Search StudyMaterials</h3>
    <input type="text" v-model="keyword">
    <button @click="searchStudyMaterials">検索</button>

    <div v-for="(studyMaterial, index) in studyMaterials" :key="studyMaterial.id" :id="index">
      <img :src="studyMaterial.rakuten_image_url"  width="200"/>
      <div>タイトル：{{studyMaterial.title}}</div>
      <button @click="registerStudyMaterial(studyMaterial, index)">
        登録
      </button>
    </div>
  </v-app>
</template>

<script>
import axios from 'axios'
export default {
  data() {
    return {
      keyword: '',
      studyMaterials: []
    }
  },
  computed: {
    authTokens() {
      return this.$store.getters.authTokens;
    }
  },
  methods: {
    searchStudyMaterials(){
      axios
        .get('/api/v1/study_materials/search?keyword=' + this.keyword,{
            headers: this.authTokens
        })
        .then(response => {
          console.log(response.data.data);
          this.studyMaterials = response.data.data
        })
        .catch(error => {
          console.log(error);
        });
    },
    registerStudyMaterial(studyMaterial, index){
      axios
       .post('/api/v1/study_materials',
       {
         title: studyMaterial.title,
         rakuten_image_url: studyMaterial.rakuten_image_url
       },
       {
         headers: this.authTokens
       })
       .then( response => {
         console.log(response);
         this.studyMaterials.splice(index, 1);
       })
       .catch( error => {
         console.log(error);
       })
    }
  }
}
</script>