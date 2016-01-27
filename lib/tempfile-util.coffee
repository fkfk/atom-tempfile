fs = require 'fs-plus'
moment = require 'moment'
path = require 'path'
tmp = require 'tmp'
_ = require 'underscore-plus'

module.exports = TempfileUtil =
  extensions:
    'source.todo': 'todo'
    'source.c': 'c'
    'source.cpp': 'cpp'
    'source.clojure': 'clj'
    'source.litcoffee': 'litcoffee'
    'source.coffee': 'coffee'
    'source.nant-build': 'build'
    'source.cs': 'cs'
    'source.cake': 'cake'
    'source.csx': 'csx'
    'source.css': 'css'
    'source.gfm': 'md'
    'text.git-commit': 'COMMIT_EDITMSG'
    'source.git-config': '.gitconfig'
    'text.git-rebase': 'git-rebase-todo'
    'source.go': 'go'
    'text.html.gohtml': 'gohtml'
    'text.html.basic': 'html'
    'text.hyperlink': ''
    'text.html.jsp': 'jsp'
    'source.java': 'java'
    'source.java-properties': 'properties'
    'source.js': 'js'
    'source.json': 'json'
    'source.css.less': 'less'
    'source.makefile': 'Makefile'
    'text.html.mustache': 'mustache'
    'source.sql.mustache': ''
    'source.objc': 'm'
    'source.objcpp': 'mm'
    'source.strings': 'strings'
    'source.perl6': 'p6'
    'source.perl': 'pl'
    'text.html.php': 'php'
    'source.plist': 'plist'
    'text.xml.plist': 'plist'
    'text.python.console': 'pycon'
    'text.python.traceback': 'pytb'
    'source.python': 'py'
    'source.ruby': 'rb'
    'text.html.ruby': 'html.erb'
    'source.regexp.python': 're'
    'text.html.erb': 'html.erb'
    'source.js.rails source.js.jquery': 'js.erb'
    'source.ruby.rails.rjs': 'rjs'
    'source.ruby.rails': 'rb'
    'source.sql.ruby': 'sql.erb'
    'source.sass': 'sass'
    'source.css.scss': 'scss'
    'text.shell-session': 'sh-session'
    'source.shell': 'sh'
    'source.sql': 'sql'
    'text.plain': 'txt'
    'source.toml': 'toml'
    'text.xml': 'xml'
    'text.xml.xsl': 'xsl'
    'source.yaml': 'yaml'
    'text.md': 'md'

  tempPath: (grammar = null) ->
    if atom.config.get "tempfile.save"
      tempPath = path.join atom.config.get("tempfile.directory"), moment().format("YYYYMMDDHHmmss")
    else
      tempPath = tmp.tmpNameSync()
    if atom.config.get "tempfile.addExtension"
      ext = @getExtension grammar
      tempPath = "#{tempPath}.#{ext}" if ext
    fs.normalize tempPath

  getExtension: (grammar) ->
    extensions = _.deepExtend {}, @extensions, atom.config.get "tempfile-extra"
    return undefined unless grammar and typeof extensions is "object"
    extensions[grammar.scopeName]

  open: (grammar, selection = null) ->
    atom.workspace.open(@tempPath(grammar)).then (editor) ->
      editor.setGrammar grammar
      if selection
        editor.insertText selection.getText() unless selection.isEmpty()
