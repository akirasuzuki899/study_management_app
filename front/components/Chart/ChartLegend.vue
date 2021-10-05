<template>
  <v-data-table
    class="fill-height overflow-y-auto"
    style="width: 100%; position: absolute; left: 0; top: 0;"
    :headers="headers"
    :items="items"
    hide-default-header
    hide-default-footer
    mobile-breakpoint="0"
    :items-per-page=-1
    dense
  >
    <template v-slot:[`item.color`]="{ item }">
      <v-icon
        dark
        :color="item.color"
        size="12"
      >
        mdi-circle
      </v-icon>
    </template>
    <template v-slot:[`item.image_url`]="{ item }">
      <v-avatar tile size="28">
        <v-img
          :src="item.image_url"
          contain
        ></v-img>
      </v-avatar>
    </template>
    <template v-slot:[`item.title`]="{ item }">
      <div class="text-truncate">
        {{item.title}}
      </div>
    </template>
  </v-data-table>
</template>

<script>
export default {
  props: {
    items: {
      type: Array,
      default: undefined
    },
  },
  data() {
    return {
      headers: [
        { text: 'Color', value: 'color' },
        { text: 'TextBooks', value: 'image_url' },
        { text: 'Title', value: 'title' },
      ],
    }
  },
}
</script>