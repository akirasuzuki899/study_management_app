<template>
  <v-row 
    class="flex-column flex-nowrap flex-sm-row flex-sm-wrap fill-height"
    :class="{ 'no-gutters' : $vuetify.breakpoint.name == 'xs' }"
  >
    <v-col 
      cols="auto" 
      sm="6" 
      :class="{ 'pb-3' : $vuetify.breakpoint.name == 'xs' }"
    >
      <v-row class="flex-column no-gutters fill-height">
        <v-col cols="auto" class="flex-shrink-1">
          <v-tabs v-model="currentItem">
            <v-tab href="#tab-search">検索</v-tab>
            <v-tab href="#tab-index">一覧</v-tab>
          </v-tabs>
        </v-col>
        <v-col cols="auto" class="flex-grow-1">
          <v-tabs-items v-model="currentItem" style="height: 100%;">
            <v-tab-item value="tab-search" style="height: 100%;">
              <SearchStudyMaterials></SearchStudyMaterials>
            </v-tab-item>
            <v-tab-item value="tab-index" style="height: 100%;">
              <IndexStudyMaterials></IndexStudyMaterials>
            </v-tab-item>
          </v-tabs-items>
        </v-col>
      </v-row>
    </v-col>
     <v-col cols="auto" sm="6">
      <MandalaChart></MandalaChart>
    </v-col>
  </v-row>
</template>
  
<script>
import IndexStudyMaterials from "../components/StudyMaterials/IndexStudyMaterials"
import SearchStudyMaterials from "../components/StudyMaterials/SearchStudyMaterials"
import MandalaChart from "../components/MandalaChart/MandalaChart"

export default {
  components: {
    IndexStudyMaterials,
    SearchStudyMaterials,
    MandalaChart,
  },
  data: () => ({
    currentItem: "tab-index",
  }),
}
</script>