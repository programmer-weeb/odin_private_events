class Attendance < ApplicationRecord
  belongs_to :attendee,
             class_name: "User",
             foreign_key: :attendee_id,
             inverse_of: :attendances

  belongs_to :event,
             class_name: "Event",
             foreign_key: :event_id,
             inverse_of: :attendances

  validates :attendee_id, uniqueness: { scope: :event_id, message: "already signed up for this event" }
end
