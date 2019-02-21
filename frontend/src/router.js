import Vue from 'vue'
import Router from 'vue-router'
import Home from './views/Home.vue'

Vue.use(Router)


  // beforeEach: changeTitle,
var router = new Router({
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home,
      meta:{
        title: 'AR Pathfinder',
        description: 'The home page of the AR Pathfinder'
      }
    },
    {
      path: '/proponents',
      name: 'proponents',
      // route level code-splitting
      // this generates a separate chunk (about.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: () => import('./views/Proponents.vue'),
      meta: {title: 'AR Proponents'}
    },
    {
      path: '/accounts-receivable',
      name: 'accounts-receivable',
      component: () => import('./views/AccountsReceivable.vue'),
      meta: {title: 'AR Accounts Receivable'}
    },
    {
      path: '/invoices',
      name: 'invoices',
      component: () => import('./views/Invoices.vue'),
      meta: {title: 'AR Invoices'}
    },
    {
      path: '/customer-accounts',
      name: 'customer-accounts',
      component: () => import('./views/CustomerAccounts.vue'),
      meta: {title: 'AR Customer Accounts'}
    },
    {
      path: '/account-sites',
      name: 'account sites',
      component: () => import('./views/AccountSites.vue'),
      meta: {title: 'AR Account Sites'}
    },
    {
      path: '/site-contacts',
      name: 'site contacts',
      component: () => import('./views/SiteContacts.vue'),
      meta: {title: 'AR Site Contacts'}
    },
    {
      path: '/deposits',
      name: 'deposits',
      component: () => import('./views/Deposits.vue'),
      meta: {title: 'AR Deposits'}
    },
    {
      path: '/credit-memos',
      name: 'credit memos',
      component: () => import('./views/CreditMemos.vue'),
      meta: {title: 'AR Credit Memos'}
    },
    {
      path: '/receipts',
      name: 'receipts',
      component: () => import('./views/Receipts.vue'),
      meta: {title: 'AR Receipts'}
    },
    {
      path: '/adjustments',
      name: 'adjustments',
      component: () => import('./views/Adjustments.vue'),
      meta: {title: 'AR Adjustments'}
    }




 ]
})

var historyCount = 0;

/* For each change of the Vue router */
router.beforeEach((to,from,next) => {
  document.title = to.meta.title // Set the page title

  if ( ++historyCount === 2) {
    var item = document.querySelector("div.page-" + from.name);
    item.classList.remove('vs-sidebar-item-active');
  }

  next();
});

router.afterEach((to,from) => {
  if (!from.name) { // This is the first render
    var item = document.querySelector("div.page-" + to.name);
    item.classList.add('vs-sidebar-item-active');
  }
})

export default router;
