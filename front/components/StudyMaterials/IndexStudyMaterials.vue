<template>
  <v-card
    class="mx-auto"
  >
    <v-card-title>
      教材一覧
    </v-card-title>
    <v-card-text>
      <StudyMaterialList
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
    </v-card-text>
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