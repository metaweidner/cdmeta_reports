require 'open-uri'
require 'fileutils'
require 'json'
require 'nokogiri'
require 'yaml'
require 'colorize'
require './repository.rb'
require './collection.rb'
require './compound_object.rb'
require './item.rb'


uhdl = Repository.new

puts "\nDownloading Repository Metadata: Subjects\n"
collection_count = 0
repository_subjects = "Collection Name\tAlias\tObject Pointer\tItem Pointer\tVocab\tOriginal Value\n"

# collections = get_collections(cdm_url)
# collection_aliases = get_collection_aliases(collections)

collection_aliases = ['p15195coll2']

collection_aliases.each do |collection_alias|

  collection_count += 1
  collection_subjects = "Collection Name\tAlias\tObject Pointer\tItem Pointer\tVocab\tOriginal Value\n"

  collection = Collection.new(collection_alias, uhdl.cdm_url, uhdl.meta_map, uhdl.collection_long_titles, uhdl.collection_titles)
  print "\n\n#{collection.long_title} (#{collection_alias})...".red

  collection.items['records'].each do |record|

    print "#{record['pointer']}..".green
    id = "#{collection.title}\t#{collection_alias}\t#{record['pointer']}"

    # get metadata and subjects
    item = Item.new(collection_alias, record['pointer'], uhdl.cdm_url, collection.labels_and_nicks)
    # break out subjects by vocabulary
    # and add names to collection names report
    collection_subjects << item.break(item.subjects, id, record['pointer'], "subject_topical")

    if record['filetype'] == "cpd" # compound object

      compound_object = CompoundObject.new(uhdl.cdm_url, collection_alias, record['pointer'])

      compound_object_items.each do |pointer|
        print "#{pointer}.".blue
        # get metadata and subjects
        item = Item.new(collection_alias, record['pointer'], uhdl.cdm_url, collection.labels_and_nicks)
        # break out subjects by vocabulary
        # and add names to collection names report
        collection_subjects << item.break(item.subjects, id, pointer, "subject_topical")
      end

      print "\\".blue
    end
  end

  repository_subjects << collection_subjects.sub("Collection Name\tAlias\tObject Pointer\tItem Pointer\tVocab\tOriginal Value\n", "")
  File.open(File.join(uhdl.download_dir, "subject_reports", "#{collection.title}_#{Time.now.strftime("%Y%m%d_%k%M%S")}.tsv"), 'w') { |f| f.write(collection_subjects) }

end

File.open(File.join(uhdl.download_dir, "subject_reports", "uhdl_subjects_#{Time.now.strftime("%Y%m%d_%k%M%S")}.tsv"), 'w') { |f| f.write(repository_subjects) }

puts "\n"
