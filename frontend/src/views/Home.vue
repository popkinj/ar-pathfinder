<template lang="pug">
div
  .header
    h2 Invoicing Pathfinder

  vs-divider


  .content
    .contacts.card
      h4 Contact Information

    .invoices.card
      h4 Invoices

    .fees.card
      h4 Fees


</template>

<script>
// @ is an alias to /src

export default {
  name: 'home',
  data() {
    return {
      url:"",
      data:"",
      type:"",
      headers:""
    }
  },
  components: {
  },
  methods: {
    handleSubmit(e) {
      e.preventDefault();
      var s = this.$store; // global state object
      var query = {url: this.url,data: this.data,headers: this.headers,type: this.type};
      this.$http.post(`${s.getters.serverUrl}/testing`,query).then((res) => {
        console.log(res.body);
      });
    }
  }
}
</script>

<style lang="stylus">
.content
  display grid
  justify-content center
  grid-template-columns 50% 50%

  .contacts
    grid-column-start 1
    grid-column-end 3

  .card
    background white
    height 20rem
    padding 1rem
    margin 1rem
    box-shadow 3px 3px 3px #cfcfcf
    // box-shadow 3px 3px 5px #888
    border-radius 5px
    border-style solid
    border-width 1px
    border-color #d9d9d9

form
  margin-top 3rem
li
  width: 5rem
  margin 1rem
</style>
