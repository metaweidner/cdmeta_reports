def get_collections(cdm_url)
  cdm_collections_url = cdm_url + "dmGetCollectionList/json"
  collections = JSON.parse(open(cdm_collections_url).read)
end


def get_collection_aliases(collections)
  collection_aliases = []
  collections.each {|v| collection_aliases << v['secondary_alias']}
  collection_aliases
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


def meta_map_to_hash(meta_map_config)
  meta_map_hash = {}
  meta_map_config.each {|field| meta_map_hash.store(field['label'], {"label" => field['label'], "namespace" => field['namespace'], "map" => field['map'], "type" => field['type'], "vocab" => field['vocab']}) }
  meta_map_hash
end


def meta_map_to_hash_dspace(meta_map_config)
  meta_map_hash = {}
  meta_map_config.each {|field| meta_map_hash.store(field['label'], {"label" => field['label'], "namespace" => field['namespace'], "element" => field['element'], "qualifier" => field['qualifier'], "vocab" => field['vocab']}) }
  meta_map_hash
end


def collections_to_hash(collections_config)
  collections_hash = {}
  collections_config.each {|collection| collections_hash.store(collection['alias'], collection['title']) }
  collections_hash
end


def collection_titles_to_hash(collections_config)
  collections_hash = {}
  collections_config.each {|collection| collections_hash.store(collection['alias'], collection['title']) }
  collections_hash
end


def collection_long_titles_to_hash(collections_config)
  collections_hash = {}
  collections_config.each {|collection| collections_hash.store(collection['alias'], collection['long_title']) }
  collections_hash
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


def get_items(cdm_url, collection_alias)
  cdm_items_url = cdm_url + "dmQuery/#{collection_alias}/0/title/title/2000/1/0/0/0/0/0/0/json"
  items = JSON.parse(open(cdm_items_url).read)
end


def get_item_info(cdm_url, collection_alias, item_pointer)
  cdm_item_info_url = cdm_url + "dmGetItemInfo/#{collection_alias}/#{item_pointer}/json"
  item_info = JSON.parse(open(cdm_item_info_url).read)
end


def get_compound_object_info(cdm_url, collection_alias, item_pointer)
  cdm_compound_object_info_url = cdm_url + "dmGetCompoundObjectInfo/#{collection_alias}/#{item_pointer}/xml"
  compound_object_info = Nokogiri::XML(open(cdm_compound_object_info_url))
end


def get_compound_object_items(compound_object_info)
  compound_object_items = compound_object_info.xpath("//pageptr/text()")
end


def get_subjects(object_info, labels_and_nicks)

  subjects = {}

  lcsh_nick = labels_and_nicks['Subject.Topical (LCSH)']
  tgm_nick = labels_and_nicks['Subject.Topical (TGM-1)']
  aat_nick = labels_and_nicks['Subject.Topical (AAT)']
  saa_nick = labels_and_nicks['Subject.Topical (SAA)']
  local_nick = labels_and_nicks['Subject.Topical (Local)']

  lcsh = object_info[lcsh_nick]
  tgm = object_info[tgm_nick]
  aat = object_info[aat_nick]
  saa = object_info[saa_nick]
  local = object_info[local_nick]

  subjects.store('lcsh', {'label' => 'Subject.Topical (LCSH)', 'value' => lcsh})
  subjects.store('tgm', {'label' => 'Subject.Topical (TGM-1)', 'value' => tgm})
  subjects.store('aat', {'label' => 'Subject.Topical (AAT)', 'value' => aat})
  subjects.store('saa', {'label' => 'Subject.Topical (SAA)', 'value' => saa})
  subjects.store('local', {'label' => 'Subject.Topical (Local)', 'value' => local})

  subjects
end


def split_subjects(vocab, subjects)
  subject_strings = []
  if subjects[vocab]['value'].nil?
    subject_strings << "There is a problem with this object."
  else
    if subjects[vocab]['value'].include? ";"
      values = subjects[vocab]['value'].split(";")
      values.each {|v| subject_strings << v.strip }
    else
      subject_strings << subjects[vocab]['value'].strip
    end
  end
  subject_strings
end


