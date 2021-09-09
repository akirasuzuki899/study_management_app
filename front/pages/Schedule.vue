<template>
  <v-row class="flex-column no-gutters fill-height">
    <v-col cols="auto" class="flex-shrink-1">
      <v-tabs v-model="currentItem">
        <v-tab href="#tab-calendar">今週</v-tab>
        <v-tab href="#tab-template">テンプレート</v-tab>
      </v-tabs>
    </v-col>

    <v-col cols="auto" class="flex-grow-1">
      <v-tabs-items v-model="currentItem" style="height: 100%;">
        <v-tab-item value="tab-calendar" style="height: 100%;">
          <Calendar></Calendar>
        </v-tab-item>
        <v-tab-item value="tab-template">
          <CalendarTemplate></CalendarTemplate>
        </v-tab-item>
      </v-tabs-items>
    </v-col>
  </v-row>
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
