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
      path: '/fees',
      name: 'fees',
      component: () => import('./views/Fees.vue'),
      meta: {title: 'Fees'}
    },
    {
      path: '/invoices',
      name: 'invoices',
      component: () => import('./views/Invoices.vue'),
      meta: {title: 'AR Invoices'}
    },
    {
      path: '/revenue-report',
      name: 'revenue-report',
      component: () => import('./views/RevenueReport.vue'),
      meta: {title: 'Revenue Report'}
    },
    {
      path: '/gl-detail-report',
      name: 'gl-detail-report',
      component: () => import('./views/GLDetailReport.vue'),
      meta: {title: 'GL Detail Report'}
    }
  ]
})

var historyCount = 0;

/* For each change of the Vue router */
router.beforeEach((to,from,next) => {
  document.title = to.meta.title // Set the page title

  // If this is the second render.. ie the first manual
  // page change.. Make sure the button on entry is turned off
  if ( ++historyCount === 2) {
    var item = document.querySelector("div.page-" + from.name);
    item.classList.remove('vs-sidebar-item-active');
  }

  next();
});

router.afterEach((to,from) => {

  // If this is the first render, highlight the current page
  // Oddly enough this isn't the default behaviour.
  if (!from.name) {
    var item = document.querySelector("div.page-" + to.name);
    if (item) { // If at home this doesn't exist
      item.classList.add('vs-sidebar-item-active');
    }
  }
})

export default router;