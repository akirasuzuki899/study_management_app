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

                  <!-- タイムピッカー -->
                  <!-- 開始時間 -->
                  <v-col
                    cols="12"
                    sm="6"
                    md="6"
                  >
                    <v-menu
                      ref="startMenu"
                      v-model="timePickerStart"
                      :close-on-content-click="false"
                      :nudge-right="40"
                      :return-value.sync="formData.start_time"
                      transition="scale-transition"
                      offset-y
                      max-width="290px"
                      min-width="290px"
                    >
                      <template v-slot:activator="{ on, attrs }">
                        <validation-provider
                          vid="start_time"
                          v-slot="{ errors }"
                          name="開始時刻"
                          rules="required"
                        >
                          <v-text-field
                            v-model="formData.start_time"
                            label="開始時刻"
                            prepend-icon="mdi-clock-time-four-outline"
                            readonly
                            v-bind="attrs"
                            v-on="on"
                            :error-messages="errors"
                          ></v-text-field>
                        </validation-provider>
                      </template>
                      <v-time-picker
                        v-if="timePickerStart"
                        v-model="formData.start_time"
                        format="24hr"
                        :allowed-minutes="allowedMinutes"
                        full-width
                        @click:minute="$refs.startMenu.save(formData.start_time)"
                      ></v-time-picker>
                    </v-menu>
                  </v-col>

                  <!-- 終了時間 -->
                  <v-col
                    cols="12"
                    sm="6"
                    md="6"
                  >
                    <v-menu
                      ref="endMenu"
                      v-model="timePickerEnd"
                      :close-on-content-click="false"
                      :nudge-right="40"
                      :return-value.sync="formData.end_time"
                      transition="scale-transition"
                      offset-y
                      max-width="290px"
                      min-width="290px"
                    >
                      <template v-slot:activator="{ on, attrs }">
                        <validation-provider
                        v-slot="{ errors }"
                        name="終了時刻"
                        rules="required|minTime:@start_time,15"
                        >
                          <v-text-field
                            v-model="formData.end_time"
                            label="終了時刻"
                            prepend-icon="mdi-clock-time-four-outline"
                            readonly
                            v-bind="attrs"
                            v-on="on"
                            :error-messages="errors"
                          ></v-text-field>
                        </validation-provider>
                      </template>
                      <v-time-picker
                        v-if="timePickerEnd"
                        v-model="formData.end_time"
                        format="24hr"
                        :allowed-minutes="allowedMinutes"
                        full-width
                        @click:minute="$refs.endMenu.save(formData.end_time)"
                      ></v-time-picker>
                    </v-menu>
                  </v-col>
                  <!-- タイムピッカー -->

                  <v-col
                    cols="12"
                    sm="12"
                    md="12"
                  >
                    <v-switch
                      v-model="formData.is_until_tomorrow"
                      inset
                      label="翌日"
                    ></v-switch>
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
                @task-template="createTaskTemplate($event); close(); "
                @task="createTask($event); close()"
              ></ButtonCreate>
              <ButtonUpdate
                v-if="method=='update'"
                :authTokens="authTokens"
                :formData="formData"
                :target="target"
                :selectedTask="selectedTask"
                @task-template="updateTaskTemplate($event); close()"
                @task="updateTask($event); close()"
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
        is_until_tomorrow: false
      })
    },
    method: {}, 
    target: {},
  },
  data () {
    return {
      timePickerStart: false,
      timePickerEnd: false,
      Dialog: false,
      dayOfWeek: ['月', '火', '水', '木', '金', '土', '日'],
      formData: {
        name: '',
        study_material_id: '',
        day_of_week: '',
        start_time: '',
        end_time: '',
        is_until_tomorrow: false
      }
    }
  },
  computed: {
    ...mapGetters(["authTokens", "studyMaterials"]),
  },
  methods: {
    ...mapActions(["createTaskTemplate","updateTaskTemplate", "createTask", "updateTask"]),

    setDefaultFormData () {
      this.formData.name = this.selectedTask.name
      this.formData.study_material_id = this.selectedTask.study_material_id
      this.formData.day_of_week = this.selectedTask.day_of_week
      this.formData.start_time = this.selectedTask.start_time
      this.formData.end_time = this.selectedTask.end_time
      this.formData.is_until_tomorrow = this.selectedTask.is_until_tomorrow
    },

    allowedMinutes: v => v % 5 === 0 || v === 0,
    
    open () {
      this.setDefaultFormData()
      this.Dialog = true
    },
    
    close () {
      this.Dialog = false
      this.$refs.observer.reset()
    }
  },
}
</script>