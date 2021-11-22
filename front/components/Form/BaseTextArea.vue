<template>
  <validation-provider
    :rules="rules"
    :name="name"
    :vid="vid"
    v-slot="{ errors }"
  >
    <v-textarea
      :value="value"
      :label="label"
      @input="$emit('input', $event)"
      :error-messages="errors"
      :outlined="outlined"
      :counter="counter"
      :dense="dense"
    ></v-textarea>
  </validation-provider>
</template>
<script>
import { ValidationProvider } from 'vee-validate';

export default {
  name: 'TextArea',
  components: {
    ValidationProvider
  },
  props: {
    value: {
      type: String,
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
    outlined: {
      type: Boolean,
      default: true
    },
    counter: {
      type: [Boolean, Number, String],
      default: true
    },
    dense: {
      type: Boolean,
      default: true
    },
  }
}
</script>