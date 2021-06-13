<template>
  <v-expansion-panels flat v-model="openedPanel">
    <v-expansion-panel>

      <v-expansion-panel-header>
        <div class="d-flex" v-if="studyRecord.is_finished == true">
          <v-card-text v-if="studyRecord.start_date == studyRecord.end_date">
            <v-icon>mdi-timer</v-icon>
            {{ `${formatDate(studyRecord.start_date)} ${studyRecord.start_time} 〜 ${studyRecord.end_time}` }}
          </v-card-text>
          <v-card-text v-else>
            <v-icon>mdi-timer</v-icon>
            {{ `${formatDateTime(studyRecord.start_date, studyRecord.start_time)} 〜 ${formatDateTime(studyRecord.end_date, studyRecord.end_time)}` }}
          </v-card-text>
        </div>
        <v-card-text v-else>
          <v-icon>mdi-timer</v-icon>
          記録がありません
        </v-card-text>
      </v-expansion-panel-header>

      <v-expansion-panel-content :eager="true">
        <StudyRecordForm
          ref="StudyRecordForm"
          :selectedStudyRecord="studyRecord"
          @close="closePanel"
        ></StudyRecordForm>
      </v-expansion-panel-content>

    </v-expansion-panel>
  </v-expansion-panels>
</template>

<script>
import StudyRecordForm from "../StudyRecords/studyRecordForm.vue";
export default {
  props: ["studyRecord", "showMenu"],
  components: {
      StudyRecordForm,
  },
  data() {
    return {
      openedPanel: null
    }
  },
  watch: {
    showMenu: function(showMenu) {
      if (showMenu == true) {
        this.$refs.StudyRecordForm.setDefaultFormData()
      } else {
        this.$refs.StudyRecordForm.initValidation()
        this.closePanel()

      }
    }
  },
  methods: {
    formatDateTime(date, time){
      const d = new Date(date)
      return `${d.getMonth() + 1}月${d.getDate()}日  ${time}`
    },
    formatDate(date){
      const d = new Date(date)
      return `${d.getMonth() + 1}月${d.getDate()}日`
    },
    closePanel () {
      this.openedPanel = null
    },
  }

}
</script>