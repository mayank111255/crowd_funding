module UsersHelper
  
  def generate_change_user_state_link(user)
    user.is_activated ? generate_ajax_href(t(:deactivate), user.id) : generate_ajax_href(t(:activate), user.id)
  end

  def generate_ajax_href(text, user_id)
    link_to(text, update_state_users_url, id: user_id, class: 'user state')
  end

  def no_of_documents
    @total_documents ||= @user.documents.size
  end

  def privileged?
  	admin? || (current_user.id == params[:id].to_i)
  end

end