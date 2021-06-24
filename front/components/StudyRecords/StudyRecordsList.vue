<template>
  <div>
    <v-card
      class="mx-auto"
      max-width="500"
    >
      <v-toolbar
        color="pink"
        dark
      >
        <v-toolbar-title>再登録</v-toolbar-title>
      </v-toolbar>

      <v-list dense :subheader="true">
        <v-list-item-group
          active-class="pink--text"
          v-model="selectedId"
        >
          <template v-for="(item, index) in unfinished_tasks">
            <v-list-item :key="item.id" @click="openScheduleForm(index)">
              <v-list-item-avatar tile size="50">
                <v-img 
                  :src="item.study_material.image_url"
                  contain
                >
                </v-img>
              </v-list-item-avatar>
              <v-list-item-content>
                  <v-list-item-title>{{ item.study_material.title }}</v-list-item-title>
                  <v-list-item-subtitle>{{ dateTime(item) }}</v-list-item-subtitle>
              </v-list-item-content>

              <!-- <v-list-item-action>
                <v-btn @click.stop="" outlined text>
                  <v-icon>mdi-delete-outline</v-icon>
                </v-btn>
              </v-list-item-action> -->
            </v-list-item>

            <v-divider
              v-if="index < unfinished_tasks.length - 1"
              :key="index"
            ></v-divider>

          </template>
        </v-list-item-group>
      </v-list>

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
import { mapGetters } from "vuex";
import TaskForm from "../Schedule/TaskForm.vue"

  export default {
    components: {
      TaskForm,
    },
    data() {
      return {
        selectedId: "",
        selectedTask: {},
      }
    },
    watch: {

    },
    computed: {
      ...mapGetters('task', ['unfinished_tasks']),
      dateTime: function() {
        return function(item){
          if (item.start_date == item.end_date){
            return `${this.formatDate(item.start_date)} ${item.start_time} 〜 ${item.end_time}`
          } else {
            return `${this.formatDateTime(item.start_date, item.start_time)} 〜 ${this.formatDateTime(item.end_date, item.end_time)}`
          }
        }
      },
    },
    methods: {
      openScheduleForm(index) {
        this.selectedTask = this.unfinished_tasks[index]
        this.$refs.scheduleForm.open()
      },
      formatDateTime(date, time){
        const d = new Date(date)
        return `${d.getMonth() + 1}月${d.getDate()}日  ${time}`
      },
      formatDate(date){
        const d = new Date(date)
        return `${d.getMonth() + 1}月${d.getDate()}日`
      },
      clearID(){
        this.selectedId = ''
      }
    }
  }
</script>