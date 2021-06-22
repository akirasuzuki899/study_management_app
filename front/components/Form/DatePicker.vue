<template>
  <v-menu
    v-model="datePicker"
    :close-on-content-click="false"
    :nudge-right="40"
    transition="scale-transition"
    offset-y
    min-width="auto"
  >
    <template v-slot:activator="{ on, attrs }">
      <validation-provider
        v-slot="{ errors }"
        :name="name"
        :rules="rules"
      >
        <v-text-field
          :value="value"
          :label="label"
          prepend-icon="mdi-calendar"
          :error-messages="errors"
          readonly
          :dense="dense"
          v-bind="attrs"
          v-on="on"
        ></v-text-field>
      </validation-provider>
    </template>
    <v-date-picker
      :value="value"
      :day-format="onlyNum"
      :allowed-dates="afterToday"
      :first-day-of-week="1"
      locale="ja-jp"
      @input="datePicker = false; $emit('input', $event)"
    ></v-date-picker>
  </v-menu>
</template>

<script>
import { ValidationProvider } from 'vee-validate';

export default {
  name: 'DatePicker',
  data() {
    return {
      datePicker: false,
    }
  },
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
  methods: {
    onlyNum: val => new Date(val).getDate(),

    afterToday: val => val >= new Date().toISOString().substr(0, 10),
  },
}
</script>