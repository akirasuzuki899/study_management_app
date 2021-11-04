<template>
  <v-expansion-panels v-model="openedPanel">
    <v-expansion-panel>

      <v-expansion-panel-header>
        <div class="d-flex" v-if="studyRecord.is_finished">
          <v-card-text class="py-0">
            <v-icon>mdi-timer</v-icon>
            {{ fromToDateTime(studyRecord.start, studyRecord.end) }}
          </v-card-text>
        </div>
        <v-card-text v-else class="py-0">
          <v-icon>mdi-timer</v-icon>
          記録がありません
        </v-card-text>
      </v-expansion-panel-header>

      <v-expansion-panel-content>
        <!-- パネルが複数：openedPanelには、1つ目のパネルが開いていれば[0]が、すべて閉じていれば[]が入る -->
        <!-- パネルが一つ：openedPanelには、開いていれば数字の0が、閉じていればnullが入る。 -->
        <StudyRecordForm
          ref="StudyRecordForm"
          :selectedStudyRecord="studyRecord"
          :isOpen="openedPanel == 0" 
          @recorded="closePanel"
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
  methods: {
    closePanel () {
      this.openedPanel = null
    },
  }

}
</script>