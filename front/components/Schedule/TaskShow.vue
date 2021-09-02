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
        <v-btn icon @click="openAlert">
          <v-icon>mdi-delete-outline</v-icon>
        </v-btn>
      </v-toolbar>

      <v-card-text v-if="selectedTask.study_material">  <!--参照エラーを防ぐ-->
        <StudyMaterial
          :studyMaterial="selectedTask.study_material"
        ></StudyMaterial>
        <v-card-text>
          <v-icon>mdi-calendar-month</v-icon>
          {{ fromToDateTime(selectedTask.start, selectedTask.end) }}
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
  </v-menu>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import TaskForm from "./TaskForm";
import StudyMaterial from "../StudyMaterials/StudyMaterial";
import StudyRecordExpansionPanel from "../StudyRecords/studyRecordExpansionPanel";
import Alert from "../Alert"

import mixinMoment from "../../plugins/mixin-moment"

export default {
  components: {
      TaskForm,
      StudyMaterial,
      StudyRecordExpansionPanel,
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
        color: 'blue',
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
    openAlert() {
       this.$refs.alert.open();
    },
  },
}
</script>

