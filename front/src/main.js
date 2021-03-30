import Vue from 'vue'
import App from './App.vue'
import axios from "axios";
import store from "./store";
import router from "./router"

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
new Vue({
  store,
  router, 
  render: h => h(App),
}).$mount('#app')
