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
        <v-card-text v-if="selectedTask.study_material" >  <!--titleが参照できないのを防ぐ-->
          <div class="d-flex align-center">
            <v-avatar
              class="ma-3"
              size="60"
              tile
            >
              <v-img :src="selectedTask.study_material.image_url"></v-img>
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

          <v-expansion-panels flat v-model="openedPanel">
            <v-expansion-panel>

              <v-expansion-panel-header>
                <div class="d-flex" v-if="selectedTask.study_record.is_finished == true">
                  <v-card-text v-if="selectedTask.study_record.start_date == selectedTask.study_record.end_date">
                    <v-icon>mdi-timer</v-icon>
                    {{ `${formatDate(selectedTask.study_record.start_date)} ${selectedTask.study_record.start_time} 〜 ${selectedTask.study_record.end_time}` }}
                  </v-card-text>
                  <v-card-text v-else>
                    <v-icon>mdi-timer</v-icon>
                    {{ `${formatDateTime(selectedTask.study_record.start_date, selectedTask.study_record.start_time)} 〜 ${formatDateTime(selectedTask.study_record.end_date, selectedTask.study_record.end_time)}` }}
                  </v-card-text>
                </div>
                <v-card-text v-else>
                  <v-icon>mdi-timer</v-icon>
                  記録がありません
                </v-card-text>
              </v-expansion-panel-header>

              <v-expansion-panel-content :eager="true">
                <StudyRecordForm
                  ref="StudyRecordForm"
                  :selectedStudyRecord="selectedTask.study_record"
                  @close="closePanel"
                ></StudyRecordForm>
              </v-expansion-panel-content>

            </v-expansion-panel>
          </v-expansion-panels>

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
import StudyRecordForm from "../StudyRecords/studyRecordForm.vue";
export default {
  components: {
      TaskForm,
      StudyRecordForm,
      ButtonDelete,
    },
  props: ["selectedTask", "selectedElement", "target"],
  data() {
    return {
      isOpen: false,
      openedPanel: null
    }
  } ,
  computed: {
    ...mapGetters(["authTokens"])
  },
  watch: {
    isOpen: function(isOpen) {
      if (isOpen == true) {
        this.$refs.StudyRecordForm.setDefaultFormData()
      } else {
        this.$refs.StudyRecordForm.initValidation()
        this.closePanel()

      }
    }
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
    closePanel () {
      this.openedPanel = null
    },
  },
}
</script>

