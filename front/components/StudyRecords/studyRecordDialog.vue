<template>
  <v-card>
    <v-dialog
      v-model="Dialog"
      max-width="400"
      @click:outside="close()"
    >
      <StudyRecordForm
        :selectedStudyRecord="studyRecord"
        :isOpen="Dialog"
        @recorded="close"
      ></StudyRecordForm>
    </v-dialog>
  </v-card>
</template>

<script>
import StudyRecordForm from "./studyRecordForm.vue"

export default {
  components: {
    StudyRecordForm
  },
  props: {
    studyRecord: {
      type: Object,
      default: undefined
    }
  },
  data () {
    return {
      Dialog: false,
    }
  },
  methods: {
    open () {
      this.Dialog = true
    },
    
    close () {
      this.Dialog = false
    },
  }
}
</script>