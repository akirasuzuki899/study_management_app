import axios from "axios";

const state = {
  taskTemplates: [],
  taskTemplate: {
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
  taskTemplates: state => state.taskTemplates
};

const mutations = {
  setTaskTemplates(state, data) {
    state.taskTemplates = data.task_templates;
  },
  addTaskTemplate(state, data) {
    state.taskTemplates.push(data.task_template)
  },
  updateTaskTemplate(state, data) {
    const index = state.taskTemplates.findIndex((v) => v.id === data.task_template.id);
    console.log(data)
    state.taskTemplates.splice(index, 1, data.task_template)
  },
  destroyTaskTemplate(state, data) {
    console.log("taskTemplates")
    console.log(state.taskTemplates)
    
    console.log("data")
    console.log(data)

    const index = state.taskTemplates.findIndex((v) => v.id === data.task_template.id);
    console.log("index")
    console.log(index)
    state.taskTemplates.splice(index, 1)
  }
};

const actions = {
  getTaskTemplates( { commit }, authTokens ) {
    axios
      .get('/api/v1/task_templates', {
        headers: authTokens
      })
      .then(({ data }) => {
        commit("setTaskTemplates", data)
      });
  },
  createTaskTemplate( { commit } , { authTokens, formData} ) {
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
        commit("addTaskTemplate", data)
      })
      .catch(error => {
        console.log(error);
      })
  },
  updateTaskTemplate( { commit }, { authTokens, selectedTask, formData } )  {
    axios
      .put(
        '/api/v1/task_templates/' + selectedTask.id,
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
        commit("updateTaskTemplate", data)
      })
      .catch(error => {
        console.log(error);
      })
  },
  deleteTaskTemplate( { commit }, { authTokens, selectedTask } ) {
    axios
      .delete(
        '/api/v1/task_templates/' + selectedTask.id,
        {
          headers: authTokens
        }
      )
      .then(({ data }) => {
        commit("destroyTaskTemplate", data)
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