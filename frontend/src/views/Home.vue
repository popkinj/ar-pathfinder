<template lang="pug">
div
  .header
    h2 Invoicing Pathfinder
    h3(v-if='$store.getters.activeProponent.name')
      | Accounts for <i>{{$store.getters.activeProponent.name}}</i>

    GetToken

  vs-divider


  .content
    .account.card
      .header
        span.name(v-if='$store.getters.activeAccount.account_description')
          | {{$store.getters.activeAccount.account_description}}
        MoreOptions(
          :options='$store.getters.accounts'
          v-if='$store.getters.activeProponent.name'
        )
      vs-divider
      .site(v-if='$store.getters.activeSite')
        .site-name {{$store.getters.activeSite.site_name}}
        .site-address1 {{$store.getters.activeSite.address_line_1}}
        .site-address2 {{$store.getters.activeSite.address_line_2}}
        .site-address3 {{$store.getters.activeSite.address_line_3}}
        span.site-city {{$store.getters.activeSite.city}}, 
        span.site-province {{$store.getters.activeSite.province}}
        .site-postal-code {{$store.getters.activeSite.postal_code}}

    .contacts.card
      vs-table(stripe :data="$store.getters.contacts")
        template(slot='thead')
          vs-th Name
          vs-th Phone
          vs-th Email
        template
          vs-tr(:key="indextr" v-for="(tr,indextr) in $store.getters.contacts")
            vs-td {{tr.full_name}}
            vs-td {{tr.phone_number}}
            vs-td {{tr.email_address}}

    .invoices.card
      .header Invoices


</template>

<script>
// @ is an alias to /src
import GetToken from '@/components/GetToken.vue';
import MoreOptions from '@/components/MoreOptions.vue';

const connect = function () {
  this.$store.subscribe((mutation) => {
    switch (mutation.type) {
      case 'activeProponent':
        this.$store.commit('loadAccounts',mutation.payload);
        break;
      case 'activeAccount':
        this.$store.commit('loadSites',mutation.payload)
        break;
      case 'activeSite':
        this.$store.commit('loadContacts',mutation.payload)
        break;
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
    GetToken,
    MoreOptions
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
  grid-template-columns 30% 70%

  .invoices
    grid-column-start 1
    grid-column-end 3

  .card
    background white
    height 20rem
    padding 1rem
    margin 1rem
    font-size 14px
    box-shadow 3px 3px 3px #cfcfcf
    border-radius 5px
    border-style solid
    border-width 1px
    border-color #d9d9d9

    .header
      font-size 20px

form
  margin-top 3rem
li
  width: 5rem
  margin 1rem
</style>
