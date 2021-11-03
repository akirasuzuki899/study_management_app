<template>
  <v-row align="center">
    <v-col cols="auto">
      <v-avatar tile size="40">
        <v-img 
          :src="studyMaterial.image_url"
          contain
        >
        </v-img>
      </v-avatar>
    </v-col>
    <v-col>
      <div>{{ studyMaterial.title }}</div>
    </v-col>
  </v-row>
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