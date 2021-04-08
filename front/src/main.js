import Vue from 'vue'
import App from './App.vue'
import axios from "axios";
import store from "./store";
import router from "./router"
import "vue-trix";
import vuetify from './plugins/vuetify';

Vue.config.productionTip = false

axios.defaults.baseURL = "http://localhost:3000/";

const interceptorsRequest = axios.interceptors.request.use(
  config => {
    return config;
  },
  error => {
    return Promise.reject(error);
  }
);
const interceptorsResponse = axios.interceptors.response.use(
  response => {
    return response;
  },
  error => {
    return Promise.reject(error);
  }
  );
axios.interceptors.request.eject(interceptorsRequest);
axios.interceptors.response.eject(interceptorsResponse);

store.dispatch('autoLogin');
new Vue({
  store,
  router,
  vuetify,
  render: h => h(App)
}).$mount('#app')