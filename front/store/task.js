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
  addTask(state, task) {
    if (Array.isArray(task)) {
      state.tasks.push(...task)
    } else {
      state.tasks.push(task)
    }
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
  createTask( { commit, dispatch } , { authTokens, formData} ) {
    dispatch("snackbar/processMessage", '作成しています...', { root: true })
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
        commit("addTask", data.task)
        dispatch("snackbar/successMessage", '作成しました', { root: true })
      })
      .catch(error => {
        console.log("error");
        console.log(error);
      })
  },
  updateTask( { commit, dispatch }, { authTokens, selectedTask, formData } )  {
    dispatch("snackbar/processMessage", '更新しています...', { root: true })
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
        dispatch("snackbar/successMessage", '更新しました', { root: true })
      })
      .catch(error => {
        console.log(error);
      })
  },
  deleteTask( { commit, dispatch }, { authTokens, selectedTask } ) {
    dispatch("snackbar/processMessage", '削除しています...', { root: true })
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
        dispatch("snackbar/successMessage", '削除しました', { root: true })
      })
      .catch( error => {
        console.log(error);
      })
  },

  createTasksFromTemplates( { commit, dispatch }, { authTokens, copy_all }){
    dispatch("snackbar/processMessage", '更新しています...', { root: true })
    this.$axios
      .post(
        '/api/v1/tasks/create_from_templates'+ `?copy_all=${copy_all}`, {},
        {
          headers: authTokens
        }
        )
        .then(( { data } ) => {
          console.log("success")
          console.log(data)
          commit("addTask", data.tasks)
          dispatch("snackbar/successMessage", '更新しました', { root: true })
        })
        .catch(error => {
          console.log("error");
          console.log(error.response.data);
          dispatch(
            "snackbar/errorMessage", 
            `更新に失敗しました。${error.response.data.message}`, 
            { root: true })
        })
  },
  updateUnfinishedTask( { commit, dispatch, state }, { authTokens, selectedTask, formData } )  {
    dispatch("snackbar/processMessage", '更新しています...', { root: true })
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
        if(state.tasks.some(task => task.id === data.task.id)){
          commit("updateTask", data)
        } else {
          commit("addTask", data)
        }
        commit("destroyUnfinishedTask", data)
        dispatch("snackbar/successMessage", '更新しました', { root: true })
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