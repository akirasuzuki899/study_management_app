<script>
import { Pie, mixins } from 'vue-chartjs'
import chartjsPluginDatalabels from 'chartjs-plugin-datalabels'
const { reactiveProp } = mixins
const dataHandler = reactiveProp.watch.chartData


export default {
  extends: Pie,
  data() {
    return {
        options: {
          responsive: true,
          maintainAspectRatio: false,
          legend: {
            display: false
          },
          tooltips: {
            enabled: false
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
        nodata: {
            chartdata: {
              datasets: {
                labels: ['NoData'],
                datasets: [
                  {
                    label: 'NoData',
                    backgroundColor: '#48484A',
                    data: [1]
                  }
                ]
              }
            },

            options: {
              responsive: true,
              maintainAspectRatio: false,
              legend: {
                display: false
              },
              tooltips: {
                enabled: false
              },
              animation: {
                duration: 0
              },
              elements: {
                arc: {
                    borderWidth: 0,
                }
              },
              plugins: {
                datalabels: {
                    display: false,
                }
              }
            },
        }
    }
  },
  props: {
    chartData: {
      type: Object,
      required: true,
      default: () => {}
    }
  },
  computed: {
    hasData () {
      return this.chartData.datasets[0].data.length >= 1 ? true : false
    }
  },
  watch: {
    'chartData': function(newData, oldData){
      this.hasData
        ? this.dataHandler(newData, oldData)
        : this.noDataHandler()
    }
  },
  methods: {
    noDataHandler () {
      this.renderChart(this.nodata.chartdata.datasets, this.nodata.options)
      this.$emit('chart:render')
    },
    dataHandler (newData, oldData) {
      dataHandler.bind(this)(newData, oldData)
    }
  },
  mounted () {
    this.addPlugin(chartjsPluginDatalabels)
    this.hasData
      ? this.renderChart(this.chartData, this.options)
      : this.noDataHandler()
  },
}
</script>