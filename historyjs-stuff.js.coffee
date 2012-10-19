# Update history on "popstate"
History.Adapter.bind window, "statechange", -> # Note: We are using statechange instead of popstate
    State = History.getState() # Note: We are using History.getState() instead of event.state
    History.log State.data, State.title, State.url
    $.getScript(State.url)

# Write to history
window.History.pushState(nil,title,path )
