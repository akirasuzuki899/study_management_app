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
  addStudyNote(state, { study_note, noteable }) {
    const group_index = state.treeView.findIndex((v) => v.id === noteable.mandala_group_id)
    const item_index = state.treeView[group_index].children.findIndex((v) => v.id === noteable.id)
    state.treeView[group_index].children[item_index].children.push(study_note)
  },
  updateStudyNote(state, { study_note, old_note, noteable, old_noteable }) {
    const group_index = state.treeView.findIndex((v) => v.id === noteable.mandala_group_id)
    const item_index  = state.treeView[group_index].children.findIndex((v) => v.id === noteable.id)
    const note_index  = state.treeView[group_index].children[item_index].children.findIndex((v) => v.id === study_note.id)
    
    if ( study_note.noteable_id == old_note.noteable_id ){
      state.treeView[group_index].children[item_index].children.splice(note_index, 1, study_note)
    } else {
      const old_group_index = state.treeView.findIndex((v) => v.id === old_noteable.mandala_group_id)
      const old_item_index  = state.treeView[old_group_index].children.findIndex((v) => v.id === old_noteable.id)
      const old_note_index  = state.treeView[old_group_index].children[old_item_index].children.findIndex((v) => v.id === old_note.id)

      state.treeView[old_group_index].children[old_item_index].children.splice(old_note_index, 1)
      state.treeView[group_index].children[item_index].children.push(study_note)
    }
  },
  destroyStudyNote(state, { study_note, noteable }) {
    const group_index = state.treeView.findIndex((v) => v.id === noteable.mandala_group_id)
    const item_index = state.treeView[group_index].children.findIndex((v) => v.id === noteable.id)
    const note_index = state.treeView[group_index].children[item_index].children.findIndex((v) => v.id === study_note.id)
   
    state.treeView[group_index].children[item_index].children.splice(note_index, 1)
    
  },
  updateTreeViewTitle(state, item){
    const place_number = item.place_number
    const group_index = state.treeView.findIndex((v) => v.id === item.mandala_group_id)
    const item_index  = state.treeView[group_index].children.findIndex((v) => v.id === item.id)

    if (place_number == 5) {
      state.treeView[group_index].title = item.text
      state.treeView[group_index].children[item_index].title = item.text
    } else {
      state.treeView[group_index].children[item_index].title = item.text
    }
  }
};
export const actions = {
  getNotes( { commit } ) {
    this.$axios
      .get('/api/v1/mandala_items/study_notes')
      .then(({ data }) => {
        console.log("success")
        console.log(data)
        commit("setTreeView", data.tree_view)
      });
  },
  createNote( { commit, dispatch } , { formData } ) {
    dispatch("snackbar/processMessage", '作成しています...', { root: true })
    return this.$axios
      .post(
        `/api/v1/mandala_items/${formData.noteable_id}/study_notes`,
        {
          title: formData.title,
          rich_text: formData.rich_text
        })
      .then(({ data }) => {
        console.log("success")
        console.log("createNote")
        console.log(data)
        commit("addStudyNote", { study_note: data.study_note, noteable: data.noteable })
        dispatch("snackbar/successMessage", '作成しました', { root: true })
        return data.study_note.id
      })
      .catch(error => {
        console.log("error");
        console.log("createNote")
        console.log(error.response);
      })
  },
  updateNote( { commit, dispatch }, { selectedNoteID, formData } )  {
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
        commit("updateStudyNote", {
          study_note:   data.study_note, 
          old_note:     data.old_note, 
          noteable:     data.noteable,
          old_noteable: data.old_noteable
        } )
        dispatch("snackbar/successMessage", '更新しました', { root: true })
      })
      .catch(error => {
        console.log(error);
      })
  },
  deleteNote( { commit, dispatch }, { selectedNoteID } ) {
    dispatch("snackbar/processMessage", '削除しています...', { root: true })
    this.$axios
      .delete('/api/v1/study_notes/' + selectedNoteID)
      .then(({ data }) => {
        console.log("success")
        console.log(data.study_note)
        console.log(selectedNoteID)
        commit("destroyStudyNote", {study_note: data.study_note, noteable: data.noteable } )
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