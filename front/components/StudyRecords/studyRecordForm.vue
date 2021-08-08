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
                  <DatePicker
                    v-model="formData.start_date"
                    name="日付"
                    label="日付"
                    rules="required"
                    :dense="true"
                  ></DatePicker>
                </v-col>

                <!-- 開始時間 -->
                <v-col cols="12" sm="6" md="6">
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

                <!-- 終了時間 -->
                <v-col cols="12" sm="6" md="6">
                  <SelectTime
                    v-model="formData.end_time"
                    name="終了時刻"
                    label="終了時間"
                    rules="required"
                    time="end"
                    :dense="true"
                  ></SelectTime>
                </v-col>
              </v-row>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-alert
              v-model="alertable"
              class="ma-0 pa-1"
              :color="alertColor"
              text
            >{{alertMessage}}
            </v-alert>
            <v-spacer></v-spacer>
            <v-btn
              color="blue darken-1"
              text
              :disabled="invalid || disabled"
              :loading="loading"
              @click="updateRecord(
                formData, selectedStudyRecord
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
import DatePicker from "../Form/DatePicker";
import SelectTime from "../Form/SelectTime";

import { mapActions } from "vuex";
import { ValidationObserver } from 'vee-validate';

import mixinMoment from "../../plugins/mixin-moment"

export default {
  components: {
    DatePicker,
    SelectTime,
    ValidationObserver,
  },
  mixins: [mixinMoment],
  props:{
    selectedStudyRecord: {
      type: Object
    },
    isOpen: {
      type: Boolean,
      isOpen: false
    }
  },
  data(){
    return {
      alertIDs: [false],
      loadIDs: [false],
      disabledIDs: [false],
      underUpgrteIDs: [false],
      alertMessage: "更新しました",
      alertColor: "green",
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

    alertable: function() {
        return this.underUpgrteIDs[this.selectedStudyRecord.id] == true && this.alertIDs[this.selectedStudyRecord.id] == true
    },
    loading: function() {
        return this.underUpgrteIDs[this.selectedStudyRecord.id] == true && this.loadIDs[this.selectedStudyRecord.id]  == true
    },
    disabled: function() {
        return this.underUpgrteIDs[this.selectedStudyRecord.id] == true && this.disabledIDs[this.selectedStudyRecord.id] == true
    },

  },
  methods: {
    ...mapActions('studyRecord', ['updateStudyRecord']),
    ...mapActions('snackbar', ['successMessage']),

    updateRecord(formData, selectedStudyRecord){
      this.$set(this.underUpgrteIDs, selectedStudyRecord.id, true)
      this.$set(this.loadIDs, selectedStudyRecord.id, true)

      this.updateStudyRecord({
        formData: formData,
        id: selectedStudyRecord.id
      }).then (() => {
        if ( this.isOpen ){
          this.$set(this.loadIDs, selectedStudyRecord.id, false)
          this.$set(this.disabledIDs, selectedStudyRecord.id, true)
          this.$set(this.alertIDs, selectedStudyRecord.id, true)
    
          setTimeout(() => {
            this.$set(this.disabledIDs, selectedStudyRecord.id, false)
            this.$set(this.alertIDs, selectedStudyRecord.id, false)
            if (this.underUpgrteIDs[this.selectedStudyRecord.id] == true) this.close()
    
            this.$set(this.underUpgrteIDs, selectedStudyRecord.id, false)
            }, 3000)
        } else {
          this.successMessage('更新しました')
          this.$set(this.underUpgrteIDs, selectedStudyRecord.id, false)
          this.$set(this.loadIDs, selectedStudyRecord.id, false)
        }
      })
    },

    setDefaultFormData () {
      this.formData.task_id = this.selectedStudyRecord.task_id
      this.formData.study_material_id = this.selectedStudyRecord.study_material_id
      this.formData.start_date = this.date(this.selectedStudyRecord.start) || this.now
      this.formData.start_time = this.time(this.selectedStudyRecord.start)
      this.formData.end_time = this.time(this.selectedStudyRecord.end)
      this.formData.is_finished = true
    },
    initValidation() {
      this.$refs.observer.reset()
    },
    close(){
      this.$emit('close');
    }
  }
}
</script>