require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  render_views

  describe 'POST #create' do
    let(:user) { User.create(email: 'gordon@blackmesa.com', password: 'HalfLife3') }
    let(:project) { Project.create(title: 'The Crystal', description: 'Unknown origin', status: Project::VALID_STATUSES.first) }
    let(:comment_params) { { body: 'This is a comment' } }

    subject { post :create, params: { project_id: project.id, comment: comment_params } }

    context 'when user is signed in' do
      before { sign_in(user) }
      
      it 'creates a new comment' do
        expect { subject }
          .to change(Comment, :all)
          .from([])
          .to(a_collection_containing_exactly(
                an_object_having_attributes(
                  body: 'This is a comment',
                  project_id: project.id,
                  user_id: user.id
                )
              )
            ) 
      end

      it 'redirects to the project show page' do
        subject
        expect(response).to redirect_to(project_path(project))
      end

      it 'sets a flash notice' do
        subject
        expect(flash[:notice]).to eq('Comment was successfully created.')
      end

      context 'with invalid attributes' do
        let(:comment_params) { { body: nil } }

        it 'does not create a new comment' do
          expect { subject }.not_to change(Comment, :count)
        end

        it 'redirects to the project show page' do
          subject
          expect(response).to redirect_to(project_path(project))
        end

        it 'sets a flash alert' do
          subject
          expect(flash[:alert]).to eq('Comment could not be created.')
        end
      end
    end

    context 'when user is not signed in' do
      it 'redirects to the sign in page' do
        subject
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'sets a flash alert' do
        subject
        expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
      end

      it 'does not create a new comment' do
        expect { subject }.not_to change(Comment, :count)
      end
    end
  end
end
