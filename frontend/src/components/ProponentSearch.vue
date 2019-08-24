<template lang="pug">
.input
  vs-input#proponent-input(
    icon-no-boarder
    icon="perm_identity"
    label-placeholder="Search for a Proponent"
    v-model='value1'
    v-on:input='proponentChange'
  )
  .close-btn(@click='clearSearch')
    vs-icon(icon='close')
</template>

<script>
const clearSearch = function () {
  this.value1 = ''; // Clear the form
  this.$store.commit('clearFocusProponents'); // Clear store
}

const proponentChange = function (txt) {
  this.$store.commit('focusProponents',txt);
}

export default {
  name: 'ProponentSearch',
  data:() => ({
    value1: ''
  }),
  methods: {
    clearSearch,
    proponentChange
  }
}
</script>

<style lang='stylus'>
.input
  i
    font-size 1rem

  .vs-input
    margin 0  
    width 100%
    height 100%

  .close-btn
    position relative
    float right
    right 5px
    margin-top -23px
    cursor pointer
    color rgba(0,0,0,0.4)
</style>