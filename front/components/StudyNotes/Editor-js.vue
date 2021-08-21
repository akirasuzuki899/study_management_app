<template>
  <div>
    <v-card>
      <v-toolbar dense>
        <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
      </v-toolbar>
      <v-navigation-drawer
        v-model="drawer"
        temporary
        absolute
      >
          <v-treeview
            hoverable
            :items="treeView"
          >
            <template v-slot:prepend="{ item }">
              <v-img
                aspect-ratio="1"
                :src="item.image_url"
              ></v-img>
            </template>
            
            <template v-slot:label="{ item }">
              <div 
                v-if="item.children"
                class="text-truncate"
              >
                {{item.title}}
              </div>
              <v-btn 
                v-else
                block
                text
                class="text-truncate"
                @click="setNote(item)"
              >
                {{item.title}}
              </v-btn>
            </template>

            <template v-slot:append="{ item }">
              <v-icon
                v-if="item.children"
                @click="newNote(item.id)"
              >
                mdi-plus
              </v-icon>
            </template>
          </v-treeview>
      </v-navigation-drawer>

      <validation-observer
        ref="observer"
        v-slot="{ invalid }"
      >
        <form>
          <v-card-text>
            <v-container
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
            </v-container>
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
            <template
              v-if="readOnlyIndicator"
            >
              <v-btn
                text
                color="primary"
                @click="toggle()"
              >
                編集
              </v-btn>
              <v-btn
                v-if="selectedNoteID"
                text
                color="secondary"
                @click="openAlert"
              >
                削除
              </v-btn>
            </template>
            <template
                v-else
            >
              <v-btn
                text
                color="primary"
                :disabled="invalid"
                @click="saveNote(); toggle()"
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
          </v-card-actions>
        </form>
      </validation-observer>
    </v-card>
    <Alert
      ref="alert"
      @clicked="deleteNote()"
    >
      <template v-slot:content>
        ノートを削除しますか
      </template>
      <template v-slot:btnText>
        削除
      </template>
    </Alert>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import TextInput from "../Form/BaseTextInput";
import SelectStudyMaterial from "../Form/SelectStudyMaterial";
import Alert from "../Alert"

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
      selectedNoteID: '',
      drawer: false,
      editor: undefined,
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
    Alert,
    ValidationObserver,
  },
  computed: {
    ...mapGetters('studyNote', ['studyNotes', 'treeView']),
    ...mapGetters('studyMaterial', ['studyMaterials']),
  },
  methods: {
    ...mapActions('studyNote', ['getStudyNotes','createStudyNote','updateStudyNote','deleteStudyNote']),
    ...mapActions('studyMaterial', ['getStudyMaterials']),
    saveNote() {
      this.editor.save().then(savedData => {
        this.formData.rich_text = JSON.stringify(savedData);

        this.selectedNoteID
         ? this.updateStudyNote({formData: this.formData, selectedNoteID: this.selectedNoteID})
         : this.createStudyNote({formData: this.formData, selectedNoteID: this.selectedNoteID})
        
        this.toggle
      });
    },
    setNote(note){
      this.selectedNoteID = note.id
      this.formData.title = note.title
      this.formData.study_material_id = note.study_material_id
      this.editor.render(
        JSON.parse(note.rich_text)
      )
      this.drawer = false
    },
    newNote(study_material_id){
      console.log('newNote')
      this.formData.study_material_id = study_material_id
      this.formData.rich_text = {}
      this.formData.title = "untitled"
      this.selectedNoteID = ''
      this.editor.clear();
      if(this.readOnlyIndicator)this.toggle()
      this.drawer = false
    },
    deleteNote(){
      this.deleteStudyNote({selectedNoteID: this.selectedNoteID})
      this.editor.clear()
      this.formData = {}
      this.selectedNoteID = ''
    },
    initEditor() {
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
      });
    },
    async toggle(){
        this.readOnlyIndicator = await this.editor.readOnly.toggle();
        if(!this.readOnlyIndicator) this.editor.caret.setToLastBlock('start', 0)
    },
    openAlert() {
      this.$refs.alert.open();
    },
  },
  mounted() {
    this.initEditor();
  },
  created() {
    this.getStudyNotes()
    this.getStudyMaterials()
  }
}
</script>