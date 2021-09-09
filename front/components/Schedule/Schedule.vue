<template>

    <v-row class="no-gutters fill-height ">
      <v-col>
        <v-row class="flex-column no-gutters fill-height">
          <v-col cols="auto" class="flex-shrink-1">
            <v-sheet>
              <v-toolbar>
                <v-btn
                  outlined
                  text
                  @click="toggleUnfinishedTaskList"
                >未実施のタスク
                <v-icon v-if="listOpen">
                  mdi-close-box-outline
                </v-icon>
                <v-icon v-else>
                  mdi-open-in-new
                </v-icon>
                </v-btn>
              </v-toolbar>
            </v-sheet>
          </v-col>
          <v-col cols="auto" class="flex-grow-1" style="position: relative;">
            <v-sheet class="fill-height overflow-y-auto" style="width: 100%; position: absolute; left: 0; top: 0;">
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

      <v-col 
        v-if="listOpen"
        cols="12" sm="3" md="3"
        >
        <UnfinishedTaskList
          class="fill-height pl-3"
          :tasks="tasks"
          v-if="listOpen"
        ></UnfinishedTaskList>
      </v-col>

    </v-row>
</template>

<script>
import { mapGetters, mapActions, mapMutations } from "vuex";
import TaskShow from "./TaskShow";
import TaskForm from "./TaskForm";
import UnfinishedTaskList from "../StudyRecords/StudyRecordsList"

import mixinMoment from "../../plugins/mixin-moment"
import mixinSchedule from "../../plugins/mixin-schedule"

  export default {
    components: {
      TaskShow,
      TaskForm,
      UnfinishedTaskList,
    },
    mixins: [mixinMoment, mixinSchedule],
    data: () => ({
      ready: false,
      target: "task",
      selectedTask: {},
      selectedElement: null,
      selecrtedTime: {},
      listOpen: false
    }),
    computed: {
      ...mapGetters('task', ['tasks']),
      cal () {
        return this.ready ? this.$refs.calendar : null
      },
      nowY () {
        return this.cal ? this.cal.timeToY(this.cal.times.now) + 'px' : '-10px'
      },
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

      toggleUnfinishedTaskList(){
        this.listOpen = !this.listOpen
      },
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
</style>