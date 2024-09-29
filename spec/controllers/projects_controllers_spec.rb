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
    let(:project) { Project.create(title: 'The Tumbler', description: 'All-terrain vehicle', status: Project::VALID_STATUSES.first) }
    
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
      let(:project) { Project.create(title: 'The Tumbler', description: 'All-terrain vehicle', status: Project::VALID_STATUSES.first) }
      
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
    end

    context 'when id is invalid' do
      it 'raises NotFound error' do
        expect { get :show, params: { id: 999 } }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:project_params) { { title: 'The Tumbler', description: 'All-terrain vehicle', status: Project::VALID_STATUSES.first } }

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
end
