<template lang="pug">
.input
  vs-input#proponent-input(
    icon-no-boarder
    icon='airport_shuttle'
    label-placehoder='Enter a Proponent'
    v-model='value1'
  )
</template>

<script>
export default {
  name: 'SearchProponent',
  data:() => ({
    value1: ''
  })
}
</script>

<style lang='stylus'>
.input

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