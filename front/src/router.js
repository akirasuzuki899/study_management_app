import Vue from 'vue';
import Router from 'vue-router';
import store from './store';

import Home from './views/Home.vue';
import Register from './views/Register.vue';
import Login from './views/Login.vue';
import StudyMaterials from './views/StudyMaterials.vue';
import StudyNotes from './views/StudyNotes.vue';

import NewStudyNotes from './components/StudyNotes/NewStudyNotes.vue';
import IndexStudyNotes from './components/StudyNotes/IndexStudyNotes.vue';
import ShowStudyNote from './components/StudyNotes/ShowStudyNote.vue';
import EditStudyNote from './components/StudyNotes/EditStudyNote.vue';

import IndexStudyMaterials from './components/StudyMaterials/IndexStudyMaterials.vue';
import SearchStudyMaterials from './components/StudyMaterials/SearchStudyMaterials.vue';

import Calendar from './components/Calendar/Calendar.vue';


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
      },
      children: [
        // { path: "new", component: NewStudyNotes },
        { path: "index", component: IndexStudyMaterials },
        { path: "search", component: SearchStudyMaterials },
        // { path: ":id", component: ShowStudyNote, props: true},
        // { path: ":id/edit", component: EditStudyNote, props: true},
      ]
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
      },
      children: [
        { path: "new", component: NewStudyNotes },
        { path: "index", component: IndexStudyNotes },
        { path: ":id", component: ShowStudyNote, props: true},
        { path: ":id/edit", component: EditStudyNote, props: true},
      ]
    },
    {
      path: '/calendar', 
      component: Calendar,
    }
  ]
});