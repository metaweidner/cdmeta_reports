class CompoundObject

  attr_reader :items

  def initialize(cdm_url, collection_alias, pointer)
    info = get_compound_object_info(cdm_url, collection_alias, pointer)
    @items = get_compound_object_items(info)
  end

  # cdm api XML: dmGetCompoundObjectInfo
  def get_compound_object_info(cdm_url, collection_alias, pointer)
    cdm_compound_object_info_url = cdm_url + "dmGetCompoundObjectInfo/#{collection_alias}/#{pointer}/xml"
    compound_object_info = Nokogiri::XML(open(cdm_compound_object_info_url))
  end

  def get_compound_object_items(info)
    compound_object_items = info.xpath('//pageptr/text()')
  end

end
