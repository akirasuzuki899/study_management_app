<template>
  <v-btn
    color="blue darken-1"
    text
    @click="createTarget"
  >
    保存
  </v-btn>
</template>

<script>
export default {
  props: ["target", "authTokens", "formData"],
  methods: {
    createTarget(){
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
        authTokens: this.authTokens,
        formData: this.formData
      })
    },
    task(){
      console.log("task")
      this.$emit("task", {
        authTokens: this.authTokens,
        formData: this.formData
      })
    },
  },
}
</script>