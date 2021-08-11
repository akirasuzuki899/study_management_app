<template>
  <v-menu
    v-model="isOpen"
    :close-on-content-click="false"
    :activator="selectedElement"
    offset-x
  >
    <v-card
      max-width="350px"
      flat
    >
      <v-toolbar :color="selectedTask.color">
        <v-toolbar-title>{{selectedTask.name}}</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-btn icon @click.stop="edit()">
          <v-icon>mdi-pencil</v-icon>
        </v-btn>
        <v-btn icon @click="openAlert">
          <v-icon>mdi-delete-outline</v-icon>
        </v-btn>
      </v-toolbar>

      <v-card-text v-if="selectedTask.study_material">
        <ShowStudyMaterial
          :studyMaterial="selectedTask.study_material"
        ></ShowStudyMaterial>
        <v-card-text>
            <v-icon>mdi-calendar-month</v-icon>
            {{ `毎週 ${selectedTask.day_of_week} ${time(selectedTask.start)} 〜 ${time(selectedTask.end)}` }}
        </v-card-text>
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
      @clicked="deleteTaskTemplate({
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
    <TaskTemplateForm
      ref="form"
      method="update"
      :target="target"
      :selectedTask="selectedTask"
      @close="close"
    ></TaskTemplateForm>
    
  </v-menu>
</template>

<script>
import { mapActions } from "vuex";
import TaskTemplateForm from "./TaskTemplateForm";
import ShowStudyMaterial from "../StudyMaterials/ShowStudyMaterials";
import Alert from "../Alert"

import mixinMoment from "../../plugins/mixin-moment"

export default {
  components: {
      TaskTemplateForm,
      ShowStudyMaterial,
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
      type: Node
    }, 
    target: {
      type: String
    },
  },
  data() {
    return {
      isOpen: false,
    }
  } ,
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
    openAlert() {
      this.$refs.alert.open();
    },
  },
}
</script>

