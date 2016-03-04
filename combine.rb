require "./lib/data_formatter"

RESOURCES_PATH = "./resources/"

if ARGV[0] == "--format"
  case ARGV[1]
    when "csv"
      puts DataFormatter.new(RESOURCES_PATH+ARGV[2], RESOURCES_PATH+ARGV[3], RESOURCES_PATH+ARGV[4]).to_csv
    when "json"
      puts DataFormatter.new(RESOURCES_PATH+ARGV[2], RESOURCES_PATH+ARGV[3], RESOURCES_PATH+ARGV[4]).to_json
    else
      raise RuntimeError.new("Wrong format. Acceptable formats: csv, json.");
  end
end