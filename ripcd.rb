require 'tempfile'
require 'optparse'
require 'yaml'

ARGV.options do |opts|
  opts.on("-o", "--output-dir=val", String)  { |val| ProjectDir = val.tr("\\", "/") }
  opts.on("-d", "--discs=val", String) { |val| DiscTotal = val.to_i }
  opts.on("-b", "--burst") { Mode = '-B' }
  opts.on("-s", "--secure") { Mode = '-S' }
  opts.on("-p", "--paranoid") { Mode = '-P' }
  opts.parse!
end

scriptPath = __dir__
configPath = scriptPath + "/ripcd.config"
configOptions = YAML.load_file(configPath)

CLI_Tools_Path = configOptions['CLI_Tools_Path']
CueToolsPath = configOptions['CueToolsPath']
LoadPath =  CLI_Tools_Path + configOptions['LoadPath']
UnloadPath =  CLI_Tools_Path + configOptions['UnloadPath']
Drive = configOptions['Drive']

def loadDisc()
  tempFile1 = Tempfile.new('batchRipping')
  tempFile2 = Tempfile.new('batchRipping')
  system(LoadPath, "--drive=#{Drive}", '--rejectifnodisc' "--logfile=#{tempFile1.path}", "--passerrorsback=#{tempFile2.path}")
  puts "\n"
end

def unloadDisc()
  tempFile1 = Tempfile.new('batchRipping')
  tempFile2 = Tempfile.new('batchRipping')
  system(UnloadPath, "--drive=#{Drive}", '--rejectifnodisc' "--logfile=#{tempFile1.path}", "--passerrorsback=#{tempFile2.path}")
  puts "\n"
end

def ripDisc()
  puts "Ripping disc: #{@discNumber}"
  `powershell "Start-Transcript -Append #{ProjectDir}/cdimage.consolelog ; #{CueToolsPath} -D #{Drive} #{Mode} ; Stop-Transcript"`
end

def checkRipError()
  ripLog = File.readlines("#{ProjectDir}/cdimage.consolelog")
  ripResults = ripLog["#{ripLog.count - 5}".to_i]
  if ripResults.include?('Results')
    ripExit = 4
  else
    ripExit = 1
  end
end
def renameOutput(file,time,status)
  outName = 'cdrip-'
  outName.prepend('FAIL_') if status == 'fail'
  dir = File.dirname(file)
  ext = File.extname(file)
  outputFile = dir + '/' + outName + time + ext
  File.rename(file,outputFile)
end

# Start process
@discNumber = 1
Dir.chdir(ProjectDir)
while @discNumber <= DiscTotal do
  ripAttempt = 1
  # need to test this loop!
  loadDisc()
  while ripAttempt <=4
    ripDisc()
    ripAttempt += checkRipError()
  end
  unloadDisc()
  time = Time.now.strftime("%m%d%H%M%S")
  outputFiles = Dir.glob("#{ProjectDir}/cdimage*")
  if outputFiles.length == 4
    ripLog = File.readlines("#{ProjectDir}/cdimage.consolelog")
    ripResults = ripLog["#{ripLog.count - 5}".to_i]
    puts ripResults
    outputFiles.each {|file| renameOutput(file, time, 'pass')}
    # Might want to change to edit cue at this step (although workflow will do that during renaming)
    csvLine = "#{@discNumber}, cdrip-#{time}, #{ripResults}"
    open("#{ProjectDir}/rip-log.txt", 'a') { |f| f.puts csvLine}
     @discNumber += 1
  else
    csvLine = "#{@discNumber}, FAIL, FAIL"
    puts "Rip Failed!"
    outputFiles.each {|file| renameOutput(file, time, 'fail')}
    @discNumber += 1
    open("#{ProjectDir}/rip-log.txt", 'a') { |f| f.puts csvLine}
    #********** NEED TO RENAME CONSOLE LOG!!********
    next
  end
end
sleep 5
puts "All done!!"