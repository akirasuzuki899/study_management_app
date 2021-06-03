export const state = () => ({
   studyMaterials: [],
   studyMaterial: {
     id: '',
     user_id: '',
     title: '',
     is_completed: '',
     created_at: '',
     updated_at: '',
   }
})

 export const getters = {
   studyMaterials: state => state.studyMaterials
};

 export const mutations = {
   setStudyMaterials(state, response) {
     state.studyMaterials = response.data.data
   },
   setCompleteStatus(state, {studyMaterial, index}) {
    state.studyMaterials[index].is_completed = !studyMaterial.is_completed
   },
   addStudyMaterials(state, response) {
     state.studyMaterials.push(response.data.data)
   }
};

export const actions = {
  getStudyMaterials( { commit }, authTokens) {
    this.$axios
      .get('/api/v1/study_materials', {
        headers: authTokens
      })
      .then(response => {
        commit("setStudyMaterials", response)
      });
  },
  toggleCompleteStatus( { commit }, { authTokens, studyMaterial, index }) {
    this.$axios
      .patch(
        '/api/v1/study_materials/' + studyMaterial.id + '/is_complete',
        {
          is_completed: !studyMaterial.is_completed
        },
        {
          headers: authTokens
        }
      )
      .then(response => {
        commit("setCompleteStatus", { studyMaterial: studyMaterial, index: index })
        console.log(response);
      })
      .catch(error => {
        console.log(error);
      });
  }
};