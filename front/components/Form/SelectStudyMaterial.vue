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
    rules="required"
  ></BaseSelect>
</template>

<script>
import { mapGetters } from "vuex";
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
    }
  },
  computed: {
    ...mapGetters('studyMaterial', ['studyMaterials']),
  },
}
</script>