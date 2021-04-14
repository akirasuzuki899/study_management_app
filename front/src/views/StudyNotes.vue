<template>
  <v-app>
    <router-view></router-view>
  </v-app>
</template>

<script>
  import NewStudyNotes from "../components/StudyNotes/NewStudyNotes";
  import IndexStudyNotes from "../components/StudyNotes/IndexStudyNotes";
  import ShowStudyNote from "../components/StudyNotes/ShowStudyNote";

  export default {
    Components: {
      NewStudyNotes,
      IndexStudyNotes,
      ShowStudyNote,
    }
  }
</script>