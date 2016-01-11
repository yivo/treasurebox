unless @console and typeof @console is 'object'
  @console = {}

for prop in ['log', 'info', 'debug']
  if typeof @console[prop] isnt 'function'
    @console[prop] = ->