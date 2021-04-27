<template>
  <v-app>
    <h3>Search StudyMaterials</h3>
    <p>{{this.message}}</p>
    <input type="text" v-model="keyword" @focus="initSearchStatus">
    <button @click="changeSearchStatus">検索</button>

    <div v-for="(studyMaterial, index) in studyMaterials" :key="studyMaterial.id" :id="index">
      <img :src="studyMaterial.rakuten_image_url"  width="100"/>
      <div>タイトル：{{studyMaterial.title}}</div>
      <button @click="registerStudyMaterial(studyMaterial, index)">登録</button>
    </div>
    <infinite-loading @infinite="infiniteHandler" v-if="SearchStatus"></infinite-loading>
  </v-app>
</template>

<script>
import axios from 'axios';
import InfiniteLoading from 'vue-infinite-loading';

export default {
  components: {
    InfiniteLoading,
  },
  data() {
    return {
      SearchStatus: false,
      message: '',
      page: 1,
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
    changeSearchStatus() {
      if(!this.keyword) {
        this.message = 'キーワードを入力して下さい'
        return;
      }
      this.SearchStatus = true
    },
    infiniteHandler($state) {
      axios
        .get('/api/v1/study_materials/search',{
            headers: this.authTokens,
            params: {
              keyword: this.keyword,
              page: this.page
            }
        })
        .then(({data}) => {
          console.log(data);
          if(data.length){
            this.page += 1;
            this.studyMaterials.push(...data)
            $state.loaded();
          } else {
            $state.complete();
          }
        })
        .catch(error => {
          console.log(error);
        });
    },
    initSearchStatus() {
      this.keyword = '';
      this.SearchStatus = false,
      this.page = 1;
      this.studyMaterials = [];
      this.message = '';
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