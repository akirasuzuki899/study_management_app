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
          <v-btn icon @click.stop="editSchedule(); $refs.form.setDefaultFormValue()">
            <v-icon>mdi-pencil</v-icon>
          </v-btn>
          <v-btn icon @click.stop="deleteSchedule(); closeShowEvent()">
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
    </v-menu>

    <Form
      ref="form"
      :selectedEvent="selectedEvent"
      :studyMaterials="studyMaterials"
    ></Form>
  </div>
</template>

<script>
import axios from "axios";
import Form from "./Form";
export default {
  components: {
      Form,
    },
  props: ["selectedEvent", "selectedElement", "studyMaterials"],
  data: () => ({
    selectedOpen: false,
  }),
  methods: {
    openShowEvent(){
      this.selectedOpen = true
    },
    closeShowEvent(){
      this.selectedOpen = false
    },
    editSchedule() {
      this.$refs.form.openForm()
    },
    deleteSchedule() {
        axios
          .delete(
            '/api/v1/schedule_templates/' + this.selectedEvent.id,
            {
              headers: this.authTokens
            }
          )
          .then(response => {
            console.log(response);
          })
          .chach(error => {
            console.log(error);
          })
      },
  }
}
</script>

