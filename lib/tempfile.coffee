TempfileView = require './tempfile-view'
util = require './tempfile-util'
config = require './config'
{CompositeDisposable} = require 'atom'

tmp = require 'tmp'

module.exports = Tempfile =
  tempfileView: null
  subscriptions: null

  config: config.config

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'tempfile:create': => @create()
    @subscriptions.add atom.commands.add 'atom-workspace', 'tempfile:paste': => @paste()

  deactivate: ->
    @subscriptions.dispose()
    @tempfileView?.destroy()

  serialize: ->
    tempfileViewState: @tempfileView?.serialize()

  create: ->
    unless @tempfileView?
      @tempfileView = new TempfileView()
    @tempfileView.toggle()

  paste: ->
    currentEditor = atom.workspace.getActiveTextEditor()
    selection = currentEditor.getLastSelection()
    grammar = currentEditor.getGrammar()
    util.open grammar, selection
