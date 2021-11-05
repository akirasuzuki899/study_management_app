<template>
  <v-btn
    :fab="fab"
    :icon="icon"
    text
    small
    @click="$emit('click')"
  >
    <v-icon v-if="right">mdi-chevron-right</v-icon>
    <v-icon v-if="left">mdi-chevron-left</v-icon>
  </v-btn>
</template>

<script>
export default {
  props: {
    right: {
      type: Boolean,
      default: false
    },
    left: {
      type: Boolean,
      default: false
    },
    fab: {
      type: Boolean,
      default: false
    },
    icon: {
      type: Boolean,
      default: false
    },
  }
}
</script>