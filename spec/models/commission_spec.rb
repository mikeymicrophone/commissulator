require 'rails_helper'

RSpec.describe Commission, type: :model do
  describe 'Syncing to Follow Up Boss' do
    describe 'a person with a name' do
      let(:person) { FubClient::Person.new :firstName => Faker::Name.first_name, :lastName => Faker::Name.last_name }
      context 'and an email' do
        before do
          person.emails = [{:value => Faker::Internet.email}]
        end
        
        it 'should be saved' do
          expect { person.save }.to_not raise_error
        end
      end
    end
  end
end
