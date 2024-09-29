require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { Project.new(title: 'The Tumbler', description: 'All-terrain vehicle', status: described_class::VALID_STATUSES.first) }
  
  it 'is valid with valid attributes' do
    expect(project).to be_valid
  end

  context 'validations' do
    it 'validates the presence of title' do
      project.title = nil
      expect(project).to be_invalid
    end

    it 'validates the presence of description' do
      project.description = nil
      expect(project).to be_invalid
    end

    it 'validates the status is included in VALID_STATUSES' do
      project.status = 'Invalid Status'
      expect(project).to be_invalid
    end
  end
end
