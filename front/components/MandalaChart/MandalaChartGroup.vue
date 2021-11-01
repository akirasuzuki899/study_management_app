<template>
  <v-row class="no-gutters">
    <v-col cols="4" v-for="n in 9" :key="n">
      <MandalaChartItem
        :ItemId="n"
        :GroupId="GroupId"
        :key="n"
        :MandalaItem="filterByPlaceNumber( MandalaGroup.mandala_items, n )"
        @item-clicked="itemClicked"
        @item-text-changed="itemTextChanged"
      ></MandalaChartItem>
    </v-col>
  </v-row>
</template>

<script>
import MandalaChartItem from "./MandalaChartItem"
export default {
  components: {
    MandalaChartItem,
  },
  props: {
    MandalaGroup: {
      type: Object,
      default:() => ({
        mandala_items: []
      })
    },
    GroupId: {
      type: Number
    }
  },
  data: () => ({
    
  }),
  methods: {
    filterByPlaceNumber(array, place_number) {
      if (!array.length) return undefined
      return array.find( v => v.place_number == place_number)
    },
    itemClicked(item){
      this.$emit('item-clicked', item)
    },
    itemTextChanged(item){
      this.$emit('item-text-changed', item)
    }
  }
}
</script>