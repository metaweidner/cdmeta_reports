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

puts "\nDownloading Repository Metadata: Names\n"
collection_count = 0
repository_names = "Collection Name\tAlias\tObject Pointer\tItem Pointer\tField and Vocab\tOriginal Value\n"

# collections = uhdl.get_collections(uhdl.cdm_url)
# collection_aliases = uhdl.get_collection_aliases(collections)

collection_aliases = ['houhistory']
# collection_aliases = ['p15195coll39', 'p15195coll11']
# collection_aliases = ['djscrew', 'hawk']

collection_aliases.each do |collection_alias|

  collection_count += 1
  collection_names = "Collection Name\tAlias\tObject Pointer\tItem Pointer\tField and Vocab\tOriginal Value\n"

  collection = Collection.new(collection_alias, uhdl.cdm_url, uhdl.meta_map, uhdl.collection_long_titles, uhdl.collection_titles)
  print "\n\n#{collection.long_title} (#{collection_alias})...".red
  
  collection.items['records'].each do |record|

    print "#{record['pointer']}..".green
    id = "#{collection.title}\t#{collection_alias}\t#{record['pointer']}"

    # get metadata and names
    item = Item.new(collection_alias, record['pointer'], uhdl.cdm_url, collection.labels_and_nicks)
    # break out names by field and vocabulary
    # and add names to collection names report
    collection_names << item.break(item.names, id, record['pointer'])

    if record['filetype'] == "cpd" # compound object

      compound_object = CompoundObject.new(uhdl.cdm_url, collection_alias, record['pointer'])

      compound_object.items.each do |pointer|
        print "#{pointer}.".blue
        # get metadata and names
        item = Item.new(collection_alias, pointer, uhdl.cdm_url, collection.labels_and_nicks)
        # break out names by field and vocabulary
        # and add names to collection names report
        collection_names << item.break(item.names, id, pointer)
      end

      print "\\".blue
    end
  end

  repository_names << collection_names.sub("Collection Name\tAlias\tObject Pointer\tItem Pointer\tField and Vocab\tOriginal Value\n", "")
  File.open(File.join(uhdl.download_dir, "name_reports", "#{collection.title}_#{Time.now.strftime("%Y%m%d_%k%M%S")}.tsv"), 'w') { |f| f.write(collection_names) }

end

File.open(File.join(uhdl.download_dir, "name_reports", "uhdl_names_#{Time.now.strftime("%Y%m%d_%k%M%S")}.tsv"), 'w') { |f| f.write(repository_names) }

puts "\n"