<script>
import { Pie, mixins } from 'vue-chartjs'
import chartjsPluginDatalabels from 'chartjs-plugin-datalabels'
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
          },
          plugins: {
              datalabels: {
              color: '#FFFFFF',
              display: 'auto',
              formatter: (value, ctx) => {
                let sum = 0;
                let dataArr = ctx.chart.data.datasets[0].data;
                dataArr.map(data => {
                  sum += data;
                });
                let percentage = Math.round((value*100 / sum))+"%";
                return percentage;
                },
            }
          }
        },
    }
  },
  mounted () {
    this.addPlugin(chartjsPluginDatalabels)
    this.renderChart(this.chartData, this.options)
  }
}
</script>