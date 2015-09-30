module ApplicationHelper

  def add_pagination(url)
    concat generate_previous_button(url) if params[:page] > 1
    concat generate_next_button(url) if params[:page] < @total_pages
  end

  def generate_previous_button(url)
    button_to t(:previous), send(url, page: params[:page] - 1), method: :get
  end

  def generate_next_button(url)
    button_to t(:next), send(url, page: params[:page] + 1), method: :get
  end

  def user_name
    current_user.name.split(" ")[0].humanize if current_user
  end
  
end
