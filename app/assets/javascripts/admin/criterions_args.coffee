$ ->
  container = $ '.has_many.criterions'

  return unless container.length > 0

  check_args_visibility = ( criterion )->
    type = criterion.find('> ol > .select > select').eq(0).val()
    args = criterion.find('> ol > .string')
    visible = type == 'Strategy::Criterion::Member'
    args.toggle visible
    args.find('> input').val('') unless visible
    return

  container.find('> .input > fieldset').each ->
    check_args_visibility $ this
    return

  container.on 'change', 'fieldset', ->
    check_args_visibility $ this
    return

  return
