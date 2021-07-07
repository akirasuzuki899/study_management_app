<template>
  <v-app>
    <v-row>
      <v-col>
        <v-sheet height="1500">
          <v-toolbar
            flat
          >
            <v-btn
              outlined
              text
              @click="openAlert"
            >週間カレンダーに反映
            </v-btn>
          </v-toolbar>
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
                {{ time(event.start) }} - {{ time(event.end)}}  <!-- 2000-01-03 24:00 の表示形式を 24:00 に変更 -->
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
            :selecrtedTime="selecrtedTime"
            :target="target"
          ></TaskTemplateForm>

          <Alert
            ref="alert"
            @clicked="createTasksFromTemplates({authTokens: authTokens, copy_all: copy_all})"
          >
            <template v-slot:title>
              テンプレートを反映
            </template>
            <template v-slot:content>
              <RadioButton
                v-model="copy_all"
                :items="[
                  {label: '月曜〜日曜', value: true},
                  {label: '今日〜日曜', value: false}]"
                :dense="true"
              >
              作成する範囲を選択してください。
              </RadioButton>
              ※週間カレンダーの予定はテンプレートを元に毎週日曜日に自動で作成されます。
            </template>
            <template v-slot:btnText>
              作成
            </template>
          </Alert>

        </v-sheet>
      </v-col>
    </v-row>
  </v-app>
</template>

<script>
import { mapGetters, mapActions, mapMutations } from "vuex";
import TaskTemplateShow from "./TaskTemplateShow";
import TaskTemplateForm from "./TaskTemplateForm";
import Alert from "../Alert";
import RadioButton from "../Form/BaseRadioButton"

import mixinMoment from "../../plugins/mixin-moment"
import mixinSchedule from "../../plugins/mixin-schedule"

  export default {
    components: {
      TaskTemplateShow,
      TaskTemplateForm,
      Alert,
      RadioButton,
    },
    mixins: [mixinMoment, mixinSchedule],
    data() {
      return {
        target: "taskTemplate",
        baseDate: '2000-01-03',
        selectedTask: {},
        selectedElement: null,
        selecrtedTime: {},
        copy_all: false,
      }
    },
    computed: {
      ...mapGetters('taskTemplate', ['taskTemplates']),
      ...mapGetters(['authTokens']),
    },
    methods: {
      ...mapActions('task', ['createTasksFromTemplates']),
      ...mapActions('taskTemplate', {
        update: 'updateTaskTemplate',
      }),
      ...mapMutations('taskTemplate', ['dragUpdate']),
      createTaskTemplate(tms) {
        if(this.$refs.taskTemplateShow.isOpen === false && this.drag === false) {
          const unixTime = this.roundTime(this.toTime(tms), 60)
          const startTime = tms.hour < 0 ? "00:00" : this.moment(unixTime).format('HH:mm')
          const endTime = tms.hour < 0 ? "01:00" : this.moment(unixTime).add(1, 'h').format('HH:mm')

          this.selecrtedTime.startTime = startTime
          this.selecrtedTime.endTime = endTime
          this.selecrtedTime.date = tms.date

          this.$refs.form.open();
        }
      },
      showTaskTemplate ({ nativeEvent, event }) {
        if (this.drag === false) {

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
        }
      },
      openAlert() {
        this.$refs.alert.open();
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