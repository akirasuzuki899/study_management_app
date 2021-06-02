import axios from "axios";

const state = {
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
};

const getters = {
  studyRecords: state => state.studyRecords
}

const mutations = {

};

const action = {

}

export default {
  state,
  getters,
  mutations,
  actions,
}