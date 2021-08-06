export const state = () => ({
  authTokens: {
    'access-token': null,
    "client": null,
    "uid": null,
    "expiry": null,
    "token-type": null,
  },
})

export const getters = {
  authTokens: state => state.authTokens
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
  }
}
export const actions = {
  login({ commit }, authData) {
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
        localStorage.setItem( "access-token", response.headers['access-token']);
        localStorage.setItem( "client", response.headers['client']);
        localStorage.setItem( "uid", response.headers['uid']);
        localStorage.setItem( "expiry", response.headers['expiry']);
        localStorage.setItem( "token-type", response.headers['token-type']);
        console.log(response);
        this.$router.push("/");
      })
      .catch(error => {
        console.log(error);
      });
  },
  logout({ commit }) {
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
    localStorage.removeItem("access-token");
    localStorage.removeItem("client");
    localStorage.removeItem("uid");
    localStorage.removeItem("expiry");
    localStorage.removeItem("token-type");
    router.replace('/login');
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
        console.log(response);
        this.$router.push('/');
      })
      .catch(error => {
        console.log(error);
      });
  }
}