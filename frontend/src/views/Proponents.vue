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
        td.name Fetch all Proponents
      tr.tester
        td.action
          vs-button(
            :disabled="$store.getters.token ? false : true"
            id="button-with-loading2"
            class="vs-con-loading__container"
            @click="openLoadingContained2"
            type="filled"
            ref="loadableButton2"
            vslor="primary")
              | Search
        td.action
          vs-input(
            :disabled="$store.getters.token ? false : true"
            class="inputx"
            label-placeholder="Enter a Name"
            @input="updateSearch"
          )
        td.name Search Proponents
    #proponents
      vs-table
        template(slot="thead")
          vs-th Name
          vs-th Proponent Number
          vs-th Business Number
        template
          vs-tr(:key="indextr" v-for="(tr,indextr) in $store.getters.proponents.items")
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
        const apiUrl = this.$store.getters.apiUrl;
        const token = this.$store.getters.token;
        const serverUrl = this.$store.getters.serverUrl;
        const url = `${serverUrl}${apiUrl}/proponents?token=${token}`;

        request(url, {json: true}, function (err,res,proponents) {
          console.log("body: ",proponents);
          if (err) {
            return console.error("Could not get data",err);
          }
          v.$store.commit('loadProponents', proponents)
          v.$vs.loading.close('#button-with-loading .con-vs-loading');
        });
      },
      openLoadingContained2(){
        this.$vs.loading({
          background: this.backgroundLoading,
          color: this.colorLoading,
          container: '#button-with-loading2',
          scale: 0.45
        });
        console.log(this.$store.getters.search);
        setTimeout( () => {
          this.$vs.loading.close('#button-with-loading2 .con-vs-loading');
        },2000);
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
