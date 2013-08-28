class Analytics < ActiveRecord::Base
  attr_accessible :action, :category, :description, :group, :time, :url, :user_id

  def self.to_csv(options = {})
  CSV.generate(options) do |csv|
    csv << column_names
    all.each do |analytics|
      csv << analytics.attributes.values_at(*column_names)
    end
  end
end
end
