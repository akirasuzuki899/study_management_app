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
  getStudyMaterials( { commit } ) {
    return this.$axios
      .get('/api/v1/study_materials')
      .then(({ data }) => {
        commit("setStudyMaterials", data.study_materials)
      })
  },
  toggleCompleteStatus( { commit }, { studyMaterial, index }) {
    this.$axios
      .patch('/api/v1/study_materials/' + studyMaterial.id + '/is_complete',
        {
          is_completed: !studyMaterial.is_completed
        })
      .then(({ data }) => {
        commit("setCompleteStatus", { study_material: data.study_material, index: index })
      })
      .catch(error => {
        console.log(error);
      });
  },
  registerStudyMaterial( { commit, dispatch },  { serchResult }){
    dispatch("snackbar/processMessage", '登録しています...', { root: true })
    return this.$axios
      .post('/api/v1/study_materials',
      {
        title: serchResult.title,
        rakuten_image_url: serchResult.image_url,
      })
      .then( ({ data }) => {
        commit('addStudyMaterials', data.study_material)
        dispatch("snackbar/successMessage", '登録しました', { root: true })
        return data
      })
      .catch( error => {
        console.log(error);
      })
  }
};