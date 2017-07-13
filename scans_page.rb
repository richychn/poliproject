require_relative 'part_of_speech'
require 'pry-byebug'
require 'date'

def scan_file(filename)
  text = ""
  File.open(filename, "r").each_line { |line| text += line.gsub("\n", " ") }
  nouns = no_of_part(text, "N")
  adjectives = no_of_part(text, "A")
  p nouns
  p adjectives
  return adjectives / nouns.to_f
end

start_time = Time.now
p scan_file("source-text.txt")
p Time.now - start_time
