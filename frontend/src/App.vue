
<template lang="pug">

  #app
    .parentx-static
      vs-sidebar.sidebar-primaryx(
        static-position=""
        color="primary"
        spacer=""
        v-model="active"
        hidden-background=true
      )
        .header-sidebar(slot="header")
          h4 Environmental Assessment

        vs-sidebar-item(index="1" icon="build")
          router-link(to="/") Home

        vs-sidebar-item(index="2" icon="get_app")
          router-link(to="/proponents") Proponents

        vs-sidebar-item(index="3" icon="get_app")
          router-link(to="accounts-receivable") Accounts Receivable

        vs-sidebar-item(index="4" icon="get_app")
          router-link(to="invoices") Invoices

        vs-sidebar-item(index="5" icon="get_app")
          router-link(to="customer-accounts") Customer Accounts

        vs-sidebar-item(index="6" icon="get_app")
          router-link(to="account-sites") Account Sites

        vs-sidebar-item(index="7" icon="get_app")
          router-link(to="site-contacts") Site Contacts

        vs-sidebar-item(index="8" icon="get_app")
          router-link(to="deposites") Deposits

        vs-sidebar-item(index="9" icon="get_app")
          router-link(to="credit-memos") Credit Memos
          
        vs-sidebar-item(index="10" icon="get_app")
          router-link(to="receipts") Receipts

        vs-sidebar-item(index="11" icon="get_app")
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
  .page
    padding 2rem
    margin-left 16rem

  .vs-sidebar
    background #f4f4f4 !important
    margin-right 1rem !imporant

  .parentx-static
    overflow hidden
    position absolute
    width 20rem
    height 100%

    .sidebar-primaryx
      height 100%

  .header-sidebarx
    display flex
    align-items center
    justify-content center
    flex-direction column
    width 100%
    h4
      display flex
      align-items center
      justify-content center
      width 100%
    button
      margin-left 10px

  .footer-sidebar
    display flex
    align-items center
    justify-content space-between
    width 100%
    button
      border 0px solid rgba(0,0,0,0) !important
      border-left 1px solid rgba(0,0,0,.07) !important
      border-radius 0px !important
  #app
    font-family 'Avenir', Helvetica, Arial, sans-serif
    -webkit-font-smoothing antialiased
    -moz-osx-font-smoothing grayscale
    text-align center
    color #2c3e50

  #nav
    padding 30px
    a
      font-weight bold
      color #2c3e50
      &.router-link-exact-active
        color #42b983
</style>
