<script>
import { Pie } from 'vue-chartjs'
export default {
  extends: Pie,
  props: {
    chartdata: {
      type: Object,
      default: undefined
    }
  },
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
    this.renderChart(this.chartdata, this.options)
  }
}
</script>