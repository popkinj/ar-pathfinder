<template lang="pug">
div
  .header
    h2 Invoicing Pathfinder
    h3(v-if='$store.getters.activeProponent')
      | Accounts for <i>{{$store.getters.activeProponent.name}}</i>
    GetToken

  vs-divider


  .content
    .invoices.card
      .header
        span.pre Account: 
        span.name(v-if='$store.getters.activeAccount')
          | {{$store.getters.activeAccount.account_description}}
      vs-divider
      .site(v-if='$store.getters.activeSite')
        .site-header Site:
        .site-name {{$store.getters.activeSite.site_name}}
        .site-address1 {{$store.getters.activeSite.address_line_1}}
        .site-address2 {{$store.getters.activeSite.address_line_2}}
        .site-address3 {{$store.getters.activeSite.address_line_3}}
        span.site-city {{$store.getters.activeSite.city}}, 
        span.site-province {{$store.getters.activeSite.province}}
        .site-postal-code {{$store.getters.activeSite.postal_code}}

    .fees.card
      h4 Contacts

    .contacts.card
      h4 Invoices


</template>

<script>
// @ is an alias to /src
import GetToken from '@/components/GetToken.vue';

const connect = function () {
  this.$store.subscribe((mutation) => {
    switch (mutation.type) {
      case 'activeProponent':
        this.$store.commit('loadAccounts',mutation.payload);
        break;
      case 'activeAccount':
        this.$store.commit('loadSites',mutation.payload)
        break
    }
  });
};

export default {
  name: 'home',
  mounted: connect,
  data() {
    return {
      url:"",
      data:"",
      type:"",
      headers:""
    }
  },
  components: {
    GetToken
  },
  methods: {
  }
}
</script>

<style lang="stylus">
.header h3
  margin-top 0.5rem

#get-token-btn
  position absolute
  right 2rem
  top 2rem

.content
  display grid
  justify-content center
  grid-template-columns 50% 50%

  .contacts
    grid-column-start 1
    grid-column-end 3

  .card
    background white
    height 20rem
    padding 1rem
    margin 1rem
    box-shadow 3px 3px 3px #cfcfcf
    border-radius 5px
    border-style solid
    border-width 1px
    border-color #d9d9d9

form
  margin-top 3rem
li
  width: 5rem
  margin 1rem
</style>
