module Library
	class Season < Library::Asset

		def episodes
			@episodes ||= begin
				Dir.glob("#{@base_path}/*").reject do |f| 
					File.directory?(f) || %w{ folder.jpg backdrop.jpg }.include?(f)
				end.map {|f| Episode.new f }
			end
		end

	end
end
