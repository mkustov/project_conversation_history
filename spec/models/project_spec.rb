# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) do
    Project.new(title: 'The Tumbler', description: 'All-terrain vehicle', status: described_class::VALID_STATUSES.first)
  end

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

  describe '#conversation_items' do
    let(:project) { Project.create(title: 'The Matrix', description: 'Find Neo', status: Project::VALID_STATUSES.first) }
    let(:user) { User.create(email: 'morpheus@matrix.com', password: 'RedPill') }
    let!(:comment) { Comment.create(body: 'This is a comment', user: user, project: project) }
    let!(:status_change) { StatusChange.create(user: user, project: project, from_status: Project::VALID_STATUSES.first, to_status: Project::VALID_STATUSES.last) }

    it 'returns all conversation items' do
      expect(project.conversation_items).to match_array([comment, status_change])
    end
  end
end
