<template>
  <v-card
    class="d-flex flex-wrap"
    outlined
    tile
  >
      <template v-for="n in 9">
        <MandalaChartItem
          :id="n"
          :key="n"
          :MandalaItem="filterByPlaceNumber( MandalaGroup.mandala_items, n )"
          style="width: calc(100%/3);"
          @item-clicked="itemClicked"
        ></MandalaChartItem>
      </template>
  </v-card>
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
    }
  }
}
</script>