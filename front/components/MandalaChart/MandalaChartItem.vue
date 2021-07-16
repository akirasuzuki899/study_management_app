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
        class="text-center pa-0"
        v-resize-text="{minFontSize: '8px'}"
      >
        {{MandalaItem.text}}
      </v-card-text>
    </v-card>
  </v-responsive>
</template>

<script>
import ResizeText from 'vue-resize-text'

export default {

  directives: {
    ResizeText
 },
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
    options: {
        minSize: 10,
        maxSize: 16,
    }
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