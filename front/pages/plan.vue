<template>
  <div>
<v-row>
  <v-col cols="12" sm="6" md="6">
    <v-tabs v-model="currentItem">
      <v-tab href="#tab-search">検索</v-tab>
      <v-tab href="#tab-index">一覧</v-tab>
      <v-tab href="#tab-note">メモ</v-tab>
    </v-tabs>

    <v-tabs-items v-model="currentItem">
      <v-tab-item value="tab-search">
        <SearchStudyMaterials></SearchStudyMaterials>
      </v-tab-item>
      <v-tab-item value="tab-index">
        <IndexStudyMaterials></IndexStudyMaterials>
      </v-tab-item>
      <v-tab-item value="tab-note">
        <Note></Note>
      </v-tab-item>
    </v-tabs-items>
  </v-col>
  <v-col cols="12" sm="6" md="6">
    <MandalaChart></MandalaChart>
  </v-col>

</v-row>



  </div>
</template>
  
<script>
import IndexStudyMaterials from "../components/StudyMaterials/IndexStudyMaterials"
import SearchStudyMaterials from "../components/StudyMaterials/SearchStudyMaterials"
import MandalaChart from "../components/MandalaChart/MandalaChart"
import Note from "../components/StudyNotes/newStudyNotes.vue"

export default {
  components: {
    IndexStudyMaterials,
    SearchStudyMaterials,
    MandalaChart,
    Note,
  },
  data: () => ({
    currentItem: "tab-index",
  }),
}
</script>