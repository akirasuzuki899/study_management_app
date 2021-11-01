<template>
  <v-row 
    class="flex-column flex-nowrap flex-sm-row flex-sm-wrap no-gutters fill-height"
  >
    <v-col
      id="ChartWrapper"
      cols="auto" sm="6"
      :style="{'max-width': chartWrapper.width}"
      class="pr-sm-2 flex-sm-grow-0 flex-sm-shrink-0"
      :class="{ 'pb-3' : $vuetify.breakpoint.name == 'xs' }" 
    >
      <MandalaChart
        ref="chart"
        v-show="chartDisplay"
        @item-text-changed="updateTitle"
      ></MandalaChart>
    </v-col>
    <v-col 
      cols="auto" sm="6"
      style="max-width: 100%;"
      class="pl-sm-2 flex-sm-grow-1 flex-sm-shrink-0"
    >
      <v-card class="fill-height">
        <v-row class="flex-column no-gutters fill-height overflow-hidden">
          <v-col cols="auto" class="flex-shrink-1">
            <v-tabs v-model="currentItem" background-color="#272727">
              <v-tab href="#tab-note">ノート</v-tab>
              <v-tab href="#tab-studyMaterial-index">教材一覧</v-tab>
              <v-tab href="#tab-studyMaterial-search">教材追加</v-tab>
            </v-tabs>
          </v-col>
          <v-col cols="auto" class="flex-grow-1">
            <v-tabs-items v-model="currentItem" style="height: 100%;">
              <v-tab-item value="tab-note" style="height: 100%;">
                <Note ref="note"></Note>
              </v-tab-item>
              <v-tab-item value="tab-studyMaterial-index" style="height: 100%;">
                <IndexStudyMaterials></IndexStudyMaterials>
              </v-tab-item>
              <v-tab-item value="tab-studyMaterial-search" style="height: 100%;">
                <SearchStudyMaterials></SearchStudyMaterials>
              </v-tab-item>
            </v-tabs-items>
          </v-col>
        </v-row>
      </v-card>
    </v-col>
  </v-row>
</template>
  
<script>
import IndexStudyMaterials from "../components/StudyMaterials/IndexStudyMaterials"
import SearchStudyMaterials from "../components/StudyMaterials/SearchStudyMaterials"
import Note from "../components/StudyNotes/MandalaChartNotes.vue"
import MandalaChart from "../components/MandalaChart/MandalaChart"

export default {
  components: {
    Note,
    IndexStudyMaterials,
    SearchStudyMaterials,
    MandalaChart,
  },
  data: () => ({
    currentItem: "tab-note",
    chartDisplay: false,
    chartWrapper: {
      width: undefined,
    },
    resizeObserver: undefined
  }),
  methods: {
    updateTitle(item) {
      this.$store.commit('mandalaItemNote/updateTreeViewTitle', item)
      this.$refs.note.updateMandalaItemTitle(item)
    },
    setHeight (wrapperHeight) {
      let chartToolbarHeight = this.$refs.chart.$refs.chartToolbar.offsetHeight
      this.chartWrapper.width = wrapperHeight - chartToolbarHeight + 8 + "px"  //wrapper の padding 8 px
    }
  },
  mounted(){
    let prevHeight = 0;

    this.resizeObserver = new ResizeObserver(entries => {
      
      this.chartDisplay = false
      let height = entries[0].target.offsetHeight
      this.chartDisplay = true

      if (typeof height === 'number' && height !== prevHeight) {
        prevHeight = height
        this.$nextTick(() => {
          this.setHeight(height)
         })
      }
    })
    this.resizeObserver.observe(document.getElementById("ChartWrapper")); 
  },
  destroyed(){
    this.resizeObserver.disconnect("ChartWrapper")
  }
}
</script>