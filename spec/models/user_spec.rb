require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.new(email: 'bruce@waynecorp.com', password: 'IAmBatman99') }

  it 'is valid with valid attributes' do
    expect(user).to be_valid
  end
end
