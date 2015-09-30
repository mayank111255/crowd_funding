class CommentsController < ApplicationController
  before_action :authorize_user, :load_project, only: [:create]

  def create
    @project.comments.create(comment_params) ? (head 200) : (head 406)
  end

  def destroy
    Comment.remove(params[:id]) ? (head 200) : (head 404)
  end

private
  
  def authorize_user
    head status: 401 unless valid_user?
  end

  def valid_user?
    current_user || params[:email].present?
  end
  
  def load_project
    head 404 unless @project = Project.find_by(id: params[:project_id])
  end

  def comment_params
    if current_user
      params.merge!(user_id: current_user.id)
      params.permit(:user_id, :description, :project_id)
    else
      params.permit( :name, :email, :description, :project_id)
    end
  end

end