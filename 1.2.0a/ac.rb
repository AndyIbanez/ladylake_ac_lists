#!/usr/bin/ruby

require "JSON"
require "Set"

allCategoriesHash = Hash.new { |hash, key| hash[key] = []  }
allCategoriesSet = Set.new

fileContents = File.read("items")
json = JSON.parse(fileContents)

def processList(objects, categoriesSet, categoriesHash)
	objects.each { |object|  processObject(object, categoriesSet, categoriesHash) }
end

def processObject(object, categoriesSet, categoriesHash)
	catName = object["category"]
	categoriesSet << catName

	if object["variations"].count == 0
		categoriesHash[catName] << createStringLine(object["content"]["name"], object["content"]["bodyColor"], object["content"]["patternColor"], object["id"])
	else
		object["variations"].each { |variation| categoriesHash[catName] << createStringLine(object["content"]["name"], variation["content"]["bodyColor"], variation["content"]["patternColor"], variation["id"]) }
	end
end

def processGenerealObject(object, categoriesSet, categoriesHash)
	object["variations"].each { |variation| categoriesHash[catName] << createStringLine(object["content"]["name"], variation["content"]["bodyColor"], variation["content"]["patternColor"], variation["id"]) }
end

#def processAccessories(object, categoriesSet, categoriesHash, category)
#	categoriesHash[category] << createStringLine(object["name"], object["content"]["bodyColor"], object["id"])
#end

def createStringLine(objectName, variation, patternColor, objectId)
	#puts "THE BODY TITLE " + bodyTitle.to_s
	initialString = "- [ ] "
	initialString += objectName
	initialString += " (" + variation unless variation == nil
	initialString += " " + patternColor unless patternColor == nil
	initialString += ")" unless variation == nil
	initialString += " | " + objectId.to_s

	return initialString
end

def printContents(categoriesHash, categoriesSet)
	categoriesSet.sort.each do |categoryName|
		puts categoryName + ":"
		categoriesHash[categoryName].each { |itemName| puts itemName }
		puts ""
	end
end

def writeContentsToFiles(categoriesHash, categoriesSet)
	categoriesSet.sort.each do |category|
		File.open(category + ".md", "w") do |file|
			categoriesHash[category].each { |itemName| file.write itemName + "\n" }
		end
	end
end
#puts json

processList(json["results"], allCategoriesSet, allCategoriesHash)
puts allCategoriesHash["Accessories"]
#printContents(allCategoriesHash, allCategoriesSet)
writeContentsToFiles(allCategoriesHash, allCategoriesSet)
allCategoriesHash.each { |key, value| puts "#{key} #{allCategoriesHash[key].count}" }

#puts "These are all the categories:"
#allCategoriesSet.sort.each { |cat| puts cat }