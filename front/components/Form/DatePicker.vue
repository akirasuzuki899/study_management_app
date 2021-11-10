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
      <BaseDatePicker
        :value="value"
        :dates="dates"
        :noTitle="noTitle"
        @input="input"
      ></BaseDatePicker>
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
      <BaseDatePicker
        width="240"
        :value="value"
        :dates="dates"
        :noTitle="noTitle"
        @input="input"
      ></BaseDatePicker>
    </v-dialog>
  </div>
</template>

<script>
import { ValidationProvider } from 'vee-validate';
import BaseDatePicker from  './BaseDatePicker'

export default {
  name: 'DatePicker',
  data() {
    return {
      datePicker: false,
    }
  },
  components: {
    ValidationProvider,
    BaseDatePicker
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
    },
    noTitle: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    input($event){
      this.datePicker = false; 
      this.$emit('input', $event)
    }
  },
}
</script>