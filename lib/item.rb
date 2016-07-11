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
      print 'KeyNotFound...'
      timestamp = Time.now.strftime('%Y%m%d_%k%M%S')
      File.open(File.join(repository.log_dir, 'UHDLMysteryObjects.txt'), 'a') do |f|
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
    values = data.split(';')
    values.each { |v| strings << v.strip }
    strings
  end

  # split coordinates string into array
  def split_geographic(data)
    if data == nil
      coordinates = ['', '']
    elsif data.include? ';'
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

  # format report, one line for each value
  def break(container, id, pointer, function)

    if function == 'subject_topical'

      collection_subjects = ''
      
      # break out subjects by vocabulary
      container['lcsh']['value'].class == Hash ? lcsh = [] : lcsh = split_values('lcsh', container)
      container['tgm']['value'].class == Hash ? tgm = [] : tgm = split_values('tgm', container)
      container['aat']['value'].class == Hash ? aat = [] : aat = split_values('aat', container)
      container['saa']['value'].class == Hash ? saa = [] : saa = split_values('saa', container)
      container['local']['value'].class == Hash ? local = [] : local = split_values('local', container)

      # add subjects to collection subjects report
      lcsh.each { |subject| collection_subjects << "#{id}\t#{pointer}\tlcsh\t#{subject}\n" } if lcsh[0]
      tgm.each { |subject| collection_subjects << "#{id}\t#{pointer}\ttgm\t#{subject}\n" } if tgm[0]
      aat.each { |subject| collection_subjects << "#{id}\t#{pointer}\taat\t#{subject}\n" } if aat[0]
      saa.each { |subject| collection_subjects << "#{id}\t#{pointer}\tsaa\t#{subject}\n" } if saa[0]
      local.each { |subject| collection_subjects << "#{id}\t#{pointer}\tlocal\t#{subject}\n" } if local[0]

      return collection_subjects

    elsif function == 'names'

      collection_names = ''

      # break out names by field and vocabulary
      container['creator_lcnaf']['value'].class == Hash ? creator_lcnaf = [] : creator_lcnaf = split_values('creator_lcnaf', container)
      container['creator_ulan']['value'].class == Hash ? creator_ulan = [] : creator_ulan = split_values('creator_ulan', container)
      container['creator_hot']['value'].class == Hash ? creator_hot = [] : creator_hot = split_values('creator_hot', container)
      container['creator_local']['value'].class == Hash ? creator_local = [] : creator_local = split_values('creator_local', container)
      container['contributor_lcnaf']['value'].class == Hash ? contributor_lcnaf = [] : contributor_lcnaf = split_values('contributor_lcnaf', container)
      container['contributor_ulan']['value'].class == Hash ? contributor_ulan = [] : contributor_ulan = split_values('contributor_ulan', container)
      container['contributor_hot']['value'].class == Hash ? contributor_hot = [] : contributor_hot = split_values('contributor_hot', container)
      container['contributor_local']['value'].class == Hash ? contributor_local = [] : contributor_local = split_values('contributor_local', container)
      container['subj_name_lcnaf']['value'].class == Hash ? subj_name_lcnaf = [] : subj_name_lcnaf = split_values('subj_name_lcnaf', container)
      container['subj_name_ulan']['value'].class == Hash ? subj_name_ulan = [] : subj_name_ulan = split_values('subj_name_ulan', container)
      container['subj_name_hot']['value'].class == Hash ? subj_name_hot = [] : subj_name_hot = split_values('subj_name_hot', container)
      container['subj_name_local']['value'].class == Hash ? subj_name_local = [] : subj_name_local = split_values('subj_name_local', container)
      container['author_lcnaf']['value'].class == Hash ? author_lcnaf = [] : author_lcnaf = split_values('author_lcnaf', container)
      container['author_ulan']['value'].class == Hash ? author_ulan = [] : author_ulan = split_values('author_ulan', container)
      container['author_hot']['value'].class == Hash ? author_hot = [] : author_hot = split_values('author_hot', container)
      container['author_local']['value'].class == Hash ? author_local = [] : author_local = split_values('author_local', container)
      container['artist_lcnaf']['value'].class == Hash ? artist_lcnaf = [] : artist_lcnaf = split_values('artist_lcnaf', container)
      container['artist_ulan']['value'].class == Hash ? artist_ulan = [] : artist_ulan = split_values('artist_ulan', container)
      container['artist_hot']['value'].class == Hash ? artist_hot = [] : artist_hot = split_values('artist_hot', container)
      container['artist_local']['value'].class == Hash ? artist_local = [] : artist_local = split_values('artist_local', container)
      container['composer_lcnaf']['value'].class == Hash ? composer_lcnaf = [] : composer_lcnaf = split_values('composer_lcnaf', container)
      container['composer_ulan']['value'].class == Hash ? composer_ulan = [] : composer_ulan = split_values('composer_ulan', container)
      container['composer_hot']['value'].class == Hash ? composer_hot = [] : composer_hot = split_values('composer_hot', container)
      container['composer_local']['value'].class == Hash ? composer_local = [] : composer_local = split_values('composer_local', container)
      container['added_composer_lcnaf']['value'].class == Hash ? added_composer_lcnaf = [] : added_composer_lcnaf = split_values('added_composer_lcnaf', container)
      container['added_composer_ulan']['value'].class == Hash ? added_composer_ulan = [] : added_composer_ulan = split_values('added_composer_ulan', container)
      container['added_composer_hot']['value'].class == Hash ? added_composer_hot = [] : added_composer_hot = split_values('added_composer_hot', container)
      container['added_composer_local']['value'].class == Hash ? added_composer_local = [] : added_composer_local = split_values('added_composer_local', container)
      container['interviewer_lcnaf']['value'].class == Hash ? interviewer_lcnaf = [] : interviewer_lcnaf = split_values('interviewer_lcnaf', container)
      container['interviewer_ulan']['value'].class == Hash ? interviewer_ulan = [] : interviewer_ulan = split_values('interviewer_ulan', container)
      container['interviewer_hot']['value'].class == Hash ? interviewer_hot = [] : interviewer_hot = split_values('interviewer_hot', container)
      container['interviewer_local']['value'].class == Hash ? interviewer_local = [] : interviewer_local = split_values('interviewer_local', container)
      container['co_creator']['value'].class == Hash ? co_creator = [] : co_creator = split_values('co_creator', container)

      # add names to collection names report
      creator_lcnaf.each { |name| collection_names << "#{id}\t#{pointer}\tcreator_lcnaf\t#{name}\n" } if creator_lcnaf[0]
      creator_ulan.each { |name| collection_names << "#{id}\t#{pointer}\tcreator_ulan\t#{name}\n" } if creator_ulan[0]
      creator_hot.each { |name| collection_names << "#{id}\t#{pointer}\tcreator_hot\t#{name}\n" } if creator_hot[0]
      creator_local.each { |name| collection_names << "#{id}\t#{pointer}\tcreator_local\t#{name}\n" } if creator_local[0]
      contributor_lcnaf.each { |name| collection_names << "#{id}\t#{pointer}\tcontributor_lcnaf\t#{name}\n" } if contributor_lcnaf[0]
      contributor_ulan.each { |name| collection_names << "#{id}\t#{pointer}\tcontributor_ulan\t#{name}\n" } if contributor_ulan[0]
      contributor_hot.each { |name| collection_names << "#{id}\t#{pointer}\tcontributor_hot\t#{name}\n" } if contributor_hot[0]
      contributor_local.each { |name| collection_names << "#{id}\t#{pointer}\tcontributor_local\t#{name}\n" } if contributor_local[0]
      subj_name_lcnaf.each { |name| collection_names << "#{id}\t#{pointer}\tsubj_name_lcnaf\t#{name}\n" } if subj_name_lcnaf[0]
      subj_name_ulan.each { |name| collection_names << "#{id}\t#{pointer}\tsubj_name_ulan\t#{name}\n" } if subj_name_ulan[0]
      subj_name_hot.each { |name| collection_names << "#{id}\t#{pointer}\tsubj_name_hot\t#{name}\n" } if subj_name_hot[0]
      subj_name_local.each { |name| collection_names << "#{id}\t#{pointer}\tsubj_name_local\t#{name}\n" } if subj_name_local[0]
      author_lcnaf.each { |name| collection_names << "#{id}\t#{pointer}\tauthor_lcnaf\t#{name}\n" } if author_lcnaf[0]
      author_ulan.each { |name| collection_names << "#{id}\t#{pointer}\tauthor_ulan\t#{name}\n" } if author_ulan[0]
      author_hot.each { |name| collection_names << "#{id}\t#{pointer}\tauthor_hot\t#{name}\n" } if author_hot[0]
      author_local.each { |name| collection_names << "#{id}\t#{pointer}\tauthor_local\t#{name}\n" } if author_local[0]
      artist_lcnaf.each { |name| collection_names << "#{id}\t#{pointer}\tartist_lcnaf\t#{name}\n" } if artist_lcnaf[0]
      artist_ulan.each { |name| collection_names << "#{id}\t#{pointer}\tartist_ulan\t#{name}\n" } if artist_ulan[0]
      artist_hot.each { |name| collection_names << "#{id}\t#{pointer}\tartist_hot\t#{name}\n" } if artist_hot[0]
      artist_local.each { |name| collection_names << "#{id}\t#{pointer}\tartist_local\t#{name}\n" } if artist_local[0]
      composer_lcnaf.each { |name| collection_names << "#{id}\t#{pointer}\tcomposer_lcnaf\t#{name}\n" } if composer_lcnaf[0]
      composer_ulan.each { |name| collection_names << "#{id}\t#{pointer}\tcomposer_ulan\t#{name}\n" } if composer_ulan[0]
      composer_hot.each { |name| collection_names << "#{id}\t#{pointer}\tcomposer_hot\t#{name}\n" } if composer_hot[0]
      composer_local.each { |name| collection_names << "#{id}\t#{pointer}\tcomposer_local\t#{name}\n" } if composer_local[0]
      added_composer_lcnaf.each { |name| collection_names << "#{id}\t#{pointer}\tadded_composer_lcnaf\t#{name}\n" } if added_composer_lcnaf[0]
      added_composer_ulan.each { |name| collection_names << "#{id}\t#{pointer}\tadded_composer_ulan\t#{name}\n" } if added_composer_ulan[0]
      added_composer_hot.each { |name| collection_names << "#{id}\t#{pointer}\tadded_composer_hot\t#{name}\n" } if added_composer_hot[0]
      added_composer_local.each { |name| collection_names << "#{id}\t#{pointer}\tadded_composer_local\t#{name}\n" } if added_composer_local[0]
      interviewer_lcnaf.each { |name| collection_names << "#{id}\t#{pointer}\tinterviewer_lcnaf\t#{name}\n" } if interviewer_lcnaf[0]
      interviewer_ulan.each { |name| collection_names << "#{id}\t#{pointer}\tinterviewer_ulan\t#{name}\n" } if interviewer_ulan[0]
      interviewer_hot.each { |name| collection_names << "#{id}\t#{pointer}\tinterviewer_hot\t#{name}\n" } if interviewer_hot[0]
      interviewer_local.each { |name| collection_names << "#{id}\t#{pointer}\tinterviewer_local\t#{name}\n" } if interviewer_local[0]
      co_creator.each { |name| collection_names << "#{id}\t#{pointer}\tco_creator\t#{name}\n" } if co_creator[0]
    end
  end

  def validate_iso_date(date_iso) # returns true or false
    response = JSON.parse(open(URI.escape("http://digital2.library.unt.edu/edtf/isValid.json?date=#{date_iso}")).read)
    response.fetch('validEDTF')
  end

  def new_file_name(metadata)
    cdm_file_name = metadata.fetch('find').split('.')
    original_file_name = metadata.fetch('file').split('.')
    new_file_name = "#{original_file_name[0]}.#{cdm_file_name[1]}"
  end

  # split multi-value, semicolon delimited fields
  def split_values(vocab, container)
    strings = []
    if container[vocab]['value'].nil?
      return strings
    else
      if container[vocab]['value'].include? ';'
        values = container[vocab]['value'].split(';')
        values.each { |v| strings << v.strip }
      else
        strings << container[vocab]['value'].strip
      end
    end
  end

  def download_file(download_dir, file_name, get_file_url, collection_alias, pointer)
    File.open(File.join(download_dir, file_name), 'wb') do |saved_file|
      open(File.join(get_file_url, collection_alias, pointer.to_s), 'rb') do |read_file|
        saved_file.write(read_file.read)
      end
    end
  end

end