require 'fileutils'

lcsh = []
tgm = []
aat = []
saa = []
local = []

# pass in the cdmeta_harvest file name
# as command line argument
File.open(ARGV[0], 'r') do |f|

  # parse each line
  f.each_line do |line|

    # split the line on the tabs
    data = line.split("\t")
    # collection_name = data[0]
    # collection_alias = data[1]
    # object_pointer = data[2]
    # item_pointer = data[3]
    vocab = data[4]
    value = data[5]

    # write unique values to vocab arrays
    if (vocab == 'lcsh')
      lcsh << value unless lcsh.include? value
    elsif (vocab == 'tgm')
      tgm << value unless tgm.include? value
    elsif (vocab == 'aat')
      aat << value unless aat.include? value
    elsif (vocab == 'saa')
      saa << value unless saa.include? value
    else
      local << value unless local.include? value
    end
  end

  # write files for each vocab with sorted unique values
  File.open(File.join(__dir__, "lcsh_subjects_#{Time.now.strftime("%Y%m%d_%k%M%S")}.txt"), 'w') do |f|
    lcsh.sort.each {|value| f.puts(value) }
  end
  File.open(File.join(__dir__, "tgm_subjects_#{Time.now.strftime("%Y%m%d_%k%M%S")}.txt"), 'w') do |f|
    tgm.sort.each {|value| f.puts(value) }
  end
  File.open(File.join(__dir__, "aat_subjects_#{Time.now.strftime("%Y%m%d_%k%M%S")}.txt"), 'w') do |f|
    aat.sort.each {|value| f.puts(value) }
  end
  File.open(File.join(__dir__, "saa_subjects_#{Time.now.strftime("%Y%m%d_%k%M%S")}.txt"), 'w') do |f|
    saa.sort.each {|value| f.puts(value) }
  end
  File.open(File.join(__dir__, "local_subjects_#{Time.now.strftime("%Y%m%d_%k%M%S")}.txt"), 'w') do |f|
    local.sort.each {|value| f.puts(value) }
  end
end