<template>
  <v-app>
    <v-row>
      <v-col>
        <v-sheet height="900">
          <v-calendar
            ref="calendar"
            :value="baseDate"
            :events="schedules"
            color="primary"
            type="week"
            :weekdays="[1, 2, 3, 4, 5, 6, 0]"
            @click:event="showEvent"
            @click:time="$refs.form.openForm();"
          >
            <!-- <template v-slot:day-label-header="{ day }">{{day = ""}}</template> -->
          </v-calendar>

          <ShowEvent 
            ref="showEvent"
            :selectedEvent="selectedEvent" 
            :selectedElement="selectedElement" 
            :studyMaterials="studyMaterials"
          ></ShowEvent>

          <Form
            ref="form"
            :selectedEvent="selectedEvent"
            :studyMaterials="studyMaterials"
          ></Form>

        </v-sheet>
      </v-col>
    </v-row>
  </v-app>
</template>

<script>
import axios from "axios";
import ShowEvent from "./ShowEvent";
import Form from "./Form";

  export default {
    components: {
      ShowEvent,
      Form,
    },
    data: () => ({
      baseDate: '2000-01-03',

      // イベントの詳細画面
      selectedEvent: {},
      selectedElement: null,

      // すべてのイベント
      schedules: [],

      // すべての教材
      studyMaterials: [],
      study_material_id: '',
    }),
    methods: {
      showEvent ({ nativeEvent, event }) {
        const open = () => {
          this.selectedEvent = event
          this.selectedElement = nativeEvent.target
          requestAnimationFrame(() => requestAnimationFrame(() => this.$refs.showEvent.openShowEvent()))
        }

        if (this.selectedOpen) {
          this.selectedOpen = false
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
    computed: {
      authTokens() {
        return this.$store.getters.authTokens;
      }
    },
    created() {
      axios
        .get('/api/v1/schedule_templates', {
          headers: this.authTokens
        })
        .then(({data}) => {
          this.schedules.push(...data.data.schedule_templates)
          this.studyMaterials.push(...data.data.study_materials)
          console.log(data)
        });
    }
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