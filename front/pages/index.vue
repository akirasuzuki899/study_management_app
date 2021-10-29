<template>
  <v-row 
    class="flex-column flex-nowrap flex-sm-row flex-sm-wrap no-gutters fill-height"
  >
    <v-col 
      cols="auto" 
      sm="6"
      class="pr-sm-2"
      :class="{ 'pb-3' : $vuetify.breakpoint.name == 'xs' }"
    >
      <TimeLine></TimeLine>
    </v-col>
    <v-col 
      cols="auto" sm="6"
      class="pl-sm-2"
    >
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