<template lang="pug">
div
  .home
    HelloWorld(msg="API Testing Playground for Iterative Development")

  vs-divider

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
form
  margin-top 3rem
li
  width: 5rem
  margin 1rem
</style>
