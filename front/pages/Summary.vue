<template>
  <v-card class="fill-height" style="width: 100%;">
    <v-row class="flex-column no-gutters fill-height">
      <v-col cols="auto" class="flex-shrink-1">
        <v-tabs>
          <v-tab @click="getDailyData()">日</v-tab>
          <v-tab @click="getWeeklyData()">週</v-tab>
          <v-tab @click="getMonthlyData()">月</v-tab>
          <v-tab >{{height}}</v-tab>
        </v-tabs>
      </v-col>
      <v-col cols="auto" class="flex-grow-1">
        <v-card-text class="fill-height">
          <v-row 
            v-if="loaded" 
            class="no-gutters flex-column flex-nowrap flex-md-row flex-md-wrap fill-height"
            >

              <v-col 
                cols="auto" md="6"
                class="flex-grow-1 pb-6 pb-md-0 pr-md-3"
              >
                <v-row 
                  class="no-gutters flex-column flex-nowrap flex-sm-row flex-sm-wrap flex-md-column flex-md-nowrap fill-height"
                >
                  <v-col 
                    cols="auto" sm="6" md="auto" 
                    class="flex-shrink-1 pr-sm-3 pr-md-0  pb-3 pb-sm-0 pb-md-3">
                    <v-row  class="no-gutters flex-column flex-nowrap">
                      <v-col cols="auto" class="pb-3">
                        <div>
                          学習時間(教材)
                        </div>
                      </v-col>
                      <v-col cols="auto">
                        <BarChart
                          :chart-data="bar_chartdata"
                          :styles="ChartHeight"
                        ></BarChart>
                      </v-col>
                    </v-row>
                  </v-col>
                  <v-col cols="auto" sm="6" md="auto" class="flex-grow-1">
                    <v-card outlined class="fill-height">
                      <v-card-text 
                        class="fill-height"
                        :class="{ 'pa-2' : $vuetify.breakpoint.name == 'xs' }"
                      >
                        <div class="fill-height" style="position: relative; min-height: 150px;">
                          <ChartLegend
                            :items="bar_legend"
                            :headers="bar_headers"
                            :custom="true"
                          >
                            <template v-slot:item="{ item }">
                              <tr>
                                <td rowspan="2" class="td-color">
                                  <v-icon
                                    dark
                                    :color="item.color"
                                    size="12"
                                  >
                                    mdi-circle
                                  </v-icon>
                                </td>
                                <td rowspan="2" class="td-image">
                                  <v-avatar tile size="28">
                                    <v-img
                                      :src="item.image_url"
                                      contain
                                    ></v-img>
                                  </v-avatar>
                                </td>
                                <td rowspan="2" style="width: 16px; padding: 0;"></td> <!-- スペースを調整するために記述 -->
                                <td :colspan="item.data.length" class="td-title pa-0 text-truncate">{{item.title}}</td>
                              </tr>
                              <tr>
                                <template v-for="(sum, index) in item.data">
                                  <td 
                                    :key="index" 
                                    class="td-sum"
                                    :class="{'text--disabled' : sum == 0 }"
                                  >{{sumToTime(sum)}}</td>
                                </template>
                              </tr>
                              <tr></tr>  <!-- 最後の列に border-bottom を適用するために記述 -->
                            </template>
                          </ChartLegend>
                        </div>
                      </v-card-text>
                    </v-card>
                  </v-col>
                </v-row>
              </v-col>

              <v-col 
                cols="auto" md="6"
                class="flex-grow-1 pl-md-3"
              >
                <v-row 
                  class="no-gutters flex-column flex-nowrap flex-sm-row flex-sm-wrap flex-md-column flex-md-nowrap fill-height"
                >
                  <v-col 
                    cols="auto" sm="6" md="auto" 
                    class="flex-shrink-1 pr-sm-3 pr-md-0  pb-3 pb-sm-0 pb-md-3">
                    <v-row  class="no-gutters flex-column flex-nowrap">
                      <v-col cols="auto" class="pb-3">
                        <div>
                          時間配分(教材)
                        </div>
                      </v-col>
                      <v-col cols="auto">
                        <PieChart 
                          :chart-data="pie_chartdata"
                          :style="ChartHeight"
                        ></PieChart>
                      </v-col>
                    </v-row>
                  </v-col>
                  <v-col cols="auto" sm="6" md="auto" class="flex-grow-1">
                    <v-card outlined class="fill-height">
                      <v-card-text 
                        class="fill-height"
                        :class="{ 'pa-2' : $vuetify.breakpoint.name == 'xs' }"
                      >
                        <div class="fill-height" style="position: relative; min-height: 150px;">
                          <ChartLegend
                            :items="pie_legend"
                            :headers="pie_headers"
                          >
                            <template v-slot:sum="{ item }">
                                {{sumToTime(item.sum)}}
                            </template>
                            <template v-slot:percentage="{ item }">
                                {{`${item.percentage} %`}}
                            </template>
                          </ChartLegend>
                        </div>
                      </v-card-text>
                    </v-card>
                  </v-col>
                </v-row>
              </v-col>


          </v-row>
          <v-row v-else class="align-content-center text-center fill-height">
            <v-col cols="12">
              <v-progress-circular
                indeterminate
                color="primary"
                class="mb-4"
              ></v-progress-circular>
            </v-col>
            <v-col cols="12" class="font-weight-bold">
              Loading...
            </v-col>
          </v-row>
        </v-card-text>
      </v-col>
    </v-row>
  </v-card>
