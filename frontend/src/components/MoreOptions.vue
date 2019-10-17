<template lang="pug">
  .options
    vs-dropdown(
      'vs-custom-content vs-trigger-click'
      v-tooltip='chooseToolTip(options,type)'
    )
      a(href.prevent)
        vs-icon(:icon='chooseIcon(options)')

      vs-dropdown-menu
        vs-dropdown-item(
          v-for='(option,index) in filterOthers(options,currentOption,optionName)'
          :key='index'
          @click='optionClicked(option,type)'
        ) {{option[optionName]}}
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
    case 2: return `There is ${more} more ${type}`;
    case 3: return `There are ${more} more ${type}s`;
    case 4: return `There are ${more} more ${type}s`;
    case 5: return `There are ${more} more ${type}s`;
    case 6: return `There are ${more} more ${type}s`;
    case 7: return `There are ${more} more ${type}s`;
    case 8: return `There are ${more} more ${type}s`;
    case 9: return `There are ${more} more ${type}s`;
    default: return `There are 10 or more ${type}s`;
  }
};

/* ## filterOthers
  Create an array of every option aside from the active one.
  @param options {object} Array of all options
  @param currentOption {object} The active option
  @param optionName {string} The parameter name to filter on.
  @return {object} Array of options, excluding the active one.
 */
const filterOthers = function (options,currentOption,optionName) {
  return options.filter(option => {
    return (option[optionName] != currentOption[optionName]);
  });
};

/* ## optionClicked
  Signal an event that one of the options has been selected.
  @param option {object} The selected option object
  @param type {string} The type of option
 */
const optionClicked = function (option,type) {
  this.$root.$emit('option-selected',option, type);
};

export default {
  name: 'MoreOptions',
  props:[
    'options',
    'currentOption',
    'optionName',
    'type'
  ],
  methods: {
    chooseIcon,
    chooseToolTip,
    optionClicked,
    filterOthers
  },
  data: function () {
    // Remove the active option from option list.
    return {
      otherOptions: []
    }
  }
}
</script>

<style lang="stylus">

.options button
  margin-left 0.3rem
  width 25px !important
  height 25px !important
  opacity 0.5
  padding 2px

  i
    font-size 1.2rem

.options button:hover
  opacity 1

</style>