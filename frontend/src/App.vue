
<template lang="pug">

  #app
    .parentx-static
      .sidebar
        vs-sidebar.sidebar-primaryx(
          color="primary"
          v-model="active"
          hidden-background=true
        )
          .header-sidebar(slot="header")
            h4 Environmental Assessment Office
            hr
            h5 Accounts Recievable Explorer

          .search
            ProponentSearch


          vs-sidebar-item(index="1" icon="home" class="page-home")
            router-link(to="/") Home

          vs-sidebar-item(index="2" icon="people_outline" class="page-proponents")
            router-link(to="/proponents") All Proponents - Testing

          vs-sidebar-item(index="3" icon="attach_money" class="page-fees")
            router-link(to="/fees") Fees

          vs-sidebar-item(index="4" icon="library_books" class="page-invoices")
            router-link(to="/invoices") Invoices

          vs-sidebar-item(index="5" icon="trending_up" class="page-revenue-report")
            router-link(to="/revenue-report") Revenue Report

          vs-sidebar-item(index="6" icon="vertical_split" class="page-gl-detail-report")
            router-link(to="/gl-detail-report") GL Detail Report
    .page
      keep-alive
        transition(name="fade", mode="out-in")
          router-view

</template>

<script>
import ProponentSearch from "@/components/ProponentsSearch.vue";

export default {
  components: {
    ProponentSearch
  },
  data:()=>({
    active:true
  })
}

/*TODO: Logic for flagging button as active for which ever
  page you're on */
  
</script>

<style lang=stylus>
.sidebar
  header
    background #036
    color white
    background-image url("/bcgov-header-vert-MD.png")
    background-repeat no-repeat
    height 4.6rem
    hr
      margin 3px 3px 3px 0px
  
    div
      margin-top 0
      /* font-size 12px */
      margin-left 4rem
  .vs-sidebar
    max-width 240px
    transition: margin-left 0.3s linear
    -o-transition: margin-left 0.3s linear
    -moz-transition: margin-left 0.3s linear
    -webkit-transition: margin-left 0.3s linear

    .vs-sidebar--items
      border-top-style solid 
      border-color orange
      border-width 4px

  .search
    margin 0.75rem


  .parentx-static
    overflow hidden
    position absolute
    width 14rem
    height 100%

    .sidebar-primaryx
      height 100%

.page
  padding 2rem
  margin-left 16rem


#app
  font-family 'Avenir', Helvetica, Arial, sans-serif
  -webkit-font-smoothing antialiased
  -moz-osx-font-smoothing grayscale
  /* text-align center */
  color #2c3e50
/* 
#nav
  padding 30px
  a
    font-weight bold
    color #2c3e50
    &.router-link-exact-active
      color #42b983 */
</style>
