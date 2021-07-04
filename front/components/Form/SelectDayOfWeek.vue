<template>
  <BaseSelect
    :value="value"
    @change="$emit('change', $event)"
    name="曜日"
    label="曜日"
    :items="dayOfWeek"
    item-text="day"
    item-value="date"
    :dense="dense"
    rules="required"
  ></BaseSelect>
</template>

<script>
import BaseSelect from "./BaseSelect"

export default {
  name: 'SelectDayOfWeek',
  components: {
    BaseSelect,
  },
  model: {
    prop: 'value',
    event: 'change',
  },
  props: {
    value: {
      type: String,
      default: ''
    },
    dense: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      dayOfWeek: [
        {day:'月', date: '2000-01-03'}, 
        {day:'火', date: '2000-01-04'}, 
        {day:'水', date: '2000-01-05'}, 
        {day:'木', date: '2000-01-06'}, 
        {day:'金', date: '2000-01-07'}, 
        {day:'土', date: '2000-01-08'}, 
        {day:'日', date: '2000-01-09'}],
    }
  },
}
</script>