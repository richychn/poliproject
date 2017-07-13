require_relative 'part_of_speech'
require 'pry-byebug'
require 'date'
require 'open-uri'
require 'nokogiri'

def scan_file(filename)
  text = file_to_text(filename)
  return scan_text(text)
end

def scan_webpage(url)
  text = webpage_to_text(url)
  return scan_text(text)
end

def scan_text(text)
  array = text_to_array(text)
  p array
  p array.length
  array1 = rm_stop_words!(array)
  p array1
  p array1.length
  nouns = no_of_part(array1, "N")
  return nouns / array.length.to_f
end

def rm_stop_words!(array)
  stop_words = []
  File.open("terrier-stop.txt", "r").each_line { |line| stop_words << line.delete("\r\n") }
  return array.delete_if { |word| stop_words.include? word }
end

def file_to_text(filename)
  text = ""
  File.open(filename, "r").each_line { |line| text += line.gsub("\n", " ") }
  return text
end

def text_to_array(text)
  array = text.downcase.gsub(/[^a-z0-9\s]/i, " ").split
  return array
end

def webpage_to_text(url)
  html_file = open(url)
  html_doc = Nokogiri::HTML(html_file)
  text = ""
  html_doc.search('p').each do |element|
    text += element.text
  end
  return text
end

start_time = Time.now
p scan_file("source-text.txt")
p Time.now - start_time
