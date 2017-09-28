class Event < ApplicationRecord

  belongs_to :user, foreign_key: :owner_id
  alias :owner :user

  def self.create_new_event(event_params)
    event = Event.new(event_params)
    event.save
    event
  end

  def publish_event
    # assumption => publish will lead to start of event as well
    self.update_attributes!(:is_published => true, :is_started => true)
  end

  def stop_event
    self.update_attributes!(:is_completed => true, :is_published => false, :is_started => false)
  end

  def delete_event
    self.update_attributes!(:is_published => false, :is_started => false, :is_deleted => false)
  end

end
