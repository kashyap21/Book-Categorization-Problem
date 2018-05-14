#!/usr/bin/env ruby

require 'csv'
# Extract genres from CSV file
books_genre = []
CSV.foreach("book_list.csv") do |row|	
	books_genre.push(row[1])
end

# Create array of genres of books
# books_genres_array is array of array
books_genres_array = []
value = []
books_genre.each do |genre|
	books_genres_array.push(genre.split('_')) if genre != nil
end

# Create array of unique genres
# array_of_genres is array
array_of_genres = []
books_genres_array.each do |book_genres_array|
	book_genres_array.each_with_index do |genre,index|		
		g = genre.downcase.strip
		book_genres_array[index] = g.delete'.'
		array_of_genres.push(book_genres_array[index]) if !array_of_genres.include?(book_genres_array[index])		
	end
end

genres_and_counts = []
array_of_genres.each do |genre|	
	# Find list of genres which are come with same genre
	# releted_genres is an array of genres which is come with this genre
	releted_genres = []
	# Count number of times genre come in dataset
	genre_occurance = 0
	books_genres_array.each do |book_genres_array|		
		if book_genres_array.include?(genre)
			genre_occurance = genre_occurance + 1
			book_genres_array.each do |books_genre|
				releted_genres.push(books_genre) if (books_genre != genre)
			end
		end				
	end		

	# puts releted_genres
	# Counts number of times genres come together
	# Genres_and_counts is array of array.
	# Internal array is 1X3 array.
	# Count is number of time genre related to main genre come.
	genres_for_counts = releted_genres	
	releted_genres = releted_genres.uniq
	releted_genres.each do |releted_genre|
		flag = 0
		genres_and_counts.each do |genre_and_count|
			flag = 1 if genre_and_count[0] == releted_genre
		end
		if flag == 0
			count = 0
			genres_for_counts.each do |genre_for_count|					
				count = count + 1 if releted_genre	== genre_for_count
			end		
			probability_of_occurance = count.to_f/genre_occurance.to_f			
			puts genre + "\t" + releted_genre + "\t" + probability_of_occurance.to_s
			genres_and_counts.push([genre,releted_genre,probability_of_occurance])
			
		end
	end	
end

# Wite adjence matrix in csv file
CSV.open("book_genre.csv", "wb") do |csv|
	genres_and_counts.each do |genre_and_count|		
		csv << [genre_and_count[0].strip,genre_and_count[1].strip,genre_and_count[2]]
	end
end