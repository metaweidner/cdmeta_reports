class CompoundObject

  attr_reader :items

  def initialize(repository, collection, pointer)
    info = get_compound_object_info(repository, collection, pointer)
    @items = get_compound_object_items(info)
  end

  # cdm api XML: dmGetCompoundObjectInfo
  def get_compound_object_info(repository, collection, pointer)
    cdm_compound_object_info_url = repository.cdm_url + "dmGetCompoundObjectInfo/#{collection.alias}/#{pointer}/xml"
    compound_object_info = Nokogiri::XML(open(cdm_compound_object_info_url))
  end

  # parse dmGetCompoundObjectInfo XML
  def get_compound_object_items(info)
    compound_object_items = info.xpath("//pageptr/text()")
  end

end
