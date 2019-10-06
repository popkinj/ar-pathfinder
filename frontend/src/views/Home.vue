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

    .fees.card
      h4 Contacts

    .contacts.card
      h4 Invoices


</template>

<script>
// @ is an alias to /src
import GetToken from '@/components/GetToken.vue';

export default {
  name: 'home',
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
