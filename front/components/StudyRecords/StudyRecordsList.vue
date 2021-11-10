<template>
  <div class="fill-height">
    <v-card class="fill-height">
      <v-row class="flex-column no-gutters fill-height">
        <v-col cols="auto" class="flex-shrink-1">
          <v-toolbar
            color="pink darken-1"
            dense
            class="rounded-t"
          >
            <v-toolbar-title>再登録</v-toolbar-title>
            <v-spacer></v-spacer>
            <v-btn
              v-if="$vuetify.breakpoint.name !== 'xs'"
              @click="$emit('close')"
              icon
            ><v-icon>mdi-close</v-icon></v-btn>
          </v-toolbar>
        </v-col>
        <v-col cols="auto" class="flex-grow-1" style="position: relative;">
          <TaskList
            ref="taskList"
            style="width: 100%; position: absolute; left: 0; top: 0;"
            :tasks="unfinished_tasks"
            @clicked="openScheduleForm"
          >
            <template v-slot:default>
              <infinite-loading
                @infinite="infiniteHandler"
              >
                <template slot="no-more">{{LoadingMessage}}</template>
                <template slot="no-results">{{LoadingMessage}}</template>
              </infinite-loading>
            </template>
          </TaskList>
        </v-col>
      </v-row>
    </v-card>
    <TaskForm
      ref="scheduleForm"
      method="update"
      target="task"
      :selectedTask="selectedTask"
      @formClosed="$refs.taskList.clearID()"
    ></TaskForm>
  </div>
</template>


<script>
import { mapGetters, mapActions } from "vuex";
import TaskList from "../Schedule/TaskList";
import TaskForm from "../Schedule/TaskForm.vue";
import InfiniteLoading from 'vue-infinite-loading';

import mixinMoment from "../../plugins/mixin-moment";

  export default {
    components: {
      TaskList,
      TaskForm,
      InfiniteLoading,
    },
    mixins: [mixinMoment],
    data() {
      return {
        selectedTask: {},
        page: 1,
      }
    },
    computed: {
      ...mapGetters('task', ['unfinished_tasks']),
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

      infiniteHandler($state) {
        this.getUnfinishedTask({
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