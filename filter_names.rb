require 'fileutils'

lcnaf = []
hot = []
ulan = []
local = []
co_creator = []

# pass in the cdmeta_harvest file path
# as command line argument
File.open(ARGV[0], 'r') do |f|

  # parse each line
  f.each_line do |line|

    # split the line on the tabs
    data = line.split("\t")
    collection_name = data[0]
    # collection_alias = data[1]
    # object_pointer = data[2]
    # item_pointer = data[3]
    field_label = data[4]
    value = data[5].chomp("\n")

    # write unique values to vocab arrays
    if (field_label == 'creator_lcnaf') || \
      (field_label == 'contributor_lcnaf') || \
      (field_label == 'subj_name_lcnaf') || \
      (field_label == 'author_lcnaf') || \
      (field_label == 'artist_lcnaf') || \
      (field_label == 'composer_lcnaf') || \
      (field_label == 'added_composer_lcnaf')
      lcnaf << [value, field_label, collection_name]
    elsif (field_label == 'creator_ulan') || \
      (field_label == 'contributor_ulan') || \
      (field_label == 'subj_name_ulan') || \
      (field_label == 'author_ulan') || \
      (field_label == 'artist_ulan') || \
      (field_label == 'composer_ulan') || \
      (field_label == 'added_composer_ulan')
      ulan << [value, field_label, collection_name]
    elsif (field_label == 'creator_hot') || \
      (field_label == 'contributor_hot') || \
      (field_label == 'subj_name_hot') || \
      (field_label == 'author_hot') || \
      (field_label == 'artist_hot') || \
      (field_label == 'composer_hot') || \
      (field_label == 'added_composer_hot')
      hot << [value, field_label, collection_name]
    elsif (field_label == 'creator_local') || \
      (field_label == 'contributor_local') || \
      (field_label == 'subj_name_local') || \
      (field_label == 'author_local') || \
      (field_label == 'artist_local') || \
      (field_label == 'composer_local') || \
      (field_label == 'added_composer_local')
      local << [value, field_label, collection_name]
    else
      co_creator << [value, field_label, collection_name]
    end
  end
end

# write files for each vocab with sorted unique values
File.open(File.join(__dir__, "lcnaf_names_#{Time.now.strftime("%Y%m%d_%k%M%S")}.txt"), 'w') do |f|
  lcnaf.sort_by! { |e| e[0] }
  lcnaf.uniq.each do |heading|
    line = ""
    heading.each { |h| line << h + "\t" }
    f.write(line.chomp("\t") + "\n")
  end
end
File.open(File.join(__dir__, "ulan_names_#{Time.now.strftime("%Y%m%d_%k%M%S")}.txt"), 'w') do |f|
  ulan.sort_by! { |e| e[0] }
  ulan.uniq.each do |heading|
    line = ""
    heading.each { |h| line << h + "\t" }
    f.write(line.chomp("\t") + "\n")
  end
end
File.open(File.join(__dir__, "hot_names_#{Time.now.strftime("%Y%m%d_%k%M%S")}.txt"), 'w') do |f|
  hot.sort_by! { |e| e[0] }
  hot.uniq.each do |heading|
    line = ""
    heading.each { |h| line << h + "\t" }
    f.write(line.chomp("\t") + "\n")
  end
end
File.open(File.join(__dir__, "local_names_#{Time.now.strftime("%Y%m%d_%k%M%S")}.txt"), 'w') do |f|
  local.sort_by! { |e| e[0] }
  local.uniq.each do |heading|
    line = ""
    heading.each { |h| line << h + "\t" }
    f.write(line.chomp("\t") + "\n")
  # write files for each vocab with sorted unique values
  File.open(File.join(__dir__, "lcnaf_names_#{Time.now.strftime('%Y%m%d_%k%M%S')}.txt"), 'w') do |f|
    lcnaf.sort.each {|element| f.puts(element) }
  end
  File.open(File.join(__dir__, "ulan_names_#{Time.now.strftime('%Y%m%d_%k%M%S')}.txt"), 'w') do |f|
    ulan.sort.each {|element| f.puts(element) }
  end
  File.open(File.join(__dir__, "hot_names_#{Time.now.strftime('%Y%m%d_%k%M%S')}.txt"), 'w') do |f|
    hot.sort.each {|element| f.puts(element) }
  end
  File.open(File.join(__dir__, "local_names_#{Time.now.strftime('%Y%m%d_%k%M%S')}.txt"), 'w') do |f|
    local.sort.each {|element| f.puts(element) }
  end
end
