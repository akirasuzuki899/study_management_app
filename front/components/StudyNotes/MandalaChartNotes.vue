<template>
  <div class="fill-height">
    <v-card class="fill-height">
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
                        <MandalaItemSelect
                          v-model="formData.noteable_id"
                          name="項目"
                          label="項目"
                          :items="mandalaItems"
                          :value="mandalaItems.id"
                          item-value="id"
                          :dense="true"
                          :disabled="readOnlyIndicator"
                          :customItem="true"
                          :customSelection="true"
                          rules="required"
                        >
                          <template v-slot:item="{item}">
                            <v-icon
                              darke
                              :color="getColor(item.mandala_group)"
                              size="12"
                            >
                              mdi-circle
                            </v-icon>
                            <div class="px-2 text-truncate">
                              {{ mandlaGroupText(item) ? mandlaGroupText(item) : "-"}}
                            </div>

                            /

                            <v-icon
                              v-if="item.place_number == 5 || item.mandala_group.place_number == 5"
                              darke
                              :color="getColor(item)"
                              size="12"
                              class="pl-2"
                            >
                              mdi-circle
                            </v-icon>
                            <div class="pl-2 text-truncate">
                              {{item.text ? item.text : "-"}}
                            </div>
                          </template>

                          <template v-slot:selection="{item}">
                            <v-row dense class="no-gutters" style="width: 100%;">

                              <v-col cols="auto">
                                <v-icon
                                  darke
                                  :color="getColor(item.mandala_group)"
                                  size="12"
                                >
                                  mdi-circle
                                </v-icon>
                              </v-col>

                              <v-col class="px-2 text-truncate">
                                  {{ mandlaGroupText(item) ? mandlaGroupText(item) : "-"}}
                              </v-col>

                              <v-col cols="auto" class="pl-2">
                                /
                                <v-icon
                                  v-if="item.place_number == 5 || item.mandala_group.place_number == 5"
                                  darke
                                  :color="getColor(item)"
                                  size="12"
                                >
                                  mdi-circle
                                </v-icon>
                              </v-col>

                              <v-col class="pl-2 text-truncate">
                                  {{item.text ? item.text : "-"}}
                              </v-col>

                            </v-row>
                          </template>
                        </MandalaItemSelect>
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
          <template v-slot:prepend="{ item }" >
            <v-icon
              v-if="item.children && (item.mandala_chart_id || item.mandala_group.place_number == 5 || item.place_number == 5)"
              darke
              :color="getColor(item)"
              size="12"
            >
              mdi-circle
            </v-icon>
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
              v-if="item.children && item.mandala_group_id"
              @click="newNote(item.id)"
            >
              mdi-plus
            </v-icon>
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
import MandalaItemSelect from "../Form/BaseSelect.vue";
import Alert from "../Alert"

import { ValidationObserver } from 'vee-validate';

export default {
  data() {
    return {
      mandalaItems: [],
      readOnlyIndicator: true,
      selectedNoteID: '',
      drawer: false,
      formData: {
        title: '',
        noteable_id: '',
        rich_text: '',
      },
      colors: {
      1: 'purple darken-2', 
      2: 'indigo darken-2', 
      3: 'blue darken-2', 
      4: 'cyan darken-2', 
      5: 'teal darken-2',  //center
      6: 'green darken-2', 
      7: 'lime darken-2', 
      8: 'amber darken-2', 
      9: 'orange darken-2'},
    }
  },
  components: {
    EditorJS,
    TextInput,
    MandalaItemSelect,
    Alert,
    ValidationObserver,
  },
  computed: {
    ...mapGetters('mandalaItemNote', ['treeView']),
    mandlaGroupText: function() {
      return function(item) {
        var centerItem = this.mandalaItems.find(i => i.mandala_group_id == item.mandala_group_id && i.place_number == 5);
        return centerItem.text
      }
    }
  },
  methods: {
    ...mapActions('mandalaItemNote', ['getNotes','createNote','updateNote','deleteNote']),
    saveNote() {
      this.$refs.editor.editor.save().then(savedData => {
        this.formData.rich_text = JSON.stringify(savedData);

        console.log("!this.formData.title")
        console.log(!this.formData.title)
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
    },
    getColor(item){
      if (item.mandala_chart_id) {
        return this.colors[item.place_number]  
      }
      if (item.mandala_group_id){
        if (item.mandala_group.place_number == 5) {
          return this.colors[item.place_number]
        }
        if (item.place_number == 5){
          return this.colors[item.mandala_group.place_number]
        }
      }
      return undefined
    },
    updateMandalaItemTitle(item){
      const item_index = this.mandalaItems.findIndex((v) => v.id === item.id)
      this.mandalaItems[item_index].text = item.text
    }
  },
  created() {
    this.getNotes()
  },
  mounted () {
    this.$axios
    .get('/api/v1/mandala_items')
    .then(({data}) => {
      console.log("data")
      console.log(data)
      this.mandalaItems = data.mandala_items
    })
  }
}
</script>