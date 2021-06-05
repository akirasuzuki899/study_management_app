<template>
  <v-btn 
    icon 
    @click="deleteTarget"
  >
    <v-icon>mdi-delete-outline</v-icon>
  </v-btn>
</template>

<script>
export default {
  props: ["target", "authTokens", "selectedTask"],
  methods: {
    deleteTarget(){
      if(this.target === "taskTemplate"){
        this.taskTemplate()
      } else if (this.target === "task"){
        this.task()
      } else {
        console.log("値が不正")
        console.log(this.target)
      }
    },
    taskTemplate(){
      console.log(this.target)
      this.$emit('task-template', {
        authTokens: this.authTokens,
        selectedTask: this.selectedTask
      })
    },
    task(){
      console.log("task")
      this.$emit("task", {
        authTokens: this.authTokens,
        selectedTask: this.selectedTask
      })
    },
  }
}
</script>