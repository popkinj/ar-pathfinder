<template lang="pug">
div
  .home
    HelloWorld(msg="API Testing Playground for Iterative Development")

  vs-divider

  form(
    v-on:submit="handleSubmit"
  )
    vs-textarea(
      v-model="url"
      label="Request URL"
    )
    vs-textarea(
      v-model="data"
      label="Request Data"
    )
    vs-textarea(
      v-model="headers"
      label="Request Headers"
    )
    ul.leftx
      li
        vs-radio(
          v-model="type"
          vs-value="get"
          color="success"
        ) GET&nbsp;&nbsp;
      li
        vs-radio(
          v-model="type"
          vs-value="post"
          color="orange"
        ) POST

    vs-button(color="primary" type="filled") Send
</template>

<script>
// @ is an alias to /src
import HelloWorld from '@/components/HelloWorld.vue'

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
    HelloWorld
  },
  methods: {
    handleSubmit(e) {
      e.preventDefault();
      var s = this.$store.state; // global state object
      var query = {url: this.url,data: this.data,headers: this.headers,type: this.type};
      this.$http.post(`${s.serverUrl}/testing`,query).then((res) => {
        console.log(res.body);
      });
    }
  }
}
</script>

<style lang="stylus">
form
  margin-top 3rem
li
  width: 5rem
  margin 1rem
</style>
