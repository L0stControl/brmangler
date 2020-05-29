#!/usr/bin/env ruby

require 'date'
require 'active_support/all'
require 'colorize'
require 'optparse'
require 'fileutils'
require 'timeout'
require 'find'

logo = '
   
   ██████╗ ██████╗    ███╗   ███╗ █████╗ ███╗   ██╗ ██████╗ ██╗     ███████╗██████╗ 
   ██╔══██╗██╔══██╗   ████╗ ████║██╔══██╗████╗  ██║██╔════╝ ██║     ██╔════╝██╔══██╗
   ██████╔╝██████╔╝   ██╔████╔██║███████║██╔██╗ ██║██║  ███╗██║     █████╗  ██████╔╝
   ██╔══██╗██╔══██╗   ██║╚██╔╝██║██╔══██║██║╚██╗██║██║   ██║██║     ██╔══╝  ██╔══██╗
   ██████╔╝██║  ██║██╗██║ ╚═╝ ██║██║  ██║██║ ╚████║╚██████╔╝███████╗███████╗██║  ██║
   ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝
         Brazilian wordlist generator hu3hu3hu3                                                                           
'.red

options = {:file => nil, :min => 1, :max => 20, :leet => true, :insane => false, :cap => true, :upcase => true, :date => true, :special => true, :months => false, :two => false}

parser = OptionParser.new do|opts|
    opts.banner = "\n Usage: ./brmangler.rb [options]\n\n"

    opts.on('-f', '--file /path/to/file', '*Mandatory* File with names'.red) do |file|
        options[:file] = file
    end

    opts.on('-m', '--min 8', 'Minimun password size') do |min|
        options[:min] = min.to_i
    end

    opts.on('-M', '--Max 12', 'Maximun password size') do |max|
        options[:max] = max.to_i
    end

    opts.on('-l', '--leet', 'DISABLE leetSpeak outputs (e.g. "p@55w0rd")') do |leet|
        options[:leet] = false
    end

    opts.on('-c', '--capitalize', 'DISABLE capitalized outputs (e.g. "Password")') do |cap|
        options[:cap] = false
    end

    opts.on('-u', '--upcase', 'DISABLE uppercase') do |upcase|
        options[:upcase] = false
    end

    opts.on('-d', '--date', 'DISABLE dates (e.g. "password@020212")') do |date|
        options[:date] = false
    end
 
    opts.on('-s', '--special', 'DISABLE passwords with special characters') do |special|
        options[:special] = false
    end

    opts.on('-t', '--twoletters', 'Enable two letters passwords (e.g. "af212303")'.red) do |two|
        options[:two] = true
    end

    opts.on('-j', '--months', 'Enable months (e.g. "janeiro@020212")'.red) do |date|
      options[:months] = true
    end

    opts.on('-i', '--insane', 'Use *ALL* wordlists to create passwords'.red) do |insane|
        options[:insane] = true
    end

end

parser.parse!

if options[:file] == nil
    print logo
    puts "#{parser}\n"
    exit
else 
    begin 
      inputFile = File.open(options[:file], "r")
      inputData = inputFile.read
      inputFile.close 
    rescue 
      puts "[Error] File #{options[:file]} not found".red
      exit
    end
end

# Variables and Constants

SPECIAL = ['!','@','#','$','%','&','*', '?']
REPLACEMENTS1 = [["a", "4"], ["e", "3"], ["s", "$"], ["o", "0"], ["i", "1"]]
REPLACEMENTS2 = [["a", "@"], ["e", "&"], ["s", "5"], ["o", "0"], ["t", "7"]]
MONTHS = ['janeiro','fevereiro','março','abril','maio','junho','julho','agosto', 'setembro', 'outubro', 'novembro', 'dezembro']
$min = options[:min]
$max = options[:max]
$date = options[:date]
$special = options[:special]
$insane = options[:insane]
$upcase = options[:upcase]
$leet = options[:leet]
$capitalize = options[:cap]
$file = options[:file]
$two = options[:two]
$months = options[:months]

# Functions

def wordSpecial(word)
  if $special == true && word.length + 1 >= $min && word.length + 1 <= $max
    (SPECIAL.length).times do |times|
      puts word + SPECIAL[times]
      puts SPECIAL[times] + word
    end
  end
  if $special == true && word.length + 2 >= $min && word.length + 1 <= $max
    (SPECIAL.length).times do |times|
        (SPECIAL.length).times do |times2|
          puts SPECIAL[times2] + word + SPECIAL[times2]
        end
    end
  end
end

def wordSpecialNum(word)
    if word.length + 3 <= $max
    (SPECIAL.length).times do |times|
      (0..99).each do |num|
        if word.length + num.to_s.length + 1 >= $min
        puts "#{num}#{word}#{SPECIAL[times]}"
        puts "#{SPECIAL[times]}#{word}#{num}"
        puts "#{word}#{SPECIAL[times]}#{num}"
        else
          next
        end
      end
    end
  end

  if word.length + 4 <= $max
    (SPECIAL.length).times do |times|
      (100..9999).each do |num|
        if word.length + num.to_s.length + 1 >= $min
          puts "#{num}#{word}#{SPECIAL[times]}"
          puts "#{SPECIAL[times]}#{word}#{num}"
          puts "#{word}#{SPECIAL[times]}#{num}"
        else
          next
        end
      end
    end
  end
end

def wordNum(word)
  if word.length + 1 >= $min
    (0..9999).each do |num|
      if word.length + num.to_s.length > $max
        break
      else
      puts "#{num}#{word}"
      puts "#{word}#{num}"
      end
    end
  end
end


def wordDate(word)

  if $date == true && word.length + 6 >= $min && word.length + 6 <= $max
    rangeDate = ((60.to_i.year.ago.to_date)..(Date.today)).to_a.map{|x| x.to_s(:db)} # 60 years 
      rangeDate.each do |date|
        dateMask = date.split("-")
        puts "#{word}#{dateMask[2]}#{dateMask[1]}#{dateMask[0][2..4]}"
      end
  end
end

def wordFullDate(word)
  if $date == true && word.length + 8 >= $min && word.length + 8 <= $max
    rangeDate = ((60.to_i.year.ago.to_date)..(Date.today)).to_a.map{|x| x.to_s(:db)} # 60 years 
      rangeDate.each do |date|
        dateMask = date.split("-")
        puts "#{word}#{dateMask[2]}#{dateMask[1]}#{dateMask[0][0..4]}"
      end
  end
end

def wordSpecialDate(word)
  if $date == true && $special == true && word.length + 7 >= $min
    (SPECIAL.length).times do |times|
      rangeDate = ((60.to_i.year.ago.to_date)..(Date.today)).to_a.map{|x| x.to_s(:db)} # 60 years
      rangeDate.each do |date|
          dateMask = date.split("-")
        if word.length + 9 <= $max
          puts "#{word}#{SPECIAL[times]}#{dateMask[2]}#{dateMask[1]}#{dateMask[0][0..4]}"
          puts "#{dateMask[2]}#{dateMask[1]}#{dateMask[0][0..4]}#{SPECIAL[times]}#{word}"
        end
        if word.length + 7 <= $max
          puts "#{word}#{SPECIAL[times]}#{dateMask[2]}#{dateMask[1]}#{dateMask[0][2..4]}"
          puts "#{dateMask[2]}#{dateMask[1]}#{dateMask[0][2..4]}#{SPECIAL[times]}#{word}"
        end
      end
    end
  end
end

def monthSpecialDate(word)
  if $date == true && $special == true
    (SPECIAL.length).times do |times|
      rangeDate = ((10.to_i.year.ago.to_date)..(Date.today)).to_a.map{|x| x.to_s(:db)} # 10 years
      rangeDate.each do |date|
        dateMask = date.split("-")        
        puts "#{word}#{SPECIAL[times]}#{dateMask[2]}#{dateMask[1]}#{dateMask[0][2..4]}"
        puts "#{dateMask[2]}#{dateMask[1]}#{dateMask[0][2..4]}#{SPECIAL[times]}#{word}"
      end
    end
  end
end


def twoLetters
  if $two == true
    ("aa".."zz").each do |letter|
      (1..999999).each do |num|
        puts "#{letter}#{num.to_s.rjust(6, '0')}"
        puts "#{num.to_s.rjust(6, '0')}#{letter}"
      end 
    end
  end
end


def leetSpeak(word)
  if $leet == true && word.length >= $min && word.length <= $max
    originalWord = word.downcase.clone
    originalWord2 = word.downcase.clone
    puts originalWord
  
    REPLACEMENTS1.each {|rep| originalWord.gsub!(rep[0], rep[1])}
       puts originalWord
       wordSpecial(originalWord)
       wordNum(originalWord)

    REPLACEMENTS2.each {|rep| originalWord2.gsub!(rep[0], rep[1])}
      puts originalWord2
      wordSpecial(originalWord2)
      wordNum(originalWord2)
  end
end


def mangler(word)
  wordSpecial(word)
  wordSpecialNum(word)
  wordSpecialDate(word)
  wordNum(word)
  wordDate(word)
  wordFullDate(word)
end

########
# Main #
########

if $months == true
  MONTHS.each do |month| 
    wordSpecialNum(month)
    monthSpecialDate(month)
  end
end

inputData.each_line do |line|

  line.delete_suffix!("\n")
  leetSpeak(line)

  (3).times do |times|
    if times == 0 
      mangler("#{line.downcase}")
    elsif times == 1 && $capitalize == true 
      if line.length >= $min && line.length <= $max
        puts line.capitalize
      end
      mangler("#{line.capitalize}")
    elsif times == 2 && $upcase == true
      if line.length >= $min && line.length <= $max
        puts line.upcase!
      end
      mangler("#{line.upcase}")
    end
  end
end

if $two == true
  twoLetters
end

if $insane == true
  dirContent = Dir["./wordlists/*"].sort
  dirContent.each do |content|
    inputFile = File.open(content, "r")
    inputData = inputFile.read
    inputFile.close 
    inputData.each_line do |line|
      leetSpeak(line)
      (3).times do |times|
        if times == 0
          puts line.downcase!
          mangler(line)
        elsif times == 1 && $upcase == true
          puts line.upcase!
          mangler(line)
        elsif times == 2 && $capitalize == true
          puts line.capitalize!
          mangler(line)
        end
      end
    end
  end
end
