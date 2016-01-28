fs = require 'fs-plus'
moment = require 'moment'
path = require 'path'
tmp = require 'tmp'
_ = require 'underscore-plus'

module.exports = TempfileUtil =
  extensions: require './tempfile-extensions'

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

  open: (grammar, options) ->
    if atom.config.get("tempfile.splitPane") isnt "current"
      activePane = atom.workspace.getActivePane()
      if atom.config.get "tempfile.useExistPane"
        pane = @findOrCreatePane activePane
      else
        pane = @createNewPane activePane
      pane.focus()
    atom.workspace.open(@tempPath(grammar)).then (editor) ->
      editor.setGrammar grammar
      if options.selection? and not options.selection?.isEmpty()
        editor.insertText options.selection?.getText(),
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
