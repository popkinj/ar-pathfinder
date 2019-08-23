import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    token: false,
    env: location.port == 8081 ? "development" : "production",
    search: '',
    proponentsCas: {},
    activeProponent: {
      name: '',
      number: '',
      businessNumber: ''
    }
  },
  mutations: {
    loadProponentsCas (state,proponentsCas) {
      state.proponentsCas = proponentsCas;
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
    proponentsCas: state => {
      return state.proponentsCas;
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
