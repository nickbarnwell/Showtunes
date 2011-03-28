module Library
	class Asset

		SERIALIZE = %w{ title description backdrop folder }

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

		def to_hash
			SERIALIZE.inject({}) {|h,v| h[v] = self.send(v.to_sym); h }
		end

		def to_json
		  self.to_hash.to_json
		end

	end
end

