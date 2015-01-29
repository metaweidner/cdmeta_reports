class Collection

  attr_reader :map, :long_title, :title, :items, :labels_and_nicks

  def initialize(collection_alias, cdm_url, meta_map, collection_long_titles, collection_titles)
    # get field information and map to dc
    field_info = get_field_info(cdm_url, collection_alias)
    @labels_and_nicks = get_labels_and_nicks(field_info)
    @map = get_collection_map(labels_and_nicks, meta_map)

    # get titles
    @long_title = collection_long_titles.fetch(collection_alias)
    @title = collection_titles.fetch(collection_alias)

    #get items
    @items = get_items(cdm_url, collection_alias)

  end

  def get_field_info(cdm_url, collection_alias)
    cdm_field_info_url = cdm_url + "dmGetCollectionFieldInfo/#{collection_alias}/json"
    field_info = JSON.parse(open(cdm_field_info_url).read)
  end

  def get_labels_and_nicks(field_info)
    labels_and_nicks = {}
    field_info.each {|field| labels_and_nicks.store(field['name'], field['nick'])}
    labels_and_nicks
  end

  def get_items(cdm_url, collection_alias)
    cdm_items_url = cdm_url + "dmQuery/#{collection_alias}/0/title/title/2000/1/0/0/0/0/0/0/json"
    items = JSON.parse(open(cdm_items_url).read)
  end

  def get_collection_map(labels_and_nicks, meta_map)
    collection_map = {}
    field_map = {}
    labels_and_nicks.each do |label, nick|
      field_map = meta_map.fetch(label)
      collection_map.store(nick, field_map)
    end
    # contentdm metadata fields
    collection_map.store("dmaccess", {"label" => "dmaccess", "namespace" => "cdm", "map" => "dmAccess", "type" => nil, "vocab" => nil})
    collection_map.store("dmimage", {"label" => "dmimage", "namespace" => "cdm", "map" => "dmImage", "type" => nil, "vocab" => nil})
    collection_map.store("restrictionCode", {"label" => "restrictionCode", "namespace" => "cdm", "map" => "restrictionCode", "type" => nil, "vocab" => nil})
    collection_map.store("cdmfilesize", {"label" => "cdmfilesize", "namespace" => "cdm", "map" => "fileSize", "type" => nil, "vocab" => nil})
    collection_map.store("cdmfilesizeformatted", {"label" => "cdmfilesizeformatted", "namespace" => "cdm", "map" => "fileSizeFormatted", "type" => nil, "vocab" => nil})
    collection_map.store("cdmprintpdf", {"label" => "cdmprintpdf", "namespace" => "cdm", "map" => "printPDF", "type" => nil, "vocab" => nil})
    collection_map.store("cdmhasocr", {"label" => "cdmhasocr", "namespace" => "cdm", "map" => "hasOCR", "type" => nil, "vocab" => nil})
    collection_map.store("cdmisnewspaper", {"label" => "cdmisnewspaper", "namespace" => "cdm", "map" => "isNewspaper", "type" => nil, "vocab" => nil})
    collection_map
  end

end
