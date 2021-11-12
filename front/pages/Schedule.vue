<template>
  <v-row class="no-gutters fill-height" style="width: 100%;">
    <v-col v-bind="( sideDatePicker || taskListOpen ) && $vuetify.breakpoint.name !== 'xs'? {sm: 8} : false">
      <v-card class="fill-height" style="width: 100%;">
        <v-row class="flex-column no-gutters fill-height overflow-hidden">
          <v-col cols="auto" class="flex-shrink-1">
            <v-tabs v-model="currentItem" background-color="#272727">
              <v-tab href="#tab-calendar">カレンダー</v-tab>
              <v-tab href="#tab-template">テンプレート</v-tab>
            </v-tabs>
          </v-col>

          <v-col cols="auto" class="flex-grow-1">
            <v-tabs-items v-model="currentItem" touchless style="height: 100%;">
              <v-tab-item value="tab-calendar" style="height: 100%;">
                <Calendar
                  ref="calendar"
                  @task-list-open="openUnfinishedTaskList"
                  @side-date-picker-open="openDatePicker"
                  :taskListOpen="taskListOpen"
                  :sideDatePicker="sideDatePicker"
                ></Calendar>
              </v-tab-item>
              <v-tab-item value="tab-template" style="height: 100%;">
                <CalendarTemplate></CalendarTemplate>
              </v-tab-item>
            </v-tabs-items>
          </v-col>
        </v-row>
      </v-card>
    </v-col>
    <v-col 
      v-if="( sideDatePicker || taskListOpen ) && $vuetify.breakpoint.name !== 'xs'"
      cols="12" sm="4" md="4"
      class="pl-3"
      >
      <v-row class="flex-column no-gutters fill-height">
        <v-col 
          v-if="sideDatePicker"
          cols="auto" 
          class="flex-shrink-1"
          :class="{'pb-3' : taskListOpen}"
        >
          <DatePicker
            :class="{'small' : $vuetify.breakpoint.name !== 'xs' && $vuetify.breakpoint.width < 800}"
            :noTitle="true"
            :value="$refs.calendar.focus"
            @input="$refs.calendar.focus = $event"
            width="100%"
          >
            <v-spacer></v-spacer>
            <v-btn
              v-if="$vuetify.breakpoint.name !== 'xs'"
              @click="closeDatePicker"
              icon
            ><v-icon>mdi-close</v-icon></v-btn>
          </DatePicker>
        </v-col>
        <v-col 
          v-if="taskListOpen"
          cols="auto" 
          class="flex-grow-1"
        >
          <UnfinishedTaskList
            id="unfinished-task-list"
            class="fill-height"
            :class="{'small' : $vuetify.breakpoint.name !== 'xs' && $vuetify.breakpoint.width < 800}"
            @close="closeUnfinishedTaskList"
          ></UnfinishedTaskList>
        </v-col>
      </v-row>
    </v-col>

    <v-dialog
      v-if="$vuetify.breakpoint.name == 'xs'"
      v-model="taskListOpen"
    >
      <v-card style="height: 60vh;">
        <UnfinishedTaskList
          class="fill-height"
        ></UnfinishedTaskList>
      </v-card>
    </v-dialog>

  </v-row>
</template>

<script>
import Calendar from "../components/Schedule/Schedule"
import CalendarTemplate from "../components/Schedule/ScheduleTemplate"
import UnfinishedTaskList from "../components/StudyRecords/StudyRecordsList.vue"
import DatePicker from "../components/Form/BaseDatePicker.vue"


export default {
  components: {
    Calendar,
    CalendarTemplate,
    UnfinishedTaskList,
    DatePicker
  },
  data() {
    return {
      currentItem: "calendar",
      taskListOpen: false,
      sideDatePicker: false
    }
  },
  methods: {
    openUnfinishedTaskList(){
      this.taskListOpen = true
    },
    closeUnfinishedTaskList(){
      this.taskListOpen = false
    },
    openDatePicker(){
      this.sideDatePicker = true
    },
    closeDatePicker(){
      this.sideDatePicker = false
    },
  }
}
</script>

<style lang="scss" scoped>
//START date picker
.v-picker--date ::v-deep {
  & .v-picker__body {
    & .v-date-picker-header{
      background-color: #303030;
    }
    & .v-date-picker-table{
      background-color: #303030;
      height: auto;
    }
    & .v-date-picker-years {
      background-color: #303030;
    }
  }
  & .v-picker__actions  {
    background-color: #303030;
  }
}

//SMALL
.small.v-picker--date ::v-deep {
  & .v-picker__body {
    & .v-date-picker-header{
      font-size: 14px;
      padding: 0px 6px;
      & .v-date-picker-header__value button{
        padding: 0px 8px; 
      }
    }
    & .v-date-picker-table{
      padding: 0px 6px;
      & table tbody tr td button {
        height: 24px;
        width: 24px;
        min-width: auto;
        & div{
          font-size: 10px;
        }
      }
      &.v-date-picker-table--date table tbody tr th{
        font-size: 10px;
      }
      &.v-date-picker-table--month table tbody tr td{
        height: auto;
      }
    }
    & .v-date-picker-years {
      & li {
        font-size: 10px;
        &.active{
          font-size: 14px;
        }
      }
    }
  }
  & .v-picker__actions  {
    padding: 0px 6px;
  }
}
//END date picker

//START task list
#unfinished-task-list ::v-deep .v-toolbar .v-toolbar__content{
  padding-right: 8px;
  & button {
    margin-right: 0px !important;
    height: 36px;
    width: 36px;
  }
}

//SMALL
.small#unfinished-task-list ::v-deep .v-toolbar .v-toolbar__content{
  padding-right: 6px;
}
//END task list
</style>