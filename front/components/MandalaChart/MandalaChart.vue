<template>
  <v-sheet
    height="100%"
    class="pa-6"
  >
    <v-card-actions>
      <v-btn 
        @click="toggleUnfinishedTaskList"
        outlined
        text
      >
        <v-icon>
          mdi-delete-outline
        </v-icon>
      </v-btn>
    </v-card-actions>

    <v-card
      class="d-flex flex-wrap"
      outlined
      tile
    >
      <MandalaChartGroup
        style="width: calc(100%/3);"
      ></MandalaChartGroup>
      <MandalaChartGroup
        style="width: calc(100%/3);"
      ></MandalaChartGroup>
      <MandalaChartGroup
        style="width: calc(100%/3);"
      ></MandalaChartGroup>
      <MandalaChartGroup
        style="width: calc(100%/3);"
      ></MandalaChartGroup>
      <MandalaChartGroup
        style="width: calc(100%/3);"
      ></MandalaChartGroup>
      <MandalaChartGroup
        style="width: calc(100%/3);"
      ></MandalaChartGroup>
      <MandalaChartGroup
        style="width: calc(100%/3);"
      ></MandalaChartGroup>
      <MandalaChartGroup
        style="width: calc(100%/3);"
      ></MandalaChartGroup>
      <MandalaChartGroup
        style="width: calc(100%/3);"
      ></MandalaChartGroup>
    </v-card>
  </v-sheet>
</template>

<script>
import MandalaChartGroup from "./MandalaChartGroup.vue"

export default {
  components: {
    MandalaChartGroup,
  },
  data: () => ({
    
  }),
}
</script>