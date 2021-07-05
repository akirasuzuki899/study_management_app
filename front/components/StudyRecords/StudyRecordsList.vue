<template>
  <div>
    <v-card
      class="mx-auto"
      max-width="500"
    >
      <v-toolbar
        color="pink"
        dark
        dense
      >
        <v-toolbar-title>再登録</v-toolbar-title>
      </v-toolbar>

      <v-list
        dense :subheader="true"
        v-if="unfinished_tasks.length"
      >

        <v-list-item-group
          active-class="pink--text"
          v-model="selectedId"
        >
          <template v-for="(item, index) in unfinished_tasks">

            <Task 
              :key="item.id" 
              :item="item"
              :index="index"
              @clicked="openScheduleForm(index)"
              @finished="destroyUnfinishedTask(unfinished_tasks[index])"
            ></Task>

            <v-divider
              v-if="index < unfinished_tasks.length - 1"
              :key="index"
            ></v-divider>

          </template>
        </v-list-item-group>
      </v-list>
      <v-card-text
        v-else
      >
        <div class="grey--text ms-4">
          未実施のタスクはありません
        </div>
      </v-card-text>

    </v-card>
    <TaskForm
      ref="scheduleForm"
      method="update"
      target="unfinishedTask"
      :selectedTask="selectedTask"
      @formClosed="clearID"
    ></TaskForm>

  </div>
</template>


<script>
import { mapGetters, mapMutations } from "vuex";
import Task from "../Schedule/Task"
import TaskForm from "../Schedule/TaskForm.vue"

import mixinMoment from "../../plugins/mixin-moment"

  export default {
    components: {
      Task,
      TaskForm,
    },
    mixins: [mixinMoment],
    props: {
      tasks: {
        type: Array,
        default: [{}]
      }
    },
    data() {
      return {
        selectedId: "",
        selectedTask: {},
      }
    },
    watch: {
      tasks: function() {
        const unfinishedTasks = this.tasks.filter(task => this.date(task.start) < this.now && task.study_record.is_finished === false)
        const newUnfinishedTasks =  unfinishedTasks.filter( i => this.unfinished_tasks.indexOf(i) == -1 )
        console.log("newUnfinishedTasks")
        console.log(newUnfinishedTasks)
        this.addUnfinishedTask(newUnfinishedTasks)
      }
    },
    computed: {
      ...mapGetters('task', ['unfinished_tasks']),
    },
    methods: {
      ...mapMutations('task', ['addUnfinishedTask', 'destroyUnfinishedTask']),
      openScheduleForm(index) {
        this.selectedTask = this.unfinished_tasks[index]
        this.$refs.scheduleForm.open()
      },
      clearID(){
        this.selectedId = ''
      },
    }
  }
</script>