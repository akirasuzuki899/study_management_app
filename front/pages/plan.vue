<template>
  <div>
    <SearchStudyMaterials></SearchStudyMaterials>
    <StudyMaterials></StudyMaterials>
  </div>
</template>
  
<script>
import StudyMaterials from "../components/StudyMaterials/IndexStudyMaterials"
import SearchStudyMaterials from "../components/StudyMaterials/SearchStudyMaterials"
export default {
  components: {
    StudyMaterials,
    SearchStudyMaterials,
  }
}
</script>