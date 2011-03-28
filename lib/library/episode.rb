module Library
	class Episode
		
		def initialize(path)
			@path = path
		end

		def xml
			File.join( File.dirname(@path), 'metadata', "#{File.basename(@path, '.*')}.xml" )
		end

		def metadata
			@metadata ||= Crack::XML.parse( open(xml).read )['Item']
		end

		def title
			metadata['EpisodeName']
		end

		def description
			metadata['Overview']
		end
	end
end
