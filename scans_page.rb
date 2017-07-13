require_relative 'part_of_speech'
require 'pry-byebug'
require 'date'
require 'open-uri'
require 'nokogiri'

def scan_file(filename)
  text = file_to_string(filename)
  array = text_to_array(text)
  array = rm_stop_words!(array)
  nouns = no_of_part(array, "N")
  return nouns / array.length.to_f
end

def rm_stop_words!(array)
  stop_words = []
  File.open("terrier-stop.txt", "r").each_line { |line| stop_words << line.delete("\r\n") }
  return array.delete_if { |word| stop_words.include? word }
end

def file_to_string(filename)
  text = ""
  File.open(filename, "r").each_line { |line| text += line.gsub("\n", " ") }
  return text
end

def text_to_array(text)
  array = text.downcase.gsub(/[^a-z0-9\s]/i, " ").split
  return array
end

start_time = Time.now
p scan_file("source-text.txt")
p Time.now - start_time
