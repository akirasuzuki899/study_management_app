<template>
  <v-card class="fill-height" style="width: 100%;">
    <v-row class="flex-column no-gutters fill-height">
      <v-col cols="auto" class="flex-shrink-1">
        <v-tabs>
          <v-tab @click="getDailyData()">日</v-tab>
          <v-tab @click="getWeeklyData()">週</v-tab>
          <v-tab @click="getMonthlyData()">月</v-tab>
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
                class="pr-md-3 pb-3 pb-md-0"
                :class="{ 'flex-shrink-1' : $vuetify.breakpoint.name == 'xs' || 'sm' }"
              >
                <v-row 
                  class="no-gutters flex-column flex-nowrap fill-height"
                >
                  <v-col cols="auto" class="flex-shrink-1 pb-3">
                    <div>
                      学習時間(教材)
                    </div>
                  </v-col>
                  <v-col cols="auto" class="flex-grow-1">
                  <BarChart
                    :chart-data="bar_chartdata"
                    :styles="barChartHeight"
                  ></BarChart>
                  </v-col>
                </v-row>
              </v-col>
              <v-col 
                cols="auto" md="6"
                :class="{'flex-grow-1' : $vuetify.breakpoint.name == 'xs' || 'sm'}"
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
                          :style="pieChartHeight"
                        ></PieChart>
                      </v-col>
                    </v-row>
                  </v-col>
                  <v-col cols="auto" sm="6" md="auto" class="flex-grow-1">
                    <v-card outlined class="fill-height">
                      <v-card-text class="fill-height">  
                        <div class="fill-height" style="position: relative; min-height: 150px;">
                          <v-data-table
                            class="fill-height overflow-y-auto"
                            style="width: 100%; position: absolute; left: 0; top: 0;"
                            :headers="headers"
                            :items="material_info"
                            hide-default-header
                            hide-default-footer
                            mobile-breakpoint="0"
                            :items-per-page=-1
                            dense
                          >
                            <template v-slot:[`item.color`]="{ item }">
                              <v-icon
                                dark
                                :color="item.color"
                                size="12"
                              >
                                mdi-circle
                              </v-icon>
                            </template>
                            <template v-slot:[`item.image_url`]="{ item }">
                              <v-avatar tile size="28">
                                <v-img
                                  :src="item.image_url"
                                  contain
                                ></v-img>
                              </v-avatar>
                            </template>
                            <template v-slot:[`item.title`]="{ item }">
                              <div class="text-truncate">
                                {{item.title}}
                              </div>
                            </template>
                          </v-data-table>
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
import StudyMaterialList from "../components/StudyMaterials/StudyMaterialList.vue"
export default {
  components: {
    BarChart,
    PieChart,
    StudyMaterialList
  },
  computed: {
      barChartHeight () {
        switch (this.$vuetify.breakpoint.name) {
          case 'xs': return { height: "150px" , position: 'relative'}
          case 'sm': return { height: "250px" , position: 'relative'}
          case 'md': return { height: "100%" , position: 'relative'}
          case 'lg': return { height: "100%" , position: 'relative'}
          case 'xl': return { height: "100%" , position: 'relative'}
        }
      },
      pieChartHeight () {
        switch (this.$vuetify.breakpoint.name) {
          case 'xs': return { height: "150px" , position: 'relative'}
          case 'sm': return { height: "250px" , position: 'relative'}
          case 'md': return { height: "300px" , position: 'relative'}
          case 'lg': return { height: "300px" , position: 'relative'}
          case 'xl': return { height: "300px" , position: 'relative'}
        }
      }
    },
  data(){
    return {
        loaded: false,
        bar_chartdata: null,
        pie_chartdata: null,
        material_info: null,
        headers: [
          { text: 'Color', value: 'color' },
          { text: 'TextBooks', value: 'image_url' },
          { text: 'Title', value: 'title' },
        ],
    }
  },
  methods: {
    getDailyData(){
      return this.$axios
        .get('/api/v1/charts/daily')
        .then(({ data }) => {
          this.bar_chartdata = data.bar_chartdata
          this.pie_chartdata = data.pie_chartdata
          this.material_info = data.material_info
        })
        .catch(error => {
          console.log(error)
        })
    },
    getWeeklyData(){
      this.$axios
        .get('/api/v1/charts/weekly')
        .then(({ data }) => {
          this.bar_chartdata = data.bar_chartdata
          this.pie_chartdata = data.pie_chartdata
          this.material_info = data.material_info
        })
        .catch(error => {
          console.log(error)
        })
    },
    getMonthlyData(){
      this.$axios
        .get('/api/v1/charts/monthly')
        .then(({ data }) => {
          this.bar_chartdata = data.bar_chartdata
          this.pie_chartdata = data.pie_chartdata
          this.material_info = data.material_info
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

<style lang="scss">  
  tbody {
     tr:hover {
        background-color: transparent !important;
     }
  }
</style>