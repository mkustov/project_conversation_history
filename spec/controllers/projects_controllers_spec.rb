# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  render_views

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    let(:project) do
      Project.create(title: 'The Tumbler', description: 'All-terrain vehicle', status: Project::VALID_STATUSES.first)
    end

    it 'returns a success response' do
      get :new, params: { id: project.id }
      expect(response).to be_successful
    end

    it 'renders the new template' do
      get :new, params: { id: project.id }
      expect(response.body).to include('New Project')
    end
  end

  describe 'GET #show' do
    context 'when id is valid' do
      let(:project) do
        Project.create(title: 'The Tumbler', description: 'All-terrain vehicle', status: Project::VALID_STATUSES.first)
      end

      it 'returns a success response' do
        get :show, params: { id: project.id }
        expect(response).to be_successful
      end

      it 'renders project details' do
        get :show, params: { id: project.id }
        expect(response.body).to include(project.title)
        expect(response.body).to include(project.description)
        expect(response.body).to include(project.status)
      end

      context 'when project has comments and status updates' do
        let(:user) { User.create(email: 'gordon@blackmesa.com', password: 'HalfLife3') }
        let!(:comment) { Comment.create(body: 'This is a comment', user: user, project: project) }
        let!(:status_change) { StatusChange.create(user: user, project: project, from_status: Project::VALID_STATUSES.first, to_status: Project::VALID_STATUSES.last) }

        it 'renders project conversation items' do
          get :show, params: { id: project.id }
          expect(response.body).to include("#{user.email}</b> posted at")
          expect(response.body).to include(comment.body)
          expect(response.body).to include("#{user.email}</b> updated status from #{status_change.from_status}")
          expect(response.body).to include("to #{status_change.to_status} at ")
        end
      end
    end

    context 'when id is invalid' do
      it 'raises NotFound error' do
        expect { get :show, params: { id: 999 } }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:project_params) do
        { title: 'The Tumbler', description: 'All-terrain vehicle', status: Project::VALID_STATUSES.first }
      end

      it 'creates a new project' do
        expect { post :create, params: { project: project_params } }
          .to change(Project, :all)
          .from([])
          .to(a_collection_containing_exactly(
                an_object_having_attributes(
                  title: 'The Tumbler',
                  description: 'All-terrain vehicle',
                  status: Project::VALID_STATUSES.first
                )
              ))
      end

      it 'redirects to the projects index' do
        post :create, params: { project: project_params }
        expect(response).to redirect_to(projects_path)
      end
    end

    context 'with invalid attributes' do
      let(:project_params) { { title: 'The Tumbler', description: 'All-terrain vehicle', status: 'Invalid Status' } }

      it 'does not create a new project' do
        expect { post :create, params: { project: project_params } }.to_not change(Project, :count)
      end

      it 'renders the new template' do
        post :create, params: { project: project_params }
        expect(response.body).to have_content('New Project')
      end
    end
  end

  describe 'PATCH #update' do
    let(:project) { Project.create(title: 'The Crystal', description: 'Experiment', status: from_status) }
    let(:user) { User.create(email: 'gordon@blackmesa.com', password: 'HalfLife3') }
    let(:from_status) { Project::VALID_STATUSES.first }
    let(:to_status) { Project::VALID_STATUSES.last }
    let(:status_change_params) { { status: to_status } }

    subject { patch :update, params: { id: project.id, project: status_change_params } }

    context 'when user is signed in' do
      before { sign_in user }

      context 'with valid attributes' do
        it 'updates the project status' do
          subject
          expect(project.reload.status).to eq(to_status)
        end

        it 'redirects to the project show page' do
          subject
          expect(response).to redirect_to(project_path(project))
        end

        it 'create status change record' do
          expect { subject }
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

      context 'with invalid attributes' do
        let(:status_change_params) { { status: 'Invalid Status' } }

        it 'does not update the project status' do
          expect { subject }.to_not(change { project.reload.status })
        end

        it 'redirects to the project show page' do
          subject
          expect(response).to redirect_to(project_path(project))
        end

        it 'does not create status change record' do
          expect { subject }.to_not(change { StatusChange.count })
        end
      end
    end

    context 'when user is not signed in' do
      it 'redirects to the sign in page' do
        subject
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'does not update the project status' do
        expect { subject }.to_not(change { project.reload.status })
      end

      it 'does not create status change record' do
        expect { subject }.to_not(change { StatusChange.count })
      end
    end
  end
end
