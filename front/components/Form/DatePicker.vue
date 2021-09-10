<template>
  <div>
    <v-menu
      v-if="$vuetify.breakpoint.name !== 'xs'"
      v-model="datePicker"
      :close-on-content-click="false"
      transition="scale-transition"
      offset-y
      min-width="auto"
    >
      <template v-slot:activator="{ on, attrs }">
        <validation-provider
          v-slot="{ errors }"
          :name="name"
          :vid="vid"
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
        :allowed-dates="dates ? allowedDates : null"
        :first-day-of-week="1"
        locale="ja-jp"
        @input="datePicker = false; $emit('input', $event)"
      ></v-date-picker>
    </v-menu>
    
    <v-dialog
      v-else
      v-model="datePicker"
      width="240"
    >
      <template v-slot:activator="{ on, attrs }">
      <validation-provider
        v-slot="{ errors }"
        :name="name"
        :vid="vid"
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
        width="240"
        :value="value"
        :day-format="onlyNum"
        :allowed-dates="dates ? allowedDates : null"
        :first-day-of-week="1"
        locale="ja-jp"
        @input="datePicker = false; $emit('input', $event)"
      ></v-date-picker>
    </v-dialog>
  </div>
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
    },
    dates: {
      type: String,
      default: null
    }
  },
  methods: {
    onlyNum: val => new Date(val).getDate(),

    allowedDates: function (val){
      if( this.dates == "afterToday") {
        return val >= this.$moment().format('YYYY-MM-DD');
      }
    }
  },
}
</script>