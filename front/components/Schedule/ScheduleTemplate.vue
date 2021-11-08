<template>
  <div class="fill-height">    
    <v-row class="flex-column no-gutters fill-height">
      <v-col cols="auto" class="flex-shrink-1">
        <v-toolbar 
          color="#303030"
          v-bind="$vuetify.breakpoint.name == 'xs' ? {dense: true} : false"
        >
          <v-btn
            v-bind="$vuetify.breakpoint.name == 'xs' ? {small: true} : false"
            outlined
            text
            @click="openAlert"
          >週間カレンダーに反映
          </v-btn>
        </v-toolbar>
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
                class="v-calendar-event"
              >
                <strong>{{ event.name }}</strong><br>
                {{ time(event.start) }} - {{ time(event.end)}}  <!-- 2000-01-03 24:00 の表示形式を 24:00 に変更 -->
              </div>
            </template>

            <template v-slot:day-label-header="{weekday}">
              <div style="width: 100%; cursor:default;" class="white--text">
                <div
                  v-if="$vuetify.breakpoint.name !== 'xs'"
                  class="d-flex justify-center align-center mx-auto"
                  style="font-size: 14px; letter-spacing: 1.25px; height: 56px;"
                >{{dayOfWeek[weekday]}}</div>
                <div
                  v-else
                  class="d-flex justify-center align-center mx-auto"
                  style="font-size: 11px; height: 25px;"
                >{{dayOfWeek[weekday]}}</div>
              </div>
            </template>
          </v-calendar>
        </v-sheet>
      </v-col>
    </v-row>

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
      </template>
      <template v-slot:btnText>
        作成
      </template>
    </Alert>
  </div>
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
        dayOfWeek: [ "日", "月", "火", "水", "木", "金", "土" ],
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
.v-calendar-event {
  padding-left: 6px;
}
.v-calendar >>> .v-calendar-daily__head .v-calendar-daily_head-day .v-calendar-daily_head-weekday{
  display: none;
}
</style>