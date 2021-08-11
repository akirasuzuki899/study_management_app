<template>
  <v-app dark>
    <v-main
      class="d-flex align-center"
    >
      <v-container
        style="max-width:500px" 
        class="mx-auto"
      >
        <nuxt />
        <Snackbar
        ></Snackbar>
      </v-container>
    </v-main>
    <v-footer
      app
    >
      <span>&copy; {{ new Date().getFullYear() }}</span>
    </v-footer>
  </v-app>
</template>

<script>
export default {
  name: 'auth',
  middleware({ store, redirect }) {
    if (store.state.auth.authenticated) {
      return redirect('/')
    }
  },
}
</script>