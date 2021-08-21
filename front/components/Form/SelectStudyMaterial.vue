<template>
  <BaseSelect
    :value="value"
    @change="$emit('change', $event)"
    name="教材"
    label="教材"
    :items="studyMaterials"
    item-text="title"
    item-value="id"
    :dense="dense"
    :disabled="disabled"
    :no-data-text="noDataText"
    rules="required"
  ></BaseSelect>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import BaseSelect from "./BaseSelect"

export default {
  name: 'SelectStudyMaterial',
  components: {
    BaseSelect,
  },
  model: {
    prop: 'value',
    event: 'change',
  },
  props: {
    value: {
      type: [Number, String],      //Numberを想定。新規作成時にStringが渡されてしまうので、後日修正する
      default: ''
    },
    dense: {
      type: Boolean,
      default: false
    },
    disabled: {
      type: Boolean,
      default: false
    },
  },
  data: () => ({
    noDataText: '教材を追加して下さい'
  }),
  computed: {
    ...mapGetters('studyMaterial', ['studyMaterials']),
  },
}
</script>