export const state = () => ({
  tasks: [],
  unfinished_tasks: [],
  task: {
    id: '',
    user: '',
    study_material: '',
    study_record: '',
    name: '',
    start: '',
    end: '',
    start_date: '',
    end_date: '',
    start_time: '',
    end_time: '',
    color: '',
  }
})

export const getters = {
  tasks: state => state.tasks,
  unfinished_tasks: state => state.unfinished_tasks
};

export const mutations = {
  setTasks(state, tasks) {
    state.tasks = tasks;
  },
  addTask(state, data) {
    state.tasks.push(data.task)
  },
  updateTask(state, data) {
    const index = state.tasks.findIndex((v) => v.id === data.task.id);
    state.tasks.splice(index, 1, data.task)
  },
  destroyTask(state, data) {
    const index = state.tasks.findIndex((v) => v.id === data.task.id);
    state.tasks.splice(index, 1)
  },
  setUnfinishedTask(state, unfinished_tasks){
    state.unfinished_tasks = unfinished_tasks;
  },
  destroyUnfinishedTask(state, data) {
    const index = state.unfinished_tasks.findIndex((v) => v.id === data.task.id);
    state.unfinished_tasks.splice(index, 1)
  },  
  updateStudyRecord(state, data){
    const index = state.tasks.findIndex((v) => v.id === data.study_record.task_id);
    state.tasks[index].study_record = data.study_record
  }
};

export const actions = {
  getTasks( { commit }, authTokens ) {
    this.$axios
      .get('/api/v1/tasks', {
        headers: authTokens
      })
      .then(({ data }) => {
        console.log("success")
        console.log(data)
        commit("setTasks", data.tasks)
        commit("setUnfinishedTask", data.unfinished_tasks)
      });
  },
  createTask( { commit } , { authTokens, formData} ) {
    this.$axios
      .post(
        '/api/v1/tasks',
        {
          name: formData.name,
          study_material_id: formData.study_material_id,
          start_date: formData.start_date,
          end_date: formData.end_date,
          start_time: formData.start_time,
          end_time: formData.end_time,
          color: formData.color,
        },
        {
          headers: authTokens
        }
      )
      .then(( { data } ) => {
        console.log("success")
        console.log(data.task)
        commit("addTask", data)
      })
      .catch(error => {
        console.log("error");
        console.log(error);
      })
  },
  updateTask( { commit }, { authTokens, selectedTask, formData } )  {
    this.$axios
      .put(
        '/api/v1/tasks/' + selectedTask.id,
        {
          name: formData.name,
          study_material_id: formData.study_material_id,
          start_date: formData.start_date,
          end_date: formData.end_date,
          start_time: formData.start_time,
          end_time: formData.end_time,
          color: formData.color,
        },
        {
          headers: authTokens
        }
      )
      .then(( { data } ) => {
        console.log("success")
        console.log(data.task)
        commit("updateTask", data)
      })
      .catch(error => {
        console.log(error);
      })
  },
  deleteTask( { commit }, { authTokens, selectedTask } ) {
    this.$axios
      .delete(
        '/api/v1/tasks/' + selectedTask.id,
        {
          headers: authTokens
        }
      )
      .then(({ data }) => {
        console.log("success")
        console.log(data.task)
        commit("destroyTask", data)
      })
      .catch( error => {
        console.log(error);
      })
  },
  updateUnfinishedTask( { commit }, { authTokens, selectedTask, formData } )  {
    this.$axios
      .put(
        '/api/v1/tasks/' + selectedTask.id,
        {
          name: formData.name,
          study_material_id: formData.study_material_id,
          start_date: formData.start_date,
          end_date: formData.end_date,
          start_time: formData.start_time,
          end_time: formData.end_time,
          color: formData.color,
        },
        {
          headers: authTokens
        }
      )
      .then(( { data } ) => {
        console.log("success")
        console.log(data.task)
        commit("addTask", data)
        commit("destroyUnfinishedTask", data)
      })
      .catch(error => {
        console.log(error);
      })
  },
};

export default {
  state,
  getters,
  mutations,
  actions,
}