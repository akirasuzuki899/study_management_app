<template>
  <v-app dark>
    <v-navigation-drawer
      v-model="drawer"
      :mini-variant="miniVariant"
      fixed
      app
    >
      <v-list>
        <v-list-item
          v-for="(item, i) in items"
          :key="i"
          :to="item.to"
          router
          exact
        >
          <v-list-item-action>
            <v-icon>{{ item.icon }}</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title v-text="item.title" />
          </v-list-item-content>
        </v-list-item>

        <v-list-item @click="logout()">
          <v-list-item-action>
            <v-icon>mdi-logout-variant</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>
              Logout
            </v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
    <v-app-bar
      fixed
      app
    >
      <v-app-bar-nav-icon @click.stop="drawer = !drawer" />
      <v-btn
        icon
        @click.stop="miniVariant = !miniVariant"
      >
        <v-icon>mdi-{{ `chevron-${miniVariant ? 'right' : 'left'}` }}</v-icon>
      </v-btn>
      <!-- <v-toolbar-title v-text="title" /> -->
      <v-spacer />
    </v-app-bar>
    <v-main>
      <v-container fluid class="fill-height">
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
import Snackbar from "../components/Snackbar.vue"

import { mapActions } from "vuex";

export default {
  name: "default",
  middleware({ store, redirect }) {
    if (!store.state.auth.authenticated) {
      return redirect('/login')
    }
  },
  components: {
    Snackbar,
  },
  data () {
    return {
      drawer: false,
      items: [
        {
          icon: 'mdi-home',
          title: 'Home',
          to: '/'
        },
        {
          icon: 'mdi-calendar-month',
          title: 'Schedule',
          to: '/schedule'
        },
        {
          icon: 'mdi-notebook-multiple',
          title: 'Plan',
          to: '/plan'
        },
        {
          icon: 'mdi-chart-bar',
          title: 'Summary',
          to: '/Summary'
        }
      ],
      miniVariant: false,
      title: 'Vuetify.js'
    }
  },
  methods: {
    ...mapActions('auth', ['logout']),
  }
}
</script>

<style>
html {
  overflow-y: auto;
}
</style>