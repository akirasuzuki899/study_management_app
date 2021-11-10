<template>
  <v-row class="no-gutters fill-height">
    <v-col>
      <v-row class="flex-column no-gutters fill-height">
        <v-col cols="auto" class="flex-shrink-1">
          <v-sheet>
            <v-toolbar 
              color="#303030" 
              class="overflow-x-auto overflow-y-hidden"
              v-bind="$vuetify.breakpoint.name == 'xs' ? {dense: true} : {dense: false}"
            >
              <template v-if="$vuetify.breakpoint.name == 'xs'">

                <div class="text-subtitle-2 text-no-wrap">
                  {{ datePicker ? datePickerTitle : calendarTitle }}
                  <v-btn v-if="datePicker" x-small icon @click="datePicker = false">
                    <v-icon>mdi-menu-up</v-icon>
                  </v-btn>
                  <v-btn v-else x-small icon @click="datePicker = true">
                    <v-icon>mdi-menu-down</v-icon>
                  </v-btn>
                </div>
                
                <v-spacer></v-spacer>

                <v-btn
                  class="mr-1"
                  icon
                  small
                  @click="setToday"
                >
                  <v-icon small>mdi-calendar-today</v-icon>
                </v-btn>

                <ArrowBtn
                  class="ml-1"
                  icon
                  left
                  @click="prev"
                ></ArrowBtn>

                <ArrowBtn
                  class="mr-1"
                  icon
                  right
                  @click="next"
                ></ArrowBtn>

                <v-btn
                  class="ml-1"
                  text
                  outlined
                  small
                  @click="$emit('task-list-open')"
                >
                  タスク
                  <v-icon 
                    v-if="taskListOpen"
                    small
                  >mdi-close-box-outline</v-icon>
                  <v-icon 
                    v-else
                    small
                  >mdi-open-in-new</v-icon>
                </v-btn>

              </template>
              <template v-else>

                <v-btn
                  v-if="!taskListOpen"
                  text
                  outlined
                  @click="$emit('task-list-open')"
                >
                  タスク
                  <v-icon>mdi-open-in-new</v-icon>
                </v-btn>

                <v-spacer v-if="!taskListOpen"></v-spacer>
                
                <div class="text-subtitle-1 text-no-wrap">
                  {{ datePicker ? "日付を選択" : calendarTitle }}
                  <v-btn v-if="datePicker" x-small icon @click="datePicker = false">
                    <v-icon>mdi-menu-up</v-icon>
                  </v-btn>
                  <v-btn v-else x-small icon @click="datePicker = true">
                    <v-icon>mdi-menu-down</v-icon>
                  </v-btn>
                </div>

                <v-spacer v-if="taskListOpen"></v-spacer>

                <v-btn
                  class="mx-sm-4"
                  text
                  outlined
                  @click="setToday"
                >
                  今週
                </v-btn>

                <ArrowBtn
                  icon
                  left
                  @click="prev"
                ></ArrowBtn>

                <ArrowBtn
                  icon
                  right
                  @click="next"
                  class="mr-0"
                ></ArrowBtn>

              </template>

            </v-toolbar>
            <DatePicker
              v-if="datePicker"
              v-model="focus"
              :class="$vuetify.breakpoint.name == 'xs' ? 'v-date-picker-header-hide' : 'v-date-picker-header-show'"
              width="100%"
              :noTitle="true"
              @picker-date="setDatePickerTitle"
            ></DatePicker>
          </v-sheet>
        </v-col>
        <v-col cols="auto" class="flex-grow-1" style="position: relative;">
          <v-sheet 
            class="fill-height overflow-y-auto px-1 pb-1" 
            style="width: 100%; position: absolute; left: 0; top: 0;"
            color="#303030"
          >
            <v-calendar
              ref="calendar"
              class="rounded"
              locale="ja"
              color="primary"
              type="week"
              v-model="focus"
              :events="tasks"
              :event-color="getEventColor"
              :interval-format="intervalFormat"
              :weekdays="weekdays"

              @click:event="showTask"
              @click:time="createTask"
              @change="updateRange"
              @mousedown:event="startDrag"
              @mousedown:time="startTime"
              @mousemove:time="mouseMove"
              @mouseup:time="endDrag"
              @mouseleave.native="cancelDrag"
            >
              <template v-slot:day-label-header="{day, present}">
                <div style="width: 100%; cursor:default;">
                  <div
                    v-if="$vuetify.breakpoint.name !== 'xs'"
                    class="rounded-circle d-flex justify-center align-center mx-auto"
                    :class="{'primary' : present}"
                    style="font-size: 14px; font-weight: 500; letter-spacing: 1.25px; height: 56px; width: 56px;"
                  >{{day}}日</div>
                  <div
                    v-else
                    class="rounded-circle d-flex justify-center align-center mx-auto"
                    :class="{'primary' : present}"
                    style="font-size: 11px; font-weight: 500; height: 25px; width: 25px;"
                  >{{day}}</div>
                </div>
              </template>

              <template v-slot:event="{ event }"> 
                <div
                  style="pointer-events:none"
                  class="v-calendar-event"
                >
                  <strong>{{ event.name }}</strong><br>
                  {{ time(event.start) }} - {{ time(event.end) }}
                </div>
                <v-overlay
                  v-if="event.study_record.is_finished"
                  absolute
                  opacity='0.5'
                ></v-overlay>
              </template>

              <template v-slot:day-body="{ date }">
                <div
                  :class="[date === getCurrentDate() ? ['first', 'v-current-time'] : '']"
                  :style="{ top: nowY }"
                ></div>
              </template>
            </v-calendar>
          </v-sheet>
        </v-col>
      </v-row>

    </v-col>

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

  </v-row>
</template>

<script>
import { mapGetters, mapActions, mapMutations } from "vuex";
import TaskShow from "./TaskShow";
import TaskForm from "./TaskForm";
import ArrowBtn from "../Btn/arrowBtn"
import DatePicker from "../Form/BaseDatePicker"

import mixinMoment from "../../plugins/mixin-moment"
import mixinSchedule from "../../plugins/mixin-schedule"

  export default {
    components: {
      TaskShow,
      TaskForm,
      ArrowBtn,
      DatePicker
    },
    mixins: [mixinMoment, mixinSchedule],
    props: {
      taskListOpen: {
        type: Boolean,
        default: false
      }
    },
    data: () => ({
      ready: false,
      target: "task",
      focus: '',
      selectedTask: {},
      selectedElement: null,
      selecrtedTime: {},
      weekdays: [1, 2, 3, 4, 5, 6, 0],
      datePicker: false,
      datePickerTitle: ''
    }),
    computed: {
      ...mapGetters('task', ['tasks']),
      cal () {
        return this.ready ? this.$refs.calendar : null
      },
      nowY () {
        return this.cal ? this.cal.timeToY(this.cal.times.now) + 'px' : '-10px'
      },
      calendarTitle () {
        if (!this.cal) return

        const { start, end } = this.cal.renderProps

        if (this.$vuetify.breakpoint.name == 'xs') {
          const thisYear  = this.cal.times.now.year

          if (thisYear == start.year) {
            return this.cal.monthShortFormatter(start, true)
          } else {
            return start.year + '年' + this.cal.monthShortFormatter(start, true) 
          }

        } else {
          const spanYears = start.year !== end.year
          const spanMonths = spanYears || start.month !== end.month

          if (spanYears) {
            return start.year + '年 ' + this.cal.monthShortFormatter(start, true) + ' 〜 ' + this.cal.monthShortFormatter(end, true) +  end.year + '年'
          }

          if (spanMonths) {
            return start.year + '年 ' + this.cal.monthShortFormatter(start, true) + ' 〜 ' + this.cal.monthShortFormatter(end, true) 
          } else {
            return start.year + '年 ' + this.cal.monthLongFormatter(start, false)
          }
        }
      }
    },
    methods: {
      ...mapActions('studyMaterial', ['getStudyMaterials']),
      ...mapActions('task', {
        update: 'updateTask',
      }),
      ...mapMutations('task', ['dragUpdate']),

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
      prev () {
        this.$refs.calendar.prev()
        console.log(this.$vuetify.breakpoint)
      },
      next () {
        this.$refs.calendar.next()
      },
      setToday () {
        this.focus = this.getCurrentDate()
      },
      updateRange(){
        if (!this.ready) return 
        this.$store.dispatch('task/getTasks', this.focus)
      },
      setDatePickerTitle(date) {
        let year = Number(date.split('-')[0])
        let month = Number(date.split('-')[1])

        if( year == this.moment().format('YYYY') ) {
          this.datePickerTitle = month + "月"
        } else {
          this.datePickerTitle = year + "年" + month + "月"
        }
      }
    },
    mounted () {
      this.ready = true
      this.scrollToTime()
      this.updateTime()
    },
    created() {
      this.$store.dispatch('task/getTasks')
      this.getStudyMaterials()
    },
  }
</script>

<style scoped>
.v-calendar-event {
  padding-left: 6px;
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
.v-date-picker-header-show.v-picker--date {
  & .v-picker__body {
    & .v-date-picker-header{
      background-color: #303030;
    }
    & .v-date-picker-table{
      background-color: #303030;
      height: auto;
      padding-bottom: 8px;
    }
  }
  border-radius: 0px;
}
.v-date-picker-header-hide.v-picker--date {
  & .v-picker__body {
    & .v-date-picker-header{
      background-color: #303030;
      display: none;
    }
    & .v-date-picker-table{
      background-color: #303030;
      height: auto;
      padding-bottom: 8px;
    }
  }
  border-radius: 0px;
}
</style>