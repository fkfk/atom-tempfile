TempfileView = require './tempfile-view'
util = require './tempfile-util'
{CompositeDisposable} = require 'atom'

tmp = require 'tmp'

module.exports = Tempfile =
  tempfileView: null
  subscriptions: null

  activate: (state) ->
    # set default value
    atom.config.setDefaults "tempfile.directory", path.join(atom.config.get('core.projectHome'), "tempfiles")

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'tempfile:create':         => @create()
    @subscriptions.add atom.commands.add 'atom-workspace', 'tempfile:create-top':     => @create('top')
    @subscriptions.add atom.commands.add 'atom-workspace', 'tempfile:create-bottom':  => @create('bottom')
    @subscriptions.add atom.commands.add 'atom-workspace', 'tempfile:create-left':    => @create('left')
    @subscriptions.add atom.commands.add 'atom-workspace', 'tempfile:create-right':   => @create('right')
    @subscriptions.add atom.commands.add 'atom-workspace', 'tempfile:create-current': => @create('current')
    @subscriptions.add atom.commands.add 'atom-workspace', 'tempfile:paste':          => @paste()
    @subscriptions.add atom.commands.add 'atom-workspace', 'tempfile:paste-top':      => @paste('top')
    @subscriptions.add atom.commands.add 'atom-workspace', 'tempfile:paste-bottom':   => @paste('bottom')
    @subscriptions.add atom.commands.add 'atom-workspace', 'tempfile:paste-left':     => @paste('left')
    @subscriptions.add atom.commands.add 'atom-workspace', 'tempfile:paste-right':    => @paste('right')
    @subscriptions.add atom.commands.add 'atom-workspace', 'tempfile:paste-current':  => @paste('current')

  deactivate: ->
    @subscriptions.dispose()
    @tempfileView?.destroy()

  serialize: ->
    tempfileViewState: @tempfileView?.serialize()

  create: (location = null) ->
    unless @tempfileView?
      @tempfileView = new TempfileView()
    if location
      @tempfileView.temporaryOpenOptions.location = location
    @tempfileView.toggle()

  paste: (location = null)->
    currentEditor = atom.workspace.getActiveTextEditor()
    grammar = currentEditor.getGrammar()
    options =
      selection: currentEditor.getLastSelection()
      location: location
    util.open grammar, options
