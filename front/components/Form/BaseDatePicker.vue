<template>
  <v-date-picker
  ref="datePicker"
  :value="value"
  :day-format="onlyNum"
  :allowed-dates="dates ? allowedDates : null"
  :first-day-of-week="1"
  :noTitle="noTitle"
  :width="width"
  color="primary"
  header-color="primary"
  locale="ja-jp"
  @input="$emit('input', $event)"
  @change="$emit('change', $event)"
  @update:picker-date="$emit('picker-date', $event)"
  @update:active-picker="$emit('active-picker', $event)"
  @update:table-date="$emit('table-date', $event)"
></v-date-picker>
</template>

<script>
export default {
  props: {
    value: {
      type: String,
    default: ''
    },
    dates: {
      type: String,
      default: null
    },
    noTitle: {
      type: Boolean,
      default: false
    },
    width: {
      type: [Number, String],
      default: 'auto'
    },
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