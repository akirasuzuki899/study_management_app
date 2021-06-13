<template>
  <div class="text-center" :key="selectedTask.id || null">
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
                  <v-col
                    cols="12"
                    sm="12"
                    md="12"
                  >
                    <validation-provider
                      v-slot="{ errors }"
                      name="タイトル"
                      rules="required|max:50"
                    >
                      <v-text-field
                        label="タイトル"
                        v-model="formData.name"
                        :error-messages="errors"
                        required
                      ></v-text-field>
                    </validation-provider>
                  </v-col>

                  <v-col
                    cols="12"
                    sm="12"
                    md="12"
                  >
                    <validation-provider
                      v-slot="{ errors }"
                      name="教材"
                      rules="required"
                    >
                      <v-select 
                        label="教材"
                        :items="studyMaterials"
                        item-text="title"
                        item-value="id"
                        v-model="formData.study_material_id"
                        :error-messages="errors"
                        required
                      />
                    </validation-provider>
                  </v-col>

                  <!-- イベントのカラー -->
                  
                  <v-col cols="12" sm="2" md="2">
                    <v-menu 
                      v-model="colorMenu"
                      :close-on-content-click="false"
                      transition="scale-transition"
                      offset-y
                    >
                      <template v-slot:activator="{ attrs }">
                        <v-text-field
                          readonly
                          append-icon="mdi-menu-down"
                          v-bind="attrs"
                          @mouseup="colorMenu = true"
                        >
                          <template v-slot:prepend-inner>
                            <div 
                              class="pa-2 rounded-circle"
                              v-bind:class="formData.color"
                            ></div>
                          </template>
                        </v-text-field>
                      </template>
                      <v-list
                        class="d-flex justify-center"
                      >
                        <v-list-item
                          v-for="(color, index) in colors"
                          :key="index"
                          @click="formData.color = color; colorMenu = false"
                        >
                          <div 
                            class="pa-2 rounded-circle"
                            v-bind:class="color"
                          ></div>
                        </v-list-item>
                      </v-list> 
                    </v-menu>
                  </v-col>
                  
                  <!-- 曜日 -->
                  <v-col
                    cols="12"
                    sm="12"
                    md="12"
                  >
                    <validation-provider
                      v-slot="{ errors }"
                      name="曜日"
                      rules="required|oneOf:月,火,水,木,金,土,日"
                    >
                      <v-select
                        label="曜日"
                        :items="dayOfWeek" 
                        v-model="formData.day_of_week"
                        :error-messages="errors"
                        required
                      ></v-select>
                    </validation-provider>
                  </v-col>

                  <!-- 開始時間 -->

                  <v-col
                    class="d-flex"
                    cols="12"
                    sm="6"
                  >
                    <validation-provider
                      vid="start_time"
                      v-slot="{ errors }"
                      name="開始時刻"
                      rules="required"
                    >
                      <v-select
                        :items="allowedTimeStart"
                        v-model="formData.start_time"
                        prepend-icon="mdi-clock-time-four-outline"
                        label="開始時間"
                        :error-messages="errors"
                        dense
                      ></v-select>
                    </validation-provider>
                  </v-col>


                  <!-- 終了時間 -->

                  <v-col
                    class="d-flex"
                    cols="12"
                    sm="6"
                  >
                    <validation-provider
                      v-slot="{ errors }"
                      name="終了時刻"
                      rules="required|minTime:@start_time,15"
                    >
                      <v-select
                        :items="allowedTimeEnd"
                        v-model="formData.end_time"
                        prepend-icon="mdi-clock-time-four-outline"
                        label="終了時間"
                        :error-messages="errors"
                        dense
                      ></v-select>
                    </validation-provider>
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
import { mapGetters, mapActions } from "vuex";
import ButtonCreate from "./TaskButtonCreate";
import ButtonUpdate from "./TaskButtonUpdate";
import { required, max, oneOf } from 'vee-validate/dist/rules';
import { minTime } from '../../plugins/vee-validate';
import { extend, ValidationObserver, ValidationProvider, setInteractionMode, localize} from 'vee-validate';
import ja from 'vee-validate/dist/locale/ja';

setInteractionMode('eager')

extend('required', required)
extend('max', max)
extend('oneOf', oneOf)
extend('minTime', minTime)
localize('ja', ja)


export default {
  components: {
    ButtonCreate,
    ButtonUpdate,
    ValidationProvider,
    ValidationObserver,
  },
  props: {
    selectedTask: {
      default:() => ({
        name: '',
        study_material_id: '',
        start_time: '',
        end_time: '',
      })
    },
    method: {}, 
    target: {},
  },
  data () {
    return {
      Dialog: false,
      colorMenu: false,
      dayOfWeek: ['月', '火', '水', '木', '金', '土', '日'],
      colors: ['blue', 'indigo', 'deep-purple', 'cyan', 'green', 'orange', 'grey darken-1'],
      baseAllowedTime: [
                 "00:15", "00:30", "00:45", 
        "01:00", "01:15", "01:30", "01:45", 
        "02:00", "02:15", "02:30", "02:45", 
        "03:00", "03:15", "03:30", "03:45", 
        "04:00", "04:15", "04:30", "04:45", 
        "05:00", "05:15", "05:30", "05:45", 
        "06:00", "06:15", "06:30", "06:45", 
        "07:00", "07:15", "07:30", "07:45", 
        "08:00", "08:15", "08:30", "08:45", 
        "09:00", "09:15", "09:30", "09:45", 
        "10:00", "10:15", "10:30", "10:45", 
        "11:00", "11:15", "11:30", "11:45", 
        "12:00", "12:15", "12:30", "12:45", 
        "13:00", "13:15", "13:30", "13:45", 
        "14:00", "14:15", "14:30", "14:45", 
        "15:00", "15:15", "15:30", "15:45", 
        "16:00", "16:15", "16:30", "16:45", 
        "17:00", "17:15", "17:30", "17:45", 
        "18:00", "18:15", "18:30", "18:45", 
        "19:00", "19:15", "19:30", "19:45", 
        "20:00", "20:15", "20:30", "20:45", 
        "21:00", "21:15", "21:30", "21:45", 
        "22:00", "22:15", "22:30", "22:45", 
        "23:00", "23:15", "23:30", "23:45", 
      ],
      formData: {
        name: '',
        study_material_id: '',
        day_of_week: '',
        start_time: '',
        end_time: '',
      }
    }
  },
  computed: {
    ...mapGetters('studyMaterial', ['studyMaterials']),
    ...mapGetters(['authTokens']),
    allowedTimeStart: function() {
      return ["00:00", ...this.baseAllowedTime]
    },
    allowedTimeEnd: function() {
      return [...this.baseAllowedTime, "24:00"]
    },
  },
  methods: {
    ...mapActions('taskTemplate', ['createTaskTemplate','updateTaskTemplate']),

    setDefaultFormData () {
      this.formData.name = this.selectedTask.name
      this.formData.study_material_id = this.selectedTask.study_material_id
      this.formData.day_of_week = this.selectedTask.day_of_week
      this.formData.start_time = this.selectedTask.start_time
      this.formData.end_time = this.selectedTask.end_time
      this.formData.color = this.selectedTask.color || "blue"
    },
    
    open () {
      this.setDefaultFormData()
      this.Dialog = true
    },
    
    close () {
      this.Dialog = false
      this.$refs.observer.reset()
    },

    closeShow() {
      this.$emit('close')
    }
  },
}
</script>