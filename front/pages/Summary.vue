<template>
  <div class="fill-height" style="width: 100%;">
    <v-row 
      v-if="loaded" 
      class="no-gutters flex-column flex-nowrap flex-md-row flex-md-wrap fill-height"
      >
        <v-col 
          cols="auto" md="6" class="pr-md-3 pb-3 pb-md-0">
          <v-card class="fill-height">
            <v-card-text class="fill-height">
              <BarChart
                :class="{ 'fill-height' : $vuetify.breakpoint.name == 'md' || 'lg' || 'xl'}"
                :chartdata="bar_chartdata"
              ></BarChart>
            </v-card-text>
          </v-card>
        </v-col>
        <v-col cols="auto" md="6">
          <v-row 
            class="no-gutters flex-column flex-nowrap flex-sm-row flex-sm-wrap flex-md-column flex-md-nowrap fill-height"
          >
            <v-col 
              cols="auto" sm="6" md="auto" 
              class="flex-shrink-1 pr-sm-3 pr-md-0  pb-3 pb-sm-0 pb-md-3">
              <v-card class="fill-height">
                <v-card-text class="fill-height">  
                  <PieChart 
                    :chartdata="pie_chartdata"
                  ></PieChart>
                </v-card-text>
              </v-card>
            </v-col>
            <v-col cols="auto" sm="6" md="auto" class="flex-grow-1">
              <v-card class="fill-height">
                <v-card-text class="fill-height">  
                  <div class="fill-height" style="position: relative; min-height: 100px;">
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
  </div>

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
  async mounted () {
    this.loaded = false
    this.$axios
    .get('/api/v1/charts/weekly')
    .then(({ data }) => {
      console.log(data)
      this.bar_chartdata = data.bar_chartdata
      this.pie_chartdata = data.pie_chartdata
      this.material_info = data.material_info
      this.loaded = true
    })
    .catch(error => {
      console.log(error)
    })
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