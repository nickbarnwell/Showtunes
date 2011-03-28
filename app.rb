# encoding: UTF-8

require 'rubygems'
require 'bundler'
Bundler.require

require 'yaml'
require 'json'

configure do
	YAML.load_file(File.open('config.yml')).each_pair {|k,v| set k.to_sym, v}
end

$LOAD_PATH.unshift File.expand_path('lib')
require 'library'

puts File.join(settings.library['base_path'], settings.library['movie_path'])

helpers do
	def television
		Dir.glob(File.join(settings.library['base_path'], settings.library['tv_path'], '*')).map {|f| Library::Movie.new(f)}
	end

	def movies
		movies = Dir.glob(File.join(settings.library['base_path'], settings.library['movie_path'], '*')).select {|m| File.directory?(m)}
		movies.map {|f| Library::Movie.new(f)}
	
	end
end

get '/movies' do
	haml :element, :locals => { :movies => movies } 
end

get '/movies.json' do
	content_type :json
	movies.to_json
end

__END__
@@movie
- movies.each do |movie|
	%article
		%header
			%h1= movie.title
		%p= movie.description
		%img{:src => movie.folder}
		%footer
			%ul
				- movie.genres.each do |genre|
					%li= genre