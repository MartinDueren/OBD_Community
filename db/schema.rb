# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130711105936) do

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.string   "action",     :limit => 50
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at"
  end

  add_index "activities", ["created_at"], :name => "index_activities_on_created_at"
  add_index "activities", ["user_id"], :name => "index_activities_on_user_id"

  create_table "ads", :force => true do |t|
    t.string   "name"
    t.text     "html"
    t.integer  "frequency"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "location"
    t.boolean  "published",        :default => false
    t.boolean  "time_constrained", :default => false
    t.string   "audience",         :default => "all"
  end

  create_table "albums", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "view_count"
  end

  create_table "assets", :force => true do |t|
    t.string   "asset_file_name"
    t.integer  "width"
    t.integer  "height"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.string   "attachable_type"
    t.integer  "attachable_id"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "thumbnail"
    t.integer  "parent_id"
    t.datetime "asset_updated_at"
  end

  create_table "authorizations", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "nickname"
    t.string   "email"
    t.string   "picture_url"
    t.string   "access_token"
    t.string   "access_token_secret"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "badges_sashes", :force => true do |t|
    t.integer  "badge_id"
    t.integer  "sash_id"
    t.boolean  "notified_user", :default => false
    t.datetime "created_at"
  end

  add_index "badges_sashes", ["badge_id", "sash_id"], :name => "index_badges_sashes_on_badge_id_and_sash_id"
  add_index "badges_sashes", ["badge_id"], :name => "index_badges_sashes_on_badge_id"
  add_index "badges_sashes", ["sash_id"], :name => "index_badges_sashes_on_sash_id"

  create_table "cars", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "categories", :force => true do |t|
    t.string "name"
    t.text   "tips"
    t.string "new_post_text"
    t.string "nav_text"
  end

  create_table "choices", :force => true do |t|
    t.integer "poll_id"
    t.string  "description"
    t.integer "votes_count", :default => 0
  end

  create_table "clippings", :force => true do |t|
    t.string   "url"
    t.integer  "user_id"
    t.string   "image_url"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "favorited_count", :default => 0
  end

  add_index "clippings", ["created_at"], :name => "index_clippings_on_created_at"

  create_table "comments", :force => true do |t|
    t.string   "title"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.integer  "recipient_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.text     "comment"
    t.string   "author_name"
    t.string   "author_email"
    t.string   "author_url"
    t.string   "author_ip"
    t.boolean  "notify_by_email",  :default => true
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["created_at"], :name => "index_comments_on_created_at"
  add_index "comments", ["recipient_id"], :name => "index_comments_on_recipient_id"
  add_index "comments", ["user_id"], :name => "fk_comments_user"

  create_table "countries", :force => true do |t|
    t.string "name"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "events", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "description"
    t.integer  "metro_area_id"
    t.string   "location"
    t.boolean  "allow_rsvp",    :default => true
  end

  create_table "favorites", :force => true do |t|
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "favoritable_type"
    t.integer  "favoritable_id"
    t.integer  "user_id"
    t.string   "ip_address",       :default => ""
  end

  add_index "favorites", ["user_id"], :name => "fk_favorites_user"

  create_table "forums", :force => true do |t|
    t.string  "name"
    t.string  "description"
    t.integer "topics_count",     :default => 0
    t.integer "sb_posts_count",   :default => 0
    t.integer "position"
    t.text    "description_html"
    t.string  "owner_type"
    t.integer "owner_id"
  end

  create_table "friendship_statuses", :force => true do |t|
    t.string "name"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "friend_id"
    t.integer  "user_id"
    t.boolean  "initiator",            :default => false
    t.datetime "created_at"
    t.integer  "friendship_status_id"
  end

  add_index "friendships", ["friendship_status_id"], :name => "index_friendships_on_friendship_status_id"
  add_index "friendships", ["user_id"], :name => "index_friendships_on_user_id"

  create_table "garages", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "homepage_features", :force => true do |t|
    t.datetime "created_at"
    t.string   "url"
    t.string   "title"
    t.text     "description"
    t.datetime "updated_at"
    t.string   "image_content_type"
    t.string   "image_file_name"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "image_file_size"
    t.integer  "width"
    t.integer  "height"
    t.datetime "image_updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.string   "email_addresses"
    t.string   "message"
    t.integer  "user_id"
    t.datetime "created_at"
  end

  create_table "measurements", :force => true do |t|
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.integer  "trip_id"
    t.integer  "rpm"
    t.float    "speed"
    t.float    "maf"
    t.string   "fuel_type"
    t.datetime "recorded_at"
    t.integer  "map"
    t.integer  "iat"
    t.float    "imap"
    t.integer  "ve"
    t.integer  "ed"
    t.spatial  "latlon",      :limit => {:srid=>4326, :type=>"point"}
    t.float    "consumption"
    t.float    "co2"
  end

  add_index "measurements", ["latlon"], :name => "index_measurements_on_latlon", :spatial => true

  create_table "merit_actions", :force => true do |t|
    t.integer  "user_id"
    t.string   "action_method"
    t.integer  "action_value"
    t.boolean  "had_errors",    :default => false
    t.string   "target_model"
    t.integer  "target_id"
    t.boolean  "processed",     :default => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "merit_activity_logs", :force => true do |t|
    t.integer  "action_id"
    t.string   "related_change_type"
    t.integer  "related_change_id"
    t.string   "description"
    t.datetime "created_at"
  end

  create_table "merit_score_points", :force => true do |t|
    t.integer  "score_id"
    t.integer  "num_points", :default => 0
    t.string   "log"
    t.datetime "created_at"
  end

  create_table "merit_scores", :force => true do |t|
    t.integer "sash_id"
    t.string  "category", :default => "default"
  end

  create_table "message_threads", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "message_id"
    t.integer  "parent_message_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.boolean  "sender_deleted",    :default => false
    t.boolean  "recipient_deleted", :default => false
    t.string   "subject"
    t.text     "body"
    t.datetime "read_at"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.integer  "parent_id"
  end

  create_table "metro_areas", :force => true do |t|
    t.string  "name"
    t.integer "state_id"
    t.integer "country_id"
    t.integer "users_count", :default => 0
  end

  create_table "moderatorships", :force => true do |t|
    t.integer "forum_id"
    t.integer "user_id"
  end

  add_index "moderatorships", ["forum_id"], :name => "index_moderatorships_on_forum_id"

  create_table "monitorships", :force => true do |t|
    t.integer "topic_id"
    t.integer "user_id"
    t.boolean "active",   :default => true
  end

  create_table "osm_lines", :force => true do |t|
    t.datetime "created_at",                                                                  :null => false
    t.datetime "updated_at",                                                                  :null => false
    t.integer  "measurement_count",                                          :default => 0
    t.integer  "avg_speed",                                                  :default => 0
    t.integer  "avg_rpm",                                                    :default => 0
    t.float    "avg_co2",                                                    :default => 0.0
    t.float    "avg_consumption",                                            :default => 0.0
    t.integer  "max_speed",                                                  :default => 0
    t.integer  "avg_standing_time",                                          :default => 0
    t.spatial  "geom",              :limit => {:srid=>0, :type=>"geometry"}
    t.text     "highway"
  end

  add_index "osm_lines", ["geom"], :name => "index_osm_lines_on_geom", :spatial => true

  create_table "osm_roads", :force => true do |t|
    t.datetime "created_at",                                                                  :null => false
    t.datetime "updated_at",                                                                  :null => false
    t.integer  "measurement_count",                                          :default => 0
    t.integer  "avg_speed",                                                  :default => 0
    t.integer  "avg_rpm",                                                    :default => 0
    t.float    "avg_co2",                                                    :default => 0.0
    t.float    "avg_consumption",                                            :default => 0.0
    t.integer  "max_speed",                                                  :default => 0
    t.integer  "avg_standing_time",                                          :default => 0
    t.spatial  "geom",              :limit => {:srid=>0, :type=>"geometry"}
    t.text     "highway"
  end

  add_index "osm_roads", ["geom"], :name => "index_osm_roads_on_geom", :spatial => true

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "published_as", :limit => 16, :default => "draft"
    t.boolean  "page_public",                :default => true
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  create_table "photos", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "photo_content_type"
    t.string   "photo_file_name"
    t.integer  "photo_file_size"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "width"
    t.integer  "height"
    t.integer  "album_id"
    t.integer  "view_count"
    t.datetime "photo_updated_at"
  end

  add_index "photos", ["created_at"], :name => "index_photos_on_created_at"
  add_index "photos", ["parent_id"], :name => "index_photos_on_parent_id"

  create_table "planet_osm_line", :id => false, :force => true do |t|
    t.integer "osm_id",             :limit => 8
    t.text    "access"
    t.text    "addr:housename"
    t.text    "addr:housenumber"
    t.text    "addr:interpolation"
    t.text    "admin_level"
    t.text    "aerialway"
    t.text    "aeroway"
    t.text    "amenity"
    t.text    "area"
    t.text    "barrier"
    t.text    "bicycle"
    t.text    "brand"
    t.text    "bridge"
    t.text    "boundary"
    t.text    "building"
    t.text    "construction"
    t.text    "covered"
    t.text    "culvert"
    t.text    "cutting"
    t.text    "denomination"
    t.text    "disused"
    t.text    "embankment"
    t.text    "foot"
    t.text    "generator:source"
    t.text    "harbour"
    t.text    "highway"
    t.text    "historic"
    t.text    "horse"
    t.text    "intermittent"
    t.text    "junction"
    t.text    "landuse"
    t.text    "layer"
    t.text    "leisure"
    t.text    "lock"
    t.text    "man_made"
    t.text    "military"
    t.text    "motorcar"
    t.text    "name"
    t.text    "natural"
    t.text    "oneway"
    t.text    "operator"
    t.text    "population"
    t.text    "power"
    t.text    "power_source"
    t.text    "place"
    t.text    "railway"
    t.text    "ref"
    t.text    "religion"
    t.text    "route"
    t.text    "service"
    t.text    "shop"
    t.text    "sport"
    t.text    "surface"
    t.text    "toll"
    t.text    "tourism"
    t.text    "tower:type"
    t.text    "tracktype"
    t.text    "tunnel"
    t.text    "water"
    t.text    "waterway"
    t.text    "wetland"
    t.text    "width"
    t.text    "wood"
    t.integer "z_order"
    t.float   "way_area"
    t.spatial "way",                :limit => {:srid=>4326, :type=>"line_string"}
  end

  add_index "planet_osm_line", ["osm_id"], :name => "planet_osm_line_pkey"
  add_index "planet_osm_line", ["way"], :name => "planet_osm_line_index", :spatial => true

  create_table "planet_osm_nodes", :id => false, :force => true do |t|
    t.integer "id",   :limit => 8,   :null => false
    t.integer "lat",                 :null => false
    t.integer "lon",                 :null => false
    t.string  "tags", :limit => nil
  end

  create_table "planet_osm_point", :id => false, :force => true do |t|
    t.integer "osm_id",             :limit => 8
    t.text    "access"
    t.text    "addr:housename"
    t.text    "addr:housenumber"
    t.text    "addr:interpolation"
    t.text    "admin_level"
    t.text    "aerialway"
    t.text    "aeroway"
    t.text    "amenity"
    t.text    "area"
    t.text    "barrier"
    t.text    "bicycle"
    t.text    "brand"
    t.text    "bridge"
    t.text    "boundary"
    t.text    "building"
    t.text    "capital"
    t.text    "construction"
    t.text    "covered"
    t.text    "culvert"
    t.text    "cutting"
    t.text    "denomination"
    t.text    "disused"
    t.text    "ele"
    t.text    "embankment"
    t.text    "foot"
    t.text    "generator:source"
    t.text    "harbour"
    t.text    "highway"
    t.text    "historic"
    t.text    "horse"
    t.text    "intermittent"
    t.text    "junction"
    t.text    "landuse"
    t.text    "layer"
    t.text    "leisure"
    t.text    "lock"
    t.text    "man_made"
    t.text    "military"
    t.text    "motorcar"
    t.text    "name"
    t.text    "natural"
    t.text    "oneway"
    t.text    "operator"
    t.text    "poi"
    t.text    "population"
    t.text    "power"
    t.text    "power_source"
    t.text    "place"
    t.text    "railway"
    t.text    "ref"
    t.text    "religion"
    t.text    "route"
    t.text    "service"
    t.text    "shop"
    t.text    "sport"
    t.text    "surface"
    t.text    "toll"
    t.text    "tourism"
    t.text    "tower:type"
    t.text    "tunnel"
    t.text    "water"
    t.text    "waterway"
    t.text    "wetland"
    t.text    "width"
    t.text    "wood"
    t.integer "z_order"
    t.spatial "way",                :limit => {:srid=>900913, :type=>"point"}
  end

  add_index "planet_osm_point", ["osm_id"], :name => "planet_osm_point_pkey"
  add_index "planet_osm_point", ["way"], :name => "planet_osm_point_index", :spatial => true

  create_table "planet_osm_polygon", :id => false, :force => true do |t|
    t.integer "osm_id",             :limit => 8
    t.text    "access"
    t.text    "addr:housename"
    t.text    "addr:housenumber"
    t.text    "addr:interpolation"
    t.text    "admin_level"
    t.text    "aerialway"
    t.text    "aeroway"
    t.text    "amenity"
    t.text    "area"
    t.text    "barrier"
    t.text    "bicycle"
    t.text    "brand"
    t.text    "bridge"
    t.text    "boundary"
    t.text    "building"
    t.text    "construction"
    t.text    "covered"
    t.text    "culvert"
    t.text    "cutting"
    t.text    "denomination"
    t.text    "disused"
    t.text    "embankment"
    t.text    "foot"
    t.text    "generator:source"
    t.text    "harbour"
    t.text    "highway"
    t.text    "historic"
    t.text    "horse"
    t.text    "intermittent"
    t.text    "junction"
    t.text    "landuse"
    t.text    "layer"
    t.text    "leisure"
    t.text    "lock"
    t.text    "man_made"
    t.text    "military"
    t.text    "motorcar"
    t.text    "name"
    t.text    "natural"
    t.text    "oneway"
    t.text    "operator"
    t.text    "population"
    t.text    "power"
    t.text    "power_source"
    t.text    "place"
    t.text    "railway"
    t.text    "ref"
    t.text    "religion"
    t.text    "route"
    t.text    "service"
    t.text    "shop"
    t.text    "sport"
    t.text    "surface"
    t.text    "toll"
    t.text    "tourism"
    t.text    "tower:type"
    t.text    "tracktype"
    t.text    "tunnel"
    t.text    "water"
    t.text    "waterway"
    t.text    "wetland"
    t.text    "width"
    t.text    "wood"
    t.integer "z_order"
    t.float   "way_area"
    t.spatial "way",                :limit => {:srid=>900913, :type=>"geometry"}
  end

  add_index "planet_osm_polygon", ["osm_id"], :name => "planet_osm_polygon_pkey"
  add_index "planet_osm_polygon", ["way"], :name => "planet_osm_polygon_index", :spatial => true

  create_table "planet_osm_rels", :id => false, :force => true do |t|
    t.integer "id",      :limit => 8,   :null => false
    t.integer "way_off", :limit => 2
    t.integer "rel_off", :limit => 2
    t.string  "parts",   :limit => 8
    t.string  "members", :limit => nil
    t.string  "tags",    :limit => nil
    t.boolean "pending",                :null => false
  end

  add_index "planet_osm_rels", ["id"], :name => "planet_osm_rels_idx"
  add_index "planet_osm_rels", ["parts"], :name => "planet_osm_rels_parts"

  create_table "planet_osm_roads", :id => false, :force => true do |t|
    t.integer "osm_id",             :limit => 8
    t.text    "access"
    t.text    "addr:housename"
    t.text    "addr:housenumber"
    t.text    "addr:interpolation"
    t.text    "admin_level"
    t.text    "aerialway"
    t.text    "aeroway"
    t.text    "amenity"
    t.text    "area"
    t.text    "barrier"
    t.text    "bicycle"
    t.text    "brand"
    t.text    "bridge"
    t.text    "boundary"
    t.text    "building"
    t.text    "construction"
    t.text    "covered"
    t.text    "culvert"
    t.text    "cutting"
    t.text    "denomination"
    t.text    "disused"
    t.text    "embankment"
    t.text    "foot"
    t.text    "generator:source"
    t.text    "harbour"
    t.text    "highway"
    t.text    "historic"
    t.text    "horse"
    t.text    "intermittent"
    t.text    "junction"
    t.text    "landuse"
    t.text    "layer"
    t.text    "leisure"
    t.text    "lock"
    t.text    "man_made"
    t.text    "military"
    t.text    "motorcar"
    t.text    "name"
    t.text    "natural"
    t.text    "oneway"
    t.text    "operator"
    t.text    "population"
    t.text    "power"
    t.text    "power_source"
    t.text    "place"
    t.text    "railway"
    t.text    "ref"
    t.text    "religion"
    t.text    "route"
    t.text    "service"
    t.text    "shop"
    t.text    "sport"
    t.text    "surface"
    t.text    "toll"
    t.text    "tourism"
    t.text    "tower:type"
    t.text    "tracktype"
    t.text    "tunnel"
    t.text    "water"
    t.text    "waterway"
    t.text    "wetland"
    t.text    "width"
    t.text    "wood"
    t.integer "z_order"
    t.float   "way_area"
    t.spatial "way",                :limit => {:srid=>4326, :type=>"line_string"}
  end

  add_index "planet_osm_roads", ["osm_id"], :name => "planet_osm_roads_pkey"
  add_index "planet_osm_roads", ["way"], :name => "planet_osm_roads_index", :spatial => true

  create_table "planet_osm_ways", :id => false, :force => true do |t|
    t.integer "id",      :limit => 8,   :null => false
    t.string  "nodes",   :limit => 8,   :null => false
    t.string  "tags",    :limit => nil
    t.boolean "pending",                :null => false
  end

  add_index "planet_osm_ways", ["id"], :name => "planet_osm_ways_idx"
  add_index "planet_osm_ways", ["nodes"], :name => "planet_osm_ways_nodes"

  create_table "polls", :force => true do |t|
    t.string   "question"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "post_id"
    t.integer  "votes_count", :default => 0
  end

  add_index "polls", ["created_at"], :name => "index_polls_on_created_at"
  add_index "polls", ["post_id"], :name => "index_polls_on_post_id"

  create_table "posts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "raw_post"
    t.text     "post"
    t.string   "title"
    t.integer  "category_id"
    t.integer  "user_id"
    t.integer  "view_count",                               :default => 0
    t.integer  "emailed_count",                            :default => 0
    t.integer  "favorited_count",                          :default => 0
    t.string   "published_as",               :limit => 16, :default => "draft"
    t.datetime "published_at"
    t.boolean  "send_comment_notifications",               :default => true
  end

  add_index "posts", ["category_id"], :name => "index_posts_on_category_id"
  add_index "posts", ["published_as"], :name => "index_posts_on_published_as"
  add_index "posts", ["published_at"], :name => "index_posts_on_published_at"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "rsvps", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "attendees_count"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "sashes", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sb_posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "forum_id"
    t.text     "body_html"
    t.string   "author_name"
    t.string   "author_email"
    t.string   "author_url"
    t.string   "author_ip"
  end

  add_index "sb_posts", ["forum_id", "created_at"], :name => "index_sb_posts_on_forum_id"
  add_index "sb_posts", ["user_id", "created_at"], :name => "index_sb_posts_on_user_id"

  create_table "segments", :id => false, :force => true do |t|
    t.spatial "geom",    :limit => {:srid=>0, :type=>"geometry"}
    t.text    "highway"
  end

  create_table "sessions", :force => true do |t|
    t.string   "sessid"
    t.text     "data"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "sessions", ["sessid"], :name => "index_sessions_on_sessid"

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "states", :force => true do |t|
    t.string "name"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"
  add_index "taggings", ["taggable_id"], :name => "index_taggings_on_taggable_id"
  add_index "taggings", ["taggable_type"], :name => "index_taggings_on_taggable_type"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.integer "taggings_count", :default => 0
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "topics", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hits",           :default => 0
    t.integer  "sticky",         :default => 0
    t.integer  "sb_posts_count", :default => 0
    t.datetime "replied_at"
    t.boolean  "locked",         :default => false
    t.integer  "replied_by"
    t.integer  "last_post_id"
  end

  add_index "topics", ["forum_id", "replied_at"], :name => "index_topics_on_forum_id_and_replied_at"
  add_index "topics", ["forum_id", "sticky", "replied_at"], :name => "index_topics_on_sticky_and_replied_at"
  add_index "topics", ["forum_id"], :name => "index_topics_on_forum_id"

  create_table "trips", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.text     "badges"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.text     "description"
    t.integer  "avatar_id"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "persistence_token"
    t.text     "stylesheet"
    t.integer  "view_count",                           :default => 0
    t.boolean  "vendor",                               :default => false
    t.string   "activation_code",        :limit => 40
    t.datetime "activated_at"
    t.integer  "state_id"
    t.integer  "metro_area_id"
    t.string   "login_slug"
    t.boolean  "notify_comments",                      :default => true
    t.boolean  "notify_friend_requests",               :default => true
    t.boolean  "notify_community_news",                :default => true
    t.integer  "country_id"
    t.boolean  "featured_writer",                      :default => false
    t.datetime "last_login_at"
    t.string   "zip"
    t.date     "birthday"
    t.string   "gender"
    t.boolean  "profile_public",                       :default => true
    t.integer  "activities_count",                     :default => 0
    t.integer  "sb_posts_count",                       :default => 0
    t.datetime "sb_last_seen_at"
    t.integer  "role_id"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count",                          :default => 0
    t.integer  "failed_login_count",                   :default => 0
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.integer  "group"
    t.integer  "sash_id"
    t.integer  "level",                                :default => 0
    t.integer  "mileage",                              :default => 0
    t.float    "rpm",                                  :default => 0.0
    t.float    "speed",                                :default => 0.0
    t.float    "standingtime",                         :default => 0.0
    t.float    "consumption",                          :default => 0.0
    t.integer  "measurement_count",                    :default => 0
    t.float    "total_co2"
    t.float    "total_consumption"
    t.float    "co2"
  end

  add_index "users", ["activated_at"], :name => "index_users_on_activated_at"
  add_index "users", ["avatar_id"], :name => "index_users_on_avatar_id"
  add_index "users", ["created_at"], :name => "index_users_on_created_at"
  add_index "users", ["featured_writer"], :name => "index_users_on_featured_writer"
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["login_slug"], :name => "index_users_on_login_slug"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
  add_index "users", ["vendor"], :name => "index_users_on_vendor"

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "poll_id"
    t.integer  "choice_id"
    t.datetime "created_at"
  end

end
