require 'rails_helper'

RSpec.describe StatusChange, type: :model do
  let(:status_change) { StatusChange.new(user: user, project: project, from_status: Project::VALID_STATUSES.first, to_status: Project::VALID_STATUSES.last) }
  let(:project) { Project.create(title: 'The Matrix', description: 'Find Neo', status: Project::VALID_STATUSES.first) }
  let(:user) { User.create(email: 'morpheus@matrix.com', password: 'RedPill') }

  it 'is valid with valid attributes' do
    expect(status_change).to be_valid
  end

  context 'validations' do
    it 'validates the presence of project' do
      status_change.project = nil
      expect(status_change).to be_invalid
    end

    it 'validates the presence of from_status' do
      status_change.from_status = nil
      expect(status_change).to be_invalid
    end

    it 'validates the presence of to_status' do
      status_change.to_status = nil
      expect(status_change).to be_invalid
    end

    it 'validates the from_status is included in VALID_STATUSES' do
      status_change.from_status = 'Invalid Status'
      expect(status_change).to be_invalid
    end

    it 'validates the to_status is included in VALID_STATUSES' do
      status_change.to_status = 'Invalid Status'
      expect(status_change).to be_invalid
    end
  end
end
