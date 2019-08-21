import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    token: false,
    env: location.port == 8081 ? "development" : "production",
    search: '',
    proponents: {},
    activeProponent: {
      name: '',
      number: '',
      businessNumber: ''
    }
  },
  mutations: {
    loadProponents (state,proponents) {
      state.proponents = proponents;
    },
    loadToken (state, newToken) {
      state.token = newToken;
    },
    clearToken (state) {
      state.token = false;
    },
    updateSearch (state,search) {
      state.search = search;
    }
  },
  getters: {
    token: state => {
      return state.token;
    },
    search: state => {
      return state.search
    },
    proponents: state => {
      return state.proponents;
    },
    apiUrl: state => {
      return state.env === 'production' ? '/api' : '/api/dev'
    },
    serverUrl: state => {
      return state.env === 'production' ?
        location.origin :
        'http://localhost:8080' // Different port in dev
    }
  },
  actions: {

  },
})
