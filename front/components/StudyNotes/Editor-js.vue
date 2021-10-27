<template>
  <div id="editorjs"></div>
</template>

<script>
import EditorJS from "@editorjs/editorjs";
import Header from "@editorjs/header";
import List from "@editorjs/list";
import Paragraph from "@editorjs/paragraph";
import Checklist from "@editorjs/checklist";
import Marker from "@editorjs/marker";
// import LinkTool from '@editorjs/link'
import ImageTool from '@editorjs/image';

import { DirectUpload } from "@rails/activestorage";

export default {
  data() {
    return {
      readOnlyIndicator: true,
      editor: undefined,
    }
  },
  methods: {
    
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
    async toggleEditable(){
        this.readOnlyIndicator = await this.editor.readOnly.toggle();
        if(!this.readOnlyIndicator) this.editor.caret.setToLastBlock('start', 0)
    },
  },
  mounted() {
    this.initEditor();
  },
}
</script>