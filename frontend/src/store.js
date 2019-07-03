import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    token: false,
    env: location.port == 8081 ? "development" : "production"
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
    },
    apiUrl: state => {
      return state.env === 'production' ? '/api' : '/api/dev'
    },
    serverUrl: state => {
      return state.env === 'production' ?
        location.origin :
        'http://localhost:8080'
    }
  },
  actions: {

  },
})
