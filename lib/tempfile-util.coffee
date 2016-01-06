config = require './config'
fs = require 'fs-plus'
moment = require 'moment'
path = require 'path'
tmp = require 'tmp'

module.exports = TempfileUtil =
  tempPath: (grammar = null) ->
    if config.get "save"
      tempPath = path.join config.get("directory"), moment().format("YYYYMMDDHHmmss")
    else
      tempPath = tmp.tmpNameSync()
    if config.get "addExtension"
      ext = @getExtension grammar
      tempPath = "#{tempPath}.#{ext}" if ext
    fs.normalize tempPath

  getExtension: (grammar) ->
    extensions = atom.config.get "tempfile-extra.extensions"
    return undefined unless grammar and typeof extensions is "object"
    extensions[grammar.scopeName]

  open: (grammar, selection = null) ->
    atom.workspace.open(@tempPath(grammar)).then (editor) ->
      editor.setGrammar grammar
      if selection
        editor.insertText selection.getText() unless selection.isEmpty()
