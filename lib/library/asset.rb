module Library
	class Asset

		def initialize(path)
			@path = path 
		end

		def backdrop
			File.join(@path, 'backdrop.jpg')
		end

		def folder
			File.join(@path, 'folder.jpg')
		end

		def xml
			File.join(@path, 'mymovies.xml')
		end

		def metadata
			@metadata ||= Crack::XML.parse(File.open(xml, 'r').read)
		end

		def parse_pipes(string)
			string[1..-1].split('|')
		end
		
		def to_json(*a)
			{
				'json_class' 	=> self.class.name,
				'data'				=> %w{title description backdrop folder}.inject({}) { |h,k| h[k] = self.send(k.to_sym); h }
			}.to_json(*a)
		end

	end
end

