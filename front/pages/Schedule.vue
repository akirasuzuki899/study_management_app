<template>
  <div>
    <v-container fluid fill-height >
      <v-row>
        <v-col>
          <v-tabs v-model="currentItem">
            <v-tab href="#tab-calendar">今週</v-tab>
            <v-tab href="#tab-template">テンプレート</v-tab>
          </v-tabs>

          <v-tabs-items v-model="currentItem">
            <v-tab-item value="tab-calendar">
              <Calendar></Calendar>
            </v-tab-item>
            <v-tab-item value="tab-template">
              <CalendarTemplate></CalendarTemplate>
            </v-tab-item>
          </v-tabs-items>
        </v-col>
        <v-col>
          <StudyRecordList
            :tasks="tasks"
            v-if="currentItem == 'tab-calendar'"
          ></StudyRecordList>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>
  

<script>
import { mapGetters } from "vuex";
import Calendar from "../components/Schedule/Schedule"
import CalendarTemplate from "../components/Schedule/ScheduleTemplate"
import StudyRecordList from "../components/StudyRecords/StudyRecordsList"

export default {
  components: {
    Calendar,
    CalendarTemplate,
    StudyRecordList,
  },
  data() {
    return {
      currentItem: "calendar"
    }
  },
  computed: {
    ...mapGetters('task', ['tasks']),
  }
}
</script>