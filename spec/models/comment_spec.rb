# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { Comment.new(body: 'This is a comment', user: user, project: project) }
  let(:user) { User.create(email: 'gordon@blackmesa.com', password: 'HalfLife3') }
  let(:project) do
    Project.create(title: 'The Crystal', description: 'Unknown origin', status: Project::VALID_STATUSES.first)
  end

  it 'is valid with valid attributes' do
    expect(comment).to be_valid
  end

  context 'validations' do
    it 'validates the presence of body' do
      comment.body = nil
      expect(comment).to be_invalid
    end
  end
end
