module LinkHelper
  def link_to_project(project, link_text = nil)
    if project.present?
      link_to_if(project.title, link_text || project.title, project_path(project), :class => 'project_link')
    elsif link_text.present?
      link_text
    end
  end

  def image_link_to_project(project, size_or_image)
    if size_or_image.to_s =~ /\.(jpg|jpeg|gif|png)$/i
      image = size_or_image
      size = nil
    else
      image = nil
      size = size_or_image
    end
    
    if project.present?
      img = image_tag(image || project.avatar_url(size), :alt => project.title)
      link_to_if(project.title, img, project_path(project))
    elsif image.present?
      image_tag(image)
    end
  end
  
    def link_to_service(service, link_text = nil)
    if service.present?
      link_to_if(service.title, link_text || service.title, service_path(service), :class => 'project_link')
    elsif link_text.present?
      link_text
    end
  end

  def image_link_to_service(service, size_or_image)
    if size_or_image.to_s =~ /\.(jpg|jpeg|gif|png)$/i
      image = size_or_image
      size = nil
    else
      image = nil
      size = size_or_image
    end
    
    if service.present?
      img = image_tag(image || service.avatar_url(size), :alt => service.title)
      link_to_if(service.title, img, service_path(service))
    elsif image.present?
      image_tag(image)
    end
  end


  def link_to_profile(profile)
    if profile.present?
      link_to_if(logged_in?, profile.name, profile_path(profile), :class => 'profile_link')
    end
  end

  def image_link_to_profile(profile, size)
    width, height = *(profile.avatar.versions[size].class.processors.first.second)
    img = image_tag(profile.avatar.url(size), :alt => profile.name, :width => width, :height => height)
    link_to_if(profile.name, img, profile_path(profile), :class => 'img_link', :title => profile.name)
  end
  
  def current_section
    @section
  end

  def link_to_section(section, href, enclosing_tag = nil, tag_options = {})
    if section.is_a?(Array)
      section, section_text = *section
    else
      section_text = section.to_s
    end

    link = link_to section_text, href

    if enclosing_tag.present?
      content_tag(enclosing_tag, tag_options.merge(:class => (section.to_s == current_section.to_s ? 'current' : ''))) {
        link
      }
    else
      link
    end
  end
end