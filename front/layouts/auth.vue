<template>
  <v-app dark>
    <v-container fluid>
      <nuxt />
    </v-container>
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