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
  name: "Erste Fahrt",
  description: "Erste hochgeladene Fahrt.",
  custom_fields: { image: 'plus.png', points: '5' }
})
Merit::Badge.create! ({
  id: 2,
  name: "50 km",
  description: "50 km Fahren mit OBDComm.",
  custom_fields: { image: '50.png', points: '5' }
})
Merit::Badge.create! ({
  id: 3,
  name: "100 km",
  description: "100 km Fahren mit OBDComm.",
  custom_fields: { image: '100.png', points: '5' }
})
Merit::Badge.create! ({
  id: 4,
  name: "500 km",
  description: "500 km Fahren mit OBDComm.",
  custom_fields: { image: '500.png', points: '5' }
})
Merit::Badge.create! ({
  id: 5,
  name: "1000 km",
  description: "1000 km Fahren mit OBDComm.",
  custom_fields: { image: '1000.png', points: '5' }
})
Merit::Badge.create! ({
  id: 6,
  name: "CO2 beste 25%",
  description: "CO2 Emissionen sind niedriger als die von 75% der anderen Fahrer.",
  custom_fields: { image: 'shoot.png', points: '5' }
})
Merit::Badge.create! ({
  id: 7,
  name: "CO2 beste 50%",
  description: "CO2 Emissionen sind niedriger als die von 50% der anderen Fahrer.",
  custom_fields: { image: 'nut.png', points: '3' }
})
Merit::Badge.create! ({
  id: 8,
  name: "CO2 Bester",
  description: "Die niedrigsten CO2 Emissionen aller Fahrer diese Woche.",
  custom_fields: { image: 'tree.png', points: '8' }
})
Merit::Badge.create! ({
  id: 9,
  name: "Verbrauch beste 25%",
  description: "Benzinverbrauch niedriger als bei 75% der anderen Fahrer.",
  custom_fields: { image: 'silver.png', points: '5' }
})
Merit::Badge.create! ({
  id: 10,
  name: "Verbrauch beste 50%",
  description: "Benzinverbrauch niedriger als bei 50% der anderen Fahrer.",
  custom_fields: { image: 'bronze.png', points: '3' }
})
Merit::Badge.create! ({
  id: 11,
  name: "Verbrauch Bester",
  description: "Niedrigster Benzinverbrauch aller Fahrer diese Woche.",
  custom_fields: { image: 'gold.png', points: '8' }
})
Merit::Badge.create! ({
  id: 12,
  name: "Gutes Schalten",
  description: "Gute Gangwechsel (Umdrehungen stets unter 3000 U/min).",
  custom_fields: { image: 'stumble.png', points: '3' }
})
Merit::Badge.create! ({
  id: 13,
  name: "Hervorragendes Schalten",
  description: "Sehr gute Gangwechsel (Umdrehungen stets unter 2500 U/min).",
  custom_fields: { image: 'star.png', points: '5' }
})
Merit::Badge.create! ({
  id: 14,
  name: "Gute Route",
  description: "Gute Strecke ohne viel Standzeit.",
  custom_fields: { image: 'linegraph.png', points: '3' }
})
Merit::Badge.create! ({
  id: 15,
  name: "Sanftes Bremsen",
  description: "Es wurde keine Energie durch zu abruptes Bremsen verschwendet.",
  custom_fields: { image: 'wheel.png', points: '3' }
})
Merit::Badge.create! ({
  id: 16,
  name: "Sanftes Beschleunigen",
  description: "Es wurde keine Energie durch zu schnelles Beschleunigen verschwendet.",
  custom_fields: { image: 'barchart.png', points: '3' }
})
Merit::Badge.create! ({
  id: 17,
  name: "Fahrt geteilt",
  description: "Teilen einer Fahrt.",
  custom_fields: { image: 'facebook.png', points: '5' }
})
Merit::Badge.create! ({
  id: 18,
  name: "2 Fahrten",
  description: "An 2 aufeinanderfolgenden Tagen eine Fahrt aufgenommen.",
  custom_fields: { image: 'calendar-2.png', points: '2' }
})
Merit::Badge.create! ({
  id: 19,
  name: "3 Fahrten",
  description: "An 3 aufeinanderfolgenden Tagen eine Fahrt aufgenommen.",
  custom_fields: { image: 'calendar-3.png', points: '3' }
})
Merit::Badge.create! ({
  id: 20,
  name: "4 Fahrten",
  description: "An 4 aufeinanderfolgenden Tagen eine Fahrt aufgenommen.",
  custom_fields: { image: 'calendar-4.png', points: '4' }
})
Merit::Badge.create! ({
  id: 21,
  name: "5 Fahrten",
  description: "An 5 aufeinanderfolgenden Tagen eine Fahrt aufgenommen.",
  custom_fields: { image: 'calendar-5.png', points: '5' }
})
Merit::Badge.create! ({
  id: 22,
  name: "6 Fahrten",
  description: "An 6 aufeinanderfolgenden Tagen eine Fahrt aufgenommen.",
  custom_fields: { image: 'calendar-6.png', points: '6' }
})
Merit::Badge.create! ({
  id: 23,
  name: "7 Fahrten",
  description: "An 7 aufeinanderfolgenden Tagen eine Fahrt aufgenommen.",
  custom_fields: { image: 'calendar-7.png', points: '7' }
})
Merit::Badge.create! ({
  id: 24,
  name: "Freundschaft",
  description: "Erste Freundeseinladung.",
  custom_fields: { image: 'adduser.png', points: '2' }
})
Merit::Badge.create! ({
  id: 25,
  name: "Erster Kommentar",
  description: "Schreiben eines Kommentares.",
  custom_fields: { image: 'pencil.png', points: '2' }
})
Merit::Badge.create! ({
  id: 26,
  name: "Kommentar bekommen",
  description: "Ersters Mal kommentiert werden.",
  custom_fields: { image: 'conversation.png', points: '2' }
})
Merit::Badge.create! ({
  id: 27,
  name: "Tester",
  description: "Offizieller Test-User",
  custom_fields: { image: 'heart.png', points: '0' }
})
Merit::Badge.create! ({
  id: 28,
  name: "Streckenmeister",
  description: "Am meisten gefahrene Kilometer aller Fahrer.",
  custom_fields: { image: 'globe.png', points: '5' }
})
