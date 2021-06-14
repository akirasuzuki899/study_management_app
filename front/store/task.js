import { normalize, schema } from 'normalizr';

const user = new schema.Entity('users');
const study_record = new schema.Entity('studyRecords');
const study_material = new schema.Entity('studyMaterials');
const task = new schema.Entity('tasks', {
  user: user,
  study_material: study_material,
  study_record: study_record,
});


export const state = () => ({
  tasks: [],
  task: {
    id: '',
    user_id: '',
    study_material_id: '',
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
  tasks: state => state.tasks
};

export const mutations = {
  setTasks(state, data) {
    state.tasks = data.tasks;
    console.log("state")
    console.log(state.tasks)
  },
  addTask(state, data) {
    state.tasks.push(data.task)
  },
  updateTask(state, data) {
    const index = state.tasks.findIndex((v) => v.id === data.task.id);
    console.log(data)
    state.tasks.splice(index, 1, data.task)
  },
  destroyTask(state, data) {
    console.log("tasks")
    console.log(state.tasks)
    
    console.log("data")
    console.log(data)

    const index = state.tasks.findIndex((v) => v.id === data.task.id);
    console.log("index")
    console.log(index)
    state.tasks.splice(index, 1)
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
        console.log(data.tasks)
        const normalizedData = normalize(data.tasks, [task]);
        console.log("normalizedData")
        console.log(normalizedData)
        commit("setTasks", data)
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
        const normalizedData = normalize(data.task, task);
        console.log("normalizedData")
        console.log(normalizedData)
        // commit("addTask", data)
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
        const normalizedData = normalize(data.task, task);
        console.log("normalizedData")
        console.log(normalizedData)
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
        const normalizedData = normalize(data.task, task);
        console.log("normalizedData")
        console.log(normalizedData)
        commit("destroyTask", data)
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