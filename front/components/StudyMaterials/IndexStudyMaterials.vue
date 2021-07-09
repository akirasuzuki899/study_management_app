<template>
  <v-card
    class="mx-auto"
  >
    <v-card-title>
      教材一覧
    </v-card-title>
    <v-card-text>
      <v-list
        :dense="true"
        :subheader="true"
        max-height="300"
        class="overflow-y-auto"
      >
        <template v-for="(item, index) in studyMaterials">

          <StudyMaterial
            :key="`material-${item.id}`"
            :studyMaterial="item"
            :index="index"
          >
            <template v-slot:btn="{studyMaterial}">
              <v-btn
                text
                @click="toggleCompleteStatus({
                  authTokens: authTokens,
                  studyMaterial: studyMaterial,
                  index: index,
                })"
              >
                {{ studyMaterial.is_completed ? '完了' : '学習中' }}
              </v-btn>
            </template>
          </StudyMaterial>

          <v-divider
            v-if="index < studyMaterials.length - 1"
            :key="`index-${index}`"
          ></v-divider>
        </template>
      </v-list>
    </v-card-text>
  </v-card>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import StudyMaterial from './StudyMaterial'

export default {
  components: {
    StudyMaterial,
  },
  computed: {
    ...mapGetters('studyMaterial',['studyMaterials']),
    ...mapGetters(['authTokens']),
  },
  methods: {
    ...mapActions('studyMaterial',['toggleCompleteStatus', 'getStudyMaterials']),
  },
  created() {
    this.getStudyMaterials(this.authTokens)
  }
}
</script>