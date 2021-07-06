<template>
  <v-list-item @click="$emit('clicked', index)">
  <v-list-item-avatar tile size="50">
    <v-img 
      :src="task.study_material.image_url"
      contain
    >
    </v-img>
  </v-list-item-avatar>
  <v-list-item-content>
      <v-list-item-title>{{ task.study_material.title }}</v-list-item-title>
      <v-list-item-subtitle>{{ fromToDateTime(task.start, task.end) }}</v-list-item-subtitle>
  </v-list-item-content>

</v-list-item>
</template>

<script>
import mixinMoment from "../../plugins/mixin-moment"

export default {
  mixins: [mixinMoment],
  props: {
    task: {
      type: Object,
    },
    index: {
      type: Number,
    }
  }
}
</script>