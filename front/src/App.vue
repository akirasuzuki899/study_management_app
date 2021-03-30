<template>
  <div id="app">
    <nav>
      <router-link to="/" class="link">Home</router-link>
      <router-link to="register" class="link">Register</router-link>
      <router-link to="login" class="link">Login</router-link>
      <router-link to="studymaterials" class="link">StudyMaterials</router-link>
    </nav>
    <router-view></router-view>
  </div>
</template>

<script>
export default {
  name: 'App',
  components: {

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
.link {
  margin-right: 10px;
}
</style>

