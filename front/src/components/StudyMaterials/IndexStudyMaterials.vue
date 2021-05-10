<template>
  <div>
    <h3>StudyMaterials</h3>
    <div v-for="(studyMaterial, index) in studyMaterials" :key="studyMaterial.id">
      <img :src="studyMaterial.image_url"  width="200"/>
      <div>タイトル：{{studyMaterial.title}}</div>
      <button @click="toggleCompleteStatus(
        { 
          authTokens: authTokens, 
          studyMaterial: studyMaterial, 
          index: index
        })"
      >
        {{ studyMaterial.is_completed ? '完了' : '学習中' }}
      </button>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";

export default {
  computed: {
    ...mapGetters(["authTokens", "studyMaterials"])
  },
  methods: {
    ...mapActions(["toggleCompleteStatus"])
  },
  created() {
    this.$store.dispatch('getStudyMaterials', this.authTokens)
  },
}
</script>