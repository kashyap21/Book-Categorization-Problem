#!/usr/bin/env ruby

require 'csv'
# Extract genres from CSV file
books_genre = []
keys_genres = []

i=0
fg=1
CSV.foreach("tmp_dataset.csv") do |row|	
  
	i = i +1
	puts i

	# Get keywords from description
	#title = row[0].downcase.split(" ")	
	if fg ==1
	description = row[2].downcase.split(" ") 
	
	#description = description.concat(title)
	description.each_with_index do |desc,index|
		description[index] = desc.delete('.')
		description[index] = description[index].delete('_')
		description[index] = description[index].delete(',')
		description[index] = description[index].delete('?')
		description[index] = description[index].delete('-')
		description[index] = description[index].delete(':')
		description[index] = description[index].delete('!')
		description[index] = description[index].delete('(')
		description[index] = description[index].delete(')')
	end

	description = description.uniq
	puts description

	keywords = ["for","then","than","all","didn't","with","did","you","you'd","had","him","until","is","there","the", "of", "they", "this", "that", "their", "these", "those", "me", "he", "she", "it", "i", "under", "above", "below", "between", "my", "why","his", "her", "up", "down", "beside", "which", "was","so","are", "where", "who", "have", "has", "from", "to", "will", "can", "could", "would", "shall", "should", "at", "on", "but", "no", "yes", "and", "or", "such", "a", "an", "in","isn't","doesn't","aren't","hasn't","haven't", "check" , "Originally" ,  "written" , "in" , "author" , "translated" , "languages" , "follow" , "children" , "tests" , "kinds" , "follows" , "around" , "after" , " finally ", "moment" , "younger" , "brother" , "attitude" , "fixed" , "sympathise", "when" , "at" , "off" , "finds" , "a" , "out" ]	
 	keywords_month = [ "january" , "February" , "march" , "april" , "may" , "June" , "july" , "august" , "september" , "octomber" , "november" , "december" ]
	words_of_book = []
	
	description.each do |desc|
		if fg == 1
		desc_character_array = desc.split()
			if !keywords.include?(desc) && !keywords_month.include?(desc)
				
				if desc_character_array.last(3).join== "ing" && desc_character_array[-4] == desc_character_array[-5] && desc.length > 5
						words_of_book.push(desc_character_array.pop(4).join.strip) if !words_of_book.include?(desc_character_array.pop(4).join.strip)
				elsif desc == "by"  
					fg = 0
				elsif desc =="around"
					fg = 0
				elsif desc_character_array.last(2).join == "es"
					fg = 1				
				else
					words_of_book.push(desc) if !words_of_book.include?(desc)
				end
			end	
			fg =1 if fg == 0			
		end	
	end

	words = words_of_book
	
	words.each_with_index do |word,index|
		if keywords.include?(word) || keywords_month.include?(word)
			words_of_book.delete(word) 			
		end
		words_of_book.delete(word) if word.length <= 4		
	end	

	
	genres_array = row[1].downcase.split('_')
	genres_array.uniq
	
	words_of_book.each do |word_of_book|
		genres_array.each do |genre|			
			flag = 0
			keys_genres.each do |key_genre|
				if key_genre[0] == word_of_book && key_genre[1] == genre
					key_genre[2] = key_genre[2] + 1 
					flag = 1
				end
			end
			keys_genres.push([word_of_book,genre,1]) if flag == 0
		end
	end	
	else 
	fg == 1;
	end
end
# total count of keyword in dataset
key_words = []
keys_genres.each do |key_genre|
	flag = 0
	key_words.each do |key_word|	
		if key_word[0] == key_genre[0]
			count = key_word[1] + key_genre[2]
			key_word[1] = count
			flag = 1
		end
	end
	key_words.push([key_genre[0],key_genre[2]]) if flag == 0
end

#Threshold
keys_genres.each do |key_genre|
	key_words.each do |key_word|
		key_genre[2] = key_genre[2].to_f/key_word[1].to_f if key_genre[0] == key_word[0]
	end
end
## just to write ...
CSV.open("tmp_key_genre.csv", "wb") do |csv|
	keys_genres.each do |key_genre|		
		csv << [key_genre[0].strip,key_genre[1].strip,key_genre[2]]
	end
end


# nagar palika sanchalit school

