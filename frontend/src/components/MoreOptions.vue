<template lang="pug">
  .options
    vs-dropdown(
      'vs-custom-content vs-trigger-click'
      v-tooltip='chooseToolTip(options,type)'
    )
      a(href.prevent)
        vs-icon(:icon='chooseIcon(options)')

      vs-dropdown-menu.dropdown-accounts
        h4 Switch Accounts
        vs-dropdown-item(
          v-for='(option,index) in filterOthers(options,currentOption,optionName)'
          :key='index'
          @click='optionClicked(option,type)'
        ) {{option[optionName]}}
        .footer
          vs-input(
            v-if='addingNew'
            :placeholder="'Enter '+type+' name'"
            v-model='value'
          )
          vs-button(
            type='line'
            v-if='!addingNew'
            @click='addingNew = !addingNew'
            line-position='bottom'
          )
            vs-icon(icon='add_box')
            | New
           
          vs-button(
            type='line'
            color='danger'
            v-if='addingNew'
            @click='addingNew = !addingNew'
            line-position='bottom'
          )
            vs-icon(icon='cancel')
            | Cancel

          vs-button(
            type='line'
            v-if='addingNew'
            @click='saveNewOption(value)'
            line-position='bottom'
          )
            vs-icon(icon='check')
            | Save
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
    case 0: return 'library_add';
    case 1: return 'library_add';
    case 2: return 'filter_1';
    case 3: return 'filter_2';
    case 4: return 'filter_3';
    case 5: return 'filter_4';
    case 6: return 'filter_5';
    case 7: return 'filter_6';
    case 8: return 'filter_7';
    case 9: return 'filter_8';
    case 10: return 'filter_9';
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
    case 2: return `There is ${more} more ${type} available`;
    case 3: return `There are ${more} more ${type}s available`;
    case 4: return `There are ${more} more ${type}s available`;
    case 5: return `There are ${more} more ${type}s available`;
    case 6: return `There are ${more} more ${type}s available`;
    case 7: return `There are ${more} more ${type}s available`;
    case 8: return `There are ${more} more ${type}s available`;
    case 9: return `There are ${more} more ${type}s available`;
    default: return `There are 10 or more ${type}s available`;
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
    'saveNewOption',
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
      addingNew: false,
      value: ''
    }
  }
}
</script>

<style lang="stylus">
background = #036

.options
  button
    cursor pointer
    margin-left 0.3rem
    width 25px !important
    height 25px !important
    opacity 0.5
    padding 2px

  button:hover
    opacity 1

  i
    font-size 1.2rem

.dropdown-accounts
  transition width 0.5s, height 0.5s

  h4 
    text-align center
    opacity 0.4
    border-bottom 1px solid rgba(0, 0, 0, 0.1)
    padding 0px 5px 5px 5px
    font-family 'Avenir', 'Helvetica', 'Arial', 'sans-serif'
    font-weight 200
    font-size 14px
  .footer
    font-size 14px
    border-top 1px solid rgba(0, 0, 0, 0.1)
    padding 0.4rem 0.1rem 0.1rem 0
    text-align right

  button
    font-size 14px !important
    padding 0.2rem

    i
      font-size 16px !important
     
    .vs-button-text
      display flex
      align-items center
      opacity 0.8
    .vs-button-text:hover
      opacity 1

  .vs-input
    max-width 10rem
    margin 0.3rem

    .input-span-placeholder
      text-align left



</style>