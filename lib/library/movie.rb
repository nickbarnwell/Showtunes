module Library
	class Movie < Library::Asset

		def metadata
			@metadata ||= Crack::XML.parse( open(xml).read )['Title']
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
			metadata['Genres'] || []
		end

	end
end