</template>

<script>
import BarChart from "../components/Chart/BarChart.vue"
import PieChart from "../components/Chart/PieChart.vue"
import ChartLegend from "../components/Chart/ChartLegend.vue"
export default {
  components: {
    BarChart,
    PieChart,
    ChartLegend,
  },
  computed: {
      height () {
        switch (this.$vuetify.breakpoint.name) {
          case 'xs': return 'xs' 
          case 'sm': return 'sm' 
          case 'md': return 'md' 
          case 'lg': return 'lg' 
          case 'xl': return 'xl' 
        }
      },
      ChartHeight () {
        switch (this.$vuetify.breakpoint.name) {
          case 'xs': return { height: "150px" , position: 'relative'}
          case 'sm': return { height: "250px" , position: 'relative'}
          case 'md': return { height: "300px" , position: 'relative'}
          case 'lg': return { height: "300px" , position: 'relative'}
          case 'xl': return { height: "300px" , position: 'relative'}
        }
      },
      sumToTime: function() {
        return function(sum) {
          if ( sum == 0 ) {
            return "0分"
          } else if ( sum < 1 ) {
            return `${sum*60}分`
          } else {
            return Number.isInteger(sum)
                      ? `${sum}時間`
                      : `${Math.floor(sum)}時間${(sum - Math.floor(sum))*60}分`
          }
      }
    }
    },
  data(){
    return {
        loaded: false,
        bar_chartdata: null,
        pie_chartdata: null,
        bar_legend: null,
        pie_legend: null,
        bar_headers: [
          { text: 'Color', value: 'color', cellClass: 'td-color', divider: true},
          { text: 'TextBooks', value: 'image_url', cellClass: 'td-image', divider: true},
          { text: 'Title', value: 'title', cellClass: 'td-title', divider: true},
        ],
        pie_headers: [
          { text: 'Color', value: 'color', cellClass: 'td-color'},
          { text: 'TextBooks', value: 'image_url', cellClass: 'td-image'},
          { text: 'Title', value: 'title', cellClass: 'td-title'},
          { text: 'Sum', value: 'sum', cellClass: 'td-sum'},
          { text: 'Percentage', value: 'percentage', cellClass: 'td-percentage'},
        ],
    }
  },
  methods: {
    getDailyData(){
      return this.$axios
        .get('/api/v1/charts/daily')
        .then(({ data }) => {
          console.log(data)
          this.bar_chartdata = data.bar.chartdata
          this.pie_chartdata = data.pie.chartdata
          this.bar_legend = data.bar.legend
          this.pie_legend = data.pie.legend
        })
        .catch(error => {
          console.log(error)
        })
    },
    getWeeklyData(){
      this.$axios
        .get('/api/v1/charts/weekly')
        .then(({ data }) => {
          this.bar_chartdata = data.bar.chartdata
          this.pie_chartdata = data.pie.chartdata
          this.bar_legend = data.bar.legend
          this.pie_legend = data.pie.legend
        })
        .catch(error => {
          console.log(error)
        })
    },
    getMonthlyData(){
      this.$axios
        .get('/api/v1/charts/monthly')
        .then(({ data }) => {
          this.bar_chartdata = data.bar.chartdata
          this.pie_chartdata = data.pie.chartdata
          this.bar_legend = data.bar.legend
          this.pie_legend = data.pie.legend
        })
        .catch(error => {
          console.log(error)
        })
    },
  },
  async mounted () {
    this.loaded = false
    await this.getDailyData()
    this.loaded = true
  }
}
</script>