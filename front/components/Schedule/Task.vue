<template>
  <div class="d-flex align-center">
    <v-avatar tile class="ma-3" size="60">
      <v-img 
        :src="task.study_material.image_url"
        contain
      >
        <v-overlay
          v-if="task.study_record.is_finished"
          absolute
          opacity='0.5'
        ></v-overlay>
      </v-img>
    </v-avatar>
    <v-card-text v-bind:class="{'text--disabled': task.study_record.is_finished}">{{ task.name }}</v-card-text>
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