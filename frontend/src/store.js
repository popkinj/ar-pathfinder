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
    activeProponent: {}, // The currently selected proponent
    accounts: [], // All accounts
    activeAccount: {}, // Currently selected account
    sites: [], // The list of proponent sites
    activeSite: {}, // The currently selected site
    contacts: []
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
        try { // If this is a valid items array
          state.accounts = res.body.items;

          // Default behaviour is to activate the first account
          this.commit('activeAccount', res.body.items[0]);
        } catch (error) { // If no items array we got an error
          const msg = `Could not obtain accounts for ${proponent.name}`;
          this._vm.$vs.notify({color:'danger',title: 'Error',text:msg});
          return console.error(msg);
        }

      });
    },
    activeAccount (state,account) {
      state.activeAccount = account;
    },
    clearAccounts (state) {
      state.accounts = [];
      state.activeAccount = {};
      state.sites = [];
      state.activeSite = {};
      state.contacts = [];
    },
    loadSites (state,proponent) {
      // Formalate the url for the api call
      const party = proponent.party_number;
      const token = this.getters.token;
      const serverUrl = this.getters.serverUrl;
      const account = this.getters.activeAccount.account_number;
      const url = `${serverUrl}/api/parties/${party}/accs/${account}/sites/?token=${token}`;
      console.log("url: ",url);

      request(url, {json:true}, (err,res) => {
        if (err) {return console.error("Could not load accounts!")}
        try { // If this is a valid items array
          state.sites = res.body.items;

          // Default behaviour is to activate the first account
          if (res.body.items.length > 0) { // Only if there is one.
            this.commit('activeSite', res.body.items[0]);
          }
        } catch (error) { // If no items array we got an error
          const msg = `Could not obtain sites for account ${account}`;
          this._vm.$vs.notify({color:'danger',title: 'Error',text:msg});
          return console.error(msg);
        }

      });
    },
    activeSite (state,site) {
      state.activeSite = site;
    },
    clearSites (state) {
      state.sites = [];
      state.activeSite = {};
      state.contacts = [];
    },
    loadContacts (state,place) {
      // Formalate the url for the api call
      const site = place.site_number;
      const token = this.getters.token;
      const serverUrl = this.getters.serverUrl;
      const party = this.getters.activeProponent.proponent_number;
      const account = this.getters.activeAccount.account_number;
      const url = `${serverUrl}/api/parties/${party}/accs/${account}/sites/${site}/conts/?token=${token}`;

      request(url, {json:true}, (err,res) => {
        if (err) {return console.error("Could not load accounts!")}
        try { // If this is a valid items array
          state.contacts = res.body.items;
        } catch (error) { // If no items array we got an error
          const msg = `Could not obtain sites contacts for account ${account}`;
          this._vm.$vs.notify({color:'danger',title: 'Error',text:msg});
          return console.error(msg);
        }
      });
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
    sites: state => {
      return state.sites;
    },
    activeSite: state => {
      return state.activeSite;
    },
    contacts: state => {
      return state.contacts;
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
