<template lang="pug">
  .invoices
    h2 Invoice
    GetToken
    vs-divider
    .invoice
      .card.proponent yo
      .card.status yo
      .card.description yo
      .card.items yo
</template>

<script>
import GetToken from '@/components/GetToken.vue';

export default {
  components: {GetToken}
}
</script>

<style lang="stylus">
.invoice
  display grid
  justify-content center
  grid-template-columns 70% 30%

  .proponent
    background red

  .status
    background blue

  .description
    grid-column-start 1
    grid-column-end 3
    background orange 
  
  .items
    grid-column-start 1
    grid-column-end 3
    background green

  .card
    padding 1rem
    margin 1rem
</style>