<template lang="pug">
vs-list
  vs-list-item(
    v-for="proponent in $store.getters.focusProponents"
    :subtitle="proponent.name"
  )
</template>

<script>
export default {
  name: 'ProponentList'
}
</script>