class Item

  attr_reader :metadata, :fields, :url, :level

  def initialize(repository, collection, level, object_pointer, item_pointer=nil)
    @level = level
    if level == 'object'
      @metadata = get_item_metadata(repository, collection, object_pointer)
      @url = "#{repository.base_url}/collection/#{collection.alias}/item/#{object_pointer}"
    else
      @metadata = get_item_metadata(repository, collection, item_pointer)
      @url = "#{repository.base_url}/collection/#{collection.alias}/item/#{object_pointer}/show/#{item_pointer}"
    end
    @fields = Hash.new
    begin
      collection.labels_and_nicks.each {|label, nick| @fields[label] = @metadata.fetch(nick).to_s }      
    rescue Exception
      print "KeyNotFound..."
      timestamp = Time.now.strftime("%Y%m%d_%k%M%S")
      File.open(File.join(repository.log_dir, "UHDLMysteryObjects.txt"), 'a') do |f|
        f.puts "#{timestamp}\tKeyNotFound\t#{collection.title}\t#{@url}\n"
        f.close
      end
    end
  end

  # get metadata hash from cdm api
  def get_item_metadata(repository, collection, pointer)
    cdm_item_metadata_url = repository.cdm_url + "dmGetItemInfo/#{collection.alias}/#{pointer}/json"
    item_metadata = JSON.parse(open(cdm_item_metadata_url).read)
  end

  # split multi-value, semicolon delimited fields into array
  def split_field(data)
    strings = []
    values = data.split(";")
    values.each { |v| strings << v.strip }
    strings
  end

  # split coordinates string into array
  def split_geographic(data)
    if data == nil
      coordinates = ["",""]
    elsif data.include? ";"
      coordinates = []
      values = data.split(';')
      values.each { |v| coordinates << v.strip }
      coordinates        
    else
      coordinates = []
      values = data.split(',')
      values.each { |v| coordinates << v.strip }
      coordinates        
    end
  end

  def validate_iso_date(date_iso) # returns true or false
    response = JSON.parse(open(URI.escape("http://digital2.library.unt.edu/edtf/isValid.json?date=#{date_iso}")).read)
    response.fetch('validEDTF')
  end

  def new_file_name(metadata)
    cdm_file_name = metadata.fetch("find").split(".")
    original_file_name = metadata.fetch("file").split(".")
    new_file_name = "#{original_file_name[0]}.#{cdm_file_name[1]}"
  end

  def download_file(download_dir, file_name, get_file_url, collection_alias, pointer)
    File.open(File.join(download_dir, file_name), "wb") do |saved_file|
      open(File.join(get_file_url, collection_alias, pointer.to_s), "rb") do |read_file|
        saved_file.write(read_file.read)
      end
    end
  end

end