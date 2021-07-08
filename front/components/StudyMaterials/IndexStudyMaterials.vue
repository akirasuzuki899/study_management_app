<template>
  <v-card
    class="mx-auto"
    max-width="500"
  >
    <v-card-title>
      教材一覧
    </v-card-title>
    <v-card-text>
      <v-list
        :dense="true"
        :subheader="true"
        max-height="300"
        class="overflow-y-auto"
      >
        <template v-for="(item, index) in studyMaterials">

          <StudyMaterial
            :key="`material-${item.id}`"
            :studyMaterial="item"
            :index="index"
          >
            <template v-slot:btn="{studyMaterial}">
              <v-btn
                text
                @click="toggleCompleteStatus({
                  authTokens: authTokens,
                  studyMaterial: studyMaterial,
                  index: index,
                })"
              >
                {{ studyMaterial.is_completed ? '完了' : '学習中' }}
              </v-btn>
            </template>
          </StudyMaterial>

          <v-divider
            v-if="index < studyMaterials.length - 1"
            :key="`index-${index}`"
          ></v-divider>
        </template>
        <infinite-loading
          @infinite="infiniteHandler"
        >
          <template slot="no-more">{{LoadingMessage}}</template>
          <template slot="no-results">{{LoadingMessage}}</template>
        </infinite-loading>
      </v-list>
    </v-card-text>
  </v-card>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import InfiniteLoading from 'vue-infinite-loading';
import StudyMaterial from './StudyMaterial'

export default {
  components: {
    StudyMaterial,
    InfiniteLoading,
  },
  data() {
    return {
      page: 1,
    }
  },
  computed: {
    ...mapGetters('studyMaterial',['studyMaterials']),
    ...mapGetters(['authTokens']),
    LoadingMessage: function() {
      if(this.studyMaterials.length > 0){
        return '検索結果は以上です'
      } else {
        return '未実施のタスクはありません'
      }
    }
  },
  methods: {
    ...mapActions('studyMaterial',['toggleCompleteStatus', 'getStudyMaterials']),
    infiniteHandler($state) {
        this.getStudyMaterials({
          authTokens: this.authTokens,
          page: this.page
        })
        .then(({ study_materials }) => {
          console.log("data")
          console.log(study_materials)
          if(study_materials.length){
            this.page += 1;
            $state.loaded();
          } else {
            $state.complete();
          }
        })
        .catch(error => {
          console.log(error);
        });
      },
  },
}
</script>