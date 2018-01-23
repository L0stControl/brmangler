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

options = {:file => nil, :min => 1, :max => 20, :leet => true, :insane => false, :cap => true, :upcase => true, :date => true, :special => true, :two => false, :qt => false}

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

    opts.on('-q', '--qt', 'Calculate the quantity of outputs') do |qt|
        options[:qt] = true
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

SPECIAL = ['!','@','#','$','%','&','*']
REPLACEMENTS1 = [["a", "4"], ["e", "3"], ["s", "$"], ["o", "0"], ["i", "1"]]
REPLACEMENTS2 = [["a", "@"], ["e", "&"], ["s", "5"], ["o", "0"], ["t", "7"]]
$min = options[:min]
$max = options[:max]
$date = options[:date]
$special = options[:special]
$insane = options[:insane]
$upcase = options[:upcase]
$qt = options[:qt]
$leet = options[:leet]
$capitalize = options[:cap]
$file = options[:file]
$two = options[:two]

# Functions

def checkPasswdSize(password)

  if password.length >= $min && password.length <= $max

    puts password.chomp

  end

end


def wordSpecial(word)
  
  if $special == true

    (SPECIAL.length).times do |times|

      checkPasswdSize(word.chomp + SPECIAL[times])
      checkPasswdSize(SPECIAL[times] + word.chomp)
      
      (SPECIAL.length).times do |times2|
        
        checkPasswdSize(SPECIAL[times] + word.chomp + SPECIAL[times2])
     
      end

    end

  end

end

def wordSpecialNum(word)

    (SPECIAL.length).times do |times|  

      (0..9999).each do |num|

        checkPasswdSize("#{num}#{word.chomp}#{SPECIAL[times]}")
        checkPasswdSize("#{SPECIAL[times]}#{word.chomp}#{num}")
        checkPasswdSize("#{word.chomp}#{SPECIAL[times]}#{num}")      

      end

    end

end

def wordNum(word)
  
  (0..9999).each do |num|

    checkPasswdSize("#{num}#{word.chomp}")
    checkPasswdSize("#{word.chomp}#{num}") 

  end

end


def wordDate(word) #

  if $date == true
  
    rangeDate = ((70.to_i.year.ago.to_date)..(Date.today)).to_a.map{|x| x.to_s(:db)} # 70 years 
      rangeDate.each do |date|
        dateMask = date.split("-")

        checkPasswdSize("#{word.chomp}#{dateMask[2]}#{dateMask[1]}#{dateMask[0][2..4]}")

      end
  end
end


def wordFullDate(word) #

  if $date == true
  
    rangeDate = ((70.to_i.year.ago.to_date)..(Date.today)).to_a.map{|x| x.to_s(:db)} # 70 years 
      rangeDate.each do |date|
        dateMask = date.split("-")
        
        checkPasswdSize("#{word.chomp}#{dateMask[2]}#{dateMask[1]}#{dateMask[0][0..4]}")

      end
  end
end

def wordSpecialDate(word) # AQUI

  if $date == true && $special == true 
  
    (SPECIAL.length).times do |times|
      rangeDate = ((70.to_i.year.ago.to_date)..(Date.today)).to_a.map{|x| x.to_s(:db)} # 70 years
      rangeDate.each do |date|
  
        dateMask = date.split("-")        
        checkPasswdSize("#{word.chomp}#{SPECIAL[times]}#{dateMask[2]}#{dateMask[1]}#{dateMask[0][0..4]}")
        checkPasswdSize("#{dateMask[2]}#{dateMask[1]}#{dateMask[0][0..4]}#{SPECIAL[times]}#{word.chomp}")
        checkPasswdSize("#{word.chomp}#{SPECIAL[times]}#{dateMask[2]}#{dateMask[1]}#{dateMask[0][2..4]}")
        checkPasswdSize("#{dateMask[2]}#{dateMask[1]}#{dateMask[0][2..4]}#{SPECIAL[times]}#{word.chomp}")
        
      end
    end
  end
end

def twoLetters
  
  if $two == true
    ("aa".."zz").each do |letter|
      (1..999999).each do |num|
        checkPasswdSize("#{letter.chomp}#{num.to_s.rjust(6, '0')}")
        checkPasswdSize("#{num.to_s.rjust(6, '0')}#{letter.chomp}")
      end 
    end
  end

end


def leetSpeak(word)

  if $leet == true
  
    originalWord = word.downcase.clone
    originalWord2 = word.downcase.clone

    REPLACEMENTS1.each {|rep| originalWord.gsub!(rep[0], rep[1])}

        checkPasswdSize("#{originalWord.chomp}")
        wordSpecial("#{originalWord.chomp}")
        wordNum("#{originalWord.chomp}")

    REPLACEMENTS2.each {|rep| originalWord2.gsub!(rep[0], rep[1])}

        wordSpecial("#{originalWord2.chomp}")
        checkPasswdSize("#{originalWord2.chomp}")
        wordNum("#{originalWord2.chomp}")

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

# Main

inputData.each_line do |line|

  leetSpeak(line)

  (3).times do |times|
    if times == 0

      checkPasswdSize("#{line.downcase!}")
      mangler(line)

    elsif times == 1 && $capitalize == true

      checkPasswdSize("#{line.capitalize!.chomp}")
      mangler(line)

    elsif times == 2 && $upcase == true

      checkPasswdSize("#{line.upcase!.chomp}")
      mangler(line)

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

        checkPasswdSize("#{line.downcase!}")
        mangler(line)

      elsif times == 1 && $upcase == true

        checkPasswdSize("#{line.upcase!}")
        mangler(line)

      elsif times == 2 && $capitalize == true

        checkPasswdSize("#{line.capitalize!}")
        mangler(line)

      end
    
  end
    end
  end
end
