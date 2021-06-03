<template>
  <v-app>
    <h3>Search StudyMaterials</h3>
    <p>{{this.message}}</p>
    <input type="text" v-model="keyword" @focus="initSearchStatus">
    <button @click="changeSearchStatus">検索</button>

    <div v-for="(serchResult, index) in serchResults" :key="serchResult.id" :id="index">
      <img :src="serchResult.rakuten_image_url"  width="100"/>
      <div>タイトル：{{serchResult.title}}</div>
      <button @click="registerStudyMaterial(serchResult, index)">登録</button>
    </div>
    <infinite-loading @infinite="infiniteHandler" v-if="SearchStatus"></infinite-loading>
  </v-app>
</template>

<script>
import { mapGetters } from "vuex";
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
      serchResults: []
    }
  },
  computed: {
    ...mapGetters(["authTokens"])
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
      this.$axios
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
            this.serchResults.push(...data)
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
      this.serchResults = [];
      this.message = '';
    },
    registerStudyMaterial(serchResult, index){
      this.$axios
       .post('/api/v1/study_materials',
       {
         title: serchResult.title,
         rakuten_image_url: serchResult.rakuten_image_url
       },
       {
         headers: this.authTokens
       })
       .then( response => {
         this.serchResults.splice(index, 1);
         this.$store.commit('studyMaterial/addStudyMaterials', response)
       })
       .catch( error => {
         console.log(error);
       })
    }
  }
}
</script>