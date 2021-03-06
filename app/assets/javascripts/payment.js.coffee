submit_pay = do $('#payment').find('[type=submit]').first

redraw_submit = () ->
  submit_pay.val "#{submit_pay.data('pay')} #{submit_pay.data('amount')} #{submit_pay.data('currency')}"
  return

do redraw_submit

$('#payment').on 'ajax:success', (e, data, status, xhr) ->
  if(data._success)
    robokassa_frame = $ '[name=robokassa_frame]'
    robokassa_frame.css 'width', '700px'
    robokassa_frame.css 'height', '535px'
    robokassa_frame.contents().find('html').html data._content
    do robokassa_frame.show
    do $('#payment').hide
  return

$('#some_phone').mask '+7 (999) 999-99-99', {
  completed: () ->
    if this.val().length
      match = this.val().match /^\+7\s\((\d{3})\)\s(\d{3})-(\d{2})-(\d{2})$/
      this.next().val "#{match[1]}#{match[2]}#{match[3]}#{match[4]}"
    else
      this.next().val ''
    return
}

$('#fake_amount').on 'change keydown', () ->
  if $(this).val() <= 0
    $(this).val 0
  if !$(this).val().length
    $(this).val 0
  amount = Math.round parseInt($(this).val()) * $(this).data('rate')
  submit_pay.data 'amount', amount
  $(this).next().val amount
  do redraw_submit
  return

$('#new_payment').on 'submit', (e) ->
  if $('#fake_amount').val() == '0'
    do e.stopPropagation
    return false
  return

$('.choose_votes_changer').on 'click', () ->
  payment_amount = $('#fake_amount')
  amount = parseInt payment_amount.val()
  amount += if $(this).html() == '+' then 25 else -25
  payment_amount.val amount
  payment_amount.trigger 'change'
  return

$('#close_participant_balance_fillup').on 'click', () ->
  do $('.floating_block').hide
  do $('#app_fog').hide
  $('.floating_block').html ''
  return
