class EventsSerializer < ActiveModel::Serializer
  attributes :id, :name, :is_started, :is_completed, :is_published, :is_deleted, :owner
  self.root = false

  def owner
    User.find(object[:owner_id])
  end

end
