<template lang="pug">
vs-list
  vs-list-item(
    v-for="proponent in $store.getters.focusProponents"
    v-on:click.native="selectProponent(proponent)"
    :subtitle="proponent.name"
  )
</template>

<script>

const selectProponent = function (proponent) {
  this.$store.commit('clearFocusProponents');
  this.$store.commit('activeProponent',proponent);
  // TODO: Clear the search input component. May require making the search text a store variable. Check what I did in the intercity application.
}

export default {
  name: 'ProponentList',
  methods: {
    selectProponent
  }
}
</script>

<style lang="stylus">
.vs-list--item
  cursor pointer
.vs-list--item:hover
  background #fafafa
</style>