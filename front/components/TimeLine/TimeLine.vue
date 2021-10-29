<template>
  <v-card class="fill-height">
    <v-row class="fill-height flex-column no-gutters">
      <v-col cols="auto" class="flex-shrink-1">
        <v-toolbar dense class="rounded-t">
          今日のタスク
        </v-toolbar>
      </v-col>
      <v-col cols="auto" class="flex-grow-1">
        <v-card-text class="fill-height py-0">
          <div v-if="todayTasks.length" class="fill-height" style="position: relative; min-height: 300px;">
            <div class="fill-height overflow-y-auto" style="width: 100%; position: absolute; left: 0; top: 0;">
              <v-timeline 
                align-top 
                dense
              >
                <template v-for="(item, index) in todayTasks">
                  <v-timeline-item 
                    :color="item.color"
                    small
                    :key="index"
                  >
                    <v-row class="no-gutters">
                      <v-col cols="12" md="3" v-bind:class="{darken: item.study_record.is_finished}">
                        <strong>{{time(item.start)}} ~ {{time(item.end)}}</strong>
                      </v-col>
                      <v-col cols="12" md="9" v-bind:class="{darken: item.study_record.is_finished}">
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
            </div>
          </div>
          <div v-else class="fill-height">
            <v-container class="fill-height">
              <v-row>
                <v-col cols="12" class="text-center">
                  <div class="subtitle-1">タスクはありません</div>
                </v-col>
                <v-col cols="12">
                  <v-btn
                    color="primary"
                    block
                    @click="$router.push('/plan')"
                  >教材を登録する</v-btn>
                </v-col>
                <v-col cols="12">
                  <v-btn
                    block
                    color="secondary"
                    @click="$router.push('/schedule')"
                  >タスクを登録する</v-btn>
                </v-col>
              </v-row>
            </v-container>
          </div>
        </v-card-text>
      </v-col>
    </v-row>
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
