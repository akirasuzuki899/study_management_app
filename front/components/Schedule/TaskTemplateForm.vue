<template>
  <div class="text-center">
    <v-dialog
      v-model="Dialog"
      width="500"
      @click:outside="close()"
    >
      <v-card>
        <v-card-title>
          <span class="headline">{{selectedTask.name || "新規作成"}}</span>
        </v-card-title>

        <validation-observer
          ref="observer"
          v-slot="{ invalid }"
        >
          <form>
            <v-card-text>
              <v-container>
                <v-row>
                  <v-col cols="12" sm="12" md="12">
                    <TextInput
                      v-model="formData.name"
                      name="タイトル"
                      label="タイトル"
                      rules="required|max:50"
                    ></TextInput>
                  </v-col>
                </v-row>

                <v-row>
                  <v-col cols="12" sm="12" md="12">
                    <SelectStudyMaterial
                      v-model="formData.study_material_id"
                    ></SelectStudyMaterial>
                  </v-col>
                </v-row>

                <v-row>
                  <v-col cols="12" sm="2" md="2">
                    <SelectorColor
                      v-model="formData.color"
                    ></SelectorColor>
                  </v-col>
                </v-row>
                
                <v-row>
                  <v-col cols="12" sm="12" md="12">
                    <SelectDayOfWeek
                      v-model="formData.day_of_week"
                    ></SelectDayOfWeek>
                  </v-col>

                  <v-col cols="12" sm="6" md="6" >
                    <SelectTime
                      vid="start_time"
                      v-model="formData.start_time"
                      name="開始時刻"
                      label="開始時間"
                      rules="required"
                      time="start"
                      :dense="true"
                    ></SelectTime>
                  </v-col>

                  <v-col cols="12" sm="6" md="6" >
                    <SelectTime
                      v-model="formData.end_time"
                      name="終了時刻"
                      label="終了時間"
                      rules="required|minTime:@start_time,15"
                      time="end"
                      :dense="true"
                    ></SelectTime>
                  </v-col>
                </v-row>
              </v-container>
              <small>*indicates required field</small>
            </v-card-text>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn
                color="blue darken-1"
                text
                @click.stop="close()"
              >
                取消
              </v-btn>
              <ButtonCreate
                :disabled="invalid"
                v-if="method=='create'"
                :authTokens="authTokens"
                :formData="formData"
                :target="target"
                @task-template="createTaskTemplate($event); close()"
              ></ButtonCreate>
              <ButtonUpdate
                v-if="method=='update'"
                :disabled="invalid"
                :authTokens="authTokens"
                :formData="formData"
                :target="target"
                :selectedTask="selectedTask"
                @task-template="updateTaskTemplate($event); close(); closeShow()"
              ></ButtonUpdate>
            </v-card-actions>
          </form>
        </validation-observer>

      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import TextInput from "../Form/BaseTextInput";
import SelectStudyMaterial from "../Form/SelectStudyMaterial";
import SelectorColor from "../Form/SelectorColor";
import SelectDayOfWeek from "../Form/SelectDayOfWeek";
import SelectTime from "../Form/SelectTime";
import ButtonCreate from "./TaskButtonCreate";
import ButtonUpdate from "./TaskButtonUpdate";

import { mapGetters, mapActions } from "vuex";
import { ValidationObserver} from 'vee-validate';


export default {
  components: {
    TextInput,
    SelectStudyMaterial,
    SelectorColor,
    SelectDayOfWeek,
    SelectTime,
    ButtonCreate,
    ButtonUpdate,
    ValidationObserver,
  },
  props: {
    selectedTask: {
      type: Object,
      default:() => ({
        id: '',
        user: '',
        name: '',
        color: 'blue',
        day_of_week: '',
        start: '',
        start_time: '',
        end: '',
        end_time: '',
        study_material: '',
      })
    },
    method: {}, 
    target: {},
  },
  data () {
    return {
      Dialog: false,
      formData: {
        name: '',
        study_material_id: '',
        color: '',
        day_of_week: '',
        start_time: '',
        end_time: '',
      }
    }
  },
  watch: {
    Dialog: function() {
      if (this.Dialog == true){
        this.setDefaultFormData()

      } else if (this.Dialog == false) {
        this.$refs.observer.reset()
      }
    },
  },
  computed: {
    ...mapGetters(['authTokens']),
  },
  methods: {
    ...mapActions('taskTemplate', ['createTaskTemplate','updateTaskTemplate']),

    setDefaultFormData () {
      this.formData.name = this.selectedTask.name
      this.formData.study_material_id = this.selectedTask.study_material_id
      this.formData.color = this.selectedTask.color
      this.formData.day_of_week = this.selectedTask.day_of_week
      this.formData.start_time = this.selectedTask.start_time
      this.formData.end_time = this.selectedTask.end_time
    },
    
    open () {
      this.Dialog = true
    },
    
    close () {
      this.Dialog = false
    },

    closeShow() {
      this.$emit('close')
    }
  },
}
</script>