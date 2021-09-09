<template>
  <v-card class="fill-height" style="min-height: 350px;">
    <v-row class="flex-column fill-height no-gutters">
      <v-col cols="auto" class="flex-shrink-1">
        <v-card-title>
          教材を追加
        </v-card-title>
        <v-card-text>
          <v-row class="no-gutters">
            <v-col cols="8">
                <TextInput
                  v-model="keyword"
                  name="キーワード"
                  label="キーワード"
                  :dense="true"
                  @focus="initSearchStatus"
                ></TextInput>
                <div style="color: #dd2c00;">
                  {{message}}
                </div>
            </v-col>
            <v-col cols="4" class="pl-4" >
              <v-btn
                text
                @click="changeSearchStatus"
              >
                検索
              </v-btn>
            </v-col>
          </v-row>
        </v-card-text>
      </v-col>
      <v-col cols="auto" class="flex-grow-1" style="position: relative;">
        <StudyMaterialList
          style="width: 100%; position: absolute; left: 0; top: 0;"
          class="pl-3"
          :studyMaterials="serchResults"
        >
          <template v-slot:btn="{studyMaterial, index}">
            <v-btn
              text
              @click="register({
                serchResult : studyMaterial,
                index: index,
              })"
            >
              登録
            </v-btn>
          </template>
          <template v-slot:default>
            <infinite-loading
              @infinite="infiniteHandler"
              v-if="SearchStatus"
            >
              <template slot="no-more">検索結果は以上です</template>
              <template slot="no-results">ヒットしませんでした</template>
            </infinite-loading>
          </template>
        </StudyMaterialList>
      </v-col>
    </v-row>
  </v-card>
</template>


<script>
import { mapActions } from "vuex";
import InfiniteLoading from 'vue-infinite-loading';
import TextInput from '../Form/BaseTextInput'
import StudyMaterialList from './StudyMaterialList'

export default {
  components: {
    TextInput,
    StudyMaterialList,
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
  methods: {
    ...mapActions('studyMaterial', ['registerStudyMaterial']),
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
            params: {
              keyword: this.keyword,
              page: this.page
            }
        })
        .then(({data}) => {
          if(data.study_materials.length || data.next){
            this.page += 1;
            this.serchResults.push(...data.study_materials)
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
      console.log("initSearchStatus")
      this.keyword = '';
      this.SearchStatus = false,
      this.page = 1;
      this.serchResults = [];
      this.message = '';
    },
    register(data){
      this.registerStudyMaterial({
        serchResult : data.serchResult,
      })
      .then(() => {
        this.serchResults.splice(data.index, 1)
      })
    },
  }
}
</script>