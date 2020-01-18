
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
            h5 Accounts Recievable

          .active-proponent(v-if='$store.getters.activeProponent.name')
            | {{$store.getters.activeProponent.name}}

          .search
            ProponentSearch
            ProponentList

          vs-sidebar-item(
            index="1"
            icon="home"
            class="page-home"
            ref="homeButton"
          )
            router-link(to="/") Home

          vs-sidebar-item(
            index="2"
            icon="library_books"
            class="page-invoices"
          )
            router-link(
              to="/invoices"
              ref="invoicesButton"
            ) Invoices

          vs-sidebar-item(
            index="3" 
            icon="people_outline" 
            class="page-proponents"
          )
            router-link(to="/proponents") All Proponents - Testing

    .page
      keep-alive
        transition(name="fade", mode="out-in")
          router-view

</template>

<script>
import ProponentSearch from "@/components/ProponentSearch.vue";
import ProponentList from "@/components/ProponentList.vue"

const connect = function () {
  console.log("mounted");
  // Listen to state changes
  this.$store.subscribe((mutation) => {
    switch (mutation.type) {
      case 'activeProponent':
        this.$store.commit('clearAccounts');
        this.$store.commit('loadAccounts',mutation.payload);
        break;
      case 'activeAccount':
        this.$store.commit('clearSites');
        this.$store.commit('loadSites',mutation.payload);
        break;
      case 'activeSite':
        this.$store.commit('loadContacts',mutation.payload);
        this.$store.commit('loadInvoices',mutation.payload);
        break;
    }
  });
};

export default {
  components: {
    ProponentSearch,
    ProponentList
  },
  mounted: connect,
  data:()=>({
    active:true
  })
}

/*TODO: Logic for flagging button as active for which ever
  page you're on */
  
</script>

<style lang=stylus>
// Colours
background = #036

.sidebar
  header
    background background
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
      padding-top 0
      border-top-style solid 
      border-color orange
      border-width 4px

    .vs-sidebar--item:hover
      background #fafafa

  .active-proponent
    color white
    background #71d468
    text-align center
    overflow hidden
    white-space nowrap 
    text-overflow ellipsis
    font-weight bolder
    font-size 20px
    padding 0.5rem 0.5rem 0.5rem 0.5rem
    

  .search
    margin 1.5rem 0.75rem 0.75rem 0.75rem


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
 * Custom tooltip styling
 * Styling copied from [here](https://github.com/Akryum/v-tooltip#style-examples).
 */
.tooltip .tooltip-inner {
  background: background;
  color: white;
  border-radius: 16px;
  padding: 5px 10px 4px;
}

.tooltip .tooltip-arrow {
  width: 0;
  height: 0;
  border-style: solid;
  position: absolute;
  margin: 5px;
  border-color: background;
  z-index: 1;
}

.tooltip[x-placement^="top"] {
  margin-bottom: 5px;
}

.tooltip[x-placement^="top"] .tooltip-arrow {
  border-width: 5px 5px 0 5px;
  border-left-color: transparent !important;
  border-right-color: transparent !important;
  border-bottom-color: transparent !important;
  bottom: -5px;
  left: calc(50% - 5px);
  margin-top: 0;
  margin-bottom: 0;
}

.tooltip[x-placement^="bottom"] {
  margin-top: 5px;
}

</style>
