xml.instruct!
xml.feed 'xmlns' => 'http://www.w3.org/2005/Atom' do
  xml.id service_url(@service)
  xml.title "#{@service.title} Recent Activity"
  xml.updated (@activities.first ? @activities.first.updated_at.xmlschema : Time.now.xmlschema)
  xml.link :href => service_url(@service, :format => "atom"), :rel => 'self'

  @activities.each do |activity|
    if activity.subject
      xml.entry do
        xml.id "tag:originalprojects.com,#{activity.updated_at.strftime("%Y-%m-%d")}:#{activity.id}"
        xml.updated activity.updated_at.xmlschema
        xml.link :href => service_url(@service, :anchor => "comments")
        xml.title "New #{activity.subject_type.gsub("Interest", "Follower")}" # pull this into a to_activity method if
                                                                              # more classes than Interest ever need it.
        xml.author do
          xml.name activity.profile.try(:name) || "Original Projects"
        end

        xml.content(:type => 'html') do
          xml.text! activity_to_html(activity)
        end
      end
    end
  end
end