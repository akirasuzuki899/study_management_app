import Vue from 'vue';
import Router from 'vue-router';
import Home from './views/Home.vue'
import Register from './views/Register.vue'
import Login from './views/Login.vue'

import StudyMaterials from './views/StudyMaterials.vue'

Vue.use(Router);

export default new Router({
  routes: [
    {path: '/', component: Home},
    {path: '/login', component: Login},
    {path: '/register', component: Register},
    {path: '/studymaterials', component: StudyMaterials}]
});