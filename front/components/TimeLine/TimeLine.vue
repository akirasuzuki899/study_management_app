<template>
  <div class="fill-height">
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
                            class="py-3"
                          ></Task>
                          <v-row class="no-gutters align-center">
                            <v-col cols="auto">
                              <v-icon>mdi-timer</v-icon>
                            </v-col>
                            <v-col>
                              <div v-if="item.study_record.is_finished == true">
                                <v-btn
                                  color="blue darken-1"
                                  style="letter-spacing: 0.1px; font-weight: 400; text-indent: 0px;"
                                  text
                                  @click="record(item.study_record)"
                                >
                                  {{ fromToDateTime(item.study_record.start, item.study_record.end) }}
                                </v-btn>
                              </div>
                              <div v-else>
                                <v-btn
                                  color="blue darken-1"
                                  text
                                  @click="record(item.study_record)"
                                >
                                  記録する
                                </v-btn>
                              </div>
                            </v-col>
                          </v-row>
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
    <StudyRecordDialog
      ref="record"
      :studyRecord="study_record"
    ></StudyRecordDialog>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import mixinMoment from "../../plugins/mixin-moment";
import Task from "../Schedule/Task";
import StudyRecordDialog from "../StudyRecords/studyRecordDialog.vue";

export default {
  components: {
    Task,
    StudyRecordDialog,
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
  data(){
    return {
      study_record: undefined
    }
  },
  methods: {
    record(record) {
      this.study_record = record
      this.$refs.record.open()
    },
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
