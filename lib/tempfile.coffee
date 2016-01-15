TempfileView = require './tempfile-view'
util = require './tempfile-util'
config = require './config'
{CompositeDisposable} = require 'atom'

tmp = require 'tmp'

module.exports = Tempfile =
  tempfileView: null
  subscriptions: null

  config: config.config
  defaultExtensions:
    'source\\\.todo': 'todo'
    'source\\\.c': 'c'
    'source\\\.cpp': 'cpp'
    'source\\\.clojure': 'clj'
    'source\\\.litcoffee': 'litcoffee'
    'source\\\.coffee': 'coffee'
    'source\\\.nant-build': 'build'
    'source\\\.cs': 'cs'
    'source\\\.cake': 'cake'
    'source\\\.csx': 'csx'
    'source\\\.css': 'css'
    'source\\\.gfm': 'md'
    'text\\\.git-commit': 'COMMIT_EDITMSG'
    'source\\\.git-config': '.gitconfig'
    'text\\\.git-rebase': 'git-rebase-todo'
    'source\\\.go': 'go'
    'text\\\.html\\\.gohtml': 'gohtml'
    'text\\\.html\\\.basic': 'html'
    'text\\\.hyperlink': ''
    'text\\\.html\\\.jsp': 'jsp'
    'source\\\.java': 'java'
    'source\\\.java-properties': 'properties'
    'source\\\.js': 'js'
    'source\\\.json': 'json'
    'source\\\.css\\\.less': 'less'
    'source\\\.makefile': 'Makefile'
    'text\\\.html\\\.mustache': 'mustache'
    'source\\\.sql\\\.mustache': ''
    'source\\\.objc': 'm'
    'source\\\.objcpp': 'mm'
    'source\\\.strings': 'strings'
    'source\\\.perl6': 'p6'
    'source\\\.perl': 'pl'
    'text\\\.html\\\.php': 'php'
    'source\\\.plist': 'plist'
    'text\\\.xml\\\.plist': 'plist'
    'text\\\.python\\\.console': 'pycon'
    'text\\\.python\\\.traceback': 'pytb'
    'source\\\.python': 'py'
    'source\\\.ruby': 'rb'
    'text\\\.html\\\.ruby': 'html.erb'
    'source\\\.regexp\\\.python': 're'
    'text\\\.html\\\.erb': 'html.erb'
    'source\\\.js\\\.rails source\\\.js\\\.jquery': 'js.erb'
    'source\\\.ruby\\\.rails\\\.rjs': 'rjs'
    'source\\\.ruby\\\.rails': 'rb'
    'source\\\.sql\\\.ruby': 'sql.erb'
    'source\\\.sass': 'sass'
    'source\\\.css\\\.scss': 'scss'
    'text\\\.shell-session': 'sh-session'
    'source\\\.shell': 'sh'
    'source\\\.sql': 'sql'
    'text\\\.plain': 'txt'
    'source\\\.toml': 'toml'
    'text\\\.xml': 'xml'
    'text\\\.xml\\\.xsl': 'xsl'
    'source\\\.yaml': 'yaml'
    'text\\\.md': 'md'

  activate: (state) ->
    atom.config.setDefaults 'tempfile-extra.extensions', @defaultExtensions
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
