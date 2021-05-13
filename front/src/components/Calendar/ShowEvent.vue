<template>
  <div>
    <v-menu
      v-model="selectedOpen"
      :close-on-content-click="false"
      :activator="selectedElement"
      offset-x
    >
      <v-card
        color="grey lighten-4"
        min-width="350px"
        flat
      >
        <v-toolbar
          :color="selectedEvent.color"
          dark
        >
          <v-toolbar-title v-html="selectedEvent.name"></v-toolbar-title>
          <v-spacer></v-spacer>
          <v-btn icon @click="editTask()">
            <v-icon>mdi-pencil</v-icon>
          </v-btn>
          <v-btn 
            icon 
            @click="
              closeShowEvent(); 
              deleteTaskTemplate(
                {
                  authTokens: authTokens, 
                  selectedEvent: selectedEvent
                })
              ">
            <v-icon>mdi-delete-outline</v-icon>
          </v-btn>
        </v-toolbar>
        <v-card-text>
          <p v-html="selectedEvent.start_time_hm"></p>
          <p v-html="selectedEvent.end_time_hm"></p>
        </v-card-text>
        <v-card-actions>
          <v-btn
            text
            color="secondary"
            @click="closeShowEvent"
          >
            閉じる
          </v-btn>
        </v-card-actions>
      </v-card>

      <Form
        ref="form"
        method="updateTaskTemplate"
        :selectedEvent="selectedEvent"
      ></Form>
      
    </v-menu>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import Form from "./Form";
export default {
  components: {
      Form,
    },
  props: ["selectedEvent", "selectedElement"],
  data() {
    return {
      selectedOpen: false,
    }
  } ,
  computed: {
    ...mapGetters(["authTokens"])
  },
  methods: {
    ...mapActions(["deleteTaskTemplate"]),

    openShowEvent(){
      this.selectedOpen = true
    },
    closeShowEvent(){
      this.selectedOpen = false
    },
    editTask() {
      this.$refs.form.openForm()
    },
  },
}
</script>

