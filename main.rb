# encoding: UTF-8
require 'sinatra'
require 'YAML'
require 'active_support'
require 'json'
configure do
	YAML.load_file(File.open('config.yml')).each_pair {|k,v| set k.to_sym, v}
end

require './models/media'
require './models/movie'
puts File.join(settings.library['base_path'], settings.library['movie_path'])

helpers do
	def television
		Dir.glob(File.join(settings.library['base_path'], settings.library['tv_path'], '*')).map {|f| Movie.new(f)}
	end

	def movies
		movies = Dir.glob(File.join(settings.library['base_path'], settings.library['movie_path'], '*')).select {|m| File.directory?(m)}
		p movies
		movies.map {|f| Movie.new(f)}
	
	end
end

get '/movies' do
	haml :element, :locals => { :movies => movies } 
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