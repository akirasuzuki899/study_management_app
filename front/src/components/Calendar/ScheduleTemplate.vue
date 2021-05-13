<template>
  <v-app>
    <v-row>
      <v-col>
        <v-sheet height="900">
          <v-calendar
            ref="calendar"
            :value="baseDate"
            :events="taskTemplates"
            color="primary"
            type="week"
            :weekdays="[1, 2, 3, 4, 5, 6, 0]"
            @click:event="showEvent"
            @click:time="createEvent"
          >
            <!-- <template v-slot:day-label-header="{ day }">{{day = ""}}</template> -->
          </v-calendar>

          <ShowEvent 
            ref="showEvent"
            :selectedEvent="selectedEvent" 
            :selectedElement="selectedElement"
          ></ShowEvent>

          <Form
            ref="form"
            method="createTaskTemplate"
          ></Form>

        </v-sheet>
      </v-col>
    </v-row>
  </v-app>
</template>

<script>
import { mapGetters } from "vuex";
import ShowEvent from "./ShowEvent";
import Form from "./Form";

  export default {
    components: {
      ShowEvent,
      Form,
    },
    data() {
      return {
        baseDate: '2000-01-03',
        selectedEvent: {},
        selectedElement: null,
      }
    },
    computed: {
      ...mapGetters(["authTokens", "taskTemplates"])
    },
    methods: {
      createEvent() {
        console.log("createEvent")
        if(this.$refs.showEvent.selectedOpen===false) this.$refs.form.openForm();
      },
      showEvent ({ nativeEvent, event }) {
        const open = () => {
          this.selectedEvent = event
          this.selectedElement = nativeEvent.target
          requestAnimationFrame(() => requestAnimationFrame(() => this.$refs.showEvent.openShowEvent()))
        }

        if (this.$refs.showEvent.selectedOpen) {
          this.$refs.showEvent.selectedOpen = false
          requestAnimationFrame(() => requestAnimationFrame(() => open()))
        } else {
          open()
        }

        nativeEvent.stopPropagation()
      },
    },
    mounted () {
      this.$refs.calendar.scrollToTime('08:00')
    },
    created() {
      this.$store.dispatch('getTaskTemplates', this.authTokens)
    },
  }
</script>

<style scoped>
.my-event {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  border-radius: 2px;
  background-color: #1867c0;
  color: #ffffff;
  border: 1px solid #1867c0;
  font-size: 12px;
  padding: 3px;
  cursor: pointer;
  margin-bottom: 1px;
  left: 4px;
  margin-right: 8px;
  position: relative;
}

.my-event.with-time {
  position: absolute;
  right: 4px;
  margin-right: 0px;
}
</style>