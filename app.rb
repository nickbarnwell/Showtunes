# encoding: UTF-8

require 'bundler'
Bundler.require

require 'yaml'
require 'json'

configure do
	YAML.load_file(File.open('config.yml')).each_pair {|k,v| set k.to_sym, v}
	set :haml, :format => :html5
end

$LOAD_PATH.unshift File.expand_path('lib')
require 'library'

%w{movies shows}.each do |asset|
	get "/#{asset}" do
		haml :index, :locals => { :assets => Library.const_get("#{asset.chop.capitalize}").all }
	end
	
	get "/#{asset}.json" do
		content_type :json
		Library.const_get("#{asset.chop.capitalize}").all.to_json
	end
	
	get "/#{settings.library['base_path']}/#{settings.library[asset.chop + '_path']}/*/*" do
		send_file URI.decode(request.path_info[1..-1])
	end
end
