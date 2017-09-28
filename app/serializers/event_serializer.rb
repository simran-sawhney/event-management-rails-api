class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :duration, :is_started, :is_completed, :is_published, :is_deleted, :latitude, :longitude, :owner, :start_date, :description
  self.root = false

  def owner
    User.find(object[:owner_id])
  end

end
