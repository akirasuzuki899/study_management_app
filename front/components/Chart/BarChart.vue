<script>
import { Bar, mixins } from 'vue-chartjs'
const { reactiveProp } = mixins

export default {
  extends: Bar,
  mixins: [reactiveProp],
  data() {
    return {
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
              }
            }],
            yAxes: [{
              stacked: true,
              ticks: {
                beginAtZero: true,
                callback: function (label, index, labels) {
                  return label + ' 時間';
                }
              }
            }],
          },
        }
    }
  },
  mounted () {
    this.renderChart(this.chartData, this.options)
  }
}
</script>