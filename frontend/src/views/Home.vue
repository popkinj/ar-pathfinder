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
      this.$http.post('/test',this.blah).then((res) => {
        console.log(this.$store)
        console.log(res);
      });
      console.log(this.blah)
    }
  }
}
</script>
