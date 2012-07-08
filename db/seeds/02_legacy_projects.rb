puts "Seeding projects and owner rights from legacy projects..."

LegacyProject.find_each do |p|
  username    = LegacyUser.find_by_id( p.owner.to_i ).try( :username ) || next
  profile     = Profile.find_by_username( username ) || next
  description = ( p.description.nil? || p.description.blank? ) ?
    "(No description provided.)" : p.description

  short_description = description[0..149]
  short_description = short_description.gsub(/[^\.]*$/, '') if short_description.length == 150
  short_description = description[0..145].gsub(/\s+[^\s]*/, '').concat(" ...") if short_description.blank?
  short_description = "This project needs short_description entered for it." if short_description.blank?

  print "  ... processing #{p.title}: "

  project  = Project.create!(
    :active             => p.ispublished,
    :short_description  => short_description,
    :description        => description,
    :current_resources  => p.haves,
    :resources_needed   => p.needs,
    :title              => p.title,
    :slug               => p.title.to_slug,
    :membership_status  => Project::MEMBERSHIP_STATUS_OPEN )

  membership = Membership.new(
    :profile            => profile,
    :project            => project,
    :originator         => true ).save

  puts "Done."
end
