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
        .header(v-else) Accounts

        MoreOptions(
          v-if='$store.getters.activeProponent.name'
          :options='$store.getters.accounts'
          :currentOption='$store.getters.activeAccount'
          :saveNewOption='saveNewAccount',
          optionName='account_description'
          optionKey='account_number'
          type='account'
        )
      .site(v-if='$store.getters.activeSite.site_name')
        vs-divider
        .site_name(
          contenteditable='true'
          @input='saveSiteChange'
        ) {{$store.getters.activeSite.site_name}}
        .address_line_1 {{$store.getters.activeSite.address_line_1}}
        .address_line_2 {{$store.getters.activeSite.address_line_2}}
        .address_line_3 {{$store.getters.activeSite.address_line_3}}
        span.city {{$store.getters.activeSite.city}}, 
        span.province {{$store.getters.activeSite.province}}
        .postal_code {{$store.getters.activeSite.postal_code}}

    .contacts.card
      vs-table(
        stripe
        v-if='$store.getters.contacts.length > 0'
        :data="$store.getters.contacts"
      )
        template(slot='thead')
          vs-th Name
          vs-th Phone
          vs-th Email
        template
          vs-tr(:key="indextr" v-for="(tr,indextr) in $store.getters.contacts")
            vs-td {{tr.full_name}}
            vs-td {{tr.phone_number}}
            vs-td {{tr.email_address}}
      .header(v-else) Contacts

    .invoices.card
      .header Invoices


</template>

<script>
/* eslint-disable */
// Components..  @ is an alias to /src
import GetToken from '@/components/GetToken.vue';
import MoreOptions from '@/components/MoreOptions.vue';

// Dependencies
import request from 'request';

const connect = function () {

  // Listen to state changes
  this.$store.subscribe((mutation) => {
    switch (mutation.type) {
      case 'activeProponent':
        this.$store.commit('clearAccounts');
        this.$store.commit('loadAccounts',mutation.payload);
        break;
      case 'activeAccount':
        this.$store.commit('clearSites');
        this.$store.commit('loadSites',mutation.payload)
        break;
      case 'activeSite':
        this.$store.commit('loadContacts',mutation.payload)
        break;
    }
  });

  /* Listen to events
   * The 'MoreOptions' component emits 'option-selected' when an option
   * is selected. Commit the appropriate mutation depending on the
   * option type
   */
  this.$root.$on('option-selected', function (option,type) {
    switch (type) {
      case 'account':
        this.$store.commit('activeAccount',option);
        break;
    }
  });
};

/* ## saveNewAccount
  Save a new account to CAS
  @param value {string} The new account name
 */
const saveNewAccount = function (value) {
  const token = this.$store.getters.token;
  const proponent = this.$store.getters.activeProponent.proponent_number;
  const server = this.$store.getters.serverUrl;
  const url = `${server}/api/parties/${proponent}/accs/?token=${token}`;
  const data = {"account_description": value, "proponent": proponent};

  const v = this; // Save 
  request.post({
    url: url,
    json: true,
    body: data,
  }, function (err,res,body) {
    if (err) {
      v.$root.$emit('new-option-failed','account'); // Emit this when Failed
    } else {
      v.$store.commit('addAccount', body);
      v.$root.$emit('new-option-saved','account'); // Emit this when saved
    }
  });
}

const saveSiteChange = function (value) {
  console.log('text: ',value.target.innerText);
  console.log('class: ',value.target.className);
}

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
    saveNewAccount,
    saveSiteChange
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
      display flex
      align-items center
      font-size 20px

  .site .site_name
    font-size 1.1rem
    margin-bottom 0.2rem

form
  margin-top 3rem
li
  width: 5rem
  margin 1rem
</style>
