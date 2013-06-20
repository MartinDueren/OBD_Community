class AddPostgisToDatabase < ActiveRecord::Migration
  def change
  	execute("CREATE EXTENSION postgis;")
  end
end
