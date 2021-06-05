export const state = () => ({
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
    prev_week_sunday_task: '',
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
  destroyTaskTemplate(state, data) {
    const state_tasks = state.taskTemplates.filter( state_task => 
      state_task.id !== data.task_template.id 
    )
    state.taskTemplates = state_tasks
  }
};

export const actions = {
  getTaskTemplates( { commit }, authTokens ) {
    this.$axios
      .get('/api/v1/task_templates', {
        headers: authTokens
      })
      .then(({ data }) => {
        console.log(data)
        commit("setTaskTemplates", data)
      });
  },
  createTaskTemplate( { commit } , { authTokens, formData} ) {
    this.$axios
      .post(
        '/api/v1/task_templates',
        {
          name: formData.name,
          study_material_id: formData.study_material_id,
          day_of_week: formData.day_of_week,
          start_time: formData.start_time,
          end_time: formData.end_time,
          is_until_tomorrow: formData.is_until_tomorrow
        },
        {
          headers: authTokens
        }
      )
      .then(( { data } ) => {
        // console.log(data)
        commit("addTaskTemplate", data)
      })
      .catch(error => {
        console.log(error);
      })
  },
  updateTaskTemplate( { commit }, { authTokens, selectedTask, formData } )  {
    this.$axios
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
    this.$axios
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