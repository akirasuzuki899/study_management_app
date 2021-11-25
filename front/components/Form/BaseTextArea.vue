<template>
  <div :id="[id + 'editorjs']" class="editorjs"></div>
</template>

<script>
import EditorJS from "@editorjs/editorjs";
import Header from "@editorjs/header";
import List from "@editorjs/list";
import Paragraph from "@editorjs/paragraph";
import Checklist from "@editorjs/checklist";
import Marker from "@editorjs/marker";

export default {
  data() {
    return {
      editor: undefined,
    }
  },
  props: {
    readOnly: {
      type: Boolean,
      default: true
    },
    text: {
      type: String,
      default: undefined
    },
    id: {
      type: Number,
      default: undefined
    }
  },
  watch: {
    text: function() {
      try {
        this.editor.render(JSON.parse(this.text))
      }catch(e) {
        this.editor.blocks.insert('paragraph')
      }
    }
  },
  methods: {
    
    initEditor() {
      this.editor = new EditorJS({
        holder: this.id + "editorjs",
        theme: 'dark',
        tools: {
          paragraph: {
            class: Paragraph,
              config: {
                preserveBlank: true,
                placeholder: 'テキストを入力'
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
        },
        readOnly: this.readOnly,
        defaultBlock: "paragraph",
        minHeight : 0,
        onReady: () => {
          try {
            this.editor.render(JSON.parse(this.text))
          }catch(e) {
            this.editor.blocks.insert('paragraph')
          }
        }
      });
    },
  },
  mounted() {
    this.initEditor();
  }
}
</script>