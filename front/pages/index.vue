<template>
  <v-row class="flex-column flex-nowrap flex-sm-row flex-sm-wrap fill-height">
    <v-col cols="auto" sm="6">
      <TimeLine></TimeLine>
    </v-col>
    <v-col cols="auto" sm="6">
      <Note></Note>
    </v-col>
  </v-row>
</template>

<script>
import Note from "../components/StudyNotes/Editor-js.vue"
import TimeLine from "../components/TimeLine/TimeLine.vue"

export default {
  components: {
    Note,
    TimeLine
  },
}
</script>