require 'nokogiri'
require 'open-uri'
require 'pry-byebug'
require 'date'

def no_of_part(text, part)
  threads = []
  array = text.downcase.gsub(/[^a-z0-9\s]/i, " ").split
  array = rm_stop_words!(array)
  i= 0

  array.each do |word|
    # threads << Thread.new do
    i += 1 if check(word, part)
    # end
  end

  # threads.each(&:join)
  return i
end

def check(word, part)
  html_file = open("http://wordnetweb.princeton.edu/perl/webwn?s=#{word}&sub=Search+WordNet&o2=&o0=1&o8=1&o1=1&o7=&o5=&o9=&o6=&o3=&o4=&h=")
  html_doc = Nokogiri::HTML(html_file)
  return html_doc.search('h3').text[0] == part
end

def rm_stop_words!(array)
  stop_words = []
  File.open("terrier-stop.txt", "r").each_line { |line| stop_words << line.delete("\r\n") }
  return array.delete_if { |word| stop_words.include? word }
end

# def timer
#   start = Time.now
#   rm_stop_words!(TEXT)
#   return Time.now - start
# end
# p timer
