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
  setCompleteStatus(state, { study_material, index }) {
    state.studyMaterials[index].is_completed = study_material.is_completed
  },
  addStudyMaterials(state, study_material) {
    const tmpArray = []
    if (Array.isArray(study_material)) {
      tmpArray.push(...state.studyMaterials, ...study_material)
    } else {
      tmpArray.push(...state.studyMaterials, study_material)
    }

    const uniqueArray = tmpArray.reduce((a, v) => {
      if (!a.some((e) => e.id === v.id)) {
        a.push(v);
      }
      return a;
    }, []);

    state.studyMaterials = uniqueArray

  }
};

export const actions = {
  getStudyMaterials( { commit }, {authTokens, page} ) {
    return this.$axios
      .get('/api/v1/study_materials?page=' + `${page}`, {
        headers: authTokens
      })
      .then(({ data }) => {
        commit("addStudyMaterials", data.study_materials)
        return data
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