path       = require 'path'
ConfigPlus = require 'atom-config-plus'

config =
  save:
    order: 1
    type: 'boolean'
    default: false
    description: "Save tempfile"
  directory:
    order: 2
    type: 'string'
    default: path.join atom.config.get('core.projectHome'), "tempfiles"
    description: "Tempfile save directory(if save option enabled)"
  addExtension:
    order: 3
    type: 'boolean'
    default: true
    description: 'Add file extension'

module.exports = new ConfigPlus 'tempfile', config
