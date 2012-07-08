module ProjectsHelper
  def originators(project)
    output = "#{pluralize_by_count("Originator", project.originators.count)}: "
    output << project.originators.map { |profile|
      if profile == current_profile then "YOU" else profile.name end
    }.to_sentence
    output
  end

  def follow_join_and_like_project_links(tag, project)
    output = []

    if current_profile.is_involved?(project)
      output << "You Are Participating in This Project"
    else
      if current_profile.is_following?(project)
        output << "You Are Following This Project"
      else
        output << link_to("Follow This Project", follow_project_path(project), :method => :post)
      end

      if project.has_open_membership?
        output << link_to("Join This Project", join_project_path(project), :method => :post)
      elsif project.has_invite_membership?
        if current_profile.requested_membership?(project)
          output << "You Have Requested To Join This Project"
        else
          output << link_to("Request To Join This Project", project_membership_requests_path(project), :method => :post)
        end
      end
    end

    like = current_profile.like_for(project)
    like_count = project.likes.count
    like_count_text = "(#{pluralize(like_count, "Like")})" if like_count > 0

    if like
      output << link_to("Unlike #{like_count_text}", project_like_url(project, like), :method => :delete)
    else
      output << link_to("I Like This #{like_count_text}", project_likes_url(project), :method => :post)
    end

    output.map { |link| content_tag(tag, link) }.join
  end

  def join_project_link(text, project)
    if project.has_open_membership?
      if !logged_in?
        link_to text, login_path
      elsif !current_profile.is_involved?(project)
        link_to text, join_project_path(project), :method => :post
      end
    end
  end
end
