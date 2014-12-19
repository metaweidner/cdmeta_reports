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

puts "\nDownloading Repository Metadata: Names\n"
collection_count = 0
repository_names = "Collection Name\tAlias\tObject Pointer\tItem Pointer\tField and Vocab\tOriginal Value\n"

# collections = get_collections(cdm_url)
# collection_aliases = get_collection_aliases(collections)

collection_aliases = ['djscrew', 'hawk']

collection_aliases.each do |collection_alias|

  collection_count += 1
  collection_names = "Collection Name\tAlias\tObject Pointer\tItem Pointer\tField and Vocab\tOriginal Value\n"
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

    # get object metadata and names
    object_info = get_item_info(cdm_url, collection_alias, record['pointer'])
    names = get_names(object_info, labels_and_nicks)

    # break out names by field and vocabulary
    names['creator_lcnaf']['value'].class == Hash ? creator_lcnaf = [] : creator_lcnaf = split_names('creator_lcnaf', names)
    names['creator_ulan']['value'].class == Hash ? creator_ulan = [] : creator_ulan = split_names('creator_ulan', names)
    names['creator_hot']['value'].class == Hash ? creator_hot = [] : creator_hot = split_names('creator_hot', names)
    names['creator_local']['value'].class == Hash ? creator_local = [] : creator_local = split_names('creator_local', names)
    names['contributor_lcnaf']['value'].class == Hash ? contributor_lcnaf = [] : contributor_lcnaf = split_names('contributor_lcnaf', names)
    names['contributor_ulan']['value'].class == Hash ? contributor_ulan = [] : contributor_ulan = split_names('contributor_ulan', names)
    names['contributor_hot']['value'].class == Hash ? contributor_hot = [] : contributor_hot = split_names('contributor_hot', names)
    names['contributor_local']['value'].class == Hash ? contributor_local = [] : contributor_local = split_names('contributor_local', names)
    names['subj_name_lcnaf']['value'].class == Hash ? subj_name_lcnaf = [] : subj_name_lcnaf = split_names('subj_name_lcnaf', names)
    names['subj_name_ulan']['value'].class == Hash ? subj_name_ulan = [] : subj_name_ulan = split_names('subj_name_ulan', names)
    names['subj_name_hot']['value'].class == Hash ? subj_name_hot = [] : subj_name_hot = split_names('subj_name_hot', names)
    names['subj_name_local']['value'].class == Hash ? subj_name_local = [] : subj_name_local = split_names('subj_name_local', names)
    names['author_lcnaf']['value'].class == Hash ? author_lcnaf = [] : author_lcnaf = split_names('author_lcnaf', names)
    names['author_ulan']['value'].class == Hash ? author_ulan = [] : author_ulan = split_names('author_ulan', names)
    names['author_hot']['value'].class == Hash ? author_hot = [] : author_hot = split_names('author_hot', names)
    names['author_local']['value'].class == Hash ? author_local = [] : author_local = split_names('author_local', names)
    names['artist_lcnaf']['value'].class == Hash ? artist_lcnaf = [] : artist_lcnaf = split_names('artist_lcnaf', names)
    names['artist_ulan']['value'].class == Hash ? artist_ulan = [] : artist_ulan = split_names('artist_ulan', names)
    names['artist_hot']['value'].class == Hash ? artist_hot = [] : artist_hot = split_names('artist_hot', names)
    names['artist_local']['value'].class == Hash ? artist_local = [] : artist_local = split_names('artist_local', names)
    names['composer_lcnaf']['value'].class == Hash ? composer_lcnaf = [] : composer_lcnaf = split_names('composer_lcnaf', names)
    names['composer_ulan']['value'].class == Hash ? composer_ulan = [] : composer_ulan = split_names('composer_ulan', names)
    names['composer_hot']['value'].class == Hash ? composer_hot = [] : composer_hot = split_names('composer_hot', names)
    names['composer_local']['value'].class == Hash ? composer_local = [] : composer_local = split_names('composer_local', names)
    names['added_composer_lcnaf']['value'].class == Hash ? added_composer_lcnaf = [] : added_composer_lcnaf = split_names('added_composer_lcnaf', names)
    names['added_composer_ulan']['value'].class == Hash ? added_composer_ulan = [] : added_composer_ulan = split_names('added_composer_ulan', names)
    names['added_composer_hot']['value'].class == Hash ? added_composer_hot = [] : added_composer_hot = split_names('added_composer_hot', names)
    names['added_composer_local']['value'].class == Hash ? added_composer_local = [] : added_composer_local = split_names('added_composer_local', names)
    names['co_creator']['value'].class == Hash ? co_creator = [] : co_creator = split_names('co_creator', names)

    # add names to collection names report
    creator_lcnaf.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcreator_lcnaf\t#{name}\n"} if creator_lcnaf[0]
    creator_ulan.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcreator_ulan\t#{name}\n"} if creator_ulan[0]
    creator_hot.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcreator_hot\t#{name}\n"} if creator_hot[0]
    creator_local.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcreator_local\t#{name}\n"} if creator_local[0]
    contributor_lcnaf.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcontributor_lcnaf\t#{name}\n"} if contributor_lcnaf[0]
    contributor_ulan.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcontributor_ulan\t#{name}\n"} if contributor_ulan[0]
    contributor_hot.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcontributor_hot\t#{name}\n"} if contributor_hot[0]
    contributor_local.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcontributor_local\t#{name}\n"} if contributor_local[0]
    subj_name_lcnaf.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tsubj_name_lcnaf\t#{name}\n"} if subj_name_lcnaf[0]
    subj_name_ulan.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tsubj_name_ulan\t#{name}\n"} if subj_name_ulan[0]
    subj_name_hot.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tsubj_name_hot\t#{name}\n"} if subj_name_hot[0]
    subj_name_local.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tsubj_name_local\t#{name}\n"} if subj_name_local[0]
    author_lcnaf.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tauthor_lcnaf\t#{name}\n"} if author_lcnaf[0]
    author_ulan.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tauthor_ulan\t#{name}\n"} if author_ulan[0]
    author_hot.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tauthor_hot\t#{name}\n"} if author_hot[0]
    author_local.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tauthor_local\t#{name}\n"} if author_local[0]
    artist_lcnaf.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tartist_lcnaf\t#{name}\n"} if artist_lcnaf[0]
    artist_ulan.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tartist_ulan\t#{name}\n"} if artist_ulan[0]
    artist_hot.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tartist_hot\t#{name}\n"} if artist_hot[0]
    artist_local.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tartist_local\t#{name}\n"} if artist_local[0]
    composer_lcnaf.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcomposer_lcnaf\t#{name}\n"} if composer_lcnaf[0]
    composer_ulan.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcomposer_ulan\t#{name}\n"} if composer_ulan[0]
    composer_hot.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcomposer_hot\t#{name}\n"} if composer_hot[0]
    composer_local.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcomposer_local\t#{name}\n"} if composer_local[0]
    added_composer_lcnaf.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tadded_composer_lcnaf\t#{name}\n"} if added_composer_lcnaf[0]
    added_composer_ulan.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tadded_composer_ulan\t#{name}\n"} if added_composer_ulan[0]
    added_composer_hot.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tadded_composer_hot\t#{name}\n"} if added_composer_hot[0]
    added_composer_local.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tadded_composer_local\t#{name}\n"} if added_composer_local[0]
    co_creator.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tco_creator\t#{name}\n"} if co_creator[0]

    if record['filetype'] == "cpd" # compound object

      # get compound object items and loop through each one
      compound_object_info = get_compound_object_info(cdm_url, collection_alias, record['pointer'])
      compound_object_items = get_compound_object_items(compound_object_info)
      compound_object_items.each do |pointer|

        print "#{pointer}.".blue

        # get object metadata and names
        object_info = get_item_info(cdm_url, collection_alias, pointer)
        names = get_names(object_info, labels_and_nicks)

        # break out names by field and vocabulary
        names['creator_lcnaf']['value'].class == Hash ? creator_lcnaf = [] : creator_lcnaf = split_names('creator_lcnaf', names)
        names['creator_ulan']['value'].class == Hash ? creator_ulan = [] : creator_ulan = split_names('creator_ulan', names)
        names['creator_hot']['value'].class == Hash ? creator_hot = [] : creator_hot = split_names('creator_hot', names)
        names['creator_local']['value'].class == Hash ? creator_local = [] : creator_local = split_names('creator_local', names)
        names['contributor_lcnaf']['value'].class == Hash ? contributor_lcnaf = [] : contributor_lcnaf = split_names('contributor_lcnaf', names)
        names['contributor_ulan']['value'].class == Hash ? contributor_ulan = [] : contributor_ulan = split_names('contributor_ulan', names)
        names['contributor_hot']['value'].class == Hash ? contributor_hot = [] : contributor_hot = split_names('contributor_hot', names)
        names['contributor_local']['value'].class == Hash ? contributor_local = [] : contributor_local = split_names('contributor_local', names)
        names['subj_name_lcnaf']['value'].class == Hash ? subj_name_lcnaf = [] : subj_name_lcnaf = split_names('subj_name_lcnaf', names)
        names['subj_name_ulan']['value'].class == Hash ? subj_name_ulan = [] : subj_name_ulan = split_names('subj_name_ulan', names)
        names['subj_name_hot']['value'].class == Hash ? subj_name_hot = [] : subj_name_hot = split_names('subj_name_hot', names)
        names['subj_name_local']['value'].class == Hash ? subj_name_local = [] : subj_name_local = split_names('subj_name_local', names)
        names['author_lcnaf']['value'].class == Hash ? author_lcnaf = [] : author_lcnaf = split_names('author_lcnaf', names)
        names['author_ulan']['value'].class == Hash ? author_ulan = [] : author_ulan = split_names('author_ulan', names)
        names['author_hot']['value'].class == Hash ? author_hot = [] : author_hot = split_names('author_hot', names)
        names['author_local']['value'].class == Hash ? author_local = [] : author_local = split_names('author_local', names)
        names['artist_lcnaf']['value'].class == Hash ? artist_lcnaf = [] : artist_lcnaf = split_names('artist_lcnaf', names)
        names['artist_ulan']['value'].class == Hash ? artist_ulan = [] : artist_ulan = split_names('artist_ulan', names)
        names['artist_hot']['value'].class == Hash ? artist_hot = [] : artist_hot = split_names('artist_hot', names)
        names['artist_local']['value'].class == Hash ? artist_local = [] : artist_local = split_names('artist_local', names)
        names['composer_lcnaf']['value'].class == Hash ? composer_lcnaf = [] : composer_lcnaf = split_names('composer_lcnaf', names)
        names['composer_ulan']['value'].class == Hash ? composer_ulan = [] : composer_ulan = split_names('composer_ulan', names)
        names['composer_hot']['value'].class == Hash ? composer_hot = [] : composer_hot = split_names('composer_hot', names)
        names['composer_local']['value'].class == Hash ? composer_local = [] : composer_local = split_names('composer_local', names)
        names['added_composer_lcnaf']['value'].class == Hash ? added_composer_lcnaf = [] : added_composer_lcnaf = split_names('added_composer_lcnaf', names)
        names['added_composer_ulan']['value'].class == Hash ? added_composer_ulan = [] : added_composer_ulan = split_names('added_composer_ulan', names)
        names['added_composer_hot']['value'].class == Hash ? added_composer_hot = [] : added_composer_hot = split_names('added_composer_hot', names)
        names['added_composer_local']['value'].class == Hash ? added_composer_local = [] : added_composer_local = split_names('added_composer_local', names)
        names['co_creator']['value'].class == Hash ? co_creator = [] : co_creator = split_names('co_creator', names)

        # add names to collection names report
        creator_lcnaf.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcreator_lcnaf\t#{name}\n"} if creator_lcnaf[0]
        creator_ulan.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcreator_ulan\t#{name}\n"} if creator_ulan[0]
        creator_hot.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcreator_hot\t#{name}\n"} if creator_hot[0]
        creator_local.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcreator_local\t#{name}\n"} if creator_local[0]
        contributor_lcnaf.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcontributor_lcnaf\t#{name}\n"} if contributor_lcnaf[0]
        contributor_ulan.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcontributor_ulan\t#{name}\n"} if contributor_ulan[0]
        contributor_hot.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcontributor_hot\t#{name}\n"} if contributor_hot[0]
        contributor_local.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcontributor_local\t#{name}\n"} if contributor_local[0]
        subj_name_lcnaf.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tsubj_name_lcnaf\t#{name}\n"} if subj_name_lcnaf[0]
        subj_name_ulan.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tsubj_name_ulan\t#{name}\n"} if subj_name_ulan[0]
        subj_name_hot.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tsubj_name_hot\t#{name}\n"} if subj_name_hot[0]
        subj_name_local.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tsubj_name_local\t#{name}\n"} if subj_name_local[0]
        author_lcnaf.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tauthor_lcnaf\t#{name}\n"} if author_lcnaf[0]
        author_ulan.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tauthor_ulan\t#{name}\n"} if author_ulan[0]
        author_hot.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tauthor_hot\t#{name}\n"} if author_hot[0]
        author_local.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tauthor_local\t#{name}\n"} if author_local[0]
        artist_lcnaf.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tartist_lcnaf\t#{name}\n"} if artist_lcnaf[0]
        artist_ulan.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tartist_ulan\t#{name}\n"} if artist_ulan[0]
        artist_hot.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tartist_hot\t#{name}\n"} if artist_hot[0]
        artist_local.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tartist_local\t#{name}\n"} if artist_local[0]
        composer_lcnaf.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcomposer_lcnaf\t#{name}\n"} if composer_lcnaf[0]
        composer_ulan.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcomposer_ulan\t#{name}\n"} if composer_ulan[0]
        composer_hot.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcomposer_hot\t#{name}\n"} if composer_hot[0]
        composer_local.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tcomposer_local\t#{name}\n"} if composer_local[0]
        added_composer_lcnaf.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tadded_composer_lcnaf\t#{name}\n"} if added_composer_lcnaf[0]
        added_composer_ulan.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tadded_composer_ulan\t#{name}\n"} if added_composer_ulan[0]
        added_composer_hot.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tadded_composer_hot\t#{name}\n"} if added_composer_hot[0]
        added_composer_local.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tadded_composer_local\t#{name}\n"} if added_composer_local[0]
        co_creator.each {|name| collection_names << "#{object_id}\t#{record['pointer']}\tco_creator\t#{name}\n"} if co_creator[0]
      end

      print "\\".blue
    end
  end

  repository_names << collection_names.sub("Collection Name\tAlias\tObject Pointer\tItem Pointer\tField and Vocab\tOriginal Value\n", "")
  File.open(File.join(download_dir, "name_reports", "#{collection_title}_#{Time.now.strftime("%Y%m%d_%k%M%S")}.tsv"), 'w') {|f| f.write(collection_names) }

end

File.open(File.join(download_dir, "name_reports", "uhdl_names_#{Time.now.strftime("%Y%m%d_%k%M%S")}.tsv"), 'w') {|f| f.write(repository_names) }
