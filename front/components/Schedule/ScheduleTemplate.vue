<template>
  <v-app>
    <v-row>
      <v-col>
        <v-sheet height="900">
          <v-calendar
            ref="calendar"
            :value="baseDate"
            :events="taskTemplates"
            locale="ja"
            color="primary"
            type="week"
            :weekdays="[1, 2, 3, 4, 5, 6, 0]"
            :event-color="getEventColor"
            @click:event="showTaskTemplate"
            @click:time="createTaskTemplate"
            :interval-format="intervalFormat"
          >
            <template v-slot:event="{ event }">
              <div>
                <strong>{{ event.name }}</strong><br>
                {{ event.start.slice( -5 ) }} - {{ event.end.slice( -5 ) }}  <!-- 2000-01-03 24:00 の表示形式を 24:00 に変更 -->
              </div>
            </template>
            <!-- <template v-slot:day-label-header="{ day }">{{day = ""}}</template> -->
          </v-calendar>

          <TaskTemplateShow 
            ref="taskTemplateShow"
            :selectedTask="selectedTask" 
            :selectedElement="selectedElement"
            :target="target"
          ></TaskTemplateShow>

          <TaskTemplateForm
            ref="form"
            method="create"
            :target="target"
          ></TaskTemplateForm>

        </v-sheet>
      </v-col>
    </v-row>
  </v-app>
</template>

<script>
import { mapGetters } from "vuex";
import TaskTemplateShow from "./TaskTemplateShow";
import TaskTemplateForm from "./TaskTemplateForm";

  export default {
    components: {
      TaskTemplateShow,
      TaskTemplateForm,
    },
    data() {
      return {
        target: "taskTemplate",
        baseDate: '2000-01-03',
        selectedTask: {},
        selectedElement: null,
        colors: ['blue', 'indigo', 'deep-purple', 'cyan', 'green', 'orange', 'grey darken-1'],
      }
    },
    computed: {
      ...mapGetters('taskTemplate', ['taskTemplates']),
      ...mapGetters(['authTokens']),
    },
    methods: {
      createTaskTemplate() {
        if(this.$refs.taskTemplateShow.isOpen === false) this.$refs.form.open();
      },
      showTaskTemplate ({ nativeEvent, event }) {
        const open = () => {
          this.selectedTask = event
          this.selectedElement = nativeEvent.target
          requestAnimationFrame(() => requestAnimationFrame(() => this.$refs.taskTemplateShow.open()))
        }

        if (this.$refs.taskTemplateShow.isOpen) {
          this.$refs.taskTemplateShow.isOpen = false
          requestAnimationFrame(() => requestAnimationFrame(() => open()))
        } else {
          open()
        }

        nativeEvent.stopPropagation()
      },
      intervalFormat(interval) {  //縦軸の時間フォーマットを hh:mm に変更
        return interval.time
      },
       getEventColor (event) {
        return event.color
      },
    },
    mounted () {
      this.$refs.calendar.scrollToTime('08:00')
    },
    created() {
      this.$store.dispatch('taskTemplate/getTaskTemplates', this.authTokens)
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