<template>
  <v-sheet>
    <!-- <v-row> -->
      <!-- <v-col cols="12" sm="12" md="12"> -->

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

      <!-- </v-col> -->
    <!-- </v-row> -->
  </v-sheet>
</template>

<script>
import Calendar from "../components/Schedule/Schedule"
import CalendarTemplate from "../components/Schedule/ScheduleTemplate"

export default {
  components: {
    Calendar,
    CalendarTemplate,
  },
  data() {
    return {
      currentItem: "calendar"
    }
  },
}
</script>
