<template>
  <v-data-table
    class="fill-height overflow-y-auto"
    style="width: 100%; position: absolute; left: 0; top: 0;"
    :headers="headers"
    :items="items"
    no-data-text="該当する期間のログはありません"
    hide-default-header
    hide-default-footer
    mobile-breakpoint="0"
    :items-per-page=-1
    dense
  >
  
    <template 
      v-if="!custom"
      v-slot:[`item.color`]="{ item }"
    >
      <v-icon
        dark
        :color="item.color"
        size="12"
      >
        mdi-circle
      </v-icon>
    </template>

    <template 
      v-if="!custom"
      v-slot:[`item.image_url`]="{ item }"
    >
      <v-avatar tile size="28">
        <v-img
          :src="item.image_url"
          contain
        ></v-img>
      </v-avatar>
    </template>

    <template 
      v-if="!custom"
      v-slot:[`item.title`]="{ item }"
    >
      <div class="text-truncate">
        {{item.title}}
      </div>
    </template>

    <template 
      v-if="!custom"
      v-slot:[`item.sum`]="{ item }"
    >
      <slot name="sum" :item="item"></slot>
    </template>

    <template 
      v-if="!custom"
      v-slot:[`item.percentage`]="{ item }"
    >
      <slot name="percentage" :item="item"></slot>
    </template>

    <template
      v-if="custom"
      v-slot:item="{ item }"
    >
      <slot name="item" :item="item"></slot>
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
    headers: {
      type: Array,
      default: undefined
    },
    custom: {
      type: Boolean,
      default: false
    }
  },
}
</script>

<style lang="scss" scoped>
  .v-data-table ::v-deep .v-data-table__wrapper > table {
    table-layout: fixed;

    tbody > tr {
      &:hover {
        background-color: transparent !important;
      }
      td {
        &.td-color {
          width: 20px;
          padding: 0;
          text-align: center;
        }
        &.td-image {
          width: 30px;
          padding: 0;
          text-align: center;
        }
        &.td-title {
          width: auto;
          padding: 0,8;
          font-size: 8px;
        }
        &.td-sum {
          width: 30px;
          padding: 0;
          text-align: center;
          font-size: 8px;
        }
        &.td-percentage {
          width: 30px;
          padding: 0;
          text-align: center;
          font-size: 8px;
        }
      }
    }
  }
</style>