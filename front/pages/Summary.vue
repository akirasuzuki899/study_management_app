<template>
  <v-row>
    <v-col>
      <div>
        <BarChart 
          v-if="loaded"
          :chartdata="chartdata"
          :options="options" />
      </div>
    </v-col>
  </v-row>
</template>

<script>
import BarChart from "../components/Chart"
export default {
  components: {
    BarChart
  },
  data(){
    return {
        loaded: false,
        chartdata: null,
        options: {
          responsive: true,
          maintainAspectRatio: false,
          legend: {
            display: false
         },
          scales: {
            xAxes: [{
              stacked: true,
              scaleLabel: {
                display: true,
                labelString: '週'
              }
            }],
            yAxes: [{
              stacked: true,
              ticks: {
                beginAtZero: true, // 0からスタートするか
                callback: function (label, index, labels) {
                  return label + ' 時間';
                }
              }
            }],
          },
        }
    }
  },
  async mounted () {
    this.loaded = false
    this.$axios
    .get('/api/v1/charts/weekly')
    .then(({ data }) => {
      console.log(data)
      this.chartdata = data.chartdata
      this.loaded = true
    })
    .catch(error => {
      console.log(error)
    })
  }
}
</script>