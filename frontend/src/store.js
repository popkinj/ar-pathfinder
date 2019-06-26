import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    token: false,
    env: location.port == 8081 ? "development" : "production",
    serverUrl: location.port == 8081 ? 'http://localhost:8080' : location.origin
  },
  mutations: {
    loadToken (state, newToken) {
      state.token = newToken;
    },
    clearToken (state) {
      state.token = false;
    }
  },
  getters: {
    token: state => {
      return state.token;
    }
  },
  actions: {

  },
})
