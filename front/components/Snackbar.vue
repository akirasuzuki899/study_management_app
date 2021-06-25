<template>
  <div class="text-center">

    <v-snackbar
      v-model="isOpen"
      :timeout="timeOut"
      :color="color"
      outlined
    >
      {{ text }}
      <template v-slot:action="{ attrs }">

        <v-btn
          icon
          v-bind="attrs"
          @click="isOpen = false"
        >
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </template>
    </v-snackbar>
  </div>
</template>
<script>
  import { mapGetters } from "vuex";
  
  export default {
    computed: {
       ...mapGetters('snackbar', ['type', 'text', 'timeOut', 'color']),
       isOpen: {
         get() {
           return this.$store.state.snackbar.isOpen
         },
         set() {
           return this.$store.dispatch('snackbar/close')
         }
       }
    },
    // methods: {
    //   restoreStatus(){
    //     console.log("----------  restoreStatus from snackbar  ----------")

    //   }
    // }
  }
</script>