<template>
  <v-sheet
    height="100%"
    class="pa-6"
  >
    <v-card-actions>
      <v-btn 
        @click="deleteMandalaChart({
          authTokens: authTokens
        })"
        outlined
        text
      >
        <v-icon>
          mdi-delete-outline
        </v-icon>
      </v-btn>
    </v-card-actions>

    <v-card
      class="d-flex flex-wrap"
      outlined
      tile
    >
      <template v-for="n in 9">
        <MandalaChartGroup
          :GroupId="n"
          :key="n"
          :MandalaGroup="filterByPlaceNumber( selectedMandalaChart.mandala_groups, n )"
          style="width: calc(100%/3);"
          @item-clicked="openForm"
        ></MandalaChartGroup>
      </template>
    </v-card>
    <MandalaForm
      ref="form"
      :selectedMandalaItem="selectedMandalaItem"
    ></MandalaForm>
  </v-sheet>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import MandalaChartGroup from "./MandalaChartGroup"
import MandalaForm from "../MandalaChart/MandalaForm"

export default {
  components: {
    MandalaChartGroup,
    MandalaForm,
  },
  data: () => ({
    selectedMandalaChart: {
      mandala_groups: [],
    },
    selectedMandalaItem: {}
  }),
  watch: {
    mandala_charts: function(){
      this.selectedMandalaChart = this.mandala_charts[0]
    }
  },
  computed: {
      ...mapGetters('mandalaChart', ['mandala_charts']),
      ...mapGetters(["authTokens"]),
  },
  methods: {
     ...mapActions('mandalaChart', ['getMandalaCharts', 'deleteMandalaChart']),
     filterByPlaceNumber(array, place_number) {
       if (!array.length) return undefined
       return array.find( v => v.place_number == place_number)
     },
     openForm(item) {
       this.selectedMandalaItem = item
       this.$refs.form.open()
     }
  },
  created() {
    this.getMandalaCharts(this.authTokens)
  }
}
</script>