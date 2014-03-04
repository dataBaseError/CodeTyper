
class FilesValidator

	RUBY = ["rb"]
	PYTHON = ["py"]
	C = ["c", "h"]
	CPP = ["cpp", "hpp", "cc"]
	JAVA = ["java"]

	VALID_EXT = [RUBY, PYTHON, C, CPP, JAVA]

	def self.validate(filename)
		VALID_EXT.each do |language|

			language.each do |ext|
				if filename.match(/\.#{ext}$/)
					return true;
				end
			end
		end
		return false;		
	end

end

