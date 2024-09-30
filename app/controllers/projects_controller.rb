# frozen_string_literal: true

class ProjectsController < ApplicationController
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
  end

  def update; end

  private

  def project_params
    params.require(:project).permit(:title, :description, :status)
  end

  def set_project
    @project = Project.find(params[:id])
  end
end
