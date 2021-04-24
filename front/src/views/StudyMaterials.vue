<template>
  <v-app>
    <router-view></router-view>
  </v-app>
</template>

<script>
  // import NewStudyMaterials from "../components/StudyMaterials/NewStudyMaterials";
  import IndexStudyMaterials from "../components/StudyMaterials/IndexStudyMaterials";
  // import ShowStudyMaterials from "../components/StudyMaterials/ShowStudyMaterials";
  // import EditStudyMaterials from "../components/StudyMaterials/EditStudyMaterials";

  export default {
    Components: {
      // NewStudyMaterials,
      IndexStudyMaterials,
      // ShowStudyMaterials,
      // EditStudyMaterials,
    }
  }
</script>