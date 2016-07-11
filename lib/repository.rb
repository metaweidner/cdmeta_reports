class Repository

  attr_reader :cdm_url, :get_file_url, :base_url, :download_dir, :log_dir, :collection_titles, :collection_long_titles, :meta_map

  def initialize
    config = YAML::load_file(File.join(__dir__, 'config.yml'))
    server = config['cdm']['server']
    port = config['cdm']['port']
    @cdm_url = "http://#{server}:#{port}/dmwebservices/index.php?q="
    @get_file_url = "http://#{server}/contentdm/file/get/"
    @base_url = "http://#{server}"
    @download_dir = config['cdm']['download_dir']
    @log_dir = File.join(@download_dir, 'logs')
    collections_config = config['collections']
    @collection_titles = collection_titles_to_hash(collections_config)
    @collection_long_titles = collection_long_titles_to_hash(collections_config)
    meta_map_config = config['meta_map']
    @meta_map = meta_map_to_hash(meta_map_config)
  end

  def collection_titles_to_hash(collections_config)
    collections_hash = {}
    collections_config.each { |collection| collections_hash.store(collection['alias'], collection['title']) }
    collections_hash
  end

  def collection_long_titles_to_hash(collections_config)
    collections_hash = {}
    collections_config.each { |collection| collections_hash.store(collection['alias'], collection['long_title']) }
    collections_hash
  end

  def meta_map_to_hash(meta_map_config)
    meta_map_hash = {}
<<<<<<< HEAD
    meta_map_config.each { |field| meta_map_hash.store(field['label'], {'label' => field['label'], 'namespace' => field['namespace'], 'map' => field['map'], 'type' => field['type'], 'vocab' => field['vocab']}) }
=======
    meta_map_config.each { |field| meta_map_hash.store(field['label'], {"label" => field['label'], "category" => field['category'], "namespace" => field['namespace'], "map" => field['map'], "type" => field['type'], "vocab" => field['vocab']}) }
>>>>>>> origin/master
    meta_map_hash
  end

  def get_collections(cdm_url)
    cdm_collections_url = cdm_url + 'dmGetCollectionList/json'
    collections = JSON.parse(open(cdm_collections_url).read)
  end

  def get_collection_aliases(collections)
    collection_aliases = []
    collections.each {|v| collection_aliases << v['secondary_alias']}
    collection_aliases
  end

end
