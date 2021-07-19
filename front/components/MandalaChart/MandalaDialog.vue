<template>
  <div class="text-center">
    <v-dialog
      v-model="Dialog"
      width="300"
      @click:outside="close()"
    >
      <MandalaShow
        v-if="!edit"
        :selectedMandalaItem="selectedMandalaItem"
        @edit="edit=true"
        @close="close()"
      ></MandalaShow>
      <MandalaForm
        v-if="edit"
        :selectedMandalaItem="selectedMandalaItem"
        :edit="edit"
        @show="edit=false"
        @close="close()"
      ></MandalaForm>
    </v-dialog>
  </div>
</template>

<script>
import MandalaShow from "../MandalaChart/MandalaShow"
import MandalaForm from "../MandalaChart/MandalaForm"

export default {
  components: {
    MandalaShow,
    MandalaForm,
  },
  props: {
    selectedMandalaItem: {
      type: Object,
      default:() => ({
        id: '',
        mandala_group_id: '',
        place_number: '',
        text: '',
        is_finished: '',
        url: '',
      })
    },
  },
  data: () => ({
    Dialog: false,
    edit: false,
  }),
  methods: {
    open () {
      this.Dialog = true
    },
    close () {
      this.Dialog = false
      this.edit = false
    },
  }
}
</script>