<template lang="pug">
  div.proponents
    h2 Proponents
    GetToken
    table
      tr.tester
        td.action
          vs-button(
            :disabled="$store.getters.token ? false : true"
            id="button-with-loading"
            class="vs-con-loading__container"
            @click="getAllProponents"
            type="filled"
            ref="loadableButton"
            vslor="primary")
              | Load
        td.name Fetch Proponents directly from the CAS API
    #proponents
      vs-table(stripe)
        template(slot="thead")
          vs-th Name
          vs-th Proponent Number
          vs-th Business Number
        template
          vs-tr(:key="indextr" v-for="(tr,indextr) in $store.getters.proponentsCas.items")
            vs-td {{tr.customer_name}}
            vs-td {{tr.party_number}}
            vs-td {{tr.business_number}}

      //- div(v-for="item in $store.getters.proponents.items") {{item.customer_name}}
</template>

<script>
  import GetToken from '@/components/GetToken.vue';
  import request from 'request';

  export default {
    data() {
      return {
      }
    },
    components: {
      GetToken
    },
    methods: {
      updateSearch(search){
        this.$store.commit('updateSearch',search)
      },
      getAllProponents(){
        const v = this
        v.$vs.loading({
          background: this.backgroundLoading,
          color: this.colorLoading,
          container: '#button-with-loading',
          scale: 0.45
        });
        // Formalate the url for the api call
        const token = this.$store.getters.token;
        const serverUrl = this.$store.getters.serverUrl;
        const url = `${serverUrl}/api/parties?token=${token}`;

        request(url, {json: true}, function (err,res,proponents) {
          if (err) {
            return console.error("Could not get data",err);
          }
          v.$store.commit('loadProponentsCas', proponents)
          v.$vs.loading.close('#button-with-loading .con-vs-loading');
        });
      }
    }
  }
</script>

<style lang="stylus">
  td
    padding 0.5rem
    text-align left

    button 
      width 5rem
  .vs-con-input-label
    margin-top 0.25rem !important
  .default-input
    .inputx
      margin 10px

  #get-token-btn
    position absolute
    right 2rem
    top 2rem

  #proponents
    text-align left
    margin-top 2rem

  .not-data-table
    display none
</style>
