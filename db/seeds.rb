# Clear existing data
puts "Cleaning database..."
Attendance.destroy_all
Event.destroy_all
User.destroy_all

puts "Creating users..."
users = []

# Create a main test user for the user to login with easily
users << User.create!(
  email: "test@example.com",
  password: "password",
  password_confirmation: "password"
)

# Create 9 more random users
9.times do
  users << User.create!(
    email: Faker::Internet.unique.email,
    password: "password",
    password_confirmation: "password"
  )
end

puts "Creating events..."
# Each user creates 2-4 events
users.each do |user|
  rand(2..4).times do
    # Mix of past and future events
    event_date = Faker::Time.between(from: 2.weeks.ago, to: 1.month.from_now)
    
    user.created_events.create!(
      title: "#{Faker::Commerce.product_name} #{%w[Launch Party Meetup Workshop Gala].sample}",
      description: Faker::Lorem.paragraphs(number: 3).join("\n\n"),
      event_date: event_date,
      location: "#{Faker::Address.community}, #{Faker::Address.city}"
    )
  end
end

puts "Creating attendances..."
# Randomly assign users to attend events they didn't create
all_events = Event.all
users.each do |user|
  # Attend 4-8 random events created by others
  potential_events = all_events.where.not(creator_id: user.id)
  potential_events.sample(rand(4..8)).each do |event|
    Attendance.create!(attendee: user, event: event)
  end
end

puts "Success! Seeded:"
puts "- #{User.count} Users"
puts "- #{Event.count} Events"
puts "- #{Attendance.count} Attendances"
puts "\nTest Login: test@example.com / password"
