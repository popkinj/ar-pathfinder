<template lang="pug">
  div.proponents
    h2 Proponents
    GetToken
    .tester
      .name Fetch all Proponents
      .action
        vs-button(
          :disabled="$store.getters.token ? false : true"
          id="button-with-loading"
          class="vs-con-loading__container"
          @click="getAllProponents"
          type="filled"
          ref="loadableButton"
          vslor="primary")
            | Load
    .tester
      .name Search Proponents
      .action
        vs-input(
          :disabled="$store.getters.token ? false : true"
          class="inputx"
          label-placeholder="Enter a Name"
          v-model="value1"
        )
      .action
        vs-button(
          :disabled="$store.getters.token ? false : true"
          id="button-with-loading2"
          class="vs-con-loading__container"
          @click="openLoadingContained2"
          type="filled"
          ref="loadableButton2"
          vslor="primary")
            | Search
</template>

<script>
  import GetToken from '@/components/GetToken.vue';
  import request from 'request';

  export default {
    data() {
      return {
        value1:'',
        value2:''
      }
    },
    components: {
      GetToken
    },
    methods: {
      getAllProponents(){
        const vs = this.$vs
        vs.loading({
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

        request(url, function (err,res,body) {
          console.log(JSON.parse(JSON.parse(body)));
          // console.log(JSON.parse(JSON.parse(body)));
          vs.loading.close('#button-with-loading .con-vs-loading');
        });
      },
      openLoadingContained2(){
        this.$vs.loading({
          background: this.backgroundLoading,
          color: this.colorLoading,
          container: '#button-with-loading2',
          scale: 0.45
        });
        setTimeout( () => {
          this.$vs.loading.close('#button-with-loading2 .con-vs-loading');
        },2000);
      }

    }
  }
</script>

<style lang="stylus">
  .vs-con-input-label
    margin-top 0.25rem !important
  .default-input
    .inputx
      margin 10px

  #get-token-btn
    position absolute
    right 2rem
    top 2rem
</style>
