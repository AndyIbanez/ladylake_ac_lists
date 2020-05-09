#!/usr/bin/ruby

puts "Enter the file you want to get the missing items from:"
fileName = gets.chomp

newFilename = "MISSING_" + fileName

unless File.exist?(fileName)
	puts "The file #{fileName} does not exist."
	return
end

fileContents = File.read(fileName)

lines = fileContents.split "\n"

def cleanLine(line)
	noCheckMarkdown = line[6..]
	splatPipe = noCheckMarkdown.split " | "
	return splatPipe[0]
end

File.open(newFilename, "w") do |file|
	lines.each do |line|
		firstPart = line[0..4]
				if firstPart == "- [ ]"
			file.write cleanLine(line) + "\n"
		end
	end
end