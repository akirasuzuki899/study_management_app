<script>
import { Pie } from 'vue-chartjs'
import chartjsPluginDatalabels from 'chartjs-plugin-datalabels'

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
  watch: {
    'chartData': dataHandler
  },
  mounted () {
    this.addPlugin(chartjsPluginDatalabels)
    this.renderChart(this.chartData, this.options)
  },
}





function dataHandler (newData, oldData) {
  if (this.chartData.datasets[0].data.length < 1) {
    console.log("this.chartData")
    console.log(this.chartData)
    this.renderChart(this.nodata.chartdata.datasets, this.nodata.options)
    this.$emit('chart:render')
  } else {
      if (oldData) {
        let chart = this.$data._chart

        // Get new and old DataSet Labels
        let newDatasetLabels = newData.datasets.map((dataset) => {
          return dataset.label
        })

        let oldDatasetLabels = oldData.datasets.map((dataset) => {
          return dataset.label
        })


        // Stringify 'em for easier compare
        const oldLabels = JSON.stringify(oldDatasetLabels)
        const newLabels = JSON.stringify(newDatasetLabels)

        // Check if Labels are equal and if dataset length is equal
        if (newLabels === oldLabels && oldData.datasets.length === newData.datasets.length) {
          newData.datasets.forEach((dataset, i) => {
            // Get new and old dataset keys
            const oldDatasetKeys = Object.keys(oldData.datasets[i])
            const newDatasetKeys = Object.keys(dataset)

            // Get keys that aren't present in the new data
            const deletionKeys = oldDatasetKeys.filter((key) => {
              return key !== '_meta' && newDatasetKeys.indexOf(key) === -1
            })

            // Remove outdated key-value pairs
            deletionKeys.forEach((deletionKey) => {
              delete chart.data.datasets[i][deletionKey]
            })

            // Update attributes individually to avoid re-rendering the entire chart
            for (const attribute in dataset) {
              if (dataset.hasOwnProperty(attribute)) {
                chart.data.datasets[i][attribute] = dataset[attribute]
              }
            }
          })

          if (newData.hasOwnProperty('labels')) {
            chart.data.labels = newData.labels
            this.$emit('labels:update')
          }
          if (newData.hasOwnProperty('xLabels')) {
            chart.data.xLabels = newData.xLabels
            this.$emit('xlabels:update')
          }
          if (newData.hasOwnProperty('yLabels')) {
            chart.data.yLabels = newData.yLabels
            this.$emit('ylabels:update')
          }
            chart.update()
            this.$emit('chart:update')
        } else {
          if (chart) {
            chart.destroy()
            this.$emit('chart:destroy')
          }
          this.renderChart(this.chartData, this.options)
          this.$emit('chart:render')
        }
      } else {
        if (this.$data._chart) {
          this.$data._chart.destroy()
          this.$emit('chart:destroy')
        }
        this.renderChart(this.chartData, this.options)
        this.$emit('chart:render')
      }
    }
  }
</script>