require 'csv'
require 'json'

class Trip
  attr_accessor :route_id, :service_id, :trip_id, :trip_headsign, :trip_short_name, :direction_id, :block_id, :shape_id

  def initialize(route_id, service_id, trip_id, trip_headsign, trip_short_name, direction_id, block_id, shape_id)
    @route_id = route_id
    @service_id = service_id
    @trip_id = trip_id
    @trip_headsign = trip_headsign
    @trip_short_name = trip_short_name
    @direction_id = direction_id
    @block_id = block_id
    @shape_id = shape_id
  end

  def to_hash
    {
      route_id: @route_id,
      service_id: @service_id,
      trip_id: @trip_id,
      trip_headsign: @trip_headsign,
      trip_short_name: @trip_short_name,
      direction_id: @direction_id,
      block_id: @block_id,
      shape_id: @shape_id
    }
  end
end

def read_trips_file(file_path)
  trips = []
  CSV.foreach(file_path, headers: true, col_sep: ",") do |row|
    trip = Trip.new(
      row[0],
      row[1],
      row[2],
      row[3],
      row[4],
      row[5],
      row[6],
      row[7],
      # row['route_id'],
      # row['service_id'],
      # row['trip_id'],
      # row['trip_headsign'],
      # row['trip_short_name'],
      # row['direction_id'],
      # row['block_id'],
      # row['shape_id']
    )
    trips << trip
  end
  trips
end

def export_trips_to_json(directories, output_json_path)
  all_trips = []

  directories.each do |directory|
    trips_file_path = File.join(directory, 'trips.txt')
    if File.exist?(trips_file_path)
      puts "Reading file: #{trips_file_path}"
      trips = read_trips_file(trips_file_path)
      puts "Found #{trips.size} trips in #{trips_file_path}"
      all_trips.concat(trips)
    else
      puts "File not found: #{trips_file_path}"
    end
  end

  trips_json = all_trips.map(&:to_hash).to_json

  File.open(output_json_path, 'w') do |file|
    file.write(trips_json)
  end

  puts "Exported #{all_trips.size} trips to #{output_json_path}"
end

directories = ['Generated/GFTSProviders/2_google_transit', 'Generated/GFTSProviders/4_google_transit', 'Generated/GFTSProviders/5_google_transit', 'Generated/GFTSProviders/6_google_transit', 'Generated/GFTSProviders/9_google_transit', 'Generated/GFTSProviders/10_google_transit', 'Generated/GFTSProviders/11_google_transit']
export_trips_to_json(directories, 'CyBus/trips.json')
