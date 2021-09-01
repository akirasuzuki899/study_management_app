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
              <v-col cols="12" sm="12" md="3">
                <strong>{{time(item.start)}} ~ {{time(item.end)}}</strong>
              </v-col>
              <v-col cols="12" sm="12" md="9">
                <ShowStudyMaterial
                  :studyMaterial="item.study_material"
                ></ShowStudyMaterial>
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
import { mapGetters, mapActions, mapMutations } from "vuex";
import mixinMoment from "../../plugins/mixin-moment";
import ShowStudyMaterial from "../StudyMaterials/ShowStudyMaterials";
import StudyRecordExpansionPanel from "../StudyRecords/studyRecordExpansionPanel";

export default {
  components: {
    ShowStudyMaterial,
    StudyRecordExpansionPanel,
  },
  mixins: [mixinMoment],
  computed: {
    ...mapGetters('task', ['tasks']),
    todayTasks() {
      return this.tasks.filter((task) => this.date(task.start) === this.now)
    }
  },
  created() {
    this.$store.dispatch('task/getTasks')
  },
}
</script>
<style scoped>
.theme--light.v-timeline:before {
    background: red;
}
</style>
