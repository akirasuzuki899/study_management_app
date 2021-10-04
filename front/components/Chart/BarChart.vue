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
              gridLines: {
              color: '#393939'
            },
              scaleLabel: {
                display: true,
              }
            }],
            yAxes: [{
              stacked: true,
              gridLines: {
              color: '#393939'
            },
              ticks: {
                beginAtZero: true,
                maxTicksLimit:5,
                callback: function (label, index, labels) {
                  return label + ' 時間';
                }
              }
            }],
          },
          tooltips: {
            
          }
        }
    }
  },
  mounted () {
    this.renderChart(this.chartData, this.options)
  }
}
</script>