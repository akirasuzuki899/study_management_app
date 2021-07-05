<template>
  <v-list-item @click="$emit('clicked', index)">
  <v-list-item-avatar tile size="50">
    <v-img 
      :src="item.study_material.image_url"
      contain
    >
    </v-img>
  </v-list-item-avatar>
  <v-list-item-content>
      <v-list-item-title>{{ item.study_material.title }}</v-list-item-title>
      <v-list-item-subtitle>{{ fromToDateTime(item.start, item.end) }}</v-list-item-subtitle>
  </v-list-item-content>

</v-list-item>
</template>

<script>
import mixinMoment from "../../plugins/mixin-moment"

export default {
  mixins: [mixinMoment],
  props: {
    item: {
      type: Object,
    },
    index: {
      type: Number,
    }
  },
  watch: {
    'item.study_record.is_finished': function() {
      if(this.item.study_record.is_finished == true){
        this.$emit('finished', this.index)
      }
    }
  }
}
</script>