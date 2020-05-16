#!/usr/bin/ruby

def isMissingFile?(file)
	return file.include?("MISSING_") || file == "items" || file.include?(".rb") || file == ".DS_Store" || file == "." || file == ".."
end

def cleanLine(line)
	noCheckMarkdown = line[6..]
	splatPipe = noCheckMarkdown.split " | "
	return splatPipe[0]
end

Dir.foreach(".") do |file|
	unless isMissingFile?(file)
		newFilename = "NOT_MISSING_#{file}"
		fileName = file

		puts "#{file}"

		fileContents = File.read(fileName)

		lines = fileContents.split "\n"

		File.open(newFilename, "w") do |file|
			lines.each do |line|
				firstPart = line[0..4]
				if firstPart == "- [x]"
					file.write cleanLine(line) + "\n"
				end
			end
		end
	end
end