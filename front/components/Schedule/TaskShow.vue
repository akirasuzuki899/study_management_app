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

      <v-card-text v-if="selectedTask.study_material">  <!--参照エラーを防ぐ-->
        <ShowStudyMaterial
          :studyMaterial="selectedTask.study_material"
        ></ShowStudyMaterial>
        <v-card-text>
          <v-icon>mdi-calendar-month</v-icon>
          {{ dateTime(selectedTask) }}
        </v-card-text>
        <StudyRecordExpansionPanel
          :studyRecord="selectedTask.study_record"
          :showMenu="isOpen"
        ></StudyRecordExpansionPanel>
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
      @close="close"
    ></TaskForm>
  </v-menu>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import TaskForm from "./TaskForm";
import ButtonDelete from "./TaskButtonDelete";
import ShowStudyMaterial from "../StudyMaterials/ShowStudyMaterials";
import StudyRecordExpansionPanel from "../StudyRecords/studyRecordExpansionPanel";
export default {
  components: {
      TaskForm,
      ShowStudyMaterial,
      StudyRecordExpansionPanel,
      ButtonDelete,
    },
  props: {
    selectedTask: {
      type: Object,
      default:() => ({
        id: '',
        user: '',
        name: '',
        color: 'blue',
        start: '',
        start_date: '',
        start_time: '',
        end: '',
        end_date: '',
        end_time: '',
        study_material: '',
        study_record: '',
      })
    }, 
    selectedElement: {
      type: Node,
    },
    target: {
      type: String,
    }
  },
  data() {
    return {
      isOpen: false,
    }
  } ,
  computed: {
    ...mapGetters(["authTokens"]),
    dateTime: function() {
        return function(item){
          if (item.start_date == item.end_date){
            return `${this.formatDate(item.start_date)} ${item.start_time} 〜 ${item.end_time}`
          } else {
            return `${this.formatDateTime(item.start_date, item.start_time)} 〜 ${this.formatDateTime(item.end_date, item.end_time)}`
          }
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
  },
}
</script>

