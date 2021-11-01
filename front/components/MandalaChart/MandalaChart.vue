<template>
  <div>
    <v-card>
      <v-row class="no-gutters">
        <v-col cols="12">
          <v-card-actions class="pb-0" ref="chartToolbar">
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
        </v-col>
        <v-col cols="12">
          <v-row class="no-gutters pa-2">
            <v-col cols="4" v-for="n in 9" :key="n">
              <MandalaChartGroup
                :GroupId="n"
                :key="n"
                :MandalaGroup="filterByPlaceNumber( selectedMandalaChart.mandala_groups, n )"
                @item-clicked="openForm"
                @item-text-changed="itemTextChanged"
              ></MandalaChartGroup>
            </v-col>
          </v-row>
        </v-col>
      </v-row>
    </v-card>
    <MandalaDialog
      ref="dialog"
      :selectedMandalaItem="selectedMandalaItem"
    ></MandalaDialog>
    <Alert
      ref="alert"
      @clicked="deleteMandalaChart({
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
  </div>
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
    itemTextChanged(item){
    this.$emit('item-text-changed', item)
    }
  },
  created() {
    this.getMandalaCharts()
  }
}
</script>