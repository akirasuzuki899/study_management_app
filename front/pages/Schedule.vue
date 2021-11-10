<template>
  <v-row class="no-gutters fill-height" style="width: 100%;">
    <v-col v-bind="taskListOpen && $vuetify.breakpoint.name !== 'xs'? {sm: 8} : false">
      <v-card class="fill-height" style="width: 100%;">
        <v-row class="flex-column no-gutters fill-height overflow-hidden">
          <v-col cols="auto" class="flex-shrink-1">
            <v-tabs v-model="currentItem" background-color="#272727">
              <v-tab href="#tab-calendar">カレンダー</v-tab>
              <v-tab href="#tab-template">テンプレート</v-tab>
            </v-tabs>
          </v-col>

          <v-col cols="auto" class="flex-grow-1">
            <v-tabs-items v-model="currentItem" touchless style="height: 100%;">
              <v-tab-item value="tab-calendar" style="height: 100%;">
                <Calendar
                  @task-list-open="openUnfinishedTaskList"
                  :taskListOpen="taskListOpen"
                ></Calendar>
              </v-tab-item>
              <v-tab-item value="tab-template" style="height: 100%;">
                <CalendarTemplate></CalendarTemplate>
              </v-tab-item>
            </v-tabs-items>
          </v-col>
        </v-row>
      </v-card>
    </v-col>
    <v-col 
      v-if="taskListOpen && $vuetify.breakpoint.name !== 'xs'"
      cols="12" sm="4" md="4"
      >
      <UnfinishedTaskList
        class="fill-height pl-3"
        @close="closeUnfinishedTaskList"
      ></UnfinishedTaskList>
    </v-col>

    <v-dialog
      v-if="$vuetify.breakpoint.name == 'xs'"
      v-model="taskListOpen"
    >
      <v-card style="height: 60vh;">
        <UnfinishedTaskList
          class="fill-height"
        ></UnfinishedTaskList>
      </v-card>
    </v-dialog>

  </v-row>
</template>

<script>
import Calendar from "../components/Schedule/Schedule"
import CalendarTemplate from "../components/Schedule/ScheduleTemplate"
import UnfinishedTaskList from "../components/StudyRecords/StudyRecordsList.vue"


export default {
  components: {
    Calendar,
    CalendarTemplate,
    UnfinishedTaskList
  },
  data() {
    return {
      currentItem: "calendar",
      taskListOpen: false
    }
  },
  methods: {
    openUnfinishedTaskList(){
      this.taskListOpen = true
    },
    closeUnfinishedTaskList(){
      this.taskListOpen = false
    },
  }
}
</script>
