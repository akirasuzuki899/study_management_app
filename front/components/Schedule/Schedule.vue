<template>
  <v-sheet>

    <v-row>
      <v-col 
      cols="12" sm="9" md="9">

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
        :tasks="tasks"
        v-if="listOpen"
      ></UnfinishedTaskList>
    </v-col>

    </v-row>
  </v-sheet>
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
