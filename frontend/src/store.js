import Vue from 'vue';
import Vuex from 'vuex';
import request from 'request';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    token: false,
    env: location.port == 8081 ? "development" : "production",
    search: '',
    proponentsCas: {},
    proponents: [], // All proponents
    focusProponents: [], // The list of proponents matching the search
    activeProponent: null, // The currently selected proponent
    accounts: [],
    activeAccount: {} 
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
    },
    loadAccounts (state,proponent) {
      // Formalate the url for the api call
      const id = proponent.proponent_number;

      const token = this.getters.token;
      const serverUrl = this.getters.serverUrl;
      const url = `${serverUrl}/api/parties/${id}/accs/?token=${token}`;
      request(url, {json:true}, (err,res) => {
        if (err) {return console.error("Could not load accounts!")}
        try {
          console.log(res.body.items);
          state.accounts = res.body.items;
          state.activeAccount = res.body.items[0];
        } catch (error) {
          return console.error("Did not receive valid json for Accounts");
        }

      });
    },
    activeAccount (state,account) {
      state.activeAccount = account;
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
    accounts: state => {
      return state.accounts;
    },
    activeAccount: state => {
      return state.activeAccount;
    },
    proponentsCas: state => {
      return state.proponentsCas;
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
