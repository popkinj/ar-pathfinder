<template lang="pug">
  .invoices
    h2 Invoice

    GetToken

    vs-divider

    .invoice
      .card.proponent
        .invoice-date Invoice Date: {{niceDate($store.getters.activeInvoice.transaction_date)}}
        .invoice-to Invoiced To:
          .invoice-to-name {{$store.getters.activeProponent.name}}
          .invoice-to-address1 {{$store.getters.activeSite.address_line_1}}
          .invoice-to-address2 {{$store.getters.activeSite.address_line_2}}
          .invoice-to-address3 {{$store.getters.activeSite.address_line_3}}
          .invoice-to-city
            span {{$store.getters.activeSite.city}}
            span , {{$store.getters.activeSite.province}}
          .invoice-to-postalcode {{$store.getters.activeSite.postal_code}}
      .card.status
        table
          tr
            td Invoice Number:
            td.value {{$store.getters.activeInvoice.invoice_number}}
          tr
            td Invoice Due:
            td.value {{niceDate($store.getters.activeInvoice.term_due_date)}}
          tr
            td Fee Total:
            td.value ${{$store.getters.activeInvoice.total}}
          tr
            td Payments Received:
            td.value ${{$store.getters.activeInvoice.total - $store.getters.activeInvoice.amount_due}}
          tr.due
            td Amount Due:
            td.value ${{$store.getters.activeInvoice.amount_due}}
      .card.description
        .description-title {{$store.getters.activeInvoice.attribute1}}
        .description-text {{$store.getters.activeInvoice.attribute2}}
      .card.fees
        vs-divider(position='center') Fees
        vs-table(:data='$store.getters.activeInvoice.lines' stripe)
          template(slot='thead')
            vs-th Date
            vs-th Description
            vs-th Amount
            vs-th Quantity
            vs-th Tax
            vs-th Fee Total
          template(slot-scope='{data}')
            vs-tr(:key='indextr' v-for='(tr,indextr) in data')
              vs-td {{niceDate($store.getters.activeInvoice.transaction_date)}}
              vs-td {{tr.attribute1}}
              vs-td ${{tr.unit_price}}
              vs-td {{tr.quantity}}
              vs-td $0
              vs-td ${{tr.unit_price * tr.quantity}}
        vs-divider
        .grand-total Total: ${{$store.getters.activeInvoice.total}}
</template>

<script>
// Components..  @ is an alias to /src
import GetToken from '@/components/GetToken.vue';

// Dependencies
import moment from 'moment';

/* ## niceDate
  Format a date string into one suitable for the invoice
  @param date {string} Date string like this "2019-12-29T08:00:00Z"
  @return {string} Date string like this "December 29, 2019"
 */
const niceDate = function (date) {
  return moment(date).format('MMMM DD, YYYY')
};

export default {
  components: {GetToken},
  methods: {
    niceDate
  }
}
</script>

<style lang="stylus">
.invoice
  display grid
  justify-content center
  grid-template-columns 50% 50%

  .invoice-to div
    margin-left 1rem

  .status
    td.value
      text-align right
      padding-left 2rem

  .card.status
    align-items end
    justify-content end

    tr.due
      font-weight bolder

  .description
    grid-column-start 1
    grid-column-end 3
  
  .fees
    grid-column-start 1
    grid-column-end 3

    .grand-total
      float right
      font-weight bolder
      margin-right 5rem

  .card
    padding 1rem
    margin 1rem
</style>