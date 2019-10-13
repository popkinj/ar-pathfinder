<template lang="pug">
  div.invoices
    h2 Invoices
    .testing blah
    MoreOptions(
      :options='$store.getters.accounts'
      type='testing'
    )
</template>

<script>
import MoreOptions from '@/components/MoreOptions.vue';

export default {
  components: {MoreOptions}
}
</script>

<style lang="stylus">
</style>