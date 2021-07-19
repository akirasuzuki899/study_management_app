<template>
  <v-sheet
    height="100%"
    class="pa-6"
  >
    <v-card-actions>
      <v-btn 
        @click="openAlert"
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
    <MandalaDialog
      ref="dialog"
      :selectedMandalaItem="selectedMandalaItem"
    ></MandalaDialog>
    <Alert
      ref="alert"
      @clicked="deleteMandalaChart({
          authTokens: authTokens,
          selectedMandalaChart: selectedMandalaChart
        })"
    >
      <template v-slot:content>
        マンダラチャートを削除しますか
      </template>
      <template v-slot:btnText>
        削除
      </template>
    </Alert>
  </v-sheet>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import MandalaChartGroup from "./MandalaChartGroup"
import MandalaDialog from "../MandalaChart/MandalaDialog"
import Alert from "../Alert"

export default {
  components: {
    MandalaChartGroup,
    MandalaDialog,
    Alert,
  },
  data: () => ({
    selectedMandalaChart: {
    mandala_groups: [
      { mandala_items: [] },
    ]
  },
    selectedMandalaItem: {}
  }),
  watch: {
    mandala_charts: function(){
      this.selectedMandalaChart = this.mandala_charts[0]  //復数作成できる場合はコードを改良する
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
       this.$refs.dialog.open()
     },
     openAlert() {
       this.$refs.alert.open();
     },
  },
  created() {
    this.getMandalaCharts(this.authTokens)
  }
}
</script>