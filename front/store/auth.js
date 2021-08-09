export const state = () => ({
  authTokens: {
    'access-token': null,
    "client": null,
    "uid": null,
    "expiry": null,
    "token-type": null,
  },
  authenticated: false,
})

export const getters = {
  authTokens: state => state.authTokens,
  authenticated: state => state.authenticated,
}

export const mutations = {
  updateAuthTokens(state, authTokens) {
    state.authTokens = {
      "access-token": authTokens['access-token'],
      "client": authTokens['client'],
      "uid": authTokens['uid'],
      "expiry": authTokens['expiry'],
      "token-type": authTokens['token-type'],
    };
  },
  userLogin(state){
    state.authenticated = true
  },
  userLogout(state){
    state.authenticated = false
  },
}
export const actions = {
  autoLogin({ commit }){  //初回読み込み時に実行する(リロード含む)
    const token  = localStorage.getItem('access-token')
    const expiry = localStorage.getItem('expiry')
    const now = new Date().getTime();
    const isExpired = now >= expiry * 1000

    if (!token) return;
    if (isExpired) {
      localStorage.removeItem("access-token");
      localStorage.removeItem("client");
      localStorage.removeItem("uid");
      localStorage.removeItem("expiry");
      localStorage.removeItem("token-type");
      return
    } else {
      commit('userLogin')
      const expiredIn = expiry * 1000 - now
      setTimeout(() => {
        localStorage.removeItem("access-token");
        localStorage.removeItem("client");
        localStorage.removeItem("uid");
        localStorage.removeItem("expiry");
        localStorage.removeItem("token-type");
        commit('userLogout')
        console.log("token expired")
      }, expiredIn)
    }

    commit('userLogin')
  },
  login({ commit , state}, authData) {
    this.$axios
      .post(
        '/api/v1/auth/sign_in',
        {
          email: authData.email,
          password: authData.password,
        }
      )
      .then(response => {
        commit('updateAuthTokens', response.headers);
        commit('userLogin');
        localStorage.setItem( "access-token", response.headers['access-token']);
        localStorage.setItem( "client", response.headers['client']);
        localStorage.setItem( "uid", response.headers['uid']);
        localStorage.setItem( "expiry", response.headers['expiry']);
        localStorage.setItem( "token-type", response.headers['token-type']);
        this.$router.push("/");
      })
      .catch(error => {
        console.log(error);
      });
  },
  logout({ commit }) {
    this.$axios
    .delete('/api/v1/auth/sign_out')
    .then(response => {
      commit(
        'updateAuthTokens', 
        {
          'access-token': null,
          "client": null,
          "uid": null,
          "expiry": null,
          "token-type": null,
        }
      );
      commit('userLogout');
      localStorage.removeItem("access-token");
      localStorage.removeItem("client");
      localStorage.removeItem("uid");
      localStorage.removeItem("expiry");
      localStorage.removeItem("token-type");
      this.$router.push('/login');
      })
      .catch(error => {
        console.log(error);
      });
  },
  register({ commit }, authData) {
    this.$axios
      .post(
        '/api/v1/auth',
        {
          name: authData.name,
          email: authData.email,
          password: authData.password,
        }
      )
      .then(response => {
        commit('updateAuthTokens', response.headers);
        commit('userLogin');
        localStorage.setItem( "access-token", response.headers['access-token']);
        localStorage.setItem( "client", response.headers['client']);
        localStorage.setItem( "uid", response.headers['uid']);
        localStorage.setItem( "expiry", response.headers['expiry']);
        localStorage.setItem( "token-type", response.headers['token-type']);
        this.$router.push('/');
      })
      .catch(error => {
        console.log(error);
      });
  }
}