<template>
  <v-container>
    <v-row align="center">
      <v-col cols="auto">
        <v-avatar tile size="40">
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
      </v-col>
      <v-col>
        <div 
          :class="{'text--disabled': task.study_record.is_finished}"
        >{{ task.name }}</div>
      </v-col>
    </v-row>
  </v-container>
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