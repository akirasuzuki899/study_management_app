import Vue from 'vue';
import Vuex from 'vuex';
import axios from "axios";
import router from '../router'

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    authTokens: {
      'access-token': null,
      "client": null,
      "uid": null,
      "expiry": null,
      "token-type": null,
    }
  },
  getters: {
    authTokens: state => state.authTokens
  },
  mutations: {
    updateAuthTokens(state, authTokens) {
      state.authTokens = {
        "access-token": authTokens['access-token'],
        "client": authTokens['client'],
        "uid": authTokens['uid'],
        "expiry": authTokens['expiry'],
        "token-type": authTokens['token-type'],
      };
    }
  },
  actions: {
    autoLogin({ commit }) {
      const authTokens = {
        'access-token': localStorage.getItem('access-token'),
        "client": localStorage.getItem('client'),
        "uid": localStorage.getItem('uid'),
        "expiry": localStorage.getItem('expiry'),
        "token-type": localStorage.getItem('token-type'),
      };
      // if (!authTokens) return;
      commit('updateAuthTokens', authTokens);
    },
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
          commit('updateAuthTokens', response.headers);
          localStorage.setItem( "access-token", response.headers['access-token']);
          localStorage.setItem( "client", response.headers['client']);
          localStorage.setItem( "uid", response.headers['uid']);
          localStorage.setItem( "expiry", response.headers['expiry']);
          localStorage.setItem( "token-type", response.headers['token-type']);
          console.log(response);
          router.push('/');
        })
        .catch(error => {
          console.log(error);
        });
    },
    logout({ commit }) {
      commit(
        'updateAuthTokens', 
        {
          'access-token': null,
          "client": null,
          "uid": null,
          "expiry": null,
          "token-type": null,
        }
      );
      localStorage.removeItem("access-token");
      localStorage.removeItem("client");
      localStorage.removeItem("uid");
      localStorage.removeItem("expiry");
      localStorage.removeItem("token-type");
      router.replace('/login');
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
          commit('updateAuthTokens', response.headers);
          console.log(response);
          router.push('/');
        })
        .catch(error => {
          console.log(error);
        });
    }
  }
});