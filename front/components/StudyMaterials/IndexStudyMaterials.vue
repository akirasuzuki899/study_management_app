<template>
  <v-card class="fill-height" style="min-height: 350px;">
    <v-row class="flex-column flex-nowrap fill-height no-gutters">
      <v-col cols="auto" class="flex-shrink-1">
        <v-card-title>
          教材一覧
        </v-card-title>
      </v-col>
      <v-col cols="auto" class="flex-grow-1" style="position: relative;">
        <StudyMaterialList
          style="width: 100%; position: absolute; left: 0; top: 0;"
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
      </v-col>
    </v-row>
  </v-card>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import StudyMaterialList from './StudyMaterialList'

export default {
  components: {
    StudyMaterialList,
  },
  computed: {
    ...mapGetters('studyMaterial',['studyMaterials']),
  },
  methods: {
    ...mapActions('studyMaterial',['toggleCompleteStatus', 'getStudyMaterials']),
  },
  created() {
    this.getStudyMaterials()
  }
}
</script>