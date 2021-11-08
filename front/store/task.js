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
  getTasks( { commit }, focus = undefined) {

    const url = focus ? `/api/v1/tasks?focus=${focus}` : "/api/v1/tasks"
    return this.$axios
      .get(url)
      .then(({ data }) => {
        console.log("success")
        console.log(data)
        focus ? commit("addTask", data.tasks) : commit("setTasks", data.tasks)
      });
  },
  createTask( { commit, dispatch } , { formData } ) {
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
        })
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
  updateTask( { commit, dispatch }, { selectedTask, formData } )  {
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
        })
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
  deleteTask( { commit, dispatch }, { selectedTask } ) {
    dispatch("snackbar/processMessage", '削除しています...', { root: true })
    this.$axios
      .delete('/api/v1/tasks/' + selectedTask.id)
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

  createTasksFromTemplates( { commit, dispatch }, { copy_all }){
    dispatch("snackbar/processMessage", '更新しています...', { root: true })
    this.$axios
      .post('/api/v1/tasks/create_from_templates'+ `?copy_all=${copy_all}`, {})
      .then(( { data } ) => {
        console.log("success")
        console.log(data)
        if (data.tasks.length){
          commit("addTask", data.tasks)
          dispatch("snackbar/successMessage", '更新しました', { root: true })
        } else {
          dispatch(
            "snackbar/warningMessage", 
            `${data.message}`, 
            { root: true })
        }
      })
      .catch(error => {
        console.log("error");
        console.log(error.response.data);
      })
  },

  getUnfinishedTask({ commit }, { page }){
    return this.$axios
      .get('/api/v1/tasks/unfinished_tasks?page=' + `${page}`)
      .then(({ data }) => {
        commit("addTask", data.tasks)
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