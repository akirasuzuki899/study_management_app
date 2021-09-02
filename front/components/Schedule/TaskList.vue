<template>
  <v-list
    :dense="true"
    :subheader="true"
    max-height="100%"
    class="overflow-y-auto"
  >
    <v-list-item-group
      active-class="pink--text"
      v-model="selectedId"
    >
      <template v-for="(item, index) in tasks">
        <v-list-item 
          @click="$emit('clicked', index)"
          :key="`task-${index}`"
        >
          <v-list-item-avatar tile size="50">
            <v-img 
              :src="item.study_material.image_url"
              contain
            ></v-img>
          </v-list-item-avatar>
          <v-list-item-content>
              <v-list-item-title>{{ item.study_material.title }}</v-list-item-title>
              <v-list-item-subtitle>{{ fromToDateTime(item.start, item.end) }}</v-list-item-subtitle>
          </v-list-item-content>
        </v-list-item>
        <v-divider
          v-if="index < tasks.length - 1"
          :key="`divider-${index}`"
        ></v-divider>
      </template>
      <slot name="default"></slot>
    </v-list-item-group>
  </v-list>
</template>

<script>
import mixinMoment from "../../plugins/mixin-moment"

export default {
  mixins: [mixinMoment],
  props: {
    tasks: {
      type: Array,
    },
  },
  data() {
    return {
        selectedId: "",
    }
  },
  methods: {
    clearID(){
      this.selectedId = ''
    },
  }
}
</script>