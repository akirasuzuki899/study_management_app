<template>
  <v-expansion-panels flat v-model="openedPanel">
    <v-expansion-panel>

      <v-expansion-panel-header>
        <div class="d-flex" v-if="studyRecord.is_finished == true">
          <v-card-text>
            <v-icon>mdi-timer</v-icon>
            {{ fromToDateTime(studyRecord.start, studyRecord.end) }}
          </v-card-text>
        </div>
        <v-card-text v-else>
          <v-icon>mdi-timer</v-icon>
          記録がありません
        </v-card-text>
      </v-expansion-panel-header>

      <v-expansion-panel-content :eager="true">
        <!-- パネルが複数：openedPanelには、1つ目のパネルが開いていれば[0]が、すべて閉じていれば[]が入る -->
        <!-- パネルが一つ：openedPanelには、開いていれば数字の0が、閉じていればnullが入る。 -->
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

import mixinMoment from "../../plugins/mixin-moment"

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
  mixins: [mixinMoment],
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
    },
  },
  methods: {
    closePanel () {
      this.openedPanel = null
    },
  }

}
</script>