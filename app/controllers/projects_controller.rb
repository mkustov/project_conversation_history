# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!, only: %i[update]
  before_action :set_project, only: %i[show update]

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to projects_path, notice: 'Project was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @comment = Comment.new
    @conversation_items = @project.conversation_items
  end

  def update
    updater_service = Services::Project::StatusUpdater.new(project: @project,
                                                           user: current_user,
                                                           from_status: @project.status,
                                                           to_status: project_params[:status])

    if updater_service.call
      redirect_to @project, notice: 'Project status was successfully updated.'
    else
      redirect_to @project, alert: 'Project status was not updated.'
    end
  end

  private

  def project_params
    params.require(:project).permit(:title, :description, :status)
  end

  def set_project
    @project = Project.find(params[:id])
  end
end
