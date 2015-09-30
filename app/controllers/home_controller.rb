class HomeController < ApplicationController

  def index
    @projects = [load_maximum_completed_projects, load_recently_created_projects,
                  load_fully_completed_projects]
  end

  private

  def load_maximum_completed_projects
    @maximum_completed_projects = Project.load_maximum_completed[0,Project::DEFAULT_PROJECTS_COUNT]
  end

  def load_recently_created_projects
    @recently_created_projects = Project.load_recently_created
  end

  def load_fully_completed_projects
    @fully_completed_projects = Project.load_fully_completed[0,Project::DEFAULT_PROJECTS_COUNT]
  end

end
