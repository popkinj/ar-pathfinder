<template lang="pug">
  div.proponents
    table
      tr
        th Fetch all Proponents
        th
          vs-button(
            id="button-with-loading"
            class="vs-con-loading__container"
            @click="openLoadingContained"
            type="filled"
            ref="loadableButton"
            vslor="primary")
              | Load
</template>

<script>
  export default {
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
      }

    }
  }
</script>

<style lang="stylus">
</style>
