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
    }
 ]
})

/* For each change of the Vue router */
router.beforeEach((to,from,next) => {
  document.title = to.meta.title // Set the page title
  next();
});

export default router;