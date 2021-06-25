<template>
  <v-expansion-panels flat v-model="openedPanel">
    <v-expansion-panel>

      <v-expansion-panel-header>
        <div class="d-flex" v-if="studyRecord.is_finished == true">
          <v-card-text>
            <v-icon>mdi-timer</v-icon>
            {{ dateTime(studyRecord) }}
          </v-card-text>
        </div>
        <v-card-text v-else>
          <v-icon>mdi-timer</v-icon>
          記録がありません
        </v-card-text>
      </v-expansion-panel-header>

      <v-expansion-panel-content :eager="true">
        <!-- パネルが複数の場合、opendPanelを配列にする必要がある -->
        <StudyRecordForm
          ref="StudyRecordForm"
          :selectedStudyRecord="studyRecord"
          :isOpen="openedPanel == 0" 
          @close="closePanel"
        ></StudyRecordForm>
      </v-expansion-panel-content>

    </v-expansion-panel>
  </v-expansion-panels>
</template>

<script>
import StudyRecordForm from "../StudyRecords/studyRecordForm.vue";
export default {
  props: {
    studyRecord: {
      type: Object
    }, 
    showMenu: {
      type: Boolean,
      default: false
    },
  },
  components: {
      StudyRecordForm,
  },
  data() {
    return {
      openedPanel: null
    }
  },
  computed: {
    dateTime: function() {
      return function(item){
        if (item.start_date == item.end_date){
          return `${this.formatDate(item.start_date)} ${item.start_time} 〜 ${item.end_time}`
        } else {
          return `${this.formatDateTime(item.start_date, item.start_time)} 〜 ${this.formatDateTime(item.end_date, item.end_time)}`
        }
      }
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
    },
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