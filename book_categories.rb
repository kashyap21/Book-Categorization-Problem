#!/usr/bin/env ruby

require 'csv'

book_name = "Yertle the Turtle and Other Stories"
book_description = "Yertle the Turtle: To rule all he surveys monarch Yertle is able; but a tall pile of turtles is very unstable...Gertrude McFuzz: Gert McFuzz gobbles pill-berries (more than a few) to grow a new tail to foil Lolla-Lee-Lou.The Big Brag: A bear and a hare in contention are firm_ but no brag is as tall as the tale of a worm...!"

# Split the words from book title and book descriptiom
# create array for it named description
# Remove duplicate words from the array
title = book_name.downcase.split(" ")
descritpion = book_description.downcase.split(" ")
descritpion = descritpion.concat(title)
descritpion = descritpion.uniq

# Define keywords which have to be removed from description array
keywords = ["is", "the", "of", "they", "this", "that", "their", "these", "those", "me", "he", "she", "it", "i", "under", "above", "below", "between", "my", "his", "her", "up", "down", "beside", "which", "was", "are", "where", "who", "have", "has", "from", "to", "will", "can", "could", "would", "shall", "should", "at", "on", "but", "no", "yes", "and", "or", "such", "a", "an", "in"]
# Remove keywords from description
# Words is an uniq array
words = []
descritpion.each do |desc|	
	if !keywords.include?(desc)
		words.push(desc.strip)
	end
end

# Extract data from graph
# books_genre is an array of arrays
books_genre = []
CSV.foreach("genres.csv") do |row|	
	books_genre.push(row)
end

# Take word one by one
# Find word in book_genre if it is on 1st or 2nd place
# If Category not include its matcher and link is generated than add it's matcher in to category
# One of the matcher is include in it than add word into category
category = []
words.each do |word|
	flag = 0	
	books_genre.each do |book_genre|			
		#puts "word = " + word + "\t book_genre = " + book_genre[0].strip + "\tbook_genre[1]" + book_genre[1].strip
		if word == book_genre[0].strip && !category.include?(book_genre[1]) && book_genre[2].to_f >= ARGV[0].to_f
			category.push(book_genre[1].strip)
			flag = 1
		end
		if word == book_genre[1].strip && !category.include?(book_genre[0]) && book_genre[2].to_f >= ARGV[0].to_f
			category.push(book_genre[0].strip)
			flag = 1
		end
		#puts flag		
	end

	category.push(word) if !category.include?(word) && flag == 1
puts category
end
puts category
