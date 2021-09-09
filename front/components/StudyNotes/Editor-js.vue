<template>
  <div class="fill-height">
    <v-card class="fill-height overflow-hidden">
      <v-row class="fill-height flex-column no-gutters">
        <v-col cols="auto" class="flex-shrink-1">
          <v-toolbar dense>
            <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
          </v-toolbar>
        </v-col>
        <v-col cols="auto" class="flex-grow-1">
          <validation-observer
            ref="observer"
            v-slot="{ invalid }"
          >
            <form class="fill-height">
              <v-row class="fill-height flex-column no-gutters">
                <v-col cols="auto" class="flex-grow-1 overflow-y-auto">
                  <v-card-text class="fill-height">
                    <v-row class="fill-height flex-column no-gutters mx-auto" style="max-width:650px">
                      <v-col cols="auto" class="flex-shrink-1">
                        <TextInput
                          v-model="formData.title"
                          name="タイトル"
                          label="タイトル"
                          rules="max:50"
                          :dense="true"
                          :disabled="readOnlyIndicator"
                        ></TextInput>
                      </v-col>
                      <v-col cols="auto" class="flex-shrink-1">
                        <SelectStudyMaterial
                          v-model="formData.study_material_id"
                          :dense="true"
                          :disabled="readOnlyIndicator"
                        ></SelectStudyMaterial>
                      </v-col>
                      <v-col cols="auto" class="flex-grow-1" style="position: relative; min-height: 300px;">
                          <div id="editorjs" class="fill-height overflow-y-auto" style="width: 100%; position: absolute; left: 0; top: 0;"></div>
                      </v-col>
                    </v-row>
                  </v-card-text>
                </v-col>
                <v-col cols="auto" class="flex-shrink-1">
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
                </v-col>
              </v-row>
            </form>
          </validation-observer>
        </v-col>
      </v-row>


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
              aspect-ratio='1'
              contain
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

          <template v-slot:default v-if="!treeView.length">
            <v-container>
              <v-btn
                class="text-truncate"
                color="primary"
                block
                @click="$router.push('/plan')"
              >教材を登録する</v-btn>
            </v-container>
          </template>
          
        </v-treeview>
      </v-navigation-drawer>
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
// import LinkTool from '@editorjs/link'
import ImageTool from '@editorjs/image';

import { DirectUpload } from "@rails/activestorage";
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
    ...mapGetters('studyNote', ['treeView']),
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
      const Host = this.$axios.defaults.baseURL
      const axios = this.$axios
      
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
          },
          // linkTool: {
          //   class: LinkTool,
          //   config: {
          //     endpoint: Host + '/api/v1/study_notes/url_metadata', // Your backend endpoint for url data fetching
          //   }
          // },
          image: {
            class: ImageTool,
            config: {

              uploader: {
                uploadByFile(file){
                  const upload = new DirectUpload(file, Host + "/rails/active_storage/direct_uploads")

                  return new Promise((resolve, reject) => {
                    upload.create((error, blob) => {
                      if(error){
                        reject(error)
                      } else {
                        resolve(blob)
                      }
                    })
                  }).then((blob) => {
                    return {
                      success: 1,
                      file: {
                        url: Host + "/rails/active_storage/blobs/" + blob.signed_id + "/" + blob.filename,
                        sgid: blob.signed_id,
                      }
                    };
                  })
                },
                uploadByUrl(url){
                  console.log("uploadByUrl")
                  return axios
                    .post(Host + "/api/v1/study_notes/download", {
                      url: url,
                      title: "test"
                    })
                    .then(({ data }) => {
                      return {
                        success: 1,
                        file: {
                          url: Host + "/rails/active_storage/blobs/" + data.signed_id + "/" + data.filename,
                          sgid: data.signed_id,
                        }
                      }
                    })
                }
              }
            }
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