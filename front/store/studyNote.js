export const state = () => ({
  studyNotes: [],
  studyNote: {
    id: '',
    user_id: '',
    title: '',
    noteable_id: '',
    rich_text: '',
    created_at: '',
    updated_at: '',
  },
  treeView: []
})

export const getters = {
  treeView: state => state.treeView,
};

export const mutations = {
  setTreeView(state, tree_view) {
    state.treeView = tree_view
  },
  addStudyNote(state, study_note) {
    const index = state.treeView.findIndex((v) => v.id === study_note.noteable_id)
    state.treeView[index].children.push(study_note)
  },
  updateStudyNote(state, { study_note, old_note }) {
    const old_index = state.treeView.findIndex((v) => v.id === old_note.noteable_id)
    const id = state.treeView[old_index].children.findIndex((v) => v.id === old_note.id)
    state.treeView[old_index].children.splice(id, 1)

    const new_index = state.treeView.findIndex((v) => v.id === study_note.noteable_id)
    state.treeView[new_index].children.push(study_note)
  },
  destroyStudyNote(state, study_note) {
    const index = state.treeView.findIndex((v) => v.id === study_note.noteable_id)
    const id = state.treeView[index].children.findIndex((v) => v.id === study_note.id)
    state.treeView[index].children.splice(id, 1)
    
  }
};
export const actions = {
  getStudyNotes( { commit } ) {
    this.$axios
      .get('/api/v1/study_materials/study_notes')
      .then(({ data }) => {
        console.log("success")
        console.log(data)
        commit("setTreeView", data.tree_view)
      });
  },
  createStudyNote( { commit, dispatch } , { formData } ) {
    dispatch("snackbar/processMessage", '作成しています...', { root: true })
    this.$axios
      .post(
        `/api/v1/study_materials/${formData.noteable_id}/study_notes`,
        {
          title: formData.title,
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
          noteable_id: formData.noteable_id,
          rich_text: formData.rich_text
        })
      .then(( { data } ) => {
        console.log("success")
        console.log(data)
        commit("updateStudyNote", {study_note: data.study_note, old_note: data.old_note } )
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