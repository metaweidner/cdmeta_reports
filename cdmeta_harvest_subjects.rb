require 'open-uri'
require 'fileutils'
require 'json'
require 'nokogiri'
require 'yaml'
require 'colorize'
require './cdmeta_reports_methods'

config = YAML::load_file(File.join(__dir__, 'reports_config.yml'))

server = config['cdm']['server']
port = config['cdm']['port']
cdm_url = "http://#{server}:#{port}/dmwebservices/index.php?q="
download_dir = config['cdm']['download_dir']

meta_map_config = config['meta_map']
meta_map = meta_map_to_hash(meta_map_config)
collections_config = config['collections']
collection_titles = collection_titles_to_hash(collections_config)
collection_long_titles = collection_long_titles_to_hash(collections_config)

puts "\nDownloading Repository Metadata: Subjects\n"
collection_count = 0
repository_subjects = "Collection Name\tAlias\tObject Pointer\tItem Pointer\tVocab\tOriginal Value\n"

# collections = get_collections(cdm_url)
# collection_aliases = get_collection_aliases(collections)

collection_aliases = ['p15195coll2']

collection_aliases.each do |collection_alias|

  collection_count += 1
  collection_subjects = "Collection Name\tAlias\tObject Pointer\tItem Pointer\tVocab\tOriginal Value\n"
  collection_title = collection_titles.fetch(collection_alias)
  collection_long_title = collection_long_titles.fetch(collection_alias)
  print "\n\n#{collection_long_title} (#{collection_alias})...".red

  # get field information and map to dc
  field_info = get_field_info(cdm_url, collection_alias)
  labels_and_nicks = get_labels_and_nicks(field_info)
  collection_map = get_collection_map(labels_and_nicks, meta_map)

  # get collection objects and loop through each
  objects = get_items(cdm_url, collection_alias)
  objects['records'].each do |record|

    print "#{record['pointer']}..".green

    object_id = "#{collection_title}\t#{collection_alias}\t#{record['pointer']}"

    # get object metadata and subjects
    object_info = get_item_info(cdm_url, collection_alias, record['pointer'])
    subjects = get_subjects(object_info, labels_and_nicks)

    # break out subjects by vocabulary
    subjects['lcsh']['value'].class == Hash ? lcsh = [] : lcsh = split_subjects('lcsh', subjects)
    subjects['tgm']['value'].class == Hash ? tgm = [] : tgm = split_subjects('tgm', subjects)
    subjects['aat']['value'].class == Hash ? aat = [] : aat = split_subjects('aat', subjects)
    subjects['saa']['value'].class == Hash ? saa = [] : saa = split_subjects('saa', subjects)
    subjects['local']['value'].class == Hash ? local = [] : local = split_subjects('local', subjects)

    # add subjects to collection subjects report
    lcsh.each {|subject| collection_subjects << "#{object_id}\t#{record['pointer']}\tlcsh\t#{subject}\n"} if lcsh[0]
    tgm.each {|subject| collection_subjects << "#{object_id}\t#{record['pointer']}\ttgm\t#{subject}\n"} if tgm[0]
    aat.each {|subject| collection_subjects << "#{object_id}\t#{record['pointer']}\taat\t#{subject}\n"} if aat[0]
    saa.each {|subject| collection_subjects << "#{object_id}\t#{record['pointer']}\tsaa\t#{subject}\n"} if saa[0]
    local.each {|subject| collection_subjects << "#{object_id}\t#{record['pointer']}\tlocal\t#{subject}\n"} if local[0]

    if record['filetype'] == "cpd" # compound object

      # get compound object items and loop through each one
      compound_object_info = get_compound_object_info(cdm_url, collection_alias, record['pointer'])
      compound_object_items = get_compound_object_items(compound_object_info)
      compound_object_items.each do |pointer|

        print "#{pointer}.".blue

        # get object metadata and subjects
        object_info = get_item_info(cdm_url, collection_alias, pointer)
        subjects = get_subjects(object_info, labels_and_nicks)

        # break out subjects by vocabulary
        subjects['lcsh']['value'].class == Hash ? lcsh = [] : lcsh = split_subjects('lcsh', subjects)
        subjects['tgm']['value'].class == Hash ? tgm = [] : tgm = split_subjects('tgm', subjects)
        subjects['aat']['value'].class == Hash ? aat = [] : aat = split_subjects('aat', subjects)
        subjects['saa']['value'].class == Hash ? saa = [] : saa = split_subjects('saa', subjects)
        subjects['local']['value'].class == Hash ? local = [] : local = split_subjects('local', subjects)

        # add subjects to collection subjects report
        lcsh.each {|subject| collection_subjects << "#{object_id}\t#{pointer}\tlcsh\t#{subject}\n"} if lcsh[0]
        tgm.each {|subject| collection_subjects << "#{object_id}\t#{pointer}\ttgm\t#{subject}\n"} if tgm[0]
        aat.each {|subject| collection_subjects << "#{object_id}\t#{pointer}\taat\t#{subject}\n"} if aat[0]
        saa.each {|subject| collection_subjects << "#{object_id}\t#{pointer}\tsaa\t#{subject}\n"} if saa[0]
        local.each {|subject| collection_subjects << "#{object_id}\t#{pointer}\tlocal\t#{subject}\n"} if local[0]
      end

      print "\\".blue
    end
  end

  repository_subjects << collection_subjects.sub("Collection Name\tAlias\tObject Pointer\tItem Pointer\tVocab\tOriginal Value\n", "")
  File.open(File.join(download_dir, "subject_reports", "#{collection_title}_#{Time.now.strftime("%Y%m%d_%k%M%S")}.tsv"), 'w') {|f| f.write(collection_subjects) }

end

File.open(File.join(download_dir, "subject_reports", "uhdl_subjects_#{Time.now.strftime("%Y%m%d_%k%M%S")}.tsv"), 'w') {|f| f.write(repository_subjects) }
