import moment from 'moment'

export const state = () => ({
  taskTemplates: [],
  taskTemplate: {
    id: '',
    user_id: '',
    name: '',
    start: '',
    end: '',
    day_of_week: '',
    created_at: '',
    updated_at: '',
    prev_week_sunday_task: '',
    color: '',
  }
});

export const getters = {
  taskTemplates: state => state.taskTemplates
};

export const mutations = {
  setTaskTemplates(state, data) {
    const task_templates = data.task_templates
    const prev_week_sunday_tasks = task_templates.reduce( function(result, task) {
      if ( task.day_of_week == "日" ){
        result.push(task.prev_week_sunday_task);
      }
      return result;
    },[]);

    task_templates.push(...prev_week_sunday_tasks)

    state.taskTemplates = task_templates;
  },
  addTaskTemplate(state, data) {
    const task_templates = [data.task_template]
    if(task_templates[0].day_of_week == "日"){
      task_templates.push(task_templates[0].prev_week_sunday_task)
    }
    state.taskTemplates.push(...task_templates)
  },
  updateTaskTemplate(state, data) {
    const task_templates = [data.task_template]
    if (task_templates[0].day_of_week == "日"){
      task_templates.push(task_templates[0].prev_week_sunday_task);
    }

    const state_tasks = state.taskTemplates.filter( state_task => 
      state_task.id !== task_templates[0].id 
    )

    task_templates.push(...state_tasks)

    state.taskTemplates = task_templates
  },
  dragUpdate(state, {dragEvent, data}) {
    if (dragEvent.day_of_week == "日"){
      const index_sundayTask = state.taskTemplates.findIndex((v) => v.id === dragEvent.id && v.dummy === false)
      const index_dummy = state.taskTemplates.findIndex((v) => v.id === dragEvent.id && v.dummy === true)
      if(dragEvent.dummy == true){
          state.taskTemplates[index_sundayTask].start = moment(data.start).add(7, 'days').format('YYYY-MM-DD HH:mm')
          state.taskTemplates[index_sundayTask].end = moment(data.end).add(7, 'days').format('YYYY-MM-DD HH:mm')
          state.taskTemplates[index_dummy].start = data.start
          state.taskTemplates[index_dummy].end = data.end

      } else {
        state.taskTemplates[index_sundayTask].start = data.start
        state.taskTemplates[index_sundayTask].end = data.end
        state.taskTemplates[index_dummy].start = moment(data.start).add(-7, 'days').format('YYYY-MM-DD HH:mm')
        state.taskTemplates[index_dummy].end = moment(data.end).add(-7, 'days').format('YYYY-MM-DD HH:mm')
      }
    } 
    else {
      const index = state.taskTemplates.findIndex((v) => v.id === dragEvent.id)
      state.taskTemplates[index].start = data.start
      state.taskTemplates[index].end = data.end
    }
  },
  destroyTaskTemplate(state, data) {
    const state_tasks = state.taskTemplates.filter( state_task => 
      state_task.id !== data.task_template.id 
    )
    state.taskTemplates = state_tasks
  }
};

export const actions = {
  getTaskTemplates( { commit } ) {
    this.$axios
      .get('/api/v1/task_templates')
      .then(({ data }) => {
        console.log(data)
        commit("setTaskTemplates", data)
      });
  },
  createTaskTemplate( { commit, dispatch } , { formData } ) {
    dispatch("snackbar/processMessage", '作成しています...', { root: true })
    this.$axios
      .post(
        '/api/v1/task_templates',
        {
          name: formData.name,
          study_material_id: formData.study_material_id,
          start_date: formData.start_date,
          start_time: formData.start_time,
          end_time: formData.end_time,
          color: formData.color,
          text: formData.text
        })
      .then(( { data } ) => {
        console.log(" res data")
        console.log(data)
        commit("addTaskTemplate", data)
        dispatch("snackbar/successMessage", '作成しました', { root: true })
      })
      .catch(error => {
        console.log(error);
      })
  },
  updateTaskTemplate( { commit, dispatch }, { selectedTask, formData } )  {
    dispatch("snackbar/processMessage", '更新しています...', { root: true })
    console.log("送信前")
    console.log(formData)
    this.$axios
    .put(
      '/api/v1/task_templates/' + selectedTask.id,
      {
        name: formData.name,
        study_material_id: formData.study_material_id,
        start_date: formData.start_date == '2000-01-02' ?  '2000-01-09' : formData.start_date,  //ダミーtemplateをtemplateに変換
        start_time: formData.start_time,
        end_time: formData.end_time,
        color: formData.color,
        text: formData.text
      })
      .then(( { data } ) => {
        console.log("送信後")
        console.log(data.task_template)
        commit("updateTaskTemplate", data)
        dispatch("snackbar/successMessage", '更新しました', { root: true })
      })
      .catch(error => {
        console.log(error);
      })
  },
  deleteTaskTemplate( { commit, dispatch }, { selectedTask } ) {
    dispatch("snackbar/processMessage", '削除しています...', { root: true })
    this.$axios
      .delete('/api/v1/task_templates/' + selectedTask.id)
      .then(({ data }) => {
        commit("destroyTaskTemplate", data)
        dispatch("snackbar/successMessage", '削除しました', { root: true })
      })
      .catch( error => {
        console.log(error);
      })
  }
};