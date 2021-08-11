<template>
  <v-sheet>
    <v-toolbar>
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
          {{ time(event.start) }} - {{ time(event.end)}}  <!-- 2000-01-03 24:00 の表示形式を 24:00 に変更 -->
        </div>
      </template>
      <!-- <template v-slot:day-label-header="{ day }">{{day = ""}}</template> -->
    </v-calendar>

    <TaskTemplateShow
      ref="taskShow"
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
      @clicked="createTasksFromTemplates({copy_all: copy_all})"
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
    },
    methods: {
      ...mapActions('task', ['createTasksFromTemplates']),
      ...mapActions('taskTemplate', {
        update: 'updateTaskTemplate',
      }),
      ...mapMutations('taskTemplate', ['dragUpdate']),

      openAlert() {
        this.$refs.alert.open();
      },
    },
    mounted () {
      this.$refs.calendar.scrollToTime('08:00')
    },
    created() {
      this.$store.dispatch('taskTemplate/getTaskTemplates')
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