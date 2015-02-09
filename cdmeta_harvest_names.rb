require 'open-uri'
require 'fileutils'
require 'json'
require 'nokogiri'
require 'yaml'
require 'colorize'
require './lib/repository.rb'
require './lib/collection.rb'
require './lib/compound_object.rb'
require './lib/item.rb'

# get repository configuration
uhdl = Repository.new

puts "\nDownloading Repository Metadata: Names\n"

# TSV header row
repository_names = "Collection\tAlias\tObject\tItem\tField_Vocab\tValue\n"

# uncomment next two lines for all collections
# collections = uhdl.get_collections(uhdl.cdm_url)
# collection_aliases = uhdl.get_collection_aliases(collections)

# or populate alias array for desired collections
# collection_aliases = ['houhistory']
collection_aliases = ['p15195coll39', 'p15195coll11']
# collection_aliases = ['djscrew', 'hawk']

collection_aliases.each do |collection_alias|

  # TSV header row
  collection_names = "Collection\tAlias\tObject\tItem\tField_Vocab\tValue\n"

  # get collection metadata mapping  
  collection = Collection.new(collection_alias, uhdl.cdm_url, uhdl.meta_map, uhdl.collection_long_titles, uhdl.collection_titles)
  print "\n\n#{collection.long_title} (#{collection_alias})...".red
  
  collection.items['records'].each do |record|

    print "#{record['pointer']}..".green
    id = "#{collection.title}\t#{collection_alias}\t#{record['pointer']}"

    # get metadata and names
    item = Item.new(collection_alias, record['pointer'], uhdl.cdm_url, collection.labels_and_nicks)
    # break out names by field and vocabulary
    # and add names to collection names report
    collection_names << item.break(item.names, id, record['pointer'], "names")

    if record['filetype'] == "cpd" # compound object

      # get list of items in object
      compound_object = CompoundObject.new(uhdl.cdm_url, collection_alias, record['pointer'])

      compound_object.items.each do |pointer|
        print "#{pointer}.".blue
        # get metadata and names
        item = Item.new(collection_alias, pointer, uhdl.cdm_url, collection.labels_and_nicks)
        # break out names by field and vocabulary
        # and add names to collection names report
        collection_names << item.break(item.names, id, pointer, "names")
      end

      print "\\".blue
    end
  end

  # add collection names to repository names string
  repository_names << collection_names.sub("Collection\tAlias\tObject\tItem\tField_Vocab\tValue\n", "")

  # write collection names report
  File.open(File.join(uhdl.download_dir, "name_reports", "#{collection.title}_#{Time.now.strftime("%Y%m%d_%k%M%S")}.tsv"), 'w') { |f| f.write(collection_names) }

end

# write repository names report
File.open(File.join(uhdl.download_dir, "name_reports", "uhdl_names_#{Time.now.strftime("%Y%m%d_%k%M%S")}.tsv"), 'w') { |f| f.write(repository_names) }

puts "\n"
