<template>
  <div>
    <validation-observer
      ref="observer"
      v-slot="{ invalid }"
    >
      <form>
        <v-card >
          <v-card-text>
            <v-container>
              <v-row>
                <!-- 開始日 -->
                <v-col cols="12" sm="12" md="12" >
                  <v-menu
                    v-model="datePickerStart"
                    :close-on-content-click="false"
                    :nudge-right="40"
                    transition="scale-transition"
                    offset-y
                    min-width="auto"
                  >
                    <template v-slot:activator="{ on, attrs }">
                      <validation-provider
                        v-slot="{ errors }"
                        name="日付"
                        rules="required"
                      >
                        <v-text-field
                          v-model="formData.start_date"
                          label="日付"
                          prepend-icon="mdi-calendar"
                          :error-messages="errors"
                          readonly
                          dense
                          v-bind="attrs"
                          v-on="on"
                        ></v-text-field>
                      </validation-provider>
                    </template>
                    <v-date-picker
                      v-model="formData.start_date"
                      :day-format="onlyNum"
                      :allowed-dates="afterToday"
                      :first-day-of-week="1"
                      locale="ja-jp"
                      @input="datePickerStart = false"
                    ></v-date-picker>
                  </v-menu>
                </v-col>

                <!-- 開始時間 -->
                <v-col cols="12" sm="6" md="6">
                  <validation-provider
                    v-slot="{ errors }"
                    name="開始時間"
                    rules="required"
                  >
                    <v-select
                      :items="allowedTimeStart"
                      v-model="formData.start_time"
                      :error-messages="errors"
                      prepend-icon="mdi-clock-time-four-outline"
                      label="開始時間"
                      dense
                    ></v-select>
                  </validation-provider>
                </v-col>

                <!-- 終了時間 -->
                <v-col cols="12" sm="6" md="6">
                  <validation-provider
                    v-slot="{ errors }"
                    name="終了時間"
                    rules="required"
                  >
                    <v-select
                      :items="allowedTimeEnd"
                      v-model="formData.end_time"
                      :error-messages="errors"
                      prepend-icon="mdi-clock-time-four-outline"
                      label="終了時間"
                      dense
                    ></v-select>
                  </validation-provider>
                </v-col>

              </v-row>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-alert
              v-model="alert"
              class="ma-0 pa-1"
              :color="alertColor"
              text
            >{{alertMessage}}
            </v-alert>
            <v-spacer></v-spacer>
            <v-btn
              :disabled="invalid || btnDisabled"
              :loading="loading"
              plain
              @click="updateRecord(
                formData, authTokens, selectedStudyRecord
              )"
            >
            更新
            </v-btn>
            
          </v-card-actions>
        </v-card>
      </form>
    </validation-observer>
  
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import { required } from 'vee-validate/dist/rules';
import { extend, ValidationObserver, ValidationProvider, setInteractionMode, localize} from 'vee-validate';
import ja from 'vee-validate/dist/locale/ja';

setInteractionMode('eager')

extend('required', required)
localize('ja', ja)

export default {
  components: {
    ValidationProvider,
    ValidationObserver,
  },
  props:["selectedStudyRecord"],
  data(){
    return {
      isOpen: false,
      alert: false,
      datePickerStart: false,
      loading: false,
      btnDisabled: false,
      alertMessage: "",
      alertColor: "",
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
        task_id: '',
        study_material_id: '',
        start_date: '',
        start_time: '',
        end_time: '',
        is_finished: '',
      }
    }
  },
  computed: {
    // ...mapGetters('studyRecord', ['studyRecords']),
    ...mapGetters(['authTokens']),

    allowedTimeStart: function() {
      return ["00:00", ...this.baseAllowedTime]
    },
    allowedTimeEnd: function() {
      return [...this.baseAllowedTime, "24:00"]
    },
  },
  methods: {
    ...mapActions('studyRecord', ['updateStudyRecord']),

    updateRecord(formData, authTokens, selectedStudyRecord){
      this.loading = true
      console.log("selectedStudyRecord")
      console.log(selectedStudyRecord.id)
      this.updateStudyRecord({
        formData: formData,
        authTokens: authTokens,
        id: selectedStudyRecord.id
      }).then((res) => {
        setTimeout(() => {
          this.loading = false
          this.btnDisabled = true
          this.alert = true
          this.alertMessage = "更新しました"
          this.alertColor = "green"
          }, 2000)
        setTimeout(() => {
          this.btnDisabled = false
          this.alert = false
          this.close()
          }, 4000)
      })
    },

    setDefaultFormData () {
      this.formData.task_id = this.selectedStudyRecord.task_id
      this.formData.study_material_id = this.selectedStudyRecord.study_material_id
      this.formData.start_date = this.selectedStudyRecord.start_date
      this.formData.start_time = this.selectedStudyRecord.start_time
      this.formData.end_time = this.selectedStudyRecord.end_time
      this.formData.is_finished = true
    },

    onlyNum: val => new Date(val).getDate(),

    afterToday: val => val >= new Date().toISOString().substr(0, 10),

    initValidation() {
      this.$refs.observer.reset()
    },
    close(){
      this.$emit('close');
    }
  }
}
</script>