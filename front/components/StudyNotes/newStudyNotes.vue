<template>
  <v-card>
    <v-card-title>
      <span class="headline">新規作成</span>
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
                <VueTrix 
                  inputId="editor1" 
                  @trix-attachment-add="handleAttachmentChanges" 
                  v-model="formData.content" 
                  placeholder="Enter content"
                ></VueTrix>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-btn
            text
            color="secondary"
            :disabled="invalid"
            @click="createNotes()"
          >
            更新
          </v-btn>
        </v-card-actions>
      </form>
    </validation-observer>
  </v-card>
</template>


<script>
import axios from "@nuxtjs/axios"
import TextInput from "../Form/BaseTextInput";
import SelectStudyMaterial from "../Form/SelectStudyMaterial";
import VueTrix from "vue-trix";
import { DirectUpload } from "@rails/activestorage";

import { ValidationObserver } from 'vee-validate';

const Host = axios.baseURL

export default {
  data() {
    return {
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
    VueTrix,
    ValidationObserver,
  },
  methods: {
    handleAttachmentChanges(event) {
        // 1. get file object
      let file = event.attachment.file;
  
      // 2. upload file to remote server with FormData
        const upload = new DirectUpload(file, Host + "rails/active_storage/direct_uploads");
        console.log(upload);
        upload.create((error, blob) => {
          if(error){
            console.log(error);
          } else {
            console.log(blob);
            // 3. if upload success, set back the attachment's URL attribute
            // @param object data from remote server response data after upload.
            let attributes = {
              sgid: blob.attachable_sgid,
              url: Host + "rails/active_storage/blobs/" + blob.signed_id + "/" + blob.filename,
            };
            event.attachment.setAttributes(attributes);
          }
        });
    },
    createNotes() {
      axios
        .post(
          '/api/v1/study_notes', 
          {
            title: this.title,
            page_number: this.page_number,
            study_material_id: this.study_material_id,
            content: this.content
          }
        )
        .then(response => {
          console.log(response);
        })
        .catch(error => {
          console.log(error);
        });
    }
  },
}
</script>>