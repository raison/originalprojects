class ActivityFeedObserver < ActiveRecord::Observer
  observe :membership, :attachment, :comment, :blog_entry, :remark

  def after_create(subject)
    activity = Activity.new(:subject => subject)
    activity.project = subject.project if subject.respond_to?(:project)
    activity.profile = subject.profile if subject.respond_to?(:profile)

    case subject
    when Membership then
      if subject.originator? and subject.project.originators.count == 1
        activity.subject = subject.project
      end
    when Attachment then
      if subject.attachable.is_a?(Project)
        activity.project = subject.attachable
      end
    when Remark then
      activity.project = subject.blog_entry.project
    end

    activity.save
  end
end
