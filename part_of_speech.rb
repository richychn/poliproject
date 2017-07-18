require 'nokogiri'
require 'open-uri'
require 'pry-byebug'
require 'date'
require_relative 'thread_pool.rb'

def no_of_part(array, part)
  #threads = []
  i= 0
  pool = ThreadPool.new(size: 50)
  array.each do |word|
    pool.schedule do
    # threads << Thread.new do
      i += 1 if check(word, part)
    # end
    end
  end
  pool.shutdown
  # threads.each(&:join)
  return i
end

def check(word, part)
  html_file = open("http://wordnetweb.princeton.edu/perl/webwn?s=#{word}&sub=Search+WordNet&o2=&o0=1&o8=1&o1=1&o7=&o5=&o9=&o6=&o3=&o4=&h=")
  html_doc = Nokogiri::HTML(html_file)
  return html_doc.search('h3').text[0] == part
end

# def timer
#   start = Time.now
#   rm_stop_words!(TEXT)
#   return Time.now - start
# end
# p timer

def no_of_part_hash(array, part)
  nhash = {}
  ahash = {}
  pool = ThreadPool.new(size: 50)
  array.each do |word|
    if nhash.key? word
      nhash[word] += 1
    elsif ahash.key? word
      ahash[word] += 1
    else
      pool.schedule do
        nhash[word] = 1 if check(word, part)
        ahash[word] = 1 unless check(word, part)
      end
    end
  end
  pool.shutdown
  return nhash.values.inject(&:+)
end

def no_of_part_hash1(array, part)
  nhash = Hash.new(0)
  #pool = ThreadPool.new(size: 50)
  array.each do |word|
    #pool.schedule do
      if nhash[word] == 0
        nhash[word] += 1 if check(word, part)
      elsif nhash[word] > 0
        nhash[word] += 1
      else
        nhash[word] = 0
      end
    # end
  end
  #pool.shutdown
  return nhash.values.inject(&:+)
end

def no_of_part_hash2(array, part)
  pool = ThreadPool.new(size: 50)
  nhash = frequency(array)
  pool.schedule do
    nhash.each do |key, value|
      nhash[key] = 0 unless check(key, part)
    end
  end
  pool.shutdown
  return nhash.values.inject(&:+)
end

def frequency(array)
  pool = ThreadPool.new(size: 50)
  word_count = Hash.new(0)
  pool.schedule do
    array.each do |word|
      word_count[word] += 1
    end
  end
  pool.shutdown
  return word_count
end
