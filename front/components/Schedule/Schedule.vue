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
            <template v-slot:event="{ event, timed }">
              <div
                style="pointer-events:none"
                class="v-event-draggable"
              >
                <strong>{{ event.name }}</strong><br>
                {{ time(event.start) }} - {{ time(event.end) }}
              </div>
              <div
                v-if="timed"
                class="v-event-drag-bottom"
                @mousedown.stop="extendBottom(event)"
              ></div>
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
            :target="target"
          ></TaskForm>

        </v-sheet>
      </v-col>
      <v-col cols="12" sm="4" md="4">
        <StudyRecordList
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

  export default {
    components: {
      TaskShow,
      TaskForm,
      StudyRecordList,
    },
    mixins: [mixinMoment],
    data: () => ({
      ready: false,
      target: "task",
      selectedTask: {},
      selectedElement: null,

      dragTime: null,
      dragEvent: null,
      dragStart: null,
      createEvent: null,
      createStart: null,
      extendOriginal: null,
      originalEvent: {
        start: null,
        end: null,
      }
    }),
    computed: {
      ...mapGetters('task', ['tasks', 'unfinished_tasks']),
      ...mapGetters(["authTokens"]),
      cal () {
        return this.ready ? this.$refs.calendar : null
      },
      nowY () {
        return this.cal ? this.cal.timeToY(this.cal.times.now) + 'px' : '-10px'
      },
    },
    methods: {
      ...mapActions('task', ['createTask', 'updateTask', ]),
      ...mapMutations('task', ['dragUpdate']),

      startDrag ({ event, timed }) {
        
        if (event && timed) {
          console.log("startDrag")
          this.dragEvent = event   //参照渡し
          this.dragTime = null
          this.extendOriginal = null
          this.originalEvent.start = this.dragEvent.start
          this.originalEvent.end = this.dragEvent.end
        }
      },
      startTime (tms) {
        console.log("startTime")
        const mouse = this.toTime(tms)

        if (this.dragEvent && this.dragTime === null) {
          const start = this.timeToMs(this.dragEvent.start)

          this.dragTime = mouse - start

        } else {
          this.createStart = this.roundTime(mouse)
          this.createEvent = {
              name: "タイトルなし",
            color: "blue",
            start: this.createStart,
            end: this.createStart,
            timed: true,
          }

          this.events.push(this.createEvent)
        }
      },
      extendBottom (event) {
        console.log("extendBottom")
        this.createEvent = event  //参照渡し
        this.createStart = this.timeToMs(event.start)
        this.extendOriginal = this.timeToMs(event.end)
      },
      mouseMove (tms) {
        console.log("mouseMove")
        const mouse = this.toTime(tms)

        if (this.dragEvent && this.dragTime !== null) {
          const start = this.timeToMs(this.dragEvent.start)
          const end = this.timeToMs(this.dragEvent.end)
          const duration = end - start   //イベントの終始をmsで保持
          const newStartTime = mouse - this.dragTime  //イベントのスタートとクリックした時間との差をmsで保持
          const newStart = this.roundTime(newStartTime)
          const newEnd = newStart + duration

          this.dragUpdate(
            {
              id: this.dragEvent.id,
              start: `${this.date(newStart)} ${this.time(newStart)}`,
              end: `${this.date(newEnd)} ${this.time(newEnd)}`,
            }
          )
        } else if (this.createEvent && this.createStart !== null) {
          const mouseRounded = this.roundTime(mouse, false)
          const min = Math.min(mouseRounded, this.createStart)
          const max = Math.max(mouseRounded, this.createStart)

          this.dragUpdate(
            {
              id: this.createEvent.id,
              start: `${this.date(min)} ${this.time(min)}`,
              end: `${this.date(max)} ${this.time(max)}`,
            }
          )
        }
      },
      endDrag () {
        if (this.dragEvent && this.dragTime !== null){
          if (this.dragEvent.start !== this.originalEvent.start || this.dragEvent.end !== this.originalEvent.end ){
            this.updateTask({
              authTokens: this.authTokens,
              selectedTask: this.dragEvent,
              formData: {
                start_date: this.date(this.dragEvent.start),
                start_time: this.time(this.dragEvent.start),
                end_time: this.time(this.dragEvent.end),
              }
            })
          }
        } else if (this.createEvent && this.createStart !== null) {
          if (this.extendOriginal !== this.originalEvent.start || this.dragEvent.end !== this.originalEvent.end ){
            console.log("this.createEvent")
            console.log(this.createEvent)
            this.updateTask({
              authTokens: this.authTokens,
              selectedTask: this.createEvent,
              formData: {
                start_date: this.date(this.createEvent.start),
                start_time: this.time(this.createEvent.start),
                end_time: this.time(this.createEvent.end),
              }
            })
          }
        }
        console.log("endDrag")
        this.dragTime = null
        this.dragEvent = null
        this.createEvent = null
        this.createStart = null
        this.extendOriginal = null
      },
      cancelDrag () {
        if (this.createEvent) {
          if (this.extendOriginal) {
            this.dragUpdate(
              {
                id: this.createEvent.id,
                end: `${this.date(this.extendOriginal)} ${this.time(this.extendOriginal)}`,
              }
            )
          } else {
            const i = this.events.indexOf(this.createEvent)
            if (i !== -1) {
              this.events.splice(i, 1)
            }
          }
        }

        this.createEvent = null
        this.createStart = null
        this.dragTime = null
        this.dragEvent = null
      },


      roundTime (time, down = true) {   //  引数と返す値はms
        const roundTo = 15 // minutes
        const roundDownTime = roundTo * 60 * 1000

        return down
          ? time - time % roundDownTime   // 切り捨て
          : time + (roundDownTime - (time % roundDownTime))  //切り上げ
      },
      toTime (tms) {   //時間をmsで返す
        return new Date(tms.year, tms.month - 1, tms.day, tms.hour, tms.minute).getTime()
      },

















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

.v-event-timed {
  user-select: none;
  -webkit-user-select: none;
}

.v-event-drag-bottom {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 4px;
  height: 4px;
  cursor: ns-resize;

  &::after {
    display: none;
    position: absolute;
    left: 50%;
    height: 4px;
    border-top: 1px solid white;
    border-bottom: 1px solid white;
    width: 16px;
    margin-left: -8px;
    opacity: 0.8;
    content: '';
  }

  &:hover::after {
    display: block;
  }
}
</style>
