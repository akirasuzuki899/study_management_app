<template>
  <div>
    <v-row>
      <v-col cols="12" sm="6" md="6">
        <Note></Note>
      </v-col>
      <v-col cols="12" sm="6" md="6">
        <TimeLine></TimeLine>
        </v-col>
    </v-row>
  </div>
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