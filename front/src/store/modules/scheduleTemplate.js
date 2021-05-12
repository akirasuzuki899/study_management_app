import axios from "axios";

const state = {
  scheduleTemplates: [],
  scheduleTemplate: {
    id: '',
    user_id: '',
    name: '',
    start_time: '',
    end_time: '',
    day_of_week: '',
    created_at: '',
    updated_at: '',
  }
};

const getters = {
  scheduleTemplates: state => state.scheduleTemplates
};

const mutations = {
  setScheduleTemplates(state, data) {
    state.scheduleTemplates = data.schedule_templates;
  },
  addScheduleTemplate(state, data) {
    state.scheduleTemplates.push(data.schedule_template)
  },
  updateScheduleTemplate(state, data) {
    const index = state.scheduleTemplates.findIndex((v) => v.id === data.schedule_template.id);
    console.log(data)
    state.scheduleTemplates.splice(index, 1, data.schedule_template)
  },
  destroyScheduleTemplate(state, data) {
    console.log("ScheduleTemplates")
    console.log(state.scheduleTemplates)
    
    console.log("data")
    console.log(data)

    const index = state.scheduleTemplates.findIndex((v) => v.id === data.schedule_template.id);
    console.log("index")
    console.log(index)
    state.scheduleTemplates.splice(index, 1)
  }
};

const actions = {
  getScheduleTemplates( { commit }, authTokens ) {
    axios
      .get('/api/v1/task_templates', {
        headers: authTokens
      })
      .then(({ data }) => {
        commit("setScheduleTemplates", data)
      });
  },
  createScheduleTemplate( { commit } , { authTokens, formData} ) {
    axios
      .post(
        '/api/v1/task_templates',
        {
          name: formData.name,
          study_material_id: formData.study_material_id,
          day_of_week: formData.day_of_week,
          start_time: formData.start_time,
          end_time: formData.end_time
        },
        {
          headers: authTokens
        }
      )
      .then(( { data } ) => {
        commit("addScheduleTemplate", data)
      })
      .catch(error => {
        console.log(error);
      })
  },
  updateScheduleTemplate( { commit }, { authTokens, selectedEvent, formData } )  {
    axios
      .put(
        '/api/v1/task_templates/' + selectedEvent.id,
        {
          name: formData.name,
          study_material_id: formData.study_material_id,
          day_of_week: formData.day_of_week,
          start_time: formData.start_time,
          end_time: formData.end_time
        },
        {
          headers: authTokens
        }
      )
      .then(( { data } ) => {
        commit("updateScheduleTemplate", data)
      })
      .catch(error => {
        console.log(error);
      })
  },
  deleteScheduleTemplate( { commit }, { authTokens, selectedEvent } ) {
    axios
      .delete(
        '/api/v1/task_templates/' + selectedEvent.id,
        {
          headers: authTokens
        }
      )
      .then(({ data }) => {
        commit("destroyScheduleTemplate", data)
      })
      .catch( error => {
        console.log(error);
      })
  }
};

export default {
  state,
  getters,
  mutations,
  actions,
}