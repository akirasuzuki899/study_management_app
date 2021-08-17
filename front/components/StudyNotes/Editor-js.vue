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
            <!-- <v-row>
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
            </v-row> -->
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
          <v-btn
            text
            color="secondary"
            :disabled="invalid"
            @click="save()"
          >
            更新
          </v-btn>
        </v-card-actions>
      </form>
    </validation-observer>
  </v-card>
</template>

<script>
import TextInput from "../Form/BaseTextInput";
import SelectStudyMaterial from "../Form/SelectStudyMaterial";
import EditorJS from "@editorjs/editorjs";
import Header from "@editorjs/header";
import List from "@editorjs/list";
import Paragraph from "@editorjs/paragraph";

import { ValidationObserver } from 'vee-validate';

export default {
  data() {
    return {
      editor: undefined,
      formData: {
        title: '',
        page_number: '',
        study_material_id: '',
        content: '',
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
    save() {
      this.editor.save().then(savedData => {
        console.log(savedData);
        this.content = savedData;
      });
    },
    init() {
      //Editor.jsの初期化
      this.editor = new EditorJS({
        //Editor.jsの対象にするidを与える
        holder: "editorjs",
        tools: {
          Header: {
            class: Header,
          },
          List: {
            class: List
          },
          Paragraph: {
            class: Paragraph,
            inlineToolbar: true,
              config: {
                // 空の行を許可する。
                preserveBlank: true,
              },
          },
        },
        defaultBlock: "Paragraph",
      });
    },
  },
  mounted() {
    this.init();
  },
}
</script>