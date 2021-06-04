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
          <ButtonDelete
            :authTokens="authTokens"
            :selectedTask="selectedTask"
            :target="target"
            @task-template="deleteTaskTemplate($event); close()"
          ></ButtonDelete>
        </v-toolbar>
        <v-card-text>
          <p v-html="selectedTask.start_time"></p>
          <p v-html="selectedTask.end_time"></p>
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

      <TaskTemplateForm
        ref="form"
        method="update"
        :target="target"
        :selectedTask="selectedTask"
        @close="close"
      ></TaskTemplateForm>
      
    </v-menu>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import TaskTemplateForm from "./TaskTemplateForm";
import ButtonDelete from "./TaskButtonDelete";
export default {
  components: {
      TaskTemplateForm,
      ButtonDelete,
    },
  props: ["selectedTask", "selectedElement", "target"],
  data() {
    return {
      isOpen: false,
    }
  } ,
  computed: {
    ...mapGetters(['authTokens'])
  },
  methods: {
    ...mapActions('taskTemplate', ['deleteTaskTemplate']),

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

