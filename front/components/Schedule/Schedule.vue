<template>
  <v-app>
    <v-row>
      <v-col>
        <v-sheet height="900">
          <v-calendar
            ref="calendar"
            :events="tasks"
            locale="ja"
            color="primary"
            type="week"
            :weekdays="[1, 2, 3, 4, 5, 6, 0]"
            :event-color="getEventColor"
            @click:event="showTask"
            @click:time="createTask"
            :interval-format="intervalFormat"
          >
            <template v-slot:event="{ event }">
              <div>
                <strong>{{ event.name }}</strong><br>
                {{ event.start.slice( -5 ) }} - {{ event.end.slice( -5 ) }}  <!-- 2000-01-03 24:00 の表示形式を 24:00 に変更 -->
              </div>
            </template>
            <!-- <template v-slot:day-body="{ date, week }">
              <div
                class="v-current-time"
                :class="{ first: date === week[0].date }"
                :style="{ top: nowY }"
              ></div>
            </template> -->
          </v-calendar>

          <TaskShow 
            ref="taskShow"
            :selectedTask="selectedTask" 
            :selectedElement="selectedElement"
            :target="target"
          ></TaskShow>

          <TaskForm
            ref="form"
            method="create"
            :target="target"
          ></TaskForm>

        </v-sheet>
      </v-col>
    </v-row>
  </v-app>
</template>

<script>
import { mapGetters } from "vuex";
import TaskShow from "./TaskShow";
import TaskForm from "./TaskForm";

  export default {
    components: {
      TaskShow,
      TaskForm,
    },
    data() {
      return {
        ready: false,
        target: "task",
        selectedTask: {},
        selectedElement: null,
        colors: ['blue', 'indigo', 'deep-purple', 'cyan', 'green', 'orange', 'grey darken-1'],
      }
    },
    computed: {
      ...mapGetters('task', ['tasks']),
      ...mapGetters(["authTokens"]),
      cal () {
        return this.ready ? this.$refs.calendar : null
      },
      nowY () {
        return this.cal ? this.cal.timeToY(this.cal.times.now) + 'px' : '-10px'
      },
    },
    methods: {
      createTask() {
        if(this.$refs.taskShow.isOpen === false) this.$refs.form.open();
      },
      showTask ({ nativeEvent, event }) {
        const open = () => {
          this.selectedTask = event
          this.selectedElement = nativeEvent.target
          requestAnimationFrame(() => requestAnimationFrame(() => this.$refs.taskShow.open()))
        }

        if (this.$refs.taskShow.isOpen) {
          this.$refs.taskShow.isOpen = false
          requestAnimationFrame(() => requestAnimationFrame(() => open()))
        } else {
          open()
        }

        nativeEvent.stopPropagation()
      },
      getCurrentTime () {
        return this.cal ? this.cal.times.now.hour * 60 + this.cal.times.now.minute : 0
      },
      scrollToTime () {
        const time = this.getCurrentTime()
        const first = Math.max(0, time - (time % 30) - 30)

        this.cal.scrollToTime(first)
      },
      updateTime () {
        setInterval(() => this.cal.updateTimes(), 60 * 1000)
      },
      intervalFormat(interval) {  //縦軸の時間フォーマットを hh:mm に変更
        return interval.time
      },
      getEventColor (event) {
        return event.color
      },
    },
    mounted () {
      this.ready = true
      this.scrollToTime()
      this.updateTime()
    },
    created() {
      this.$store.dispatch('task/getTasks', this.authTokens)
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


<style lang="scss">
.v-current-time {
  height: 2px;
  background-color: #ea4335;
  position: absolute;
  left: -1px;
  right: 0;
  pointer-events: none;

  &.first::before {
    content: '';
    position: absolute;
    background-color: #ea4335;
    width: 12px;
    height: 12px;
    border-radius: 50%;
    margin-top: -5px;
    margin-left: -6.5px;
  }
}
</style>