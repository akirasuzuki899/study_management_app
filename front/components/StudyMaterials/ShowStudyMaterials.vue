<template>
  <div class="d-flex align-center">
    <v-avatar tile class="ma-3" size="60">
      <v-img 
        :src="studyMaterial.image_url"
        contain
      >
      </v-img>
    </v-avatar>
    <v-card-text>{{ studyMaterial.title }}</v-card-text>
  </div>
</template>

<script>
export default {
  props: {
    studyMaterial: {
      type: Object
    }
  }
}
</script>