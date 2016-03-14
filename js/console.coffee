unless @console and typeof @console is 'object'
  @console = {}

for prop in ['log', 'info', 'debug', 'warn']
  if typeof @console[prop] isnt 'function'
    @console[prop] = ->

return