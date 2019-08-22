
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

          vs-sidebar-item(index="1" icon="build" class="page-home")
            router-link(to="/") Home

          vs-sidebar-item(index="2" icon="get_app" class="page-proponents")
            router-link(to="/proponents") Proponents

          vs-sidebar-item(index="3" icon="get_app" class="page-accounts-receivable")
            router-link(to="accounts-receivable") Accounts Receivable

          vs-sidebar-item(index="4" icon="get_app" class="page-invoices")
            router-link(to="invoices") Invoices

          vs-sidebar-item(index="5" icon="get_app" class="page-customer-accounts")
            router-link(to="customer-accounts") Customer Accounts

          vs-sidebar-item(index="6" icon="get_app" class="page-account-sites")
            router-link(to="account-sites") Account Sites

          vs-sidebar-item(index="7" icon="get_app" class="page-site-contacts")
            router-link(to="site-contacts") Site Contacts

          vs-sidebar-item(index="8" icon="get_app" class="page-deposits")
            router-link(to="deposits") Deposits

          vs-sidebar-item(index="9" icon="get_app" class="page-credit-memos")
            router-link(to="credit-memos") Credit Memos
            
          vs-sidebar-item(index="10" icon="get_app" class="page-receipts")
            router-link(to="receipts") Receipts

          vs-sidebar-item(index="11" icon="get_app" class="page-adjustments")
            router-link(to="adjustments") Adjustments 
    .page
      keep-alive
        transition(name="fade", mode="out-in")
          router-view

</template>

<script>
export default {
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
    transition: margin-left 0.3s linear
    -o-transition: margin-left 0.3s linear
    -moz-transition: margin-left 0.3s linear
    -webkit-transition: margin-left 0.3s linear

    .vs-sidebar--items
      border-top-style solid 
      border-color orange
      border-width 4px


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
