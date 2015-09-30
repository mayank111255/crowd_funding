module HomeHelper

  def generate_load_more_button
    offset = params[:offset] ? params[:offset].to_i + 1 : 2
    button_to 'Load More', :root, data: { 'disable-with': 'Loading..' }, class: 'load', filter: params[:filter], offset: offset, form: { :class => 'button' }
  end

  def name_projects_cache
    cache_name = ""
    @projects.each do |collection|
      last_updated_project = collection.max { |a,b| a.updated_at <=> b.updated_at }
      cache_name.concat(last_updated_project.updated_at.to_s) if last_updated_project
    end
    cache_name
  end
  
end