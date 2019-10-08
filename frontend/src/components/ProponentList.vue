<template lang="pug">
vs-list
  vs-list-item(
    v-for="proponent in $store.getters.focusProponents"
    v-on:click.native="selectProponent(proponent)"
    :key="proponent.proponent_number"
    :subtitle="proponent.name"
  )
</template>

<script>

const selectProponent = function (proponent) {
  this.$store.commit('clearFocusProponents');
  this.$store.commit('activeProponent',proponent);
  this.$root.$emit('clearSearch');
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