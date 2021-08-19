<template>
  <v-card>
    <v-card-title>
      <span class="headline">Edito.js</span>
    </v-card-title>
    <validation-observer
      ref="observer"
      v-slot="{ invalid }"
    >
      <form>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="12" sm="12" md="12">
                <TextInput
                  v-model="formData.title"
                  name="タイトル"
                  label="タイトル"
                  rules="required|max:50"
                  :dense="true"
                ></TextInput>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12" sm="12" md="12">
                <SelectStudyMaterial
                  v-model="formData.study_material_id"
                  :dense="true"
                ></SelectStudyMaterial>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12" sm="12" md="12">
                <div>
                  <div id="editorjs"></div>
                </div>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-btn
            v-if="readOnlyIndicator"
            text
            color="primary"
            @click="toggle()"
          >
            編集
          </v-btn>
          <template
              v-else
          >
            <v-btn
              text
              color="primary"
              :disabled="invalid"
              @click="save(); toggle()"
            >
              更新
            </v-btn>
            <v-btn
              text
              color="secondary"
              @click="toggle()"
            >
              取消
            </v-btn>
          </template>
          <!-- <v-btn
            text
            color="secondary"
            @click="set()"
          >
            test
          </v-btn> -->
        </v-card-actions>
      </form>
    </validation-observer>

  </v-card>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import TextInput from "../Form/BaseTextInput";
import SelectStudyMaterial from "../Form/SelectStudyMaterial";
import EditorJS from "@editorjs/editorjs";
import Header from "@editorjs/header";
import List from "@editorjs/list";
import Paragraph from "@editorjs/paragraph";
import Checklist from "@editorjs/checklist";
import Marker from "@editorjs/marker";

import { ValidationObserver } from 'vee-validate';

export default {
  data() {
    return {
      readOnlyIndicator: true,
      editor: undefined,
      
      formData: {
        title: '',
        study_material_id: '',
        rich_text: '',
      }
    }
  },
  components: {
    TextInput,
    SelectStudyMaterial,
    ValidationObserver,
  },
  computed:{
    ...mapGetters('studyNote', ['studyNotes']),
  },
  methods: {
    ...mapActions('studyNote', ['getStudyNotes','createStudyNote']),
    save() {
      this.editor.save().then(savedData => {
        this.formData.rich_text = JSON.stringify(savedData);
        this.createStudyNote({
          formData: this.formData
        })
      });
    },
    set() {
      this.editor.render(
        JSON.parse(this.studyNotes[0]["rich_text"])
      )
    },
    init() {
      this.editor = new EditorJS({
        holder: "editorjs",
        theme: 'dark',
        tools: {
          paragraph: {
            class: Paragraph,
              config: {
                preserveBlank: true,
                placeholder: 'Paragraph'
              },
          },
          header: {
            class: Header,
            config: {
              placeholder: 'Header'
            },
          },
          list: {
            class: List,
            inlineToolbar: true,
            config: {
              placeholder: 'List'
            },
          },
          checklist: {
            class: Checklist,
            config: {
              placeholder: 'Checklist'
            },
          },
          marker: {
            class: Marker,
          }
        },
        readOnly: true,
        defaultBlock: "paragraph",
        onChange: () => {console.log(this.editor)}
      });
    },
    async toggle(){
        this.readOnlyIndicator = await this.editor.readOnly.toggle();
    }
  },
  mounted() {
    this.init();
    },
  created() {
    this.getStudyNotes()
  }
}
</script>