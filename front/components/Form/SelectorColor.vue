<template>
  <v-menu 
    v-model="colorMenu"
    :close-on-content-click="false"
    transition="scale-transition"
    offset-y
    min-width="150px"
  >
    <template v-slot:activator="{ attrs }">
      <v-text-field
        readonly
        append-icon="mdi-menu-down"
        :dense="dense"
        v-bind="attrs"
        @mouseup="colorMenu = true"
      >
        <template v-slot:prepend-inner>
          <v-icon :color="value">mdi-circle</v-icon>
        </template>
      </v-text-field>
    </template>
    <v-sheet class="d-flex flex-wrap" style="width: 150px; height: 150px;">
      <div 
        v-for="(color, index) in colors"
        :key="index"
        style="width: calc(100%/3);"
        class="align-self-center text-center"
      >
        <v-btn icon @click="$emit('click', color); colorMenu = false">
          <v-icon :color="color">mdi-circle</v-icon>
        </v-btn>
      </div>
    </v-sheet>
  </v-menu>
</template>

<script>
export default {
  name: 'SelectorColor',
  data () {
    return {
      colorMenu: false,
      colors: [
        'purple darken-2', 
        'indigo darken-2', 
        'blue darken-2', 
        'cyan darken-2', 
        'teal darken-2',  //center
        'green darken-2', 
        'lime darken-2', 
        'amber darken-2', 
        'orange darken-2'],
    }
  },
  model: {
    prop: 'value',
    event: 'click',
  },
  props: {
    value: {
      type: String,
      default: 'blue'
    },
    dense: {
      type: Boolean,
      default: false
    }
  },
}
</script>