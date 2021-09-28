<script>
import { Bar } from 'vue-chartjs'
export default {
  extends: Bar,
  props: {
    chartdata: {
      type: Object,
      default: undefined
    },
  },
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
  mounted () {
    this.renderChart(this.chartdata, this.options)
  }
}
</script>