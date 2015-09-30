module ProjectsHelper

  def add_link_to_publish(project)
    if admin?
      project.status.eql?('Published') ? add_ajax_link('Unpublish', project) : add_ajax_link('Publish', project)
    end
  end

  def add_link_to_cancel(project)
    status = project.status
    if admin? && !status.eql?('Expired') && !status.eql?('Completed')
      status.eql?('Canceled') ? add_ajax_link('Reopen', project) : add_ajax_link('Cancel', project)
    end
  end

  def add_ajax_link(text, project)
    link_to text, update_status_project_url(project), class: 'project state btn btn-primary'
  end

  def add_edit_button
    if user_authorized_for_edit?
      concat link_to 'Edit Project', edit_project_url(current_project), data: { 'disable-with': 'Processing..' }, class: "btn btn-primary"
    end
  end

  def add_donation_fields
    unless created_by_current_user?
      concat text_field_tag :invested_amount, "", project_id: @project.id,
                            minimum: @project.user_minimum_contribution,
                            maximum: @project.user_maximum_contribution,
                            placeholder: "#{@project.user_minimum_contribution} <= amount <= #{@project.user_maximum_contribution}"
      concat "      "
      concat link_to t(:invest), 'javascript:', class: "btn btn-primary", id: 'invest_button', url: new_transaction_for_project_url(@project)
    end
  end

  def insert_delete_image(comment)
    if admin?
      link_to(image_tag("delete-icon", size: '10x10', class: 'delete_image'), comment_url(comment), method: :DELETE,
              data: { 'disable-with': 'Loading..' }, class: 'delete_comment')
    end
  end

  def add_load_more_button
    offset = params[:offset] ? params[:offset].to_i + 1 : 1
    link_to 'Load More', catagory_projects_url(params[:catagory], offset: offset),
              class: 'load btn btn-primary'
  end

  def get_commentor_name(comment)
    (comment.name && comment.name.humanize) || comment.user.name.humanize
  end

end