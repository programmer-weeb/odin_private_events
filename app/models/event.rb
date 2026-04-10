class Event < ApplicationRecord
  belongs_to :creator,
             class_name: "User",
             foreign_key: :creator_id,
             inverse_of: :created_events

  has_many :attendances,
           foreign_key: :event_id,
           inverse_of: :event,
           dependent: :destroy

  has_many :attendees,
           through: :attendances,
           source: :attendee

  validates :title, presence: true
  validates :description, presence: true
  validates :event_date, presence: true
  validates :location, presence: true

  def self.past
    where("event_date < ?", Time.current)
  end

  def self.upcoming
    where("event_date >= ?", Time.current)
  end
end
