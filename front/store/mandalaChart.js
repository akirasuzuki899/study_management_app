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
  destroyMandalaChart(state, mandala_chart) {
    const index = state.mandala_charts.findIndex((v) => v.id === mandala_chart.id);
    state.mandala_charts.splice(index, 1)
  },
  updateMandalaItem(state, data){
    const chart_index = state.mandala_charts.findIndex((v) => v.id === data.mandala_item.mandala_group.mandala_chart_id);
    const group_index = state.mandala_charts[chart_index].mandala_groups.findIndex((v) => v.id === data.mandala_item.mandala_group_id);
    const item_index  = state.mandala_charts[chart_index].mandala_groups[group_index].mandala_items.findIndex((v) => v.id === data.mandala_item.id);
    const state_item  = state.mandala_charts[chart_index].mandala_groups[group_index].mandala_items[item_index]

    state_item.text = data.mandala_item.text
    state_item.is_finished = data.mandala_item.is_finished

    if(data.correspond_item){
      const correspond_group_index = state.mandala_charts[chart_index].mandala_groups.findIndex((v) => v.id === data.correspond_item.mandala_group_id);
      const correspond_item_index  = state.mandala_charts[chart_index].mandala_groups[correspond_group_index].mandala_items.findIndex((v) => v.id === data.correspond_item.id);
      const correspond_state_item  = state.mandala_charts[chart_index].mandala_groups[correspond_group_index].mandala_items[correspond_item_index]

      console.log("correspond_group_index")
      console.log(correspond_group_index)
      console.log("correspond_item_index")
      console.log(correspond_item_index)

      correspond_state_item.text = data.correspond_item.text
    }

  }
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
  updateMandalaItem({ commit, dispatch }, { authTokens, selectedMandalaItem, formData }){
    dispatch("snackbar/processMessage", '削除しています...', { root: true })
    this.$axios
      .put(
        '/api/v1/mandala_items/' + selectedMandalaItem.id,
        {
          text: formData.text,
          is_finished: formData.is_finished,
          mandala_group_id: formData.mandala_group_id,
          place_number: formData.place_number,
        },
        {
          headers: authTokens
        }
      )
      .then(({ data }) => {
        console.log("success from update item")
        console.log(data)
        commit("updateMandalaItem", data)
        dispatch("snackbar/successMessage", '更新しました', { root: true })
      })
      .catch( error => {
        console.log(error);
      })
  }
}

export default {
  state,
  getters,
  mutations,
  actions,
}