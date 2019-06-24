<template lang="pug">
  div.proponents
    h2 Proponents
    GetToken
    .tester
      .name Fetch all Proponents
      .action
        vs-button(
          id="button-with-loading"
          class="vs-con-loading__container"
          @click="openLoadingContained"
          type="filled"
          ref="loadableButton"
          vslor="primary")
            | Load
    .tester
      .name Search Proponents
      .action
        vs-input(
          class="inputx"
          label-placeholder="Enter a Name"
          v-model="value1"
        )
      .action
        vs-button(
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
      openLoadingContained(){
        this.$vs.loading({
          background: this.backgroundLoading,
          color: this.colorLoading,
          container: '#button-with-loading',
          scale: 0.45
        });
        setTimeout( () => {
          this.$vs.loading.close('#button-with-loading .con-vs-loading');
        },2000);
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
