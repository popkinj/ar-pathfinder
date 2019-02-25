import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    env: location.port == 8081 ? "developmnet" : "production"
  },
  mutations: {

  },
  actions: {

  },
})
