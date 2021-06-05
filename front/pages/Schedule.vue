<template>
<div>
  <button @click="currentComponent = 'Calendar'">今週</button>
  <button @click="currentComponent = 'CalendarTemplate'">テンプレート</button>
  <keep-alive>
    <component :is="currentComponent"></component>
  </keep-alive>

</div>
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
      currentComponent: "Calendar"
    }
  }
}
</script>