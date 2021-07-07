<template>
  <v-app>
    <v-row>
      <v-col cols="12" sm="8" md="8">
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

            @mousedown:event="startDrag"
            @mousedown:time="startTime"
            @mousemove:time="mouseMove"
            @mouseup:time="endDrag"
            @mouseleave.native="cancelDrag"
          >
            <template v-slot:event="{ event }">
              <div
                style="pointer-events:none"
                class="v-event-draggable"
              >
                <strong>{{ event.name }}</strong><br>
                {{ time(event.start) }} - {{ time(event.end) }}
              </div>
            </template>

            <template v-slot:day-body="{ date }">
              <div
                :class="[date === getCurrentDate() ? ['first', 'v-current-time'] : '']"
                :style="{ top: nowY }"
              ></div>
            </template>
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
            :selecrtedTime="selecrtedTime"
            :target="target"
          ></TaskForm>

        </v-sheet>
      </v-col>
      <v-col cols="12" sm="4" md="4">
        <StudyRecordList
          :tasks="tasks"
        ></StudyRecordList>
      </v-col>
    </v-row>
  </v-app>
</template>

<script>
import { mapGetters, mapActions, mapMutations } from "vuex";
import TaskShow from "./TaskShow";
import TaskForm from "./TaskForm";
import StudyRecordList from "../StudyRecords/StudyRecordsList"

import mixinMoment from "../../plugins/mixin-moment"
import mixinSchedule from "../../plugins/mixin-schedule"

  export default {
    components: {
      TaskShow,
      TaskForm,
      StudyRecordList,
    },
    mixins: [mixinMoment, mixinSchedule],
    data: () => ({
      ready: false,
      target: "task",
      selectedTask: {},
      selectedElement: null,
      selecrtedTime: {},
    }),
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
      ...mapActions('task', {
        update: 'updateTask',
      }),
      ...mapMutations('task', ['dragUpdate']),

      createTask(tms) {
        if(this.$refs.taskShow.isOpen === false && this.drag === false) {
          let time = ""
          // const time = function(){
            if( tms.hour < 0 ){
              time = "00:00"
            } else {
              time =  this.time(this.roundTime(this.toTime(tms), true, 60))
            }
          // }
          console.log("time")
          console.log(time)
          console.log("this.moment(time).add(1, 'h').format('HH:mm')")
          console.log(this.moment(time).add(1, 'h').format('HH:mm'))
          this.selecrtedTime.startTime = time
          this.selecrtedTime.endTime = this.moment(this.roundTime(this.toTime(tms), true, 60)).add(1, 'h').format('HH:mm')
          this.selecrtedTime.date = tms.date
          // console.log("this.selecrtedTime")
          // console.log(this.selecrtedTime)
          this.$refs.form.open();
        }
      },
      showTask ({ nativeEvent, event }) {
        if (this.drag === false) {

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
        }
      },
      getCurrentTime () {
        return this.cal ? this.cal.times.now.hour * 60 + this.cal.times.now.minute : 0
      },
      getCurrentDate () {
        return this.cal ? this.cal.times.now.date : ''
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
      getType(v) {
        var toString = Object.prototype.toString
        return toString.call(v);
      }
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

<style scoped lang="scss">
.v-event-draggable {
  padding-left: 6px;
}
</style>
