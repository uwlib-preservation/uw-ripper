#!/usr/bin/env ruby

require 'optparse'
require 'tempfile'


ARGV.options do |opts|
  opts.on("-t", "--target=val", String) { |val| @waves = Dir.glob("#{val.tr("\\","/")}/*.wav") }
  opts.on("-n", "--name-file=val", String) { |val| @newFileNames = File.readlines(val.tr("\\","/")) }
  opts.parse!
end

def safetyCheck()
  if ! defined?(@waves) || @waves.empty?
    puts "Please add directory containing wave files!"
    exit
  elsif ! defined?(@newFileNames) || @newFileNames.empty?
    puts "Please add list of new file names!"
    exit
  elsif @waves.count != @newFileNames.count
    puts "Number of waves and new file names doesn't match! Please check inputs."
    exit
  end
end
    
    
      

def updateCue(cuePath,position)
  oldCue = File.readlines(cuePath)
  temp = Tempfile.new
  newCuePath = File.dirname(cuePath) + '/' + @newFileNames[position].chomp + '.cue'
  oldCue.each do|line|
    if (line.include?('FILE') && line.include?('WAVE'))
      newLine = "FILE " + '"' + @newFileNames[position].chomp + '.wav' + '"' + " WAVE\n"
      temp << newLine
    else
      temp << line
    end
  end
  temp.rewind
  temp.close
  FileUtils.mv(temp.path,newCuePath)
  if ! File.readlines(newCuePath).empty?
    FileUtils.rm(cuePath)
  end
end

safetyCheck()
wavesSorted = @waves.sort_by {|filename| File.mtime(filename) }
wavesSorted.each_with_index do |wave,index|
  newName = "#{File.dirname(wave)}/#{@newFileNames[index].chomp}"
  rootName = "#{File.dirname(wave)}/#{File.basename(wave,".*")}"
  unless File.exist?(newName)
    cuePath = rootName + '.cue'
    updateCue(cuePath,index) if File.exist?(cuePath)
    FileUtils.mv(wave,newName + '.wav')
    FileUtils.mv(rootName + '.log', newName + '.log') if File.exist?(rootName + '.log')
    FileUtils.mv(rootName + '.consolelog', newName + '.consolelog') if File.exist?(rootName + '.consolelog')
  else
    puts "File #{newName} already exists! Skipping!"
  end
end
