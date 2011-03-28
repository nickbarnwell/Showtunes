module Library
	class Show < Library::Asset
		
		def xml
			File.join @base_path, 'series.xml'
		end

		def metadata
			@metadata ||= Crack::XML.parse(File.open(xml, 'r').read)['Series']
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
			Dir.glob("#{@base_path}/*").select {|f| File.directory?(f) }.map {|f| Season.new(f) }
		end
	end
end