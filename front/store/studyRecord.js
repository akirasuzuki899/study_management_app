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

};

export const action = {

}