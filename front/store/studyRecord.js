export const state = () => ({
  studyRecords: [],
  studyRecord: {
    id: '',
    user_id: '',
    task_id: '',
    study_material_id: '',
    start_time: '',
    end_time: '',
    is_finished: '',
    created_at: '',                
    updated_at: '',
  }
})

export const getters = {
  studyRecords: state => state.studyRecords
}

export const mutations = {
  setStudyRecords(state, data) {
    state.studyRecords = data.study_records
    console.log("studyRecords")
    console.log(state.studyRecords)
  },
  addStudyRecords(state, data) {
    state.studyRecords.push(data.study_records)
  },
  updateStudyRecord(state, data){
    const index = state.studyRecords.findIndex((v) => v.id === data.study_records.id);
    // console.log(data)
    state.studyRecords.splice(index, 1, data.study_records)
  }
};

export const actions = {
  getStudyRecords( { commit }, authTokens ){
    this.$axios
      .get('/api/v1/study_records', {
        headers: authTokens
      })
      .then(({ data }) => {
        console.log(data)
        commit("setStudyRecords", data)
      });
  },
  createStudyRecords( { commit }, { authTokens, formData }){
    this.$axios
      .post(
        '/api/v1/study_records',
        {
          task_id: formData.task_id,
          study_material_id: formData.study_material_id,
          start_date: formData.start_date,
          start_time: formData.start_time,
          end_time: formData.end_time,
          is_finished: formData.is_finished,
        },
        {
          headers: authTokens
        }
      )
      .then(( { data } ) => {
        console.log("success")
        console.log(data)
        commit("addStudyRecords", data)
      })
      .catch(error => {
        console.log("error");
        console.log(error);
      })
  },
  updateStudyRecord( { commit }, { authTokens, formData, id } ){
    return this.$axios
      .put(
        '/api/v1/study_records/' + id,
        {
          task_id: formData.task_id,
          study_material_id: formData.study_material_id,
          start_date: formData.start_date,
          start_time: formData.start_time,
          end_time: formData.end_time,
          is_finished: formData.is_finished,
        },
        {
          headers: authTokens
        }
      )
      .then(( { data } ) => {
        commit("updateStudyRecord", data)
        return data
      })
      .catch(error => {
        console.log(error);
      })
  },
}