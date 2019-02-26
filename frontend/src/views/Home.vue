<template lang="pug">
div
  .home
    HelloWorld(msg="API Testing Playground for Iterative Development")

  vs-divider

  form(
    v-on:submit="handleSubmit"
  )

    vs-textarea(
      v-model="blah"
      label="Request String"
    )
    vs-button(color="primary" type="filled") Send
</template>

<script>
// @ is an alias to /src
import HelloWorld from '@/components/HelloWorld.vue'

export default {
  name: 'home',
  data() {
    return {
      blah:""
    }
  },
  components: {
    HelloWorld
  },
  methods: {
    handleSubmit(e) {
      e.preventDefault();
      var s = this.$store.state; // global state object
      var query = {query: this.blah};
      this.$http.post(`${s.serverUrl}/testing`,query).then((res) => {
        console.log(res);
      });
    }
  }
}
</script>

<style lang="stylus">
form
  margin-top 3rem
</style>