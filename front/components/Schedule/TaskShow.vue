<template>
  <v-menu
    v-model="isOpen"
    :eager="true"
    :close-on-content-click="false"
    :activator="selectedElement"
    offset-x
  >
    <v-card
      v-if="selectedTask.study_material"
      max-width="350px"
      flat
    >
      <v-toolbar dense :color="selectedTask.color">
        <v-toolbar-title>{{ selectedTask.name }}</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-btn icon @click.stop="edit()">
          <v-icon>mdi-pencil</v-icon>
        </v-btn>
        <v-btn icon @click="openAlert">
          <v-icon>mdi-delete-outline</v-icon>
        </v-btn>
      </v-toolbar>

      <v-card-text>
        <StudyMaterial
          :studyMaterial="selectedTask.study_material"
          class="py-3"
        ></StudyMaterial>
        <v-row class="no-gutters pb-1">
          <v-col cols="auto" class="pl-2">
            <v-icon>mdi-calendar-month</v-icon>
          </v-col>
          <v-col class="pl-4">
            <div>
              {{ fromToDateTime(selectedTask.start, selectedTask.end) }}
            </div>
          </v-col>
        </v-row>

        <v-row class="no-gutters align-center">
          <v-col cols="auto" class="pl-2">
            <v-icon>mdi-timer</v-icon>
          </v-col>
          <v-col class="pl-4">
            <div v-if="selectedTask.study_record.is_finished">
              {{ fromToDateTime(selectedTask.study_record.start, selectedTask.study_record.end) }}
            </div>
            <div v-else>
              記録がありません
            </div>
          </v-col>
        </v-row>
      </v-card-text>

      <v-card-actions>
        <v-btn
          text
          color="secondary"
          @click="close()"
        >
          閉じる
        </v-btn>
        <v-spacer></v-spacer>
        <v-btn
          v-if="selectedTask.study_record.is_finished"
          color="blue darken-1"
          text
          @click="record"
        >
          記録を更新
        </v-btn>
        <v-btn
          v-else
          color="blue darken-1"
          text
          @click="record"
        >
          記録する
        </v-btn>
      </v-card-actions>
    </v-card>
    <Alert
      ref="alert"
      @clicked="deleteTask({
        selectedTask: selectedTask,
      }); close()"
    >
      <template v-slot:content>
        予定を削除しますか
      </template>
      <template v-slot:btnText>
        削除
      </template>
    </Alert>
    <TaskForm
      ref="form"
      method="update"
      :target="target"
      :selectedTask="selectedTask"
      @close="close"
    ></TaskForm>
    <StudyRecordDialog
      ref="record"
      :studyRecord="selectedTask.study_record"
    ></StudyRecordDialog>
  </v-menu>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import TaskForm from "./TaskForm";
import StudyMaterial from "../StudyMaterials/StudyMaterial";
import StudyRecordDialog from "../StudyRecords/studyRecordDialog.vue";
import Alert from "../Alert"

import mixinMoment from "../../plugins/mixin-moment"

export default {
  components: {
      TaskForm,
      StudyMaterial,
      StudyRecordDialog,
      Alert,
    },
  mixins: [mixinMoment],
  props: {
    selectedTask: {
      type: Object,
      default:() => ({
        id: '',
        user: '',
        name: '',
        color: 'blue darken-2',
        start: '',
        end: '',
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
  },
  computed: {
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
    record() {
      this.$refs.record.open()
    },
    openAlert() {
       this.$refs.alert.open();
    },
  },
}
</script>

