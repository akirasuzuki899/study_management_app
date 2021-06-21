<template>
  <v-menu 
    v-model="colorMenu"
    :close-on-content-click="false"
    transition="scale-transition"
    offset-y
  >
    <template v-slot:activator="{ attrs }">
      <v-text-field
        readonly
        append-icon="mdi-menu-down"
        v-bind="attrs"
        @mouseup="colorMenu = true"
      >
        <template v-slot:prepend-inner>
          <div
            class="pa-2 rounded-circle"
            :class="value"
          ></div>
        </template>
      </v-text-field>
    </template>
    <v-list
      class="d-flex justify-center"
    >
      <v-list-item
        v-for="(color, index) in colors"
        :key="index"
        @click="$emit('click', color); colorMenu = false"
      >
        <div
          class="pa-2 rounded-circle"
          :class="color"
        ></div>
      </v-list-item>
    </v-list>
  </v-menu>
</template>

<script>
export default {
  name: 'SelectorColor',
  data () {
    return {
      colorMenu: false,
      colors: ['blue', 'indigo', 'deep-purple', 'cyan', 'green', 'orange', 'grey darken-1'],
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
    }
  },
}
</script>