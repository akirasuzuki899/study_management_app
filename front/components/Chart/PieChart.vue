<script>
import { Pie, mixins } from 'vue-chartjs'
const { reactiveProp } = mixins

export default {
  extends: Pie,
  mixins: [reactiveProp],
  data() {
    return {
        options: {
          responsive: true,
          maintainAspectRatio: false,
          legend: {
            display: false
         },
          elements: {
            arc: {
                borderWidth: 0
            }
          }
        },
    }
  },
  mounted () {
    this.renderChart(this.chartData, this.options)
  }
}
</script>