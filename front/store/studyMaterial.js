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
  setStudyMaterials(state, study_material) {
    state.studyMaterials = study_material
  },
  setCompleteStatus(state, { study_material, index }) {
    state.studyMaterials[index].is_completed = study_material.is_completed
  },
  addStudyMaterials(state, study_material) {
    state.studyMaterials.push(study_material)
  }
};

export const actions = {
  getStudyMaterials( { commit }, authTokens ) {
    return this.$axios
      .get('/api/v1/study_materials', {
        headers: authTokens
      })
      .then(({ data }) => {
        commit("setStudyMaterials", data.study_materials)
      })
  },
  toggleCompleteStatus( { commit }, { authTokens, studyMaterial, index }) {
    this.$axios
      .patch('/api/v1/study_materials/' + studyMaterial.id + '/is_complete',
        {
          is_completed: !studyMaterial.is_completed
        },
        {
          headers: authTokens
        }
      )
      .then(({ data }) => {
        commit("setCompleteStatus", { study_material: data.study_material, index: index })
      })
      .catch(error => {
        console.log(error);
      });
  },
  registerStudyMaterial( { commit },  { authTokens, serchResult }){
    return this.$axios
      .post('/api/v1/study_materials',
      {
        title: serchResult.title,
        rakuten_image_url: serchResult.image_url,
      },
      {
        headers: authTokens
      })
      .then( ({ data }) => {
        commit('addStudyMaterials', data.study_material)
        return data
      })
      .catch( error => {
        console.log(error);
      })
  }
};