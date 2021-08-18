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
                <TextInput
                  v-model="formData.page_number"
                  name="ページ数"
                  label="ページ数"
                  rules="required|max:6"
                  :dense="true"
                ></TextInput>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12" sm="12" md="12">
                <div>
                  <div class="edit" id="editorjs"></div>
                </div>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <!-- <v-btn
            v-if="editor.readOnly"
            text
            color="secondary"
            @click="editor.readOnly.toggle()"
          >
            編集
          </v-btn> -->
          <v-btn
            text
            color="secondary"
            :disabled="invalid"
            @click="save()"
          >
            更新
          </v-btn>
          <v-btn
            text
            color="secondary"
            @click="editor.readOnly.toggle()"
          >
           toggle
          </v-btn>
          <v-btn
            text
            color="secondary"
            @click="set()"
          >
            test
          </v-btn>
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
      editor: undefined,
      formData: {
        title: '',
        page_number: '',
        study_material_id: '',
        rich_text: '',
      }
    }
  },
  components: {
    TextInput,
    SelectStudyMaterial,
    EditorJS,
    ValidationObserver,
  },
  methods: {
    ...mapActions('studyNote', ['createStudyNote']),
    save() {
      this.editor.save().then(savedData => {
        console.log("savedData");
        console.log(savedData);
        this.formData.rich_text = JSON.stringify(savedData);
        this.createStudyNote({
          formData: this.formData
        })
      });
    },
    set() {
      this.editor.render(
        JSON.parse('{"time":1629208496936,"blocks":[{"id":"9sPirmmGKl","type":"paragraph","data":{"text":"test"}},{"id":"XYlvmZsAO7","type":"paragraph","data":{"text":""}},{"id":"_ttoq2nNB2","type":"paragraph","data":{"text":"test"}},{"id":"vuJ_OUxEwr","type":"paragraph","data":{"text":""}}],"version":"2.22.2"}')
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
          Marker: {
            class: Marker,
          }
        },
        readOnly: false,
        defaultBlock: "paragraph",
        data: JSON.parse('{"time":1629208496936,"blocks":[{"id":"9sPirmmGKl","type":"paragraph","data":{"text":"test"}},{"id":"XYlvmZsAO7","type":"paragraph","data":{"text":""}},{"id":"_ttoq2nNB2","type":"paragraph","data":{"text":"test"}},{"id":"vuJ_OUxEwr","type":"paragraph","data":{"text":""}}],"version":"2.22.2"}')
      });
    },
  },
  mounted() {
    this.init();
  },
}
</script>