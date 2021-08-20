<template>
  <v-card>
    <v-toolbar dense>
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
    </v-toolbar>
    <v-navigation-drawer
      v-model="drawer"
      temporary
      absolute
    >
        <v-treeview
          hoverable
          :items="treeView"
        >
          <template v-slot:label="props">
            <div v-if="props.item.children">
              {{props.item.title}}
            </div>
            <v-btn v-else>
              {{props.item.title}}
            </v-btn>
          </template>
        </v-treeview>

    </v-navigation-drawer>
    <Note></Note>
  </v-card>
</template>

<script>
import { mapGetters } from "vuex";
import Note from "../components/StudyNotes/Editor-js.vue"

export default {
  components: {
    Note,
  },
  data() {
    return {
      drawer: false,
      mini: true,
    }
  },
  computed: {
    ...mapGetters('studyNote', ['treeView']),
  },
}
</script>