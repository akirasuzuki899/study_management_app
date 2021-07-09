<template>
  <v-list-item @click="$emit('clicked', index)">
    <v-list-item-avatar tile size="50">
      <v-img
        :src="studyMaterial.image_url"
        contain
      >
      </v-img>
    </v-list-item-avatar>
    <v-list-item-content>
        <v-list-item-title>{{ studyMaterial.title }}</v-list-item-title>
        <slot name="content" :study-material="studyMaterial"></slot>
    </v-list-item-content>
    <v-list-item-action>
        <slot name="btn" :study-material="studyMaterial"></slot>
    </v-list-item-action>
  </v-list-item>
</template>

<script>
export default {
  props: {
    studyMaterial: {
      type: Object,
    },
    index: {
      type: Number,
    }
  }
}
</script>