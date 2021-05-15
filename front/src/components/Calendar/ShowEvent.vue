<template>
  <div>
    <v-menu
      v-model="isOpen"
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
          :color="selectedTask.color"
          dark
        >
          <v-toolbar-title v-html="selectedTask.name"></v-toolbar-title>
          <v-spacer></v-spacer>
          <v-btn icon @click="edit()">
            <v-icon>mdi-pencil</v-icon>
          </v-btn>
          <v-btn 
            icon 
            @click="
              close(); 
              deleteTaskTemplate(
                {
                  authTokens: authTokens, 
                  selectedTask: selectedTask
                })
              ">
            <v-icon>mdi-delete-outline</v-icon>
          </v-btn>
        </v-toolbar>
        <v-card-text>
          <p v-html="selectedTask.start_time_hm"></p>
          <p v-html="selectedTask.end_time_hm"></p>
        </v-card-text>
        <v-card-actions>
          <v-btn
            text
            color="secondary"
            @click="close()"
          >
            閉じる
          </v-btn>
        </v-card-actions>
      </v-card>

      <TaskForm
        ref="form"
        method="update"
        :target="target"
        :selectedTask="selectedTask"
      ></TaskForm>
      
    </v-menu>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import TaskForm from "./Form";
export default {
  components: {
      TaskForm,
    },
  props: ["selectedTask", "selectedElement", "target"],
  data() {
    return {
      isOpen: false,
    }
  } ,
  computed: {
    ...mapGetters(["authTokens"])
  },
  methods: {
    ...mapActions(["deleteTaskTemplate"]),

    open(){
      this.isOpen = true
    },
    close(){
      this.isOpen = false
    },
    edit() {
      this.$refs.form.open()
    },
  },
}
</script>

