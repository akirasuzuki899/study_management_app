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
      .get('/api/v1/schedule_templates', {
        headers: authTokens
      })
      .then(({ data }) => {
        commit("setScheduleTemplates", data)
      });
  },
  deleteScheduleTemplate( { commit }, { authTokens, selectedEvent } ) {
    axios
      .delete(
        '/api/v1/schedule_templates/' + selectedEvent.id,
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