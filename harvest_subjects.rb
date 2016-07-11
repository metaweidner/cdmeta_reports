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
tsv_header = "Collection\tURL\tElement\tValue\n"
repository_report = tsv_header

# uncomment next two lines for all collections
# collections = uhdl.get_collections(uhdl.cdm_url)
# collection_aliases = uhdl.get_collection_aliases(collections)

# or populate alias array for desired collections
collection_aliases = ['ville']

collection_aliases.each do |collection_alias|

  # TSV header row
  collection_report = tsv_header

  # get collection metadata mapping
  collection = Collection.new(collection_alias, uhdl)
  print "\n\n#{collection.long_title} (#{collection_alias})...".red

  collection.items['records'].each do |record|

    print "#{record['pointer']}..".green

    # get metadata and subjects
    item = Item.new(collection_alias, record['pointer'], uhdl.cdm_url, collection.labels_and_nicks)
    # break out subjects by vocabulary
    # and add names to collection names report
    collection_subjects << item.break(item.subjects, id, record['pointer'], 'subject_topical')
    object_url = "#{uhdl.base_url}/collection/#{collection_alias}/item/#{record['pointer']}"

    # get item metadata
    item = Item.new(collection_alias, record['pointer'], uhdl.cdm_url)
    # and cycle through all of the elements
    item.metadata.each do |nick,data|
      if data.is_a?(String)
        # get element config
        element_map = collection.map.fetch(nick)
        # limit to subject topical
        if (element_map.fetch('map') == "subject" && element_map.fetch('type') == "topic")
          # set up element_map values
          namespace = element_map.fetch('namespace')
          element = element_map.fetch('map')
          element_map.fetch('type') == nil ? type = "" : type = "." + element_map.fetch('type')
          element_map.fetch('vocab') == nil ? vocab = "" : vocab = "." + element_map.fetch('vocab')
          # split multi-value fields
          if data.include? ";"
            values = item.split(data)
            values.each { |v| collection_report << "#{collection.title}\t#{object_url}\t#{namespace}:#{element}#{type}#{vocab}\t#{v}\n" }
          else
            collection_report << "#{collection.title}\t#{object_url}\t#{namespace}:#{element}#{type}#{vocab}\t#{data}\n"
          end
        end
      end
    end

    if record['filetype'] == 'cpd' # compound object

      # get list of items in object
      compound_object = CompoundObject.new(uhdl.cdm_url, collection_alias, record['pointer'])

      compound_object.items.each do |pointer|
        print "#{pointer}.".blue
        # get metadata and subjects
        item = Item.new(collection_alias, record['pointer'], uhdl.cdm_url, collection.labels_and_nicks)
        # break out subjects by vocabulary
        # and add names to collection names report
        collection_subjects << item.break(item.subjects, id, pointer, 'subject_topical')
        # get item metadata
        item = Item.new(collection_alias, pointer, uhdl.cdm_url)
        # and cycle through all of the elements
        item.metadata.each do |nick,data|
          if data.is_a?(String)
            # get element config
            element_map = collection.map.fetch(nick)
            # limit to subject topical
            if (element_map.fetch('map') == "subject" && element_map.fetch('type') == "topic")
              # set up element_map values
              namespace = element_map.fetch('namespace')
              element = element_map.fetch('map')
              element_map.fetch('type') == nil ? type = "" : type = "." + element_map.fetch('type')
              element_map.fetch('vocab') == nil ? vocab = "" : vocab = "." + element_map.fetch('vocab')
              # split multi-value fields
              if data.include? ";"
                values = item.split(data)
                values.each { |v| collection_report << "#{collection.title}\t#{object_url}/show/#{pointer}\t#{namespace}:#{element}#{type}#{vocab}\t#{v}\n" }
              else
                collection_report << "#{collection.title}\t#{object_url}/show/#{pointer}\t#{namespace}:#{element}#{type}#{vocab}\t#{data}\n"
              end
            end
          end
        end
      end
      print "\\".blue
    end
  end

  # add collection subjects to repository subjects string
  repository_subjects << collection_subjects.sub("Collection\tAlias\tObject\tItem\tVocab\tValue\n", '')

  # write collection subjects report
  File.open(File.join(uhdl.download_dir, 'subject_reports', "#{collection.title}_#{Time.now.strftime('%Y%m%d_%k%M%S')}.tsv"), 'w') { |f| f.write(collection_subjects) }
  repository_report << collection_report.sub(tsv_header, "")

  # write collection subjects report
  File.open(File.join(uhdl.download_dir, "subject_reports", "#{collection.title}_#{Time.now.strftime("%Y%m%d_%k%M%S")}.tsv"), 'w') { |f| f.write(collection_report) }

end

# write repository subjects report
File.open(File.join(uhdl.download_dir, 'subject_reports', "uhdl_subjects_#{Time.now.strftime('%Y%m%d_%k%M%S')}.tsv"), 'w') { |f| f.write(repository_subjects) }
File.open(File.join(uhdl.download_dir, "subject_reports", "uhdl_subjects_#{Time.now.strftime("%Y%m%d_%k%M%S")}.tsv"), 'w') { |f| f.write(repository_report) }

puts "\n"
