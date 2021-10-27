<template>
  <v-row 
    class="flex-column flex-nowrap flex-sm-row flex-sm-wrap fill-height"
    :class="{ 'no-gutters' : $vuetify.breakpoint.name == 'xs' }"
  >
    <v-col 
      cols="auto" 
      sm="6"
      :class="{ 'pb-3' : $vuetify.breakpoint.name == 'xs' }"
      >
      <TimeLine></TimeLine>
    </v-col>
    <v-col cols="auto" sm="6">
      <Note></Note>
    </v-col>
  </v-row>
</template>

<script>
import Note from "../components/StudyNotes/StudyMaterialNotes.vue"
import TimeLine from "../components/TimeLine/TimeLine.vue"

export default {
  components: {
    Note,
    TimeLine
  },
}
</script>