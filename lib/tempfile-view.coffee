# via grammar-selector
# https://github.com/atom/grammar-selector/blob/master/lib/grammar-list-view.coffee

{SelectListView} = require 'atom-space-pen-views'
tmp = require 'tmp'
_ = require 'underscore-plus'
util = require './tempfile-util'

module.exports =
class TempfileView extends SelectListView
  openOptions: {}
  temporaryOpenOptions: {}

  initialize: ->
    super

    @addClass('tempfile')
    @list.addClass('mark-active')

  getFilterKey: ->
    'name'

  destroy: ->
    @cancel()

  viewForItem: (grammar) ->
    element = document.createElement('li')
    grammarName = grammar.name ? grammar.scopeName
    element.textContent = grammarName
    element.dataset.grammar = grammarName
    element

  cancelled: ->
    @panel?.destroy()
    @panel = null
    @editor = null
    @temporaryOpenOptions = {}

  confirmed: (grammar) ->
    options = _.deepExtend {}, @openOptions, @temporaryOpenOptions
    util.open grammar, options
    @cancel()

  attach: ->
    @storeFocusedElement()
    @panel ?= atom.workspace.addModalPanel(item: this)
    @focusFilterEditor()

  toggle: ->
    if @panel?
      @cancel()
    else
      @setItems(@getGrammars())
      @attach()

  getGrammars: ->
    grammars = atom.grammars.getGrammars().filter (grammar) ->
      grammar isnt atom.grammars.nullGrammar

    grammars.sort (grammarA, grammarB) ->
      if grammarA.scopeName is 'text.plain'
        -1
      else if grammarB.scopeName is 'text.plain'
        1
      else
        grammarA.name?.localeCompare?(grammarB.name) ? grammarA.scopeName?.localeCompare?(grammarB.name) ? 1

    grammars
