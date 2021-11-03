<template>
  <v-card class="fill-height" style="width: 100%;" id="test">
    <v-row 
      v-if="loaded" 
      class="flex-column no-gutters fill-height">
      <v-col cols="auto" class="flex-grow-1">
        <v-card-text class="fill-height">
          <v-row 
            class="no-gutters flex-column flex-nowrap flex-md-row flex-md-wrap fill-height"
            >


              <!-- barChart -->
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
                      <v-col cols="auto" class="pb-0 pb-sm-3">
                        <div class="text-subtitle-1">
                          学習時間
                        </div>
                      </v-col>
                      <v-col cols="auto">
                        <v-tabs grow v-model="bar.format">
                          <v-tab @click="getDailyData('bar', 0)" href="#daily">日</v-tab>
                          <v-tab @click="getWeeklyData('bar', 0)" href="#weekly">週</v-tab>
                          <v-tab @click="getMonthlyData('bar', 0)" href="#monthly">月</v-tab>
                        </v-tabs>
                      </v-col>
                      <v-col cols="auto">
                        <div class="text-caption d-flex align-center mx-auto my-3" style="max-width: 400px;">
                          <v-btn
                            icon
                            small
                            @click="getChartData(bar.format, 'bar', bar.diff-1)"
                          >
                            <v-icon>mdi-chevron-left</v-icon>
                          </v-btn>
                          <v-spacer></v-spacer>
                            {{barChartRange}} 
                          <v-spacer></v-spacer>
                          <v-btn
                            icon
                            small
                            @click="getChartData(bar.format, 'bar', bar.diff+1)"
                          >
                            <v-icon>mdi-chevron-right</v-icon>
                          </v-btn>
                        </div>
                      </v-col>
                      <v-col cols="auto">
                        <BarChart
                          :chart-data="bar.chartdata"
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
                            :items="bar.legend"
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
              <!-- barChart -->


              <!-- pieChart -->
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
                      <v-col cols="auto" class="pb-0 pb-sm-3">
                        <div class="text-subtitle-1">
                          時間配分
                        </div>
                      </v-col>
                      <v-col cols="auto">
                        <v-tabs grow v-model="pie.format">
                          <v-tab @click="getDailyData('pie', 0)" href="#daily">日</v-tab>
                          <v-tab @click="getWeeklyData('pie', 0)" href="#weekly">週</v-tab>
                          <v-tab @click="getMonthlyData('pie', 0)" href="#monthly">月</v-tab>
                        </v-tabs>
                      </v-col>
                      <v-col cols="auto">
                        <div class="text-caption d-flex align-center mx-auto my-3" style="max-width: 400px;">
                          <v-btn
                            icon
                            small
                            @click="getChartData(pie.format, 'pie', pie.diff-1)"
                          >
                            <v-icon>mdi-chevron-left</v-icon>
                          </v-btn>
                          <v-spacer></v-spacer>
                            {{pieChartRange}} 
                          <v-spacer></v-spacer>
                          <v-btn
                            icon
                            small
                            @click="getChartData(pie.format, 'pie', pie.diff+1)"
                          >
                            <v-icon>mdi-chevron-right</v-icon>
                          </v-btn>
                        </div>
                      </v-col>
                      <v-col cols="auto">
                        <PieChart
                          :chart-data="pie.chartdata"
                          :style="ChartHeight"
                          @chart:render="scrollTo(positionY)"
                          @chart:update="scrollTo(positionY)"
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
                            :items="pie.legend"
                            :headers="pie.headers"
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
              <!-- pieChart -->


          </v-row>
        </v-card-text>
      </v-col>
    </v-row>
    <Loader v-else></Loader>
  </v-card>
</template>

<script>
import BarChart from "../components/Chart/BarChart.vue"
import PieChart from "../components/Chart/PieChart.vue"
import ChartLegend from "../components/Chart/ChartLegend.vue"
import Loader from "../components/Loader.vue"
import mixinMoment from "../plugins/mixin-moment"
export default {
  components: {
    BarChart,
    PieChart,
    ChartLegend,
    Loader
  },
  mixins: [mixinMoment],
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
      },
      barChartRange: function() {
        return `${this.dateYyMmDd(this.bar.range.start)} ~ ${this.dateYyMmDd(this.bar.range.end)}`
      },
      pieChartRange: function() {
        if (this.pie.range.start == this.pie.range.end) {
          return this.dateYyMmDd(this.pie.range.start)
        } else {
          return `${this.dateYyMmDd(this.pie.range.start)} ~ ${this.dateYyMmDd(this.pie.range.end)}`
        }
      }
    },
  data(){
    return {
        loaded: false,
        bar: {
          chartdata: {},
          legend: [],
          range: {
            start: null,
            end: null
          },
          chart_type: null,
          format: null,
          diff: 0
        },
        pie: {
          chartdata: {},
          legend: [],
          range: {
            start: null,
            end: null
          },
          chart_type: null,
          format: null,
          diff: 0,
          headers: [
            { text: 'Color', value: 'color', cellClass: 'td-color'},
            { text: 'TextBooks', value: 'image_url', cellClass: 'td-image'},
            { text: 'Title', value: 'title', cellClass: 'td-title'},
            { text: 'Sum', value: 'sum', cellClass: 'td-sum'},
            { text: 'Percentage', value: 'percentage', cellClass: 'td-percentage'},
          ],
        },
        positionY: null,
    }
  },
  methods: {
    getBarAndPieChartData(){
      return this.$axios
        .get(`/api/v1/charts`)
        .then(({data}) => {
          console.log(data)
          this.bar.chartdata = data.bar.chartdata
          this.bar.legend = data.bar.legend
          this.bar.range = data.bar.range
          this.bar.format = 'daily'
          this.pie.chartdata = data.pie.chartdata
          this.pie.legend = data.pie.legend
          this.pie.range = data.pie.range
          this.pie.format = 'weekly'
        })
        .catch(error => {
          console.log(error)
        })
    },
    getChartData(format ,chart_type, diff){
      return this.$axios
        .get(`/api/v1/charts/${format}?chart_type=${chart_type}&diff=${diff}`)
        .then(({ data }) => {
          console.log(data)
          this.setPositionY()
          this[chart_type].chartdata = data[chart_type].chartdata
          this[chart_type].legend = data[chart_type].legend
          this[chart_type].range = data[chart_type].range
          this[chart_type].diff = diff
        })
        .catch(error => {
          console.log(error)
        })
    },
    getDailyData(chart_type, diff){
      this[chart_type].format = 'daily'
      this.getChartData('daily', chart_type, diff)
    },
    getWeeklyData(chart_type, diff){
      this[chart_type].format = 'weekly'
      this.getChartData(this[chart_type].format, chart_type, diff)
    },
    getMonthlyData(chart_type, diff){
      this[chart_type].format = 'monthly'
      this.getChartData('monthly', chart_type, diff)
    },
    setPositionY() {
      this.positionY = window.scrollY
    },
    scrollTo(positionY){
      window.scrollTo(0,positionY)
    },

  },
  async mounted () {
    this.loaded = false
    await this.getBarAndPieChartData()
    this.loaded = true
  }
}
</script>

<style lang="scss" scoped>
.v-tabs ::v-deep .v-slide-group__prev {
display: none !important;
}
</style>