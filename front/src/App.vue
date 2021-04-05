<template>
  <div id="app">
    <nav>
      <template v-if="isAuthenticated">
        <router-link to="/" class="header-item">Home</router-link>
        <router-link to="studymaterials" class="header-item">StudyMaterials</router-link>
        <router-link to="studynotes" class="header-item">StudyNotes</router-link>
        <span class="header-item" @click="logout">logout</span>
        
      </template>
      <template v-if="!isAuthenticated">
        <router-link to="login" class="header-item">Login</router-link>
        <router-link to="register" class="header-item">Register</router-link>
      </template>
    </nav>
    <router-view></router-view>
  </div>
</template>

<script>
import axios from "axios";
export default {
  name: 'App',
  computed: {
    isAuthenticated() {
      return this.$store.getters.authTokens['access-token'] !== null;
    }
  },
  methods: {
    logout() {
      this.$store.dispatch('logout');
      axios
      .delete('/api/v1/auth/sign_out',
      {
        // "uid": this.$store.state["uid"],
        // "access-token": this.$store.state["access-token"],
        // "client": this.$store.state["client"],
        headers: this.authTokens
      })
      .then(response => {
        console.log(response);
      })
      .catch(error => {
        console.log(error);
      })
    }
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
.header-item {
  margin-right: 10px;
  cursor: pointer;
}
</style>

