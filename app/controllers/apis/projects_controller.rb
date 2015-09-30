class Apis::ProjectsController < ActionController::Base
  before_action :load_projects, only: [:index]

  def index
    render json: @projects.as_json
  end

private

  def load_projects
    @projects = Project.load_published
  end

end