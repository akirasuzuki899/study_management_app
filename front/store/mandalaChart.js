export const state = () => ({
  mandala_charts: []
})

export const getters = {
  mandala_charts: state => state.mandala_charts,
}

export const mutations = {
  setMandalaCharts(state, mandala_charts){

    const sortedMandalaCharts = mandala_charts.map(function(mandala_chart){

        //グループの place_number でソート
        mandala_chart.mandala_groups.sort(function(a,b){
          return a.place_number - b.place_number
        })

        //アイテムの place_number でソート
        mandala_chart.mandala_groups.map(
          mandala_group => {
            mandala_group.mandala_items.sort(function(a,b){
              return a.place_number - b.place_number
            })
          }
        )

        return mandala_chart
      }
    )

    state.mandala_charts = sortedMandalaCharts
  },
  // sortMandalaCharts(state){
  // },
  destroyMandalaChart(state, mandala_chart) {
    const index = state.mandala_charts.findIndex((v) => v.id === mandala_chart.id);
    state.mandala_charts.splice(index, 1)
  },
}
export const actions = {
  getMandalaCharts( { commit }, authTokens ){
    this.$axios
    .get('/api/v1/mandala_charts', {
      headers: authTokens
    })
    .then(({ data }) => {
      console.log("success")
      console.log(data)
      commit("setMandalaCharts", data.mandala_charts)
    })
    .catch(error => {
      console.log(error);
    })
  },
  deleteMandalaChart( { commit, dispatch }, { authTokens, selectedMandalaChart } ) {
    dispatch("snackbar/processMessage", '削除しています...', { root: true })
    this.$axios
      .delete(
        '/api/v1/mandala_charts/' + 10,
        {
          headers: authTokens
        }
      )
      .then(({ data }) => {
        console.log("success")
        commit("destroyMandalaChart", data.mandala_chart)
        dispatch("snackbar/successMessage", '削除しました', { root: true })
      })
      .catch( error => {
        console.log(error);
      })
  },
}

export default {
  state,
  getters,
  mutations,
  actions,
}