<template lang="pug">
  vs-button(
    id="get-token-btn"
    class="vs-con-loading__container"
    color="danger"
    type="filled"
    @click="getToken"
    ) Not Validated
</template>

<script>
import request from 'request';

export default {
  name: 'GetToken',
  methods: {
    getToken () {
      // Activate the spinner
      this.$vs.loading({
        background: this.backgroundLoading,
        color: this.colorLoading,
        container: '#get-token-btn',
        scale: 0.45
      });
      const url = `${this.$store.state.serverUrl}/get-token`;
      console.log(`url:${url}`)
      request.get(url, function (err,res,body) {
        console.log("err: ",err);
        console.log("body: ",body);
        this.$vs.loading.close('#get-token-btn');
      })
    }
  }
}
</script>

