# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# $(document).on 'turbolinks:load', ->
#   $('.commission_form_row').on 'click', '.row_remover', ->
#     $($(this).closest('.commission_form_row')).remove()

@annualize = ->
  if $('#commission_annualized_rent').val() == ''
    $('#commission_annualized_rent').val(($('#commission_leased_monthly_rent').val() * 12).toFixed 2)

@ripple = ->
  if $('#commission_tenant_side_commission').val() == ''
    broker_fee = $('#commission_annualized_rent').val() * ($('#commission_commission_fee_percentage').val() / 100)
    $('#commission_tenant_side_commission').val(broker_fee.toFixed 2)
    total()

@total = ->
  # if $('#commission_total_commission').val() == ''
  sum = parseFloat($('#commission_tenant_side_commission').val()) + parseFloat($('#commission_owner_pay_commission').val())
  $('#commission_total_commission').val(sum.toFixed 2)

# @breakdown = ->
#   # if $('#commission_citi_commission').val() == ''
#   citi_habitats_share = $('#commission_total_commission').val() * 0.3
#   citi_pads_share = $('#commission_total_commission').val() * 0.2
#   $('#commission_citi_commission').val(citi_habitats_share.toFixed 2)
#   # if $('#commission_co_broke_commission').val() == ''
#   $('#commission_co_broke_commission').val(citi_pads_share.toFixed 2)
