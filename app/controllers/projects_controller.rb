class ProjectsController < ApplicationController
  helper_method :user_authorized_for_edit?, :created_by_current_user?, :current_project

  before_action :authorize_user, only: [:index, :new, :edit, :update]
  before_action :build_project_attachments, only: [:new]
  before_action :set_pagination_defaults, :load_projects, only: [:index]
  before_action :load_project, only: [:edit, :update, :show]
  before_action :authorize_user_for_edit, only: [:edit, :update]
  before_action :check_project_accessibility, only: [:show]

  def index
    flash.now[:notice] = t(:not_found, object: 'project') unless @projects.present?
  end

  def new
    render
  end

  def create
    @project = current_user.projects.build(project_params)
    @project.save ? after_create : (render 'new')
  end

  def show
    render
  end

  def edit
    render
  end

  def update
    if @project.update(project_params)
      redirect_to :root, notice: t(:project_updated)
    else
      render 'edit'
    end
  end

  def update_status
    if current_project
      current_project.update_status(params[:status]) ? (head 200) : (head 400)
    else
      head 404
    end
  end

  def view_all
    @projects = load_projects_catagory_wise
    @projects = sort if @projects.present?
    (render layout: false) if params_present?
  end
  
private

  def params_present?
    params[:offset] || params[:filter] || params[:sort_by]
  end 

  def load_projects_catagory_wise
    limit,offset = *get_limit_and_offset
    
    case params[:catagory]
    when "maximum_completed"
      Project.load_maximum_completed(params[:filter])[offset, limit]
    when "recently_created"
      Project.load_recently_created(limit, offset, params[:filter])
    when "fully_completed"
      Project.load_fully_completed(params[:filter])[offset, limit]
    end

  end

  def get_limit_and_offset
    limit = get_limit
    offset = get_offset
    [limit,offset]
  end

  def get_limit
    params[:offset] ? Project::MORE_CATAGORY_PROJECTS_COUNT : Project::DEFAULT_CATAGORY_PROJECTS_COUNT
  end

  def get_offset
    params[:offset] ? Project::DEFAULT_CATAGORY_PROJECTS_COUNT + (Project::MORE_CATAGORY_PROJECTS_COUNT * (params[:offset].to_i - 1)) : 0
  end

  def filter
    @filter = params[:filter] ? params[:filter] : Project::DEFAULT_FILTER
    @projects.select! { |project| project.kind.eql?(@filter) }
  end

  def sort
    @sort_by = params[:sort_by] ? params[:sort_by] : Project::DEFAULT_SORT
    case @sort_by
    when 'Popularity'
      @projects.sort_by { |project| project.get_contributers_count }.reverse
    when 'Recent'
      @projects.sort_by { |project| project.created_at }.reverse
    when 'Ending at'
      @projects.sort_by { |project| project.end_date }
    when params[:catagory].titleize
      @projects
    end
  end

  def authorize_user_for_edit
    redirect_to :root unless user_authorized_for_edit?
  end

  def created_by_current_user?
    @is_owner ||= (current_project.user_id == current_user.id) if current_user
  end

  def user_authorized_for_edit?
    created_by_current_user? && !current_project.published?
  end

  def after_create
    current_user.profile_complete? ? (redirect_to :root, notice: t(:project_created)) : (redirect_to edit_user_url(current_user), notice: t(:request_profile_completion))
  end

  def load_project
    (redirect_to :root, notice: "Project Not Found") unless current_project
  end

  def current_project
    @project ||= Project.find_by(id: params[:id])
  end

  def load_projects
    @projects = admin? ? load_projects_for_current_page : load_user_projects
  end

  def load_user_projects
    params[:id] ? User.find_by(id: params[:id]).try(:projects) : current_user.projects
  end

  def load_projects_for_current_page
    Project.fetch_for_current_page(PROJECTS_PER_PAGE, params[:page]) if requested_page_valid?
  end

  def requested_page_valid?
    params[:page] <= @total_pages && params[:page] >= 1
  end

  def check_project_accessibility
    unless admin?
      (redirect_to :root, notice: 'Access Denied') unless project_accessible?
    end
  end

  def project_accessible?
    current_project.published? || created_by_current_user?
  end

  def set_pagination_defaults
    if admin?
      params[:page] = params[:page] ? params[:page].to_i : 1
      @total_pages = (Project.all.count.to_f / PROJECTS_PER_PAGE).ceil
    end
  end

  def build_project_attachments
    @project = Project.new
    @project.documents.build
    @project.images.build
  end

  def project_params
    params.require(:project).permit(:id, :kind, :title, :description, :end_date, :total_amount, :video_link, :user_minimum_contribution,
                                      documents_attributes: [:attachment, :attachable_subtype, :id],
                                      images_attributes: [:attachment, :attachable_subtype, :id] )
  end

end