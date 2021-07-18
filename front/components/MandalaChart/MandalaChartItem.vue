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
    <!-- font-size: 0; は、アイコンの周りに生じる謎のスペースを消すために使用している -->
    <div
      style="position: absolute; top: 0; font-size: 0;"   
    >
      <v-icon
        v-if="MandalaItem.is_finished"
        size="10"
      >
        mdi-sticker-check-outline
      </v-icon>
      <v-icon
        v-if="MandalaItem.url"
        size="10"
      >
        mdi-link-variant
      </v-icon>
    </div>
      <v-card-text
        
        class="text-center pa-0"
        v-resize-text="{minFontSize: '6px'}"
        style="line-height: 1;"
      >
        <VClamp :max-lines="2">
        {{MandalaItem.text}}
        </VClamp>
      </v-card-text>
    </v-card>
  </v-responsive>
</template>

<script>
import ResizeText from 'vue-resize-text'
import VClamp from 'vue-clamp'

export default {
  components: {
    VClamp
  },
  directives: {
    ResizeText,
 },
  props: {
    MandalaItem: {
      type: Object,
      default:() => ({
        text: '',
        is_finished: false,
        place_number: '',
        mandala_group_id: '',
        url: '',
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
    },
  }),
  methods: {
    getColor(){
      if(this.GroupId == 5){
        return this.colors[this.ItemId]
      } else if (this.ItemId == 5) {
        return this.colors[this.GroupId]
      }
    },
  },
}
</script>