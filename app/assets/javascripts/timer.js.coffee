Timer = () ->
  # nothing

Timer.prototype = {
  _format_int: (i) ->
    return if i >= 10 then "#{i}" else "0#{i}"

  _set_time: () ->
    t = this._format_int
    time = this._time / 1000
    h = Math.floor(time / 3600) % 60
    m = Math.floor(time / 60) % 60
    s = Math.floor(time % 60)
    this._$timer.find("h1").html "#{t(h)} : #{t(m)} : #{t(s)}"
    return

  _tiktak: () ->
    this._time -= 1000
    do this._set_time
    do this.end_timer unless this._time > 0
    return

  end_timer: () ->
    clearInterval this._timer_bind
    do window.location.reload
    return

  start_timer: (milliseconds) ->
    thus = this
    thus._time = milliseconds
    thus._$timer = $ '#timer'
    thus._$timer.html "<h1>Something wrong</h1>"
    do thus._tiktak
    ifunc = () ->
      do thus._tiktak
      return
    thus._timer_bind = setInterval ifunc, 1000
    return
}

timer = new Timer()

$('#timer').length && $.ajax {
  url: "/votings/#{$('#timer').data('votingid')}/get_timer"
  type: 'GET'
  success: (body) ->
    timer.start_timer body.timer
    return
  error: (e) ->
    console.log(e)
    return
}
