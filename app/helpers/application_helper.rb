module ApplicationHelper

  def glyphicon_tag(glyph)
    content_tag(:span, "",  class: "glyphicon glyphicon-#{glyph}")
  end

  def glyphicon_submit_helper(glyph)
    button_tag(type: 'submit', class: 'btn btn-primary') do
      glyphicon_tag(glyph)
    end
  end

  def glyphicon_link_to(url, glyph='play-circle')
    link_to url, class: 'btn btn-link btn-glyph' do
      glyphicon_tag(glyph)
    end
  end

  def project_with_link(project)
    capture do
      concat content_tag(:span, project.name, class: 'project-name')
      concat ' '
      concat glyphicon_link_to project_path(project)
    end unless project.nil?
  end
  
  def profile_with_link(profile)
    capture do
      concat content_tag(:span, profile.full_name, class: 'profile-full-name')
      concat ' '
      concat glyphicon_link_to detect_profile_path(profile)
    end unless profile.nil?
  end

  def ensure_http_scheme(url)
    uri = URI.parse(url)
    if (!uri.scheme)
      url = 'http://' + url
    end
    return url
  end

  def detect_profile_path(profile)
    return coordinator_path(profile) if profile.is_coordinator?
    return fellow_path(profile) if profile.is_fellow?
    return volunteer_path(profile) if profile.is_volunteer?
    return applicant_path(profile) if profile.is_applicant?
  end

  def sanitize_html_area(html)
    # TODO: actually sanitize the html
    (html || '').html_safe
  end

  def options_for_project_status
    capture do 
      Rails.configuration.x.project_status.each do |(k,v)|
        concat content_tag(:option, v["status"], value: k)
      end
    end
  end

  def project_status_tag(project, tag)
    clazz = "project-status"
    statuses = Rails.configuration.x.project_status
    if !project.nil? and statuses.has_key? project.status
      clazz = "#{clazz} project-status-#{statuses[project.status]["status"].parameterize.underscore}"
    end
    content_tag(tag, class: clazz) do
      yield if block_given?
    end
  end

  def project_urgency_badge(project)
    return if project.nil?
    text_badge_for_value(project.urgency, Rails.configuration.x.project_urgency)
  end
  
  def project_priority_badge(project)
    return if project.nil?
    text_badge_for_value(project.priority, Rails.configuration.x.project_priority)
  end

  def project_status_badge(project)
    return if project.nil?
    text_badge_for_value(project.status, Rails.configuration.x.project_status)
  end

  def text_badge_for_value(value, collection)
    text, textcolor, bgcolor = text_and_colors_for_value(value, collection)
    content_tag(:span, text, class: "label", style: "color: #{textcolor}; background-color: #{bgcolor}")
  end

  def text_and_colors_for_value(value, collection)
    text = value.to_s
    textcolor = 'black'
    bgcolor = 'white'
    if collection.has_key? value
      text = collection[value]["text"] || text
      textcolor = collection[value]["textcolor"] || textcolor
      bgcolor = collection[value]["bgcolor"] || bgcolor
    end
    return text, textcolor, bgcolor
  end

end
