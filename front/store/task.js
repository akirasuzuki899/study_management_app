import moment from 'moment'

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
    color: '',
  }
})

export const getters = {
  tasks: state => state.tasks,
  unfinished_tasks: state => state.tasks.filter((task) => task.study_record.is_finished === false && moment(task.start).isBefore(moment(), 'day') )
};

export const mutations = {
  setTasks(state, tasks) {
    state.tasks = tasks;
  },
  addTask(state, task) {
    const tmpArray = []
    if (Array.isArray(task)) {
      tmpArray.push(...state.tasks, ...task)
    } else {
      tmpArray.push(...state.tasks, task)
    }

    const uniqueArray = tmpArray.reduce((a, v) => {
      if (!a.some((e) => e.id === v.id)) {
        a.push(v);
      }
      return a;
    }, []);

    state.tasks = uniqueArray

  },
  updateTask(state, task) {
    const index = state.tasks.findIndex((v) => v.id === task.id);
    state.tasks.splice(index, 1, task)
  },
  dragUpdate(state, {dragEvent, data}) {
    const index = state.tasks.findIndex((v) => v.id === dragEvent.id)
    state.tasks[index].start = data.start
    state.tasks[index].end = data.end
  },
  destroyTask(state, task) {
    const index = state.tasks.findIndex((v) => v.id === task.id);
    state.tasks.splice(index, 1)
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
        commit("updateTask", data.task)
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
        console.log(selectedTask)
        commit("destroyTask", data.task)
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

  getUnfinishedTask({ commit }, {authTokens, page}){
    return this.$axios
      .get('/api/v1/tasks/unfinished_tasks?page=' + `${page}`, {
        headers: authTokens
      })
      .then(({ data }) => {
        commit("addTask", data.tasks)
        console.log("data actions")
        console.log(data)
        return data
      })
  }
};

export default {
  state,
  getters,
  mutations,
  actions,
}