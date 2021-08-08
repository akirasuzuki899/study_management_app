<template>
  <v-btn
    color="blue darken-1"
    text
    :disabled="disabled"
    @click="updateTarget"
  >
    更新
  </v-btn>
</template>

<script>
export default {
  props: ["target", "formData", "selectedTask", "disabled"],
  methods: {
    updateTarget(){
      if (this.target === "taskTemplate"){
        this.taskTemplate()
      } else if (this.target === "task") {
        this.task()
      } else {
        console.log("値が不正")
        console.log(this.target)
      }
    },
    taskTemplate(){
      console.log(this.target)
      this.$emit('task-template', {
        formData: this.formData,
        selectedTask: this.selectedTask
      })
    },
    task(){
      console.log("task")
      this.$emit("task", {
        formData: this.formData,
        selectedTask: this.selectedTask
      })
    }
  },
}
</script>