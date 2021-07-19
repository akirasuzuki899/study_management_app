<template>
  <v-dialog
    v-model="dialog"
    persistent
    max-width="400"
  >
    <v-card>
      <v-card-title class="text-h5">
        <slot name="title"></slot>
      </v-card-title>
      <v-card-text>
        <slot name="content"></slot>
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn
          color="secondary"
          text
          @click="close()"
        >
          閉じる
        </v-btn>
        <v-btn
          color="blue darken-1"
          text
          @click="close(); $emit('clicked')"
        >
          <slot name="btnText"></slot>
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  data () {
    return {
      dialog: false,
    }
  },
  methods: {
    open() {
      this.dialog = true
    },
    close() {
      this.dialog = false
    },
  }
}
</script>