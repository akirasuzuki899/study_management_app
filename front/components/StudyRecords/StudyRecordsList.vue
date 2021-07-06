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
        max-height="400"
        class="overflow-y-auto"
      >
        <!-- v-if="unfinished_tasks.length" -->

        <v-list-item-group
          active-class="pink--text"
          v-model="selectedId"
        >
          <template v-for="(item, index) in unfinished_tasks">

            <Task 
              :key="item.id" 
              :task="item"
              :index="index"
              @clicked="openScheduleForm(index)"
            ></Task>

            <v-divider
              v-if="index < unfinished_tasks.length - 1"
              :key="index"
            ></v-divider>
          </template>
          <infinite-loading @infinite="infiniteHandler"></infinite-loading>
        </v-list-item-group>
      </v-list>
      <v-card-text
      >
        <!-- v-else -->
        <!-- <div class="grey--text ms-4">
          未実施のタスクはありません
        </div> -->
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
import { mapGetters, mapActions } from "vuex";
import Task from "../Schedule/Task"
import TaskForm from "../Schedule/TaskForm.vue"
import InfiniteLoading from 'vue-infinite-loading';

import mixinMoment from "../../plugins/mixin-moment"

  export default {
    components: {
      Task,
      TaskForm,
      InfiniteLoading,
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
        page: 1,
      }
    },
    computed: {
      ...mapGetters('task', ['unfinished_tasks']),
      ...mapGetters(["authTokens"]),
    },
    methods: {
      ...mapActions('task', ['getUnfinishedTask']),
      openScheduleForm(index) {
        this.selectedTask = this.unfinished_tasks[index]
        this.$refs.scheduleForm.open()
      },
      clearID(){
        this.selectedId = ''
      },
      infiniteHandler($state) {
        console.log("infiniteHandler")
        this.getUnfinishedTask({
          authTokens: this.authTokens,
          page: this.page
        })
        .then(( { tasks } ) => {
          console.log("data.tasks");
          console.log(tasks);
          if(tasks.length){
            this.page += 1;
            $state.loaded();
          } else {
            $state.complete();
          }
        })
        .catch(error => {
          console.log(error);
        });
      },
    },
  }
</script>