<template>
  <BaseSelect
    :value="value"
    @change="$emit('change', $event)"
    name="曜日"
    label="曜日"
    rules="required|oneOf:月,火,水,木,金,土,日"
    :items="dayOfWeek"
    item-text="title"
    item-value="id"
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
  },
  data() {
    return {
      dayOfWeek: ['月', '火', '水', '木', '金', '土', '日'],
    }
  },
}
</script>