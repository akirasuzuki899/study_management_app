<template>
  <!-- <validation-provider
    :rules="rules"
    :name="name"
    :vid="vid"
    v-slot="{ errors }"
  > -->
    <v-checkbox
      :value="value"
      :label="label"
      :on-icon="'mdi-check'"
      :off-icon="'mdi-check'"
      :dense="dense"
    ></v-checkbox>
      <!-- :error-messages="errors" -->
  <!-- </validation-provider> -->
</template>

<script>
import { ValidationProvider } from 'vee-validate';

export default {
  name: 'CheckBox',
  components: {
    ValidationProvider
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