<template>
  <div>

    <v-tabs v-model="currentItem">
      <v-tab href="#tab-search">検索</v-tab>
      <v-tab href="#tab-index">一覧</v-tab>
    </v-tabs>

    <v-tabs-items v-model="currentItem">
      <v-tab-item value="tab-search">
        <SearchStudyMaterials></SearchStudyMaterials>
      </v-tab-item>
      <v-tab-item value="tab-index">
        <IndexStudyMaterials></IndexStudyMaterials>
      </v-tab-item>
    </v-tabs-items>

  </div>
</template>
  
<script>
import IndexStudyMaterials from "../components/StudyMaterials/IndexStudyMaterials"
import SearchStudyMaterials from "../components/StudyMaterials/SearchStudyMaterials"

export default {
  components: {
    IndexStudyMaterials,
    SearchStudyMaterials,
  },
  data: () => ({
    currentItem: "tab-index",
  }),
}
</script>