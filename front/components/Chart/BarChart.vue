<script>
import { Bar, mixins } from 'vue-chartjs'
import chartjsPluginDatalabels from 'chartjs-plugin-datalabels'
const { reactiveProp } = mixins

const totalizer = {
  id: 'totalizer',

  beforeUpdate: chart => {
    let totals = {}
    let utmost = 0

    chart.data.datasets.forEach((dataset, datasetIndex) => {
      if (chart.isDatasetVisible(datasetIndex)) {
        utmost = datasetIndex
        dataset.data.forEach((value, index) => {
          totals[index] = (totals[index] || 0) + value
        })
      }
    })

    chart.$totalizer = {
      totals: totals,
      utmost: utmost
    }
  }
}

export default {
  extends: Bar,
  mixins: [reactiveProp],
  data() {
    return {
        options: {
          layout: {
            padding: {
              top: 30
            }
          },
          responsive: true,
          maintainAspectRatio: false,
          events: [],
          legend: {
            display: false
          },
          scales: {
            xAxes: [{
              stacked: true,
              gridLines: {
                color: '#393939'
              },
              ticks: {
                fontColor: '#FFF',
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
                fontColor: '#FFF',
                callback: function (label, index, labels) {
                  return label + ' 時間';
                }
              }
            }],
          },
          plugins: {
            datalabels: {
              color: '#FFF',
              font: {
                size: 10,
              },
              textAlign: 'center',
              align: 'end',
              anchor: 'end',
              formatter: (value, ctx) => {
                const sum = ctx.chart.$totalizer.totals[ctx.dataIndex]
                if ( sum < 1 ) {
                  return `${sum*60}分`
                } else {
                  return Number.isInteger(sum)
                    ? `${sum}時間`
                    : [`${Math.floor(sum)}時間`, `${(sum - Math.floor(sum))*60}分`]
                }
              },
              display: function(ctx) {
                const total = ctx.chart.$totalizer.totals[ctx.dataIndex]
                return ctx.datasetIndex === ctx.chart.$totalizer.utmost && total !== 0
              }
            }
          },
        }
    }
  },
  mounted () {
    this.addPlugin(totalizer)
    this.addPlugin(chartjsPluginDatalabels)
    this.renderChart(this.chartData, this.options)
  }
}
</script>