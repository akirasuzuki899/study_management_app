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
      :type="type"
      @input="$emit('input', $event)"
      @focus="$emit('focus', $event)"
      :error-messages="errors"
      :dense="dense"
      :disabled="disabled"
      :append-icon="appendIcon"
      :append-outer-icon="appendOuterIcon"
      :prepend-icon="prependIcon"
      :prepend-inner-icon="prependInnerIcon"
      :placeholder="placeholder"
      :single-line="singleLine"
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
    type: {
      type: String,
      default: undefined
    },
    dense: {
      type: Boolean,
      default: false
    },
    disabled: {
      type: Boolean,
      default: false
    },
    appendIcon: {
      type: String,
      default: undefined
    },
    appendOuterIcon: {
      type: String,
      default: undefined
    },
    prependIcon: {
      type: String,
      default: undefined
    },
    prependInnerIcon: {
      type: String,
      default: undefined
    },
    placeholder: {
      type: String,
      default: undefined
    },
    singleLine: {
      type: Boolean,
      default: false
    }
  },
};
</script>