@Timer = ( element ) ->
  @_$timer = element
  @start_timer = parseInt( element.data 'time' )
  
@Timer.prototype = {
  _format_int: (i) ->
    return if i >= 10 then "#{i}" else "0#{i}"

  _set_time: () ->
    t = @_format_int
    time = @_time / 1000
    d = Math.floor(time / (3600 * 24))
    h = Math.floor(time / 3600) % 60
    m = Math.floor(time / 60) % 60
    s = Math.floor(time % 60)
    @_$timer.find("h1").html "#{t(d)} : #{t(h)} : #{t(m)} : #{t(s)}"
    return

  _tiktak: () ->
    @_time -= 1000
    do @_set_time
    do @end_timer unless @_time > 0
    return

  end_timer: () ->
    clearInterval @_timer_bind
    do window.location.reload
    return

  start_timer: (milliseconds) ->
    @_time = milliseconds
    @_$timer.html "<h1>Something wrong</h1>"

    thus = this
    do @_tiktak
    ifunc = () ->
      do thus._tiktak
      return
    @_timer_bind = setInterval ifunc, 1000
    return
}