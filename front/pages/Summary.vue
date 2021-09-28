<template>
  <v-row>
    <v-col cols="12">
      <div>
        <BarChart 
          v-if="loaded"
          :chartdata="bar_chartdata" />
      </div>
    </v-col>
    <v-col cols="12">
      <div>
        <PieChart 
          v-if="loaded"
          :chartdata="pie_chartdata" />
      </div>
    </v-col>
  </v-row>
</template>

<script>
import BarChart from "../components/Chart/BarChart.vue"
import PieChart from "../components/Chart/PieChart.vue"
export default {
  components: {
    BarChart,
    PieChart
  },
  data(){
    return {
        loaded: false,
        bar_chartdata: null,
        pie_chartdata: null,
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
      this.loaded = true
    })
    .catch(error => {
      console.log(error)
    })
  }
}
</script>