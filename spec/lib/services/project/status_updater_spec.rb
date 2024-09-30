# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Project::StatusUpdater do
  let(:project) { Project.create(title: 'The Matrix', description: 'Find Neo', status: Project::VALID_STATUSES.first) }
  let(:user) { User.create(email: 'trinity@matrix.com', password: 'NeoLover') }
  let(:from_status) { Project::VALID_STATUSES.first }
  let(:to_status) { Project::VALID_STATUSES.last }

  let(:status_updater) do
    described_class.new(project: project, user: user, from_status: from_status, to_status: to_status)
  end

  describe '#call' do
    context 'when status change is valid' do
      it 'updates the project status' do
        expect { status_updater.call }.to change { project.reload.status }.from(from_status).to(to_status)
      end

      it 'creates a status change record' do
        expect { status_updater.call }
          .to change { StatusChange.all }
          .from([])
          .to(a_collection_containing_exactly(
                an_object_having_attributes(
                  project: project,
                  user: user,
                  from_status: from_status,
                  to_status: to_status
                )
              ))
      end
    end

    context 'when status change is invalid' do
      let(:from_status) { 'Invalid status' }

      it 'returns false' do
        expect(status_updater.call).to be_falsey
      end

      it 'does not update the project status' do
        expect { status_updater.call }.not_to(change { project.reload.status })
      end

      it 'does not create a status change record' do
        expect { status_updater.call }.not_to(change { StatusChange.count })
      end
    end

    context 'when saving status change fails' do
      let(:status_change) { instance_double(StatusChange) }

      before do
        expect(StatusChange).to receive(:create!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'does not update the project status' do
        expect { status_updater.call }.not_to(change { project.reload.status })
      end
    end
  end
end
