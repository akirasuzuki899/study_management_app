<template>
  <v-menu
    v-model="isOpen"
    :eager="true"
    :close-on-content-click="false"
    :activator="selectedElement"
    offset-x
  >
    <v-card
      max-width="600px"
      flat
    >
      <v-toolbar dense :color="selectedTask.color">
        <v-toolbar-title>{{selectedTask.name}}</v-toolbar-title>
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
          v-if="selectedTask.study_material"
          :studyMaterial="selectedTask.study_material"
          class="py-3"
        ></StudyMaterial>
        <v-row class="no-gutters align-center">
          <v-col cols="auto" class="pl-2">
            <v-icon>mdi-calendar-month</v-icon>
          </v-col>
          <v-col class="pl-4">
            {{ `毎週 ${selectedTask.day_of_week} ${time(selectedTask.start)} 〜 ${time(selectedTask.end)}` }}
          </v-col>
        </v-row>

        <v-divider class="my-3"></v-divider>

        <v-row class="flex-column no-gutters">
          <v-col>
            <div class="text-subtitle-1 font-weight-bold pb-2">詳細</div>
          </v-col>
          <v-col>
            <TextArea
              v-if="id"
              ref="textArea"
              class="overflow-y-auto" 
              :style="TextAreaHeight"
              :id="id"
              :text="selectedTask.text"
            ></TextArea>
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
import StudyMaterial from "../StudyMaterials/StudyMaterial";
import Alert from "../Alert"
import TextArea from "../Form/BaseTextArea"


import mixinMoment from "../../plugins/mixin-moment"

export default {
  components: {
      TaskTemplateForm,
      StudyMaterial,
      Alert,
      TextArea
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
      type: Node
    }, 
    target: {
      type: String
    },
  },
  computed: {
    TextAreaHeight () {
      switch (this.$vuetify.breakpoint.name) {
        case 'xs': return { "max-height": "200px" }
        case 'sm': return { "max-height": "250px" }
        case 'md': return { "max-height": "250px" }
        case 'lg': return { "max-height": "250px" }
        case 'xl': return { "max-height": "250px" }
      }
    }
  },
  data() {
    return {
      isOpen: false,
      id: undefined
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
  mounted () {
    this.id = this._uid
  },
}
</script>

