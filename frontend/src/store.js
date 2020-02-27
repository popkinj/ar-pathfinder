import Vue from 'vue';
import Vuex from 'vuex';
import request from 'request';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    token: false,
    env: location.port == 8081 ? "development" : "production",
    search: '',
    searchTimer: {abort: () => {}}, // Proponent request to allow aborting
    proponentsCas: {}, // TBD: **Deprecate** selecting proponents directly from CAS
    proponents: [], // All proponents
    focusProponents: [], // The list of proponents matching the search
    activeProponent: {}, // The currently selected proponent
    accounts: [], // All accounts
    activeAccount: {}, // Currently selected account
    sites: [], // The list of proponent sites
    activeSite: {}, // The currently selected site
    contacts: [], // The site contact list
    invoices: [], // List of all invoices
    activeInvoice: {}, // The currently selected invoice
    timers: {} // Hold all state timers
  },
  mutations: {
    addTimer (state, name, timer) {
      state.timers[name] = timer;
    },
    removeTimer (state, name) {
      clearTimeout(state.timers[name]);
    },
    clearFocusProponents (state) {
      state.focusProponents = [];
    },
    focusProponents (state,text) { // Filter proponents by match
      if (text.length < 1) { // If no text... when erasing
        return state.focusProponents = []; // Return zero entries
      }

      // Abort previous request
      state.searchTimer.abort();

      // Formulate url
      const serverUrl = this.getters.serverUrl;
      const url  = `${serverUrl}/proponents?search=${text}`;

      // Request proponents
      state.searchTimer = request(url,{json:true}, (err,res) => {
        if (err) {
          return this._vm.$vs.notify({
            color:'danger',
            title: 'Error',
            text: err
          })
        }
        state.focusProponents = res.body.rows;
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
    addAccount (state,account) {
      state.accounts.push(account);
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
      state.invoices = [];
      state.activeInvoice = {};
    },
    loadSites (state,proponent) {
      // Formalate the url for the api call
      const party = proponent.party_number;
      const token = this.getters.token;
      const serverUrl = this.getters.serverUrl;
      const account = this.getters.activeAccount.account_number;
      const url = `${serverUrl}/api/parties/${party}/accs/${account}/sites/?token=${token}`;

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
    addSite (state,site) {
      state.sites.push(site);
    },
    activeSite (state,site) {
      state.activeSite = site;
    },
    clearSites (state) {
      state.sites = [];
      state.activeSite = {};
      state.contacts = [];
      state.invoices = [];
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
    },
    loadInvoices (state,place) {
      // Formalate the url for the api call
      const site = place.site_number;
      const token = this.getters.token;
      const serverUrl = this.getters.serverUrl;
      const party = this.getters.activeProponent.proponent_number;
      const account = this.getters.activeAccount.account_number;
      const url = `${serverUrl}/api/parties/${party}/accs/${account}/sites/${site}/invs/?token=${token}`;

      request(url, {json:true}, (err,res) => {
        if (err) {return console.error("Could not load invoices!")}
        try { // If this is a valid items array
          state.invoices = res.body.items;
          // console.log(res.body);
        } catch (error) { // If no items array we got an error
          const msg = `Could not obtain site invoices for account ${account}`;
          this._vm.$vs.notify({color:'danger',title: 'Error',text:msg});
          return console.error(msg);
        }
      });
    },
    loadInvoice (state,invoice) {
      // Formalate the url for the api call
      const site = this.getters.activeSite.site_number;
      const token = this.getters.token;
      const serverUrl = this.getters.serverUrl;
      const party = this.getters.activeProponent.proponent_number;
      const account = this.getters.activeAccount.account_number;
      const url = `${serverUrl}/api/parties/${party}/accs/${account}/sites/${site}/invs/${invoice}/?token=${token}`;

      request(url, {json:true}, (err,res) => {
        if (err) {return console.error("Could not load invoice!")}
        try { // If this is a valid items array
          state.activeInvoice = res.body;
        } catch (error) { // If no items array we got an error
          const msg = `Could not obtain site invoice for account ${account}`;
          this._vm.$vs.notify({color:'danger',title: 'Error',text:msg});
          return console.error(msg);
        }
      });
    },
    clearActiveInvoice (state) {
      state.activeInvoice = {};
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
    invoices: state => {
      return state.invoices;
    },
    activeInvoice: state => {
      return state.activeInvoice;
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
