<template>
  <v-card>
    <v-card-text class="py-0">
      <v-timeline 
        align-top 
        dense 
        v-if="todayTasks.length"
      >
        <template v-for="(item, index) in todayTasks">
          <v-timeline-item 
            :color="item.color"
            small
            :key="index"
          >
            <v-row class="pt-1">
              <v-col cols="12" sm="12" md="3" v-bind:class="{darken: item.study_record.is_finished}">
                <strong>{{time(item.start)}} ~ {{time(item.end)}}</strong>
              </v-col>
              <v-col cols="12" sm="12" md="9" v-bind:class="{darken: item.study_record.is_finished}">
                <Task
                  :task="item"
                ></Task>
                <StudyRecordExpansionPanel
                  :studyRecord="item.study_record"
                ></StudyRecordExpansionPanel>
              </v-col>
            </v-row>
          </v-timeline-item>
        </template>
      </v-timeline>
      <div v-else>
        タスクはありません
      </div>
    </v-card-text>
  </v-card>
</template>

<script>
import { mapGetters } from "vuex";
import mixinMoment from "../../plugins/mixin-moment";
import Task from "../Schedule/Task";
import StudyRecordExpansionPanel from "../StudyRecords/studyRecordExpansionPanel";

export default {
  components: {
    Task,
    StudyRecordExpansionPanel,
  },
  mixins: [mixinMoment],
  computed: {
    ...mapGetters('task', ['tasks']),
    todayTasks() {      
      const todayTasks =  this.tasks.filter((task) => this.date(task.start) === this.now)
      todayTasks.sort(function(a, b){
        return a.start < b.start
          ?  -1
          :  1
      })
      return todayTasks
    }
  },
  created() {
    this.$store.dispatch('task/getTasks')
  },
}
</script>
<style scoped>
.darken > strong, .darken >>> .v-expansion-panels .v-expansion-panel .v-expansion-panel-header .v-card__text{
  opacity: 0.5;
}
</style>
