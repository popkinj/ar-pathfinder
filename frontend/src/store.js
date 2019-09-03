import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    token: false,
    env: location.port == 8081 ? "development" : "production",
    search: '',
    proponentsCas: {},
    proponents: [],
    focusProponents: [],
    activeProponent: null
  },
  mutations: {
    loadProponents (state,proponents) { // Load all propnents
      state.proponents = proponents;
    },
    clearFocusProponents (state) {
      state.focusProponents = [];
    },
    focusProponents (state,text) { // Filter proponents by match
      const findRegex = new RegExp(text,'i'); // Ignore case
      state.focusProponents = state.proponents.filter((d) => {
        if (text.length < 1) { // If no text
          return false
        } else {
          return findRegex.test(d.name); // Else check match
        }
      });
    },
    activeProponent (state,proponent) {
      state.activeProponent = proponent;
    },
    clearActiveProponent (state) {
      state.activeProponent = null;

    },
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
    focusProponents: state => {
      return state.focusProponents;
    },
    activeProponent: state => {
      return state.activeProponent;
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
