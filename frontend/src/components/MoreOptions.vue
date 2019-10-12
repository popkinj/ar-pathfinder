<template lang="pug">
  .more-options
    .option(
      v-for='option in options'
    ) {{option}}
</template>

<script>
export default {
  name: 'MoreOptions',
  props: ['options']
}
</script>

<style lang="stylus">

</style>