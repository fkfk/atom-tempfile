# tempfile

Create temporary file.
Similar to '[open-junk-file.el](http://www.emacswiki.org/emacs/open-junk-file.el)'.

## Features

- Create temporary file.
- With selection, paste selected text.
- If you want to save temporary file, please enable "Save" option from the settings.

## How to use

### Create empty temporary file

- Invoke `tempfile:create`.

### Create temporary file and paste selected text

- Invoke `tempfile:paste`.
- Choose "Paste to tempfile" from context menu.

## Configuring extension

You can add more file extension for a given language scope.
To do this, add the settings to the `~/.atom/config.cson` in the format below.

```coffeescript
'tempfile-extra':
  'source.perl': 'pl6'
```