def get_names(object_info, labels_and_nicks)
  names = {}
  names.store('creator_lcnaf', {'label' => 'Creator (LCNAF)', 'value' => object_info[labels_and_nicks['Creator (LCNAF)']]})
  names.store('creator_ulan', {'label' => 'Creator (ULAN)', 'value' => object_info[labels_and_nicks['Creator (ULAN)']]})
  names.store('creator_hot', {'label' => 'Creator (HOT)', 'value' => object_info[labels_and_nicks['Creator (HOT)']]})
  names.store('creator_local', {'label' => 'Creator (Local)', 'value' => object_info[labels_and_nicks['Creator (Local)']]})
  names.store('contributor_lcnaf', {'label' => 'Contributor (LCNAF)', 'value' => object_info[labels_and_nicks['Contributor (LCNAF)']]})
  names.store('contributor_ulan', {'label' => 'Contributor (ULAN)', 'value' => object_info[labels_and_nicks['Contributor (ULAN)']]})
  names.store('contributor_hot', {'label' => 'Contributor (HOT)', 'value' => object_info[labels_and_nicks['Contributor (HOT)']]})
  names.store('contributor_local', {'label' => 'Contributor (Local)', 'value' => object_info[labels_and_nicks['Contributor (Local)']]})
  names.store('subj_name_lcnaf', {'label' => 'Subject.Name (LCNAF)', 'value' => object_info[labels_and_nicks['Subject.Name (LCNAF)']]})
  names.store('subj_name_ulan', {'label' => 'Subject.Name (ULAN)', 'value' => object_info[labels_and_nicks['Subject.Name (ULAN)']]})
  names.store('subj_name_hot', {'label' => 'Subject.Name (HOT)', 'value' => object_info[labels_and_nicks['Subject.Name (HOT)']]})
  names.store('subj_name_local', {'label' => 'Subject.Name (Local)', 'value' => object_info[labels_and_nicks['Subject.Name (Local)']]})
  names.store('author_lcnaf', {'label' => 'Author (LCNAF)', 'value' => object_info[labels_and_nicks['Author (LCNAF)']]})
  names.store('author_ulan', {'label' => 'Author (ULAN)', 'value' => object_info[labels_and_nicks['Author (ULAN)']]})
  names.store('author_hot', {'label' => 'Author (HOT)', 'value' => object_info[labels_and_nicks['Author (HOT)']]})
  names.store('author_local', {'label' => 'Author (Local)', 'value' => object_info[labels_and_nicks['Author (Local)']]})
  names.store('artist_lcnaf', {'label' => 'Artist (LCNAF)', 'value' => object_info[labels_and_nicks['Artist (LCNAF)']]})
  names.store('artist_ulan', {'label' => 'Artist (ULAN)', 'value' => object_info[labels_and_nicks['Artist (ULAN)']]})
  names.store('artist_hot', {'label' => 'Artist (HOT)', 'value' => object_info[labels_and_nicks['Artist (HOT)']]})
  names.store('artist_local', {'label' => 'Artist (Local)', 'value' => object_info[labels_and_nicks['Artist (Local)']]})
  names.store('composer_lcnaf', {'label' => 'Composer (LCNAF)', 'value' => object_info[labels_and_nicks['Composer (LCNAF)']]})
  names.store('composer_ulan', {'label' => 'Composer (ULAN)', 'value' => object_info[labels_and_nicks['Composer (ULAN)']]})
  names.store('composer_hot', {'label' => 'Composer (HOT)', 'value' => object_info[labels_and_nicks['Composer (HOT)']]})
  names.store('composer_local', {'label' => 'Composer (Local)', 'value' => object_info[labels_and_nicks['Composer (Local)']]})
  names.store('added_composer_lcnaf', {'label' => 'Added Composers (LCNAF)', 'value' => object_info[labels_and_nicks['Added Composers (LCNAF)']]})
  names.store('added_composer_ulan', {'label' => 'Added Composers (ULAN)', 'value' => object_info[labels_and_nicks['Added Composers (ULAN)']]})
  names.store('added_composer_hot', {'label' => 'Added Composers (HOT)', 'value' => object_info[labels_and_nicks['Added Composers (HOT)']]})
  names.store('added_composer_local', {'label' => 'Added Composers (Local)', 'value' => object_info[labels_and_nicks['Added Composers (Local)']]})
  names.store('co_creator', {'label' => 'Co-creator', 'value' => object_info[labels_and_nicks['Co-creator']]})
  names
end


def split_names(vocab, names)
  name_strings = []
  if names[vocab]['value'].nil?
    return name_strings
  else
    if names[vocab]['value'].include? ";"
      values = names[vocab]['value'].split(";")
      values.each {|v| name_strings << v.strip }
    else
      name_strings << names[vocab]['value'].strip
    end
  end
  name_strings
end
