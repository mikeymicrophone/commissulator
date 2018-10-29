require 'rails_helper'

RSpec.describe Deal, type: :model do
  describe 'Calculating sub-commissions' do
    context 'with no owner pay commission' do
      context 'without listing side commission' do
        context 'without co-broke' do
          context 'with open listing' do
            context 'with direct deal' do
              let(:deal) { Fabricate :completed_deal }
              let(:commission) { Fabricate :commission, :deal => deal, :co_broke => false, :owner_pay => false }
              
              before do
                commission.agent_split_percentage = 70
                ap commission.attributes
              end
              
              it 'should distribute 50 percent' do
                expect(deal.distributable_commission 50).to eq 50.percent_of commission.total_commission
              end
              
              it 'should deliver agent split' do
                expect(deal.agent_commission).to eq 20.percent_of commission.total_commission
              end
            end
          end
        end
      end
    end
  end
end
