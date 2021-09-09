<template>
  <validation-observer
    ref="observer"
    v-slot="{ invalid }"
  >
    <form>
      <v-card>
        <v-card-text>
          <v-container>
            <v-row :class="{ 'no-gutters' : $vuetify.breakpoint.name == 'xs' }">
              <v-col cols="12">
                <TextInput
                  v-model="formData.text"
                  name="タイトル"
                  label="タイトル"
                  rules="max:50"
                  :dense="true"
                ></TextInput>
              </v-col>
              <v-col cols="12">
                <TextInput
                  v-model="formData.url"
                  name="リンク"
                  label="URL"
                  rules="url"
                  :dense="true"
                  prependInnerIcon="mdi-link-variant"
                ></TextInput>
              </v-col>
              <v-col cols="12">
                <v-layout>
                <CheckBox
                  v-model="formData.is_finished"
                  :on-icon="'mdi-sticker-check-outline'"
                  :off-icon="'mdi-sticker-check-outline'"
                  :dense="true"
                ></CheckBox>
                </v-layout>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            text
            color="secondary"
            @click="$emit('show')"
          >
            取消
          </v-btn>
          <v-btn
            color="blue darken-1"
            text
            :disabled="invalid"
            @click="
              updateMandalaItem({
              selectedMandalaItem: selectedMandalaItem,
              formData: formData,
              });
              $emit('close')"
          >
          更新
          </v-btn>
        </v-card-actions>
      </v-card>
    </form>
  </validation-observer>
</template>

<script>
import TextInput from "../Form/BaseTextInput";
import CheckBox from "../Form/BaseCheckBox"

import { mapGetters, mapActions } from "vuex";
import { ValidationObserver } from 'vee-validate';

export default {
  components: {
    TextInput,
    CheckBox,
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
        is_finished: '',
        url: '',
      })
    },
    edit: {
      type: Boolean,
      default: false,
    }
  },
  data: () => ({
    formData: {
      id: '',
      mandala_group_id: '',
      place_number: '',
      text: '',
      is_finished: '',
      url: '',
    },
  }),
  watch: {
    edit: {
      handler: function() {
        if (this.edit == true){
          this.setDefaultFormData()

        } else if (this.edit == false) {
          this.$emit('formClosed')
          this.$refs.observer.reset()
        }
      },
      immediate: true
    },
  },
  computed: {
  },
  methods: {
    ...mapActions('mandalaChart', ['updateMandalaItem']),

    setDefaultFormData () {
      this.formData.mandala_group_id = this.selectedMandalaItem.mandala_group_id
      this.formData.place_number = this.selectedMandalaItem.place_number
      this.formData.text = this.selectedMandalaItem.text
      this.formData.is_finished = this.selectedMandalaItem.is_finished
      this.formData.url = this.selectedMandalaItem.url
    },
  }
}
</script>