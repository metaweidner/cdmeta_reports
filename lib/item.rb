class Item

  attr_reader :metadata

  def initialize(collection_alias, pointer, cdm_url)
    @metadata = get_item_metadata(cdm_url, collection_alias, pointer)
  end

  # get metadata hash from cdm api
  def get_item_metadata(cdm_url, collection_alias, pointer)
    cdm_item_metadata_url = cdm_url + "dmGetItemInfo/#{collection_alias}/#{pointer}/json"
    item_metadata = JSON.parse(open(cdm_item_metadata_url).read)
  end

  # split multi-value, semicolon delimited fields into array
  def split(data)
    strings = []
    values = data.split(";")
    values.each { |v| strings << v.strip }
    strings
  end

end