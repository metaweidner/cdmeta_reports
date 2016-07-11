class Collection

  attr_reader :alias, :labels_and_nicks, :map, :long_title, :title, :items

  def initialize(collection_alias, repository)
    @alias = collection_alias
    # get field information and map to config file
    field_info = get_field_info(repository.cdm_url, collection_alias)
    @labels_and_nicks = get_labels_and_nicks(field_info)
    @map = get_collection_map(labels_and_nicks, repository.meta_map)
    # get titles
    @long_title = repository.collection_long_titles.fetch(collection_alias)
    @title = repository.collection_titles.fetch(collection_alias)
    #get items
    @items = get_items(repository.cdm_url, collection_alias)
  end

  # returns hash from cdm api: dmGetCollectionFieldInfo
  def get_field_info(cdm_url, collection_alias)
    cdm_field_info_url = cdm_url + "dmGetCollectionFieldInfo/#{collection_alias}/json"
    field_info = JSON.parse(open(cdm_field_info_url).read)
  end

  # returns field labels and cdm nicks hash
  def get_labels_and_nicks(field_info)
    labels_and_nicks = {}
    field_info.each { |field| labels_and_nicks.store(field['name'], field['nick']) }
    labels_and_nicks
  end

  # returns items hash from cdm api: dmQuery
  def get_items(cdm_url, collection_alias)
    cdm_items_url = cdm_url + "dmQuery/#{collection_alias}/0/title/title/2000/1/0/0/0/0/0/0/json"
    items = JSON.parse(open(cdm_items_url).read)
  end

  # returns field mapping hash based on config file
  def get_collection_map(labels_and_nicks, meta_map)
    collection_map = {}
    field_map = {}
    labels_and_nicks.each do |label, nick|
      field_map = meta_map.fetch(label)
      collection_map.store(nick, field_map)
    end
    # contentdm metadata fields
<<<<<<< HEAD
    collection_map.store('dmaccess', {'label' => 'dmaccess', 'namespace' => 'cdm', 'map' => 'dmAccess', 'type' => nil, 'vocab' => nil})
    collection_map.store('dmimage', {'label' => 'dmimage', 'namespace' => 'cdm', 'map' => 'dmImage', 'type' => nil, 'vocab' => nil})
    collection_map.store('restrictionCode', {'label' => 'restrictionCode', 'namespace' => 'cdm', 'map' => 'restrictionCode', 'type' => nil, 'vocab' => nil})
    collection_map.store('cdmfilesize', {'label' => 'cdmfilesize', 'namespace' => 'cdm', 'map' => 'fileSize', 'type' => nil, 'vocab' => nil})
    collection_map.store('cdmfilesizeformatted', {'label' => 'cdmfilesizeformatted', 'namespace' => 'cdm', 'map' => 'fileSizeFormatted', 'type' => nil, 'vocab' => nil})
    collection_map.store('cdmprintpdf', {'label' => 'cdmprintpdf', 'namespace' => 'cdm', 'map' => 'printPDF', 'type' => nil, 'vocab' => nil})
    collection_map.store('cdmhasocr', {'label' => 'cdmhasocr', 'namespace' => 'cdm', 'map' => 'hasOCR', 'type' => nil, 'vocab' => nil})
    collection_map.store('cdmisnewspaper', {'label' => 'cdmisnewspaper', 'namespace' => 'cdm', 'map' => 'isNewspaper', 'type' => nil, 'vocab' => nil})
=======
    collection_map.store("dmaccess", {"label" => "dmaccess", "category" => nil, "namespace" => "cdm", "map" => "dmAccess", "type" => nil, "vocab" => nil})
    collection_map.store("dmimage", {"label" => "dmimage", "category" => nil, "namespace" => "cdm", "map" => "dmImage", "type" => nil, "vocab" => nil})
    collection_map.store("restrictionCode", {"label" => "restrictionCode", "category" => nil, "namespace" => "cdm", "map" => "restrictionCode", "type" => nil, "vocab" => nil})
    collection_map.store("cdmfilesize", {"label" => "cdmfilesize", "category" => nil, "namespace" => "cdm", "map" => "fileSize", "type" => nil, "vocab" => nil})
    collection_map.store("cdmfilesizeformatted", {"label" => "cdmfilesizeformatted", "category" => nil, "namespace" => "cdm", "map" => "fileSizeFormatted", "type" => nil, "vocab" => nil})
    collection_map.store("cdmprintpdf", {"label" => "cdmprintpdf", "category" => nil, "namespace" => "cdm", "map" => "printPDF", "type" => nil, "vocab" => nil})
    collection_map.store("cdmhasocr", {"label" => "cdmhasocr", "category" => nil, "namespace" => "cdm", "map" => "hasOCR", "type" => nil, "vocab" => nil})
    collection_map.store("cdmisnewspaper", {"label" => "cdmisnewspaper", "category" => nil, "namespace" => "cdm", "map" => "isNewspaper", "type" => nil, "vocab" => nil})
>>>>>>> origin/master
    collection_map
  end

end
