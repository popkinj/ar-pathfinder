<template lang="pug">
  // The first button shows if we already have a token
  vs-button(
    v-if="$store.getters.token"
    id="get-token-btn"
    class="vs-con-loading__container"
    color="success"
    type="filled"
    @click="getToken"
    ) Verified
  // This button shows if there's no token
  vs-button(
    v-else
    id="get-token-btn"
    class="vs-con-loading__container"
    color="danger"
    type="filled"
    @click="getToken"
    ) Not Verified
</template>

<script>
import request from 'request';

export default {
  name: 'GetToken',
  methods: {
    getToken () {
      const v = this;
      const vs = this.$vs;
      // Activate the spinner
      vs.loading({
        background: this.backgroundLoading,
        color: 'danger',
        container: '#get-token-btn',
        scale: 0.45
      });

      // Request the token
      const url = `${this.$store.state.serverUrl}/get-token`;
      request.get(url, function (err,res,body) {
        if (err) {
          return console.error(err);
        }

        const json = JSON.parse(body);

        if (!json.access_token) {
          return console.error('Empty token');
        }
        // Update the token in the store
        v.$store.commit('loadToken', json.access_token)

        // Close the spinner
        vs.loading.close('#get-token-btn .con-vs-loading');
      })
    }
  }
}
</script>

<style lang="stylus" scoped>
  button
    width 100px
</style>
