require "rubygems"
require "sinatra"
require "haml"
require "json"

DATA_SOURCE = "data.json"

get "/" do
  haml :index
end

# some cache issues
get '/:name.haml' do
  file_path = "public/templates/#{params[:name]}.haml"
  File.open(file_path).read if File.exists?(file_path)
end


get "/items.json" do
  JSON.parse(File.read(DATA_SOURCE)).to_json
end