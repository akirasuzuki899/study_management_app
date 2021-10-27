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
                          placeholder="untitled"
                        ></TextInput>
                      </v-col>
                      <v-col cols="auto" class="flex-shrink-1">
                        <SelectStudyMaterial
                          v-model="formData.noteable_id"
                          :dense="true"
                          :disabled="readOnlyIndicator"
                        ></SelectStudyMaterial>
                      </v-col>
                      <v-col cols="auto" class="flex-grow-1" style="position: relative; min-height: 300px;">
                          <EditorJS 
                            ref="editor"
                            class="fill-height overflow-y-auto" 
                            style="width: 100%; position: absolute; left: 0; top: 0;"
                          ></EditorJS>
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
                        @click="toggleEditable()"
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
                        @click="saveNote()"
                      >
                        更新
                      </v-btn>
                      <v-btn
                        text
                        color="secondary"
                        @click="toggleEditable()"
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
      @clicked="destroyNote()"
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
import EditorJS from "./Editor-js.vue";
import TextInput from "../Form/BaseTextInput";
import SelectStudyMaterial from "../Form/SelectStudyMaterial";
import Alert from "../Alert"

import { ValidationObserver } from 'vee-validate';

export default {
  data() {
    return {
      readOnlyIndicator: true,
      selectedNoteID: '',
      drawer: false,
      formData: {
        title: '',
        noteable_id: '',
        rich_text: '',
      }
    }
  },
  components: {
    EditorJS,
    TextInput,
    SelectStudyMaterial,
    Alert,
    ValidationObserver,
  },
  computed: {
    ...mapGetters('studyMaterialNote', ['treeView']),
    ...mapGetters('studyMaterial', ['studyMaterials']),
  },
  methods: {
    ...mapActions('studyMaterialNote', ['getNotes','createNote','updateNote','deleteNote']),
    ...mapActions('studyMaterial', ['getStudyMaterials']),
    saveNote() {
      this.$refs.editor.editor.save().then(savedData => {
        this.formData.rich_text = JSON.stringify(savedData);

        if (!this.formData.title.trim()) this.formData.title = "untitled"

        this.selectedNoteID
         ? this.updateNote({formData: this.formData, selectedNoteID: this.selectedNoteID})
         : this.createNote({formData: this.formData}).then( noteID => {this.selectedNoteID = noteID})
        
        this.toggleEditable()
      });
    },
    setNote(note){
      this.selectedNoteID = note.id
      this.formData.title = note.title
      this.formData.noteable_id = note.noteable_id
      this.$refs.editor.editor.render(
        JSON.parse(note.rich_text)
      )
      this.drawer = false
    },
    newNote(noteable_id){
      this.formData.noteable_id = noteable_id
      this.formData.rich_text = {}
      this.formData.title = ''
      this.selectedNoteID = ''
      this.$refs.editor.editor.clear();
      if(this.readOnlyIndicator) this.toggleEditable()
      this.drawer = false
    },
    destroyNote(){
      this.deleteNote({selectedNoteID: this.selectedNoteID})
      this.$refs.editor.editor.clear();
      this.formData = {}
      this.selectedNoteID = ''
    },
    openAlert() {
      this.$refs.alert.open();
    },
    toggleEditable() {
      this.readOnlyIndicator = !this.readOnlyIndicator
      this.$refs.editor.toggleEditable()
    }
  },
  created() {
    this.getNotes()
    this.getStudyMaterials()
  }
}
</script>