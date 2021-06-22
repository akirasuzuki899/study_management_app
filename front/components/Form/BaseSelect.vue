<template>
  <validation-provider
    :rules="rules"
    :name="name"
    :vid="vid"
    v-slot="{ errors }"
  >
    <v-select
      :label="label"
      :value="value"
      @change="$emit('change', $event)"
      :items="items"
      :item-text="itemText"
      :item-value="itemValue"
      :error-messages="errors"
      :prepend-icon="prependIcon"
      :dense="dense"
    />
  </validation-provider>
</template>

<script>
import { ValidationProvider } from 'vee-validate';

export default {
  name: 'BaseSelect',
  components: {
    ValidationProvider
  },
  model: {
    prop: 'value',
    event: 'change',
  },
  props: {
    value: {
      type: [Number, String],
      default: ''
    },
    rules: {
      type: [String, Object],
      default: ''
    },
    name: {
      type: String,
      default: ''
    },
    vid: {
      type: String,
      default: undefined
    },
    label: {
      type: String,
      default: ''
    },
    items: {
      type: Array,
      default: ''
    },
    itemText: {
      type: String,
      default: undefined
    },
    itemValue: {
      type: String,
      default: undefined
    },
    prependIcon: {
      type: String,
      default: undefined
    },
    dense: {
      type: Boolean,
      default: false
    }
  },
  data: () => ({
    item: {}
  }),
}
</script>