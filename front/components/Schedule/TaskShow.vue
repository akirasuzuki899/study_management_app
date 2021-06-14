<template>
    <v-menu
      v-model="isOpen"
      :eager="true"
      :close-on-content-click="false"
      :activator="selectedElement"
      offset-x
    >
      <v-card
        max-width="350px"
        flat
      >
        <v-toolbar :color="selectedTask.color">
          <v-toolbar-title>{{ selectedTask.name }}</v-toolbar-title>
          <v-spacer></v-spacer>
          <v-btn icon @click.stop="edit()">
            <v-icon>mdi-pencil</v-icon>
          </v-btn>
          <ButtonDelete
            :authTokens="authTokens"
            :selectedTask="selectedTask"
            :target="target"
            @task="deleteTask($event); close()"
          ></ButtonDelete>
        </v-toolbar>

        <v-card-text v-if="selectedTask.study_material" >  <!--参照エラーを防ぐ-->
          <div class="d-flex align-center">
            <v-avatar tile class="ma-3" size="60">
              <v-img 
                :src="selectedTask.study_material.image_url"
                contain
              >
              </v-img>
            </v-avatar>
            <v-card-text>{{ selectedTask.study_material.title }}</v-card-text>
          </div>
          <v-card-text v-if="selectedTask.start_date == selectedTask.end_date">
            <v-icon>mdi-calendar-month</v-icon>
            {{ `${formatDate(selectedTask.start_date)} ${selectedTask.start_time} 〜 ${selectedTask.end_time}` }}
          </v-card-text>
          <v-card-text v-else>
            <v-icon>mdi-calendar-month</v-icon>
            {{ `${formatDateTime(selectedTask.start_date, selectedTask.start_time)} 〜 ${formatDateTime(selectedTask.end_date, selectedTask.end_time)}` }}
          </v-card-text>
          <StudyRecordExpansionPanel
            :studyRecord="selectedTask.study_record"
            :showMenu="isOpen"
          >
          </StudyRecordExpansionPanel>
        </v-card-text>

        <v-card-actions>
          <v-btn
            text
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
        @close="close"
      ></TaskForm>
    </v-menu>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import TaskForm from "./TaskForm";
import ButtonDelete from "./TaskButtonDelete";
import StudyRecordExpansionPanel from "../StudyRecords/studyRecordExpansionPanel";
export default {
  components: {
      TaskForm,
      StudyRecordExpansionPanel,
      ButtonDelete,
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
    ...mapActions('task', ['deleteTask']),

    open(){
      this.isOpen = true
    },
    close(){
      this.isOpen = false
    },
    edit() {
      this.$refs.form.open()
    },
    formatDateTime(date, time){
      const d = new Date(date)
      return `${d.getMonth() + 1}月${d.getDate()}日  ${time}`
    },
    formatDate(date){
      const d = new Date(date)
      return `${d.getMonth() + 1}月${d.getDate()}日`
    },
  },
}
</script>

