module ReferralSourcesHelper
  def referral_source_options
    options_from_collection_for_select ReferralSource.all, :id, :name
  end
end
