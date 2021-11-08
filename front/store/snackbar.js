export const state = () => ({
  isOpen: false,
  text: '',
  color: '',
  timeOut: -1,
})
export const getters = {
  isOpen: state => state.isOpen,
  text: state => state.text,
  color: state => state.color,
  timeOut: state => state.timeOut,
};
export const mutations = {
  setStatus (state, boolean) {
    state.isOpen = boolean
  },
  setText (state, text){
    state.text = text
  },
  setColor (state, color){
    state.color = color
  },
  setTimeOut (state, timeOut){
    state.timeOut = timeOut
  },

};
export const actions = {
  close({ commit }){
    commit("setStatus", false)
  },
  processMessage({ commit }, text) {
    commit("setStatus", true)
    commit("setColor", '')
    commit("setText", text)
    commit("setTimeOut", -1)
  },
  successMessage({ commit }, text ) {
    commit("setStatus", true)
    commit("setColor", 'success')
    commit("setText", text)
    commit("setTimeOut", 5000)
  },
  errorMessage({ commit }, text ){
    commit("setStatus", true)
    commit("setColor", 'error')
    commit("setText", text)
    commit("setTimeOut", -1)
  },
  warningMessage({ commit }, text ){
    commit("setStatus", true)
    commit("setColor", 'warning')
    commit("setText", text)
    commit("setTimeOut", 5000)
  },
};
