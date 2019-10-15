import Vue from 'vue';
import Vuesax from 'vuesax';
import App from './App.vue';
import router from './router';
import store from './store';
import VueResource from 'vue-resource';

import 'vuesax/dist/vuesax.css';
import 'material-icons/iconfont/material-icons.css';

import VTooltip from 'v-tooltip';

Vue.use(Vuesax);
Vue.use(VueResource);
Vue.use(VTooltip);

Vue.config.productionTip = false;

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app');
