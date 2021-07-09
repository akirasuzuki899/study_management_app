<template>
  <div>
    <v-card
      class="mx-auto"
      max-width="300"
    >
      <v-toolbar
        color="pink"
        dark
        dense
      >
        <v-toolbar-title>再登録</v-toolbar-title>
      </v-toolbar>

      <v-list
        :dense="true"
        :subheader="true"
        max-height="300"
        class="overflow-y-auto"
      >
        <v-list-item-group
          active-class="pink--text"
          v-model="selectedId"
        >
          <template v-for="(item, index) in unfinished_tasks">

            <Task
              :key="`task-${item.id}`"
              :task="item"
              :index="index"
              @clicked="openScheduleForm(index)"
            ></Task>

            <v-divider
              v-if="index < unfinished_tasks.length - 1"
              :key="`index-${index}`"
            ></v-divider>
          </template>
          <infinite-loading
            @infinite="infiniteHandler"
          >
            <template slot="no-more">{{LoadingMessage}}</template>
            <template slot="no-results">{{LoadingMessage}}</template>
          </infinite-loading>
        </v-list-item-group>
      </v-list>

    </v-card>
    <TaskForm
      ref="scheduleForm"
      method="update"
      target="task"
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
      LoadingMessage: function() {
        if(this.unfinished_tasks.length > 0){
          return '検索結果は以上です'
        } else {
          return '未実施のタスクはありません'
        }
      },
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
        this.getUnfinishedTask({
          authTokens: this.authTokens,
          page: this.page
        })
        .then(( { tasks } ) => {
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