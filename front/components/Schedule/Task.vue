<template>
  <div class="d-flex align-center">
    <v-avatar tile class="ma-3" size="60">
      <v-img 
        :src="task.study_material.image_url"
        contain
      >
      </v-img>
    </v-avatar>
    <v-card-text>{{ task.name }}</v-card-text>
  </div>
</template>

<script>
export default {
  props: {
    task: {
      type: Object
    }
  }
}
</script>