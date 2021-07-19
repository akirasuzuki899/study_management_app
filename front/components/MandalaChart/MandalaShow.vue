<template>
  <v-card>
    <v-subheader>
      タイトル
    </v-subheader>
    <v-card-text>
      {{selectedMandalaItem.text}}
    </v-card-text>

    <v-subheader>
      外部リンク
      <v-btn
        v-if="selectedMandalaItem.url"
        :href="selectedMandalaItem.url"
        target="_blank"
        small
      >
        開く
      </v-btn>
    </v-subheader>
    <v-card-text>
      <div class="text-truncate">
        {{selectedMandalaItem.url}}
      </div>
    </v-card-text>

    <v-subheader>
      ステータス
    </v-subheader>
    <v-card-text>
      {{selectedMandalaItem.is_finished ? '完了' : '学習中'}}
    </v-card-text>

    <v-card-actions>
      <v-btn
        text
        color="secondary"
        @click="$emit('close')"
      >
        閉じる
      </v-btn>
      <v-spacer></v-spacer>
      <v-btn
        color="blue darken-1"
        text
        @click="$emit('edit')"
      >
        編集
      </v-btn>
    </v-card-actions>
  </v-card>
</template>

<script>
export default {
  props: {
    selectedMandalaItem: {
      type: Object,
      default:() => ({
        id: '',
        mandala_group_id: '',
        place_number: '',
        text: '',
        is_finished: '',
        url: '',
      })
    },
  },
}
</script>