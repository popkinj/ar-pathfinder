<template lang="pug">
  vs-icon(
    icon='mood'
  )
    //- .option(
    //-   v-for='option in options'
    //- ) {{option.account_description}}
</template>

<script>
export default {
  name: 'MoreOptions',
  props: ['options']
}
</script>

<style lang="stylus">

</style>