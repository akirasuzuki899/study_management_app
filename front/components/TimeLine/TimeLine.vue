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
          <v-card-text v-if="loaded" class="fill-height py-0">
            <div v-if="todayTasks.length" class="fill-height" style="position: relative; min-height: 350px;">
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
                        <v-col cols="12" md="9">
                          <Task :task="item"></Task>
                          <v-row class="no-gutters align-center">
                            <v-col cols="auto" class="pl-5">
                              <v-icon :class="{'text--disabled': item.study_record.is_finished}">mdi-timer</v-icon>
                            </v-col>
                            <v-col class="pl-4">
                              <div v-if="item.study_record.is_finished" class="text--disabled">
                                {{ fromToDateTime(item.study_record.start, item.study_record.end) }}
                              </div>
                              <div v-else>
                                記録がありません
                              </div>
                            </v-col>
                          </v-row>
                        </v-col>
                      </v-row>
                      
                      <div class="pt-3">
                        <v-btn
                          v-if="item.study_record.is_finished"
                          color="blue darken-1"
                          outlined
                          @click="record(item.study_record)"
                        >
                          更新
                        </v-btn>
                        <v-btn
                          v-else
                          color="blue darken-1"
                          outlined
                          @click="record(item.study_record)"
                        >
                          記録
                        </v-btn>
                      </div>
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
          <Loader v-else style="min-height: 350px;"></Loader>
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
import Loader from "../Loader.vue"

export default {
  components: {
    Task,
    StudyRecordDialog,
    Loader
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
      study_record: undefined,
      loaded: false
    }
  },
  methods: {
    record(record) {
      this.study_record = record
      this.$refs.record.open()
    },
  },
  async created() {
    this.loaded = false
    this.$store.dispatch('task/getTasks')
    this.loaded = true

  },
}
</script>
<style scoped>
.darken > strong, .darken >>> .v-expansion-panels .v-expansion-panel .v-expansion-panel-header .v-card__text{
  opacity: 0.5;
}
</style>
