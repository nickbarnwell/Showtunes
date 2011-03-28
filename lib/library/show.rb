module Library
	class Show < Library::Asset
		
		def metadata
			@metadata ||= Crack::XML.parse(File.open(xml, 'r').read)['Series']
		end
		
		def xml
			File.join @path, 'series.xml'
		end

		def title
			metadata['SeriesName']
		end

		def genres
			parse_pipes metadata['Genre']
		end

		def description
			metadata['Overview']
		end

		def seasons
			Dir.glob("#{@path}/*").select {|f| File.directory?(f) }.map {|f| Library::Season.new(f) }
		end
	end
end