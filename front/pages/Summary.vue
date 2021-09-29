<template>
  <div class="fill-height" style="width: 100%;">
    <v-row v-if="loaded" class="no-gutters fill-height">
        <v-col cols="12" md="6">
          <BarChart
            :chartdata="bar_chartdata" />
        </v-col>
        <v-col cols="12" md="6">
          <v-row class="no-gutters fill-height flex-column flex-nowrap flex-sm-row flex-sm-wrap flex-md-column flex-md-nowrap">
            <v-col cols="auto" sm="6" md="auto" class="flex-shrink-1 flex-sm-shrink-0 flex-md-shrink-1">
              <PieChart 
                :chartdata="pie_chartdata" />
            </v-col>
            <v-col cols="auto" sm="6" md="auto" class="flex-grow-1 flex-sm-grow-0 flex-md-grow-1" style="min-height: 200px; position: relative;">
              <StudyMaterialList
                style="width: 100%; position: absolute; left: 0; top: 0;"
                :studyMaterials="material_info" />
            </v-col>
          </v-row>
        </v-col>
    </v-row>
    <v-row v-else class="align-content-center text-center no-gutters fill-height">
      <v-col cols="12">
        <v-progress-circular
          indeterminate
          color="primary"
          class="mb-4"
        ></v-progress-circular>
      </v-col>
      <v-col cols="12" class="font-weight-bold">
        Loading...
      </v-col>
    </v-row>
  </div>

</template>

<script>
import BarChart from "../components/Chart/BarChart.vue"
import PieChart from "../components/Chart/PieChart.vue"
import StudyMaterialList from "../components/StudyMaterials/StudyMaterialList.vue"
export default {
  components: {
    BarChart,
    PieChart,
    StudyMaterialList
  },
  data(){
    return {
        loaded: false,
        bar_chartdata: null,
        pie_chartdata: null,
        material_info: null,
    }
  },
  async mounted () {
    this.loaded = false
    this.$axios
    .get('/api/v1/charts/weekly')
    .then(({ data }) => {
      console.log(data)
      this.bar_chartdata = data.bar_chartdata
      this.pie_chartdata = data.pie_chartdata
      this.material_info = data.material_info
      this.loaded = true
    })
    .catch(error => {
      console.log(error)
    })
  }
}
</script>