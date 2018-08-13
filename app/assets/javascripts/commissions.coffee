# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# $(document).on 'turbolinks:load', ->
#   $('.commission_form_row').on 'click', '.row_remover', ->
#     $($(this).closest('.commission_form_row')).remove()

@annualize = ->
  if $('#commission_annualized_rent').val() == ''
    $('#commission_annualized_rent').val($('#commission_leased_monthly_rent').val() * 12)

@ripple = ->
  if $('#commission_tenant_side_commission').val() == ''
    $('#commission_tenant_side_commission').val($('#commission_annualized_rent').val() * ($('#commission_commission_fee_percentage').val() / 100))
    total()

@total = ->
  # if $('#commission_total_commission').val() == ''
  $('#commission_total_commission').val(parseFloat($('#commission_tenant_side_commission').val()) + parseFloat($('#commission_owner_pay_commission').val()) + parseFloat($('#commission_listing_side_commission').val()))
  breakdown()

@breakdown = ->
  # if $('#commission_citi_commission').val() == ''
  $('#commission_citi_commission').val($('#commission_total_commission').val() * 0.3)
  # if $('#commission_co_broke_commission').val() == ''
  $('#commission_co_broke_commission').val($('#commission_total_commission').val() * 0.2)
