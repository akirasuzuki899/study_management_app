<template>
  <validation-provider
    :rules="rules"
    :name="name"
    :vid="vid"
    v-slot="{ errors }"
  >
    <v-checkbox
      :input-value="value"
      :label="label"
      @change="$emit('change', $event)"
      :error-messages="errors"
      :on-icon="onIcon"
      :off-icon="offIcon"
      :dense="dense"
    ></v-checkbox>
  </validation-provider>
</template>

<script>
import { ValidationProvider } from 'vee-validate';

export default {
  name: 'CheckBox',
  components: {
    ValidationProvider
  },
  model: {
    prop: 'value',
    event: 'change',
  },
  props: {
    value: {
      type: Boolean,
      default: undefined
    },
    rules: {
      type: String,
      default: undefined
    },
    name: {
      type: String,
      default: undefined
    },
    vid: {
      type: String,
      default: undefined
    },
    label: {
      type: String,
      default: undefined
    },
    dense: {
      type: Boolean,
      default: false
    },
    onIcon: {
      type: String,
      default: undefined
    },
    offIcon: {
      type: String,
      default: undefined
    },
  },
}
</script>