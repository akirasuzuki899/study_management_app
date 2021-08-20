export const state = () => ({
  studyNotes: [],
  studyNote: {
    id: '',
    user_id: '',
    title: '',
    study_material_id: '',
    rich_text: '',
    created_at: '',
    updated_at: '',
  },
  treeView: []
})

export const getters = {
  studyNotes: state => state.studyNotes,
  treeView: state => state.treeView,
};

export const mutations = {
  setStudyNotes(state, study_note) {
    state.studyNotes = study_note
  },
  addStudyNote(state, study_note) {
    state.studyNotes.push(study_note)
  },
  updateStudyNote(state, study_note) {
    const index = state.studyNotes.findIndex((v) => v.id === study_note.id);
    state.studyNotes.splice(index, 1, study_note)
  },
  destroyStudyNote(state, study_note) {
    const index = state.studyNotes.findIndex((v) => v.id === study_note.id);
    state.studyNotes.splice(index, 1)
  },
  setTreeView(state, tree_view) {
    state.treeView = tree_view
  }
};
export const actions = {
  getStudyNotes( { commit } ) {
    this.$axios
      .get('/api/v1/study_notes')
      .then(({ data }) => {
        console.log("success")
        console.log(data)
        commit("setStudyNotes", data.study_notes)
        commit("setTreeView", data.tree_view)
      });
  },
  createStudyNote( { commit, dispatch } , { formData } ) {
    dispatch("snackbar/processMessage", '作成しています...', { root: true })
    this.$axios
      .post(
        '/api/v1/study_notes',
        {
          title: formData.title,
          study_material_id: formData.study_material_id,
          rich_text: formData.rich_text
        })
      .then(({ data }) => {
        console.log("success")
        console.log("createStudyNote")
        console.log(data)
        commit("addStudyNote", data.study_note)
        dispatch("snackbar/successMessage", '作成しました', { root: true })
      })
      .catch(error => {
        console.log("error");
        console.log("createStudyNote")
        console.log(error.response);
      })
  },
  updateStudyNote( { commit, dispatch }, { selectedNoteID, formData } )  {
    dispatch("snackbar/processMessage", '更新しています...', { root: true })
    this.$axios
      .put(
        '/api/v1/study_notes/' + selectedNoteID,
        {
          title: formData.title,
          study_material_id: formData.study_material_id,
          rich_text: formData.rich_text
        })
      .then(( { data } ) => {
        console.log("success")
        console.log(data.study_note)
        commit("updateStudyNote", data.study_note)
        dispatch("snackbar/successMessage", '更新しました', { root: true })
      })
      .catch(error => {
        console.log(error);
      })
  },
  deleteStudyNote( { commit, dispatch }, { selectedNoteID } ) {
    dispatch("snackbar/processMessage", '削除しています...', { root: true })
    this.$axios
      .delete('/api/v1/study_notes/' + selectedNoteID)
      .then(({ data }) => {
        console.log("success")
        console.log(data.study_note)
        console.log(selectedNoteID)
        commit("destroyStudyNote", data.study_note)
        dispatch("snackbar/successMessage", '削除しました', { root: true })
      })
      .catch( error => {
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