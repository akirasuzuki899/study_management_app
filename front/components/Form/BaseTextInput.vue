<template>
  <validation-provider
    :rules="rules"
    :name="name"
    :vid="vid"
    v-slot="{ errors }"
  >
    <v-text-field
      :value="value"
      :label="label"
      @input="$emit('input', $event)"
      :error-messages="errors"
      :dense="dense"
    ></v-text-field>
  </validation-provider>
</template>

<script>
import { ValidationProvider } from 'vee-validate';

export default {
  name: 'TextInput',
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
    dense: {
      type: Boolean,
      default: false
    }
  },
};
</script>