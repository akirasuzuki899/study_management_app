<template>
  <v-responsive 
    :aspect-ratio="1"
  >
    <v-card 
      height="100%"
      outlined
      tile
      class="d-flex align-center"
      :color="getColor()"
      @click="$emit('item-clicked', MandalaItem)"
    >
      <v-card-text
        class="text-center text-truncate pa-0"
      >
        {{MandalaItem.text}}
      </v-card-text>
    </v-card>
  </v-responsive>
</template>

<script>
export default {
  props: {
    MandalaItem: {
      type: Object,
      default:() => ({
        text: '',
        is_finished: false,
        place_number: '',
        mandala_group_id: '',
      })
    },
    ItemId: {
      type: Number
    },
    GroupId: {
      type: Number
    }

  },
  data: () => ({
    colors: {
      1: 'purple', 
      2: 'indigo', 
      3: 'blue', 
      4: 'cyan', 
      5: 'teal',  //center
      6: 'green', 
      7: 'lime', 
      8: 'amber', 
      9: 'orange'},
  }),

  methods: {
    getColor(){
      if(this.GroupId == 5){
        return this.colors[this.ItemId]
      } else if (this.ItemId == 5) {
        return this.colors[this.GroupId]
      }
    }
  }
}
</script>