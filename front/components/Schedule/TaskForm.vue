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
                      :dense="true"
                    ></TextInput>
                  </v-col>
                </v-row>

                <v-row>
                  <v-col cols="12" sm="12" md="12">
                    <SelectStudyMaterial
                      v-model="formData.study_material_id"
                      :dense="true"
                    ></SelectStudyMaterial>
                  </v-col>
                </v-row>

                <v-row>
                  <v-col cols="12" sm="2" md="2">
                    <SelectorColor
                      v-model="formData.color"
                      :dense="true"
                    ></SelectorColor>
                  </v-col>
                </v-row>

                <v-row>
                  <v-col cols="12" sm="12" md="12" >
                    <DatePicker
                      v-model="formData.start_date"
                      name="日付"
                      label="日付"
                      rules="required"
                      :dense="true"
                    ></DatePicker>
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
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn
                text
                color="secondary"
                @click="close()"
              >
                取消
              </v-btn>
              <ButtonCreate
                :disabled="invalid"
                v-if="method=='create'"
                :authTokens="authTokens"
                :formData="formData"
                :target="target"
                @task="createTask($event); close()"
              ></ButtonCreate>
              <ButtonUpdate
                v-if="method=='update'"
                :disabled="invalid"
                :authTokens="authTokens"
                :formData="formData"
                :target="target"
                :selectedTask="selectedTask"
                @task="updateTask($event); close(); closeShow()"
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
import DatePicker from "../Form/DatePicker";
import SelectTime from "../Form/SelectTime";
import ButtonCreate from "./TaskButtonCreate";
import ButtonUpdate from "./TaskButtonUpdate";

import { mapGetters, mapActions } from "vuex";
import { ValidationObserver } from 'vee-validate';

import mixinMoment from "../../plugins/mixin-moment"

export default {
  components: {
    TextInput,
    SelectStudyMaterial,
    SelectorColor,
    DatePicker,
    SelectTime,
    ButtonCreate,
    ButtonUpdate,
    ValidationObserver,
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
    selecrtedTime: {
      type: Object,
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
        start_date: '',
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
        this.$emit('formClosed')
        this.$refs.observer.reset()
      }
    },
  },
  computed: {
    ...mapGetters(['authTokens']),
  },
  methods: {
    ...mapActions('task', ['createTask', 'updateTask']),

    setDefaultFormData () {
      this.formData.name = this.selectedTask.name
      this.formData.study_material_id = this.selectedTask.study_material_id
      this.formData.color = this.selectedTask.color
      this.formData.start_date = this.date(this.selectedTask.start) || this.selecrtedTime.date
      this.formData.start_time = this.time(this.selectedTask.start) || this.selecrtedTime.startTime
      this.formData.end_time = this.time(this.selectedTask.end) || this.selecrtedTime.endTime
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