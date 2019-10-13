<template lang="pug">
  span.options
    vs-icon(
      :icon='icon'
    )
    //- .option(
    //-   v-for='option in options'
    //- ) {{option.account_description}}
</template>

<script>
/* ## chooseIcon
  Based on the number of options choose the icon.
  @param options {object} Array of optional choices
  @return {string} Material icon name
 */
const chooseIcon = function (options) {
  // This is verbose but the fastest.
  switch (options.length) {
    case 0: return 'library-add';
    case 1: return 'library-add';
    case 2: return 'filter_2';
    case 3: return 'filter_3';
    case 4: return 'filter_4';
    case 5: return 'filter_5';
    case 6: return 'filter_6';
    case 7: return 'filter_7';
    case 8: return 'filter_8';
    case 9: return 'filter_9';
    default: return 'filter_9_plus';
  }
};

/* ## chooseToolTip
  Based on the number of options choose the tooltip.
  @param options {object} Array of optional choices
  @param type {string} Name of options
  @return {string} Tooltip text
 */
const chooseToolTip = function (options,type) {
  const more = options.length - 1;
  // This is verbose but the fastest.
  switch (options.length) {
    case 0: return `Create a new ${type}`;
    case 1: return `Create a new ${type}`;
    case 2: return `There are ${more} more ${type}s`;
    case 3: return `There are ${more} more ${type}s`;
    case 4: return `There are ${more} more ${type}s`;
    case 5: return `There are ${more} more ${type}s`;
    case 6: return `There are ${more} more ${type}s`;
    case 7: return `There are ${more} more ${type}s`;
    case 8: return `There are ${more} more ${type}s`;
    case 9: return `There are ${more} more ${type}s`;
    default: return `There are 10 or more ${type}s`;
  }
}

export default {
  name: 'MoreOptions',
  data: function () {
    return {
      icon: chooseIcon(this.options),
      type: chooseToolTip(this.options,this.type)
    }
  }
}
</script>

<style lang="stylus">

</style>