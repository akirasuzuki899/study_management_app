<template>
  <v-card>
    <validation-observer
      ref="observer"
      v-slot="{ invalid }"
    >
      <form>
        <v-card-text
          class="d-flex justify-center"
        >
          <v-row 
            style="max-width:650px"
          >
            <v-col cols="12" sm="12" md="12">
              <TextInput
                v-model="formData.title"
                name="タイトル"
                label="タイトル"
                rules="max:50"
                :dense="true"
                :disabled="readOnlyIndicator"
              ></TextInput>
            </v-col>
            <v-col cols="12" sm="12" md="12">
              <SelectStudyMaterial
                v-model="formData.study_material_id"
                :dense="true"
                :disabled="readOnlyIndicator"
              ></SelectStudyMaterial>
            </v-col>
          </v-row>
        </v-card-text>
        <v-card-text>
          <v-container>

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
      selectedNote: {},
      editor: undefined,
      item: this.treeview,
      formData: {
        title: 'untitled',
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
  computed: {
    ...mapGetters('studyNote', ['studyNotes', 'treeView']),
    ...mapGetters('studyMaterial', ['studyMaterials']),
  },
  // watch: {
  //   studyMaterials: {
  //     deep: true,
  //     handler: 'treeview',
  //   }
  // },
  methods: {
    ...mapActions('studyNote', ['getStudyNotes','createStudyNote','updateStudyNote']),
    ...mapActions('studyMaterial', ['getStudyMaterials']),
    save() {
      this.editor.save().then(savedData => {
        this.formData.rich_text = JSON.stringify(savedData);

        this.selectedNote.id
         ? this.updateStudyNote({formData: this.formData})
         : this.createStudyNote({formData: this.formData})
      });
    },
    set() {
      this.editor.render(
        JSON.parse(this.studyNotes[0]["rich_text"])
      )
    },
    // treeview(){
    //   if(this.studyMaterials.length){
    //     console.log("testttttttt")
    //     console.log(this.studyMaterials)
    //     console.log(this.studyMaterials.length)
    //   }else{
    //     console.log("aaaaaaaaaa")
    //     console.log(this.studyMaterials)
    //   }
    // },
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
    this.treeview
    },
  created() {
    this.getStudyNotes()
    this.getStudyMaterials()
  }
}
</script>