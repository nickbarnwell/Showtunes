class Media

	SERIALIZE = %w{ title description backdrop folder }

	def initialize(base_path)
		@base_path = base_path 
	end

	def backdrop
		File.join(@base_path, 'backdrop.jpg')
	end

	def folder
		File.join(@base_path, 'folder.jpg')
	end

	def xml
		File.join(@base_path, 'mymovies.xml')
	end

	def metadata
		@metadata ||= Crack::XML.parse(File.open(xml, 'r').read)
	end

	def parsePipes(string)
		string[1..-1].split('|')
	end

	def to_hash
		SERIALIZE.inject({}) {|h,v| h[v] = self.send(v.to_sym); h }
	end

	def to_json
	  self.to_hash.to_json
	end

end

