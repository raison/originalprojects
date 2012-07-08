module ServicesHelper
  def originators(service)
    output = "#{pluralize_by_count("Originator", service.originators.count)}: "
    output << service.originators.map { |profile|
      if profile == current_profile then "YOU" else profile.name end
    }.to_sentence
    output
  end

  def follow_join_and_like_service_links(tag, service)
    output = []

    if current_profile.is_involved?(service)
      output << "You Are Participating in This Service"
    else
      if current_profile.is_following?(service)
        output << "You Are Following This Service"
      else
        output << link_to("Follow This Service", follow_service_path(service), :method => :post)
      end

      if service.has_open_membership?
        output << link_to("Join This Service", join_service_path(service), :method => :post)
      elsif service.has_invite_membership?
        if current_profile.requested_membership?(service)
          output << "You Have Requested To Join This Service"
        else
          output << link_to("Request To Join This Service", service_membership_requests_path(service), :method => :post)
        end
      end
    end

    like = current_profile.like_for(service)
    like_count = service.likes.count
    like_count_text = "(#{pluralize(like_count, "Like")})" if like_count > 0

    if like
      output << link_to("Unlike #{like_count_text}", service_like_url(service, like), :method => :delete)
    else
      output << link_to("I Like This #{like_count_text}", service_likes_url(service), :method => :post)
    end

    output.map { |link| content_tag(tag, link) }.join
  end

  def join_service_link(text, service)
    if service.has_open_membership?
      if !logged_in?
        link_to text, login_path
      elsif !current_profile.is_involved?(service)
        link_to text, join_service_path(service), :method => :post
      end
    end
  end
end