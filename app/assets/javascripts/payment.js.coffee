submit_pay = do $('#payment').find('[type=submit]').first

submit_pay.val "#{submit_pay.data('pay')} #{submit_pay.data('amount')} #{submit_pay.data('currency')}"
