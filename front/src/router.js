import Vue from 'vue';
import Router from 'vue-router';
import Home from './views/Home.vue'
import Register from './views/Register.vue'
import Login from './views/Login.vue'
import store from './store'

import StudyMaterials from './views/StudyMaterials.vue'
import StudyNotes from './views/StudyNotes.vue'

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: '/', 
      component: Home,
      beforeEnter(to, from, next){
        if (store.getters.authTokens['access-token']) {
          next();
        } else {
          next('/login');
        }
      }
    },
    {
      path: '/login', 
      component: Login,
      beforeEnter(to, from, next){
        if (store.getters.authTokens['access-token']) {
          next('/');
        } else {
          next();
        }
      }
    },
    {
      path: '/register', 
      component: Register,
      beforeEnter(to, from, next){
        if (store.getters.authTokens['access-token']) {
          next('/');
        } else {
          next();
        }
      }
    },
    {
      path: '/studymaterials', 
      component: StudyMaterials,
      beforeEnter(to, from, next){
        if (store.getters.authTokens['access-token']) {
          next();
        } else {
          next('/login');
        }
      }
    },
    {
      path: '/studynotes', 
      component: StudyNotes,
      beforeEnter(to, from, next){
        if (store.getters.authTokens['access-token']) {
          next();
        } else {
          next('/login');
        }
      }
    }
  ]
});