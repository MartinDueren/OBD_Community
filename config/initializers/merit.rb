# Use this hook to configure merit parameters
Merit.setup do |config|
  # Check rules on each request or in background
  # config.checks_on_each_request = true

  # Define ORM. Could be :active_record (default) and :mongo_mapper and :mongoid
  # config.orm = :active_record

  # Define :user_model_name. This model will be used to grand badge if no :to option is given. Default is "User".
  # config.user_model_name = "User"

  # Define :current_user_method. Similar to previous option. It will be used to retrieve :user_model_name object if no :to option is given. Default is "current_#{user_model_name.downcase}".
  # config.current_user_method = "current_user"
end

# Create application badges (uses https://github.com/norman/ambry)
# Merit::Badge.create!({
#   id: 1,
#   name: 'just-registered'
# }, {
#   id: 2,
#   name: 'best-unicorn',
#   custom_fields: { category: 'fantasy' }
# })

Merit::Badge.create! ({
  id: 1,
  name: "first-trip",
  description: "Uploaded a trip!",
  custom_fields: { image: 'plus.png' }
})
Merit::Badge.create! ({
  id: 2,
  name: "50-km",
  description: "You have driven 50 Km using OBDComm!",
  custom_fields: { image: '50.png' }
})
Merit::Badge.create! ({
  id: 3,
  name: "100-km",
  description: "You have driven 100 Km using OBDComm!",
  custom_fields: { image: '100.png' }
})
Merit::Badge.create! ({
  id: 4,
  name: "500-km",
  description: "You have driven 500 Km using OBDComm!",
  custom_fields: { image: '500.png' }
})
Merit::Badge.create! ({
  id: 5,
  name: "1000-km",
  description: "You have driven 1000 Km using OBDComm!",
  custom_fields: { image: '1000.png' }
})
Merit::Badge.create! ({
  id: 6,
  name: "co2-75",
  description: "CO2 emissions lower than 75% of other users.",
  custom_fields: { image: 'shoot.png' }
})
Merit::Badge.create! ({
  id: 7,
  name: "co2-50",
  description: "CO2 emissions lower than 50% of other users.",
  custom_fields: { image: 'nut.png' }
})
Merit::Badge.create! ({
  id: 8,
  name: "co2-lowest",
  description: "Lowest CO2 emissions from all drivers this week.",
  custom_fields: { image: 'tree.png' }
})
Merit::Badge.create! ({
  id: 9,
  name: "fuel-75",
  description: "Fuel consumption lower than 75% of other users.",
  custom_fields: { image: 'silver.png' }
})
Merit::Badge.create! ({
  id: 10,
  name: "fuel-50",
  description: "Fuel consumption lower than 50% of other users.",
  custom_fields: { image: 'bronze.png' }
})
Merit::Badge.create! ({
  id: 11,
  name: "fuel-lowest",
  description: "Lowest fuel consumtpion of all users this week.",
  custom_fields: { image: 'gold.png' }
})
Merit::Badge.create! ({
  id: 12,
  name: "good-shifting",
  description: "Good gear shifting.",
  custom_fields: { image: 'stumble.png' }
})
Merit::Badge.create! ({
  id: 13,
  name: "awesome-shifting",
  description: "Awesome gear shifting!",
  custom_fields: { image: 'star.png' }
})
Merit::Badge.create! ({
  id: 14,
  name: "good-route",
  description: "Awesome you choose great routes without much standing time.",
  custom_fields: { image: 'linegraph.png' }
})
Merit::Badge.create! ({
  id: 15,
  name: "smooth-braking",
  description: "Did not waste energy by braking too hard.",
  custom_fields: { image: 'wheel.png' }
})
Merit::Badge.create! ({
  id: 16,
  name: "smooth-acceleration",
  description: "Did not waste energy by accelerating too hard.",
  custom_fields: { image: 'barchart.png' }
})
Merit::Badge.create! ({
  id: 17,
  name: "shared-trip",
  description: "Shared a trip.",
  custom_fields: { image: 'facebook.png' }
})
Merit::Badge.create! ({
  id: 18,
  name: "consecutive-trips-2",
  description: "Logged trips on two consecutive days.",
  custom_fields: { image: 'calendar-2.png' }
})
Merit::Badge.create! ({
  id: 19,
  name: "consecutive-trips-3",
  description: "Logged trips on three consecutive days.",
  custom_fields: { image: 'calendar-3.png' }
})
Merit::Badge.create! ({
  id: 20,
  name: "consecutive-trips-4",
  description: "Logged trips on four consecutive days.",
  custom_fields: { image: 'calendar-4.png' }
})
Merit::Badge.create! ({
  id: 21,
  name: "consecutive-trips-5",
  description: "Logged trips on five consecutive days.",
  custom_fields: { image: 'calendar-5.png' }
})
Merit::Badge.create! ({
  id: 22,
  name: "consecutive-trips-6",
  description: "Logged trips on six consecutive days.",
  custom_fields: { image: 'calendar-6.png' }
})
Merit::Badge.create! ({
  id: 23,
  name: "consecutive-trips-7",
  description: "Logged trips on seven consecutive days.",
  custom_fields: { image: 'calendar-7.png' }
})
Merit::Badge.create! ({
  id: 24,
  name: "first-friend",
  description: "Added a friend.",
  custom_fields: { image: 'adduser.png' }
})
Merit::Badge.create! ({
  id: 25,
  name: "first-comment",
  description: "Commented on something.",
  custom_fields: { image: 'pencil.png' }
})
Merit::Badge.create! ({
  id: 26,
  name: "got-comment",
  description: "Got a comment on something.",
  custom_fields: { image: 'conversation.png' }
})
Merit::Badge.create! ({
  id: 27,
  name: "test-user",
  description: "Official test user.",
  custom_fields: { image: 'heart.png' }
})
Merit::Badge.create! ({
  id: 28,
  name: "most-miles",
  description: "Mileage leader.",
  custom_fields: { image: 'globe.png' }
})
