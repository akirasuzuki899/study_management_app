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
        <v-card-text>
          <v-container>
            <v-row>
              <v-col
                cols="12"
                sm="12"
                md="12"
              >
                <v-text-field
                  label="タイトル"
                  v-model="formData.name"
                  required
                ></v-text-field>
              </v-col>
              <v-col
                cols="12"
                sm="12"
                md="12"
              >
                <v-select 
                  label="教材"
                  :items="studyMaterials"
                  item-text="title"
                  item-value="id"
                  v-model="formData.study_material_id"
                  required
                />
              </v-col>
              <v-col
                cols="12"
                sm="4"
                md="4"
              >
                <v-select
                  label="曜日"
                  :items="dayOfWeek" 
                  v-model="formData.day_of_week"
                  required
                ></v-select>
              </v-col>

              <!-- タイムピッカー -->
              <!-- 開始時間 -->
              <v-col
                cols="12"
                sm="4"
                md="4"
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
                    <v-text-field
                      v-model="formData.start_time"
                      label="開始時刻"
                      prepend-icon="mdi-clock-time-four-outline"
                      readonly
                      v-bind="attrs"
                      v-on="on"
                    ></v-text-field>
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
                sm="4"
                md="4"
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
                    <v-text-field
                      v-model="formData.end_time"
                      label="終了時刻"
                      prepend-icon="mdi-clock-time-four-outline"
                      readonly
                      v-bind="attrs"
                      v-on="on"
                    ></v-text-field>
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
          <v-btn
            v-if="method === 'create'"
            color="blue darken-1"
            text
            @click="
              create(
                {
                  authTokens: authTokens,
                  formData: formData
                }); 
              close()"
          >
            保存
          </v-btn>
          <v-btn
            v-if="method === 'update'"
            color="blue darken-1"
            text
            @click="
              update(
                {
                  authTokens: authTokens,
                  selectedTask: selectedTask,
                  formData: formData,
                }); 
              close()"
          >
            更新
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";

export default {
  props: {
    selectedTask: {
      default:() => ({
        name: '',
        study_material_id: '',
        day_of_week: '',
        start_time_hm: '',
        end_time_hm: ''
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
        end_time: ''
      }
    }
  },
  computed: {
    ...mapGetters(["authTokens", "studyMaterials"]),
  },
  methods: {
    ...mapActions({
      create: "createTaskTemplate",
      update:  "updateTaskTemplate"
    }),

    setDefaultFormData () {
      this.formData.name = this.selectedTask.name
      this.formData.study_material_id = this.selectedTask.study_material_id
      this.formData.day_of_week = this.selectedTask.day_of_week
      this.formData.start_time = this.selectedTask.start_time_hm
      this.formData.end_time = this.selectedTask.end_time_hm
    },

    allowedMinutes: v => v % 5 === 0 || v === 0,

    open () {
      this.setDefaultFormData()
      this.Dialog = true
    },
    
    close () {
      this.Dialog = false
    }
  },
}
</script>