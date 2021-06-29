<template>
    <v-radio-group 
      :value="value" 
      @change="$emit('change', $event)"
      :dense="dense"
    >
      <template v-slot:label>
        <slot></slot>
      </template>
      <v-radio
        v-for="(item, index) in items"
        :key="index"
        :label="item.label"
        :value="item.value"
      ></v-radio>
    </v-radio-group>
</template>

<script>
export default {
  name: 'RadioButton',
  model: {
    prop: 'value',
    event: 'change',
  },
  props: {
    value: {},
    items: {
      type: Array,
      default: [{}]
    },
    dense: {
      type: Boolean,
      default: false
    }
  }
}
</script>