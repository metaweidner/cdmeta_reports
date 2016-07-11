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

puts "\nDownloading Repository Metadata: Subjects\n"

# TSV header row
repository_subjects = "Collection\tAlias\tObject\tItem\tVocab\tValue\n"

# uncomment next two lines for all collections
# collections = uhdl.get_collections(uhdl.cdm_url)
# collection_aliases = uhdl.get_collection_aliases(collections)

# or populate alias array for desired collections
collection_aliases = ['p15195coll2']

collection_aliases.each do |collection_alias|

  # TSV header row
  collection_subjects = "Collection\tAlias\tObject\tItem\tVocab\tValue\n"

  # get collection metadata mapping
  collection = Collection.new(collection_alias, uhdl.cdm_url, uhdl.meta_map, uhdl.collection_long_titles, uhdl.collection_titles)
  print "\n\n#{collection.long_title} (#{collection_alias})...".red

  collection.items['records'].each do |record|

    print "#{record['pointer']}..".green
    id = "#{collection.title}\t#{collection_alias}\t#{record['pointer']}"

    # get metadata and subjects
    item = Item.new(collection_alias, record['pointer'], uhdl.cdm_url, collection.labels_and_nicks)
    # break out subjects by vocabulary
    # and add names to collection names report
    collection_subjects << item.break(item.subjects, id, record['pointer'], 'subject_topical')

    if record['filetype'] == 'cpd' # compound object

      # get list of items in object
      compound_object = CompoundObject.new(uhdl.cdm_url, collection_alias, record['pointer'])

      compound_object_items.each do |pointer|
        print "#{pointer}.".blue
        # get metadata and subjects
        item = Item.new(collection_alias, record['pointer'], uhdl.cdm_url, collection.labels_and_nicks)
        # break out subjects by vocabulary
        # and add names to collection names report
        collection_subjects << item.break(item.subjects, id, pointer, 'subject_topical')
      end

      print "\\".blue
    end
  end

  # add collection subjects to repository subjects string
  repository_subjects << collection_subjects.sub("Collection\tAlias\tObject\tItem\tVocab\tValue\n", '')

  # write collection subjects report
  File.open(File.join(uhdl.download_dir, 'subject_reports', "#{collection.title}_#{Time.now.strftime('%Y%m%d_%k%M%S')}.tsv"), 'w') { |f| f.write(collection_subjects) }

end

# write repository subjects report
File.open(File.join(uhdl.download_dir, 'subject_reports', "uhdl_subjects_#{Time.now.strftime('%Y%m%d_%k%M%S')}.tsv"), 'w') { |f| f.write(repository_subjects) }

puts "\n"
