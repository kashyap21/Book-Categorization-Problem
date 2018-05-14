#!/usr/bin/env ruby
require 'rubygems'
require 'nokogiri'   
require 'open-uri'
require 'spreadsheet'
require 'csv'

book_name = []
book_description = []
book_genre = []

i = 170
begin
	PAGE_URL = "http://www.iblist.com/book" + i.to_s + ".htm"
	page = Nokogiri::HTML(open(PAGE_URL))

	name = page.xpath('/html/body/div[2]/div[3]/div[1]/table/tr/td/table/tr/td/p[2]/text()[2]').text.strip
	description = page.xpath('/html/body/div[2]/div[3]/div[1]/table/tr/td/table/tr/td/div').text


	description = description.gsub(',','_')
	genres = []
	page.xpath('/html/body/div[2]/div[3]/div[1]/table/tr/td/table/tr/td/p[3]/a').each do |link|
	  genres.push(link.text)
	  
	end	
	genres = genres.uniq
	genre = " "
	genres.each do |g|
		genre = genre != " "? genre + "_" + g : g
	end
	book_name.push(name)
	book_description.push(description)
	book_genre.push(genre)
	i = i + 1
end while i < 180

CSV.open("book_list11.csv", "wb") do |csv|
	book_name.each_with_index do |b_name,index|		
		csv << [b_name.strip,book_genre[index].strip,book_description[index].strip]
	end
end

Subline text.
end
