<template>
  <v-list
    :dense="true"
    :subheader="true"
    max-height="100%"
    class="overflow-y-auto"
  >
    <template v-for="(item, index) in studyMaterials">
      <v-list-item 
        @click="$emit('clicked', index)"
        :key="`material-${index}`"
        :ripple="ripple"
      >
        <v-list-item-avatar tile size="50">
          <v-img
            :src="item.image_url"
            contain
          >
          </v-img>
        </v-list-item-avatar>
        <v-list-item-content>
            <v-list-item-title>{{ item.title }}</v-list-item-title>
            <slot name="content" :study-material="item" :index="index"></slot>
        </v-list-item-content>
        <v-list-item-action>
            <slot name="btn" :study-material="item" :index="index"></slot>
        </v-list-item-action>
      </v-list-item>
      <v-divider
        v-if="index < studyMaterials.length - 1"
        :key="`divider-${index}`"
      ></v-divider>
    </template>
    <slot name="default"></slot>
  </v-list>
</template> 
<script>
export default {
  props: {
    studyMaterials: {
      type: Array,
    },
    maxHeight: {
      type: String,
    },
    ripple: {
      type: Boolean,
      default: true
    }
  }
}
</script>