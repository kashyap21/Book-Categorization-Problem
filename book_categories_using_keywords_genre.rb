#!/usr/bin/env ruby

require 'csv'

book_name = "Berserk"
book_description = "iblist.com user synopsisTen years ago a military experiment left people dead.  Now they don't seem to be resting so peacefully."

# Split the words from book title and book descriptiom
# create array for it named description
# Remove duplicate words from the array
title = book_name.downcase.split(" ")
description = book_description.downcase.split(" ")
description = description.concat(title)
description.each_with_index do |desc,index|
	description[index] = desc.delete('.')
	description[index] = description[index].delete('_')
	description[index] = description[index].delete(',')
	description[index] = description[index].delete('?')
	description[index] = description[index].delete('-')
	description[index] = description[index].delete(':')
	description[index] = description[index].delete('!')
end
description = description.uniq

# Define keywords which have to be removed from description array
keywords = ["then","than","all","didn't","with","did","you","you'd","had","him","until","is","there","the", "of", "they", "this", "that", "their", "these", "those", "me", "he", "she", "it", "i", "under", "above", "below", "between", "my", "why","his", "her", "up", "down", "beside", "which", "was","so","are", "where", "who", "have", "has", "from", "to", "will", "can", "could", "would", "shall", "should", "at", "on", "but", "no", "yes", "and", "or", "such", "a", "an", "in"]
# Remove keywords from description
# Words is an uniq array
words = []
description.each do |desc|
	desc_character_array = desc.split(//)
	if desc_character_array.last(3).join== "ing" && desc_character_array[-4] == desc_character_array[-5] && desc.length > 5
		words.push(desc_character_array.pop(4).join.strip) if !words.include?(desc_character_array.pop(4).join.strip)
	else
		words.push(desc.strip) if !words.include?(desc.strip)
	end		
end

# Extract data from graph
# books_genre is an array of arrays
books_genre = []
CSV.foreach("tmp_key_genre.csv") do |row|	
	books_genre.push(row)
end

# Take word one by one
# Find word in book_genre if it is on 1st or 2nd place
# If Category not include its matcher and link is generated than add it's matcher in to category
# One of the matcher is include in it than add word into category
category = []
words.each do |word|	
	books_genre.each do |book_genre|					
		category.push(book_genre[1].strip) if word == book_genre[0].strip && !category.include?(book_genre[1]) && book_genre[2].to_f >= ARGV[0].to_f
	end	
end

puts category
