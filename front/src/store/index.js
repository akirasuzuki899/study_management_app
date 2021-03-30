import Vue from 'vue';
import Vuex from 'vuex';
import axios from "axios";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    headers: {
      'access-token': null,
      "client": null,
      "uid": null,
      "expiry": null,
      "token-type": null,
    }
  },
  getters: {
    headers: state => state.headers
  },
  mutations: {
    updateAuthInfo(state, response) {
      state.headers = {
        "access-token": response['headers']['access-token'],
        "client": response['headers']['client'],
        "uid": response['headers']['uid'],
        "expiry": response['headers']['expiry'],
        "token-type": response['headers']['token-type'],
      };
    }, 
    signOut(state) {
      state.headers = null;
    },
  },
  actions: {
    login({ commit }, authData) {
      axios
        .post(
          '/api/v1/auth/sign_in',
          {
            email: authData.email,
            password: authData.password,
          }
        )
        .then(response => {
          commit('updateAuthInfo', response);
          console.log(response);
        })
        .catch(error => {
          console.log(error);
        });
    },
    register({ commit }, authData) {
      axios
        .post(
          '/api/v1/auth',
          {
            name: authData.name,
            email: authData.email,
            password: authData.password,
          }
        )
        .then(response => {
          commit('updateAuthInfo', response);
          console.log(response);
        })
        .catch(error => {
          console.log(error);
        });
    }
  }
});