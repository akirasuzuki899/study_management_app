<template>
  <v-responsive 
    :aspect-ratio="1"
  >
    <v-card 
      height="100%"
      outlined
      tile
      class="d-flex align-center"
      @click="$emit('item-clicked', MandalaItem)"
    >
      <!-- <v-card-text
        class="text-center text-truncate"
      >
        
      </v-card-text> -->
    </v-card>
  </v-responsive>
</template>

<script>
export default {
  props: {
    MandalaItem: {
      type: Object
    }
  },
  data: () => ({
    text: '',
  }),
}
</script>