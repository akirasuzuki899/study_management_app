<template>
  <div class="text-center">
    <v-dialog
      v-model="Dialog"
      width="300"
      @click:outside="close()"
    >
      <validation-observer
        ref="observer"
        v-slot="{ invalid }"
      >
        <form>
          <v-card >
            <v-card-text>
              <v-container>
                <v-row>
                  <v-col cols="12" sm="12" md="12">
                    <TextInput
                      v-model="formData.text"
                      name="タイトル"
                      label="タイトル"
                      rules="required|max:50"
                      :dense="true"
                    ></TextInput>
                  </v-col>
                  <v-col cols="12" sm="12" md="12">
                    <v-checkbox
                      v-model="formData.is_finished"
                      :on-icon="'mdi-check'"
                      :off-icon="'mdi-check'"
                    ></v-checkbox>
                  </v-col>
                </v-row>
              </v-container>
            </v-card-text>
            <v-card-actions>
              <v-btn
                :disabled="invalid"
              >
                <!-- @click="updateRecord(
                  formData, authTokens, selectedMandalaItem
                )" -->
              更新
              </v-btn>
            </v-card-actions>
          </v-card>
        </form>
      </validation-observer>
    </v-dialog>
  </div>
</template>

<script>
import TextInput from "../Form/BaseTextInput";

import { mapGetters, mapActions } from "vuex";
import { ValidationObserver } from 'vee-validate';

export default {
  components: {
    TextInput,
    ValidationObserver,
  },
  props: {
    selectedMandalaItem: {
      type: Object,
      default:() => ({
        id: '',
        mandala_group_id: '',
        place_number: '',
        text: '',
        color: '',
        is_finished: '',
      })
    },
  },
  data: () => ({
    Dialog: false,
    formData: {
      id: '',
      mandala_group_id: '',
      place_number: '',
      text: '',
      is_finished: '',
    }
  }),
  watch: {
    Dialog: function() {
      if (this.Dialog == true){
        this.setDefaultFormData()

      } else if (this.Dialog == false) {
        this.$emit('formClosed')
        this.$refs.observer.reset()
      }
    },
  },
  computed: {
    ...mapGetters(['authTokens']),
  },
  methods: {
    ...mapActions('', ['']),

    setDefaultFormData () {
      this.formData.mandala_group_id = this.selectedMandalaItem.mandala_group_id
      this.formData.place_number = this.selectedMandalaItem.place_number
      this.formData.text = this.selectedMandalaItem.text
      this.formData.is_finished = this.selectedMandalaItem.is_finished
    },
    open () {
      this.Dialog = true
    },
    
    close () {
      this.Dialog = false
    },
  }
}
</script>