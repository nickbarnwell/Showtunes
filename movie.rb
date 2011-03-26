require 'crack'
require 'media'

class Movie < Media
	attr_accessor :title, :running_time, :release_year, :description, :genres
	def metadata
		@metadata ||= Crack::XML.parse(File.open(xml, 'r').read)['Title']
	end

	def title
		metadata['OriginalTitle']
	end	
	def running_time
		metadata['RunningTime']
	end
	def release_year
		metadata['ProductionYear']
	end

	def description
		metadata['Description']
	end

	def genres
		if !metadata['Genres'].nil?
			metadata['Genres']
		end
		[]
	end

end 



class Show < Media
	def xml
		File.join(@base_path, 'series.xml')
	end

	def metadata
		@metadata ||= Crack::XML.parse(File.open(xml, 'r').read)['Series']
	end

	def title
		metadata['SeriesName']
	end

	def genres
		parsePipes(metadata['Genre'])
	end

	def description
		metadata['Overview']
	end

	def seasons
		Dir.glob("#{@base_path}/*").select {|f| File.directory?(f)}.map {|f| Season.new(f)}
	end

end

class Season < Media
	def episodes
		@episodes ||= begin
			eps = Dir.glob("#{@base_path}/*").reject {|f| File.directory?(f)}
			eps -= ["#{@base_path}/folder.jpg","#{@base_path}/backdrop.jpg"]
			eps.map {|f| Episode.new(f)}
		end
	end
end

class Episode
	attr_reader :path
	def initialize(path)
		@path = path
	end

	def xml
		f = File.basename(@path, File.extname(@path))
		File.join(File.dirname(@path), 'metadata', f+'.xml')
	end

	def metadata
		@metadata ||= Crack::XML.parse(File.open(xml, 'r').read)['Item']
	end

	def title
		metadata['EpisodeName']
	end

	def description
		metadata['Overview']
	end
end

s = Show.new('Fresh Prince of Bel-Air')

s.seasons.each do |sea|
	sea.episodes.each do |e|
		puts e.title
		puts e.description
	end
end