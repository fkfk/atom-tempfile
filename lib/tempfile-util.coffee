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
    if atom.config.get("tempfile.splitPane") isnt "current"
      activePane = atom.workspace.getActivePane()
      if atom.config.get "tempfile.useExistPane"
        pane = @findOrCreatePane activePane
      else
        pane = @createNewPane activePane
      pane.focus()
    atom.workspace.open(@tempPath(grammar)).then (editor) ->
      editor.setGrammar grammar
      if selection and not selection.isEmpty()
        editor.insertText selection.getText(),
          autoIndent: atom.config.get 'tempfile.autoIndent'

  createNewPane: (pane, location = null) ->
    return switch location || atom.config.get "tempfile.splitPane"
      when "left"   then pane.splitLeft()
      when "right"  then pane.splitRight()
      when "top"    then pane.splitUp()
      when "bottom" then pane.splitDown()

  findOrCreatePane: (pane, location = null) ->
    [axisLocation, mostIndex, addIndex] = switch location || atom.config.get "tempfile.splitPane"
      when "left"   then ["horizontal", 0, -1]
      when "right"  then ["horizontal", pane.parent.children.length - 1, 1]
      when "top"    then ["vertical", 0, -1]
      when "bottom" then ["vertical", pane.parent.children.length - 1, 1]

    if pane.parent.orientation is axisLocation
      index = pane.parent.children.findIndex (p) ->
        p.id is pane.id
      if index is mostIndex
        return @createNewPane(pane, location)
      else
        target = pane.parent.children[index + addIndex]
        while target.constructor.name is "PaneAxis"
          target = target.children[0]
        return target
    else
      return @createNewPane(pane, location)
