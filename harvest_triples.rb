require 'open-uri'
require 'fileutils'
require 'json'
require 'nokogiri'
require 'yaml'
require 'colorize'
require './lib/repository.rb'
require './lib/collection.rb'
require './lib/report.rb'
require './lib/item.rb'
require './lib/cdmeta.rb'
require './lib/compound_object.rb'

# get repository configuration
uhdl = Repository.new

puts "\nDownloading Collections\n"

time_stamp = Time.now.strftime('%Y%m%d_%k%M%S')

# uncomment next two lines for all collections
collections = uhdl.get_collections(uhdl.cdm_url)
collection_aliases = uhdl.get_collection_aliases(collections)

# or populate alias array for desired collections
# collection_aliases = ['p15195coll5','p15195coll17','p15195coll2','p15195coll10','p15195coll26','p15195coll4','p15195coll3','uhtt','p15195coll6','hca30','ville']
# collection_aliases = ['p15195coll4' ,'hca30', 'ville']
# collection_aliases = ['hca30', 'ville', '2013_009']
# collection_aliases = ['2013_009'] # dj styles
# collection_aliases = ['reims']
collection_aliases = ['p15195coll4', 'ville'] # texas city disaster photos
# collection_aliases = ['p15195coll5'] #
# collection_aliases = ['p15195coll16'] #
# collection_aliases = ['p15195coll14'] #
# collection_aliases = ['p15195coll12'] # israel shreve
# collection_aliases = ['earlytex']
# collection_aliases = ['sham']
# collection_aliases = ['mcdav']
# collection_aliases = ['p15195coll15'] # ship of fools woodcuts
# collection_aliases = ['p15195coll3'] # uh buildings
# collection_aliases = ['p15195coll34'] # 1850s 1860s hotel menus
# collection_aliases = ['p15195coll22'] # uss houston bluebonnet newsletters
# collection_aliases = ['slough']

collection_aliases.each_with_index do |collection_alias, index|

  # get collection metadata mapping
  collection = Collection.new(collection_alias, uhdl)
  print "\n\n#{collection.long_title} (#{collection_alias})...".red

  # set up reports
  report = Report.new('graph', uhdl, collection, 'triples', 'nt')
  report.collection_data << report.header
  report.repository_data << report.header if index == 0

  # create collection download directory
  FileUtils::mkdir_p report.collection_dir
  # create collection files directory
  FileUtils::mkdir_p report.file_dir if file_download == 'yes'

  # iterate through all objects in collection
  collection.items['records'].each do |record|

    print "#{record['pointer']}..".green

    # get item metadata
    item = Item.new(uhdl, collection, 'object', record['pointer'])
    metadata = Cdmeta.new(collection.alias, report, item)
    # add triples to report
    report.collection_data << metadata.add_triples(metadata)
  end

  # write collection report
  report.write(report.collection_dir, report.name, report.collection_data)
  # add collection report to repository report
  report.repository_data << report.collection_data.sub(report.header, '')
  # append to repository report
  report.append(report.dir, "uhdl_#{report.type}_#{time_stamp}.#{report.format}", report.repository_data)

  print 'END'.red
end

puts "\n"
