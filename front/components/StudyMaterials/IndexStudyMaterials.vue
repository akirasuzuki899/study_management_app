<template>
  <v-card class="fill-height" style="min-height: 350px;">
    <template v-if="loaded">
      <StudyMaterialList
        v-if="studyMaterials.length"
        style="height: 100%; width: 100%; position: absolute; left: 0; top: 0;"
        :studyMaterials="studyMaterials"
      >
        <template v-slot:btn="{studyMaterial, index}">
          <v-btn
            text
            @click="toggleCompleteStatus({
              studyMaterial: studyMaterial,
              index: index,
            })"
          >
            {{ studyMaterial.is_completed ? '完了' : '学習中' }}
          </v-btn>
        </template>
      </StudyMaterialList>

      <v-container v-else class="fill-height">
        <v-row class="align-content-center text-center fill-height">
          <v-col cols="12">
            <div class="subtitle-1">教材はありません</div>
          </v-col>
          <v-col cols="12">
            <v-btn
              color="primary"
              block
              @click="$router.push('/plan')"
            >教材を登録する</v-btn>
          </v-col>
        </v-row>
      </v-container>
    </template>

    <template v-else>
      <v-container class="fill-height">
        <v-row class="align-content-center text-center fill-height">
          <v-col cols="12">
            <v-progress-circular
              indeterminate
              color="primary"
            ></v-progress-circular>
          </v-col>
          <v-col cols="12" class="font-weight-bold">
            Loading...
          </v-col>
        </v-row>
      </v-container>
    </template>

  </v-card>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import StudyMaterialList from './StudyMaterialList'

export default {
  components: {
    StudyMaterialList,
  },
  data(){
    return {
      loaded: false,
    }
  },
  computed: {
    ...mapGetters('studyMaterial',['studyMaterials']),
  },
  methods: {
    ...mapActions('studyMaterial',['toggleCompleteStatus', 'getStudyMaterials']),
  },
  async created() {
    this.loaded = false
    await this.getStudyMaterials()
    this.loaded = true
  }
}
</script>