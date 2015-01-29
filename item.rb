class Item

  attr_reader :subjects, :names

  def initialize(collection_alias, pointer, cdm_url, labels_and_nicks)
    info = get_item_info(cdm_url, collection_alias, pointer)
    @names = get_names(info, labels_and_nicks)
  end

  def get_item_info(cdm_url, collection_alias, pointer)
    cdm_item_info_url = cdm_url + "dmGetItemInfo/#{collection_alias}/#{pointer}/json"
    item_info = JSON.parse(open(cdm_item_info_url).read)
  end

  def get_names(item_info, labels_and_nicks)
    names = {}
    names.store('creator_lcnaf', {'label' => 'Creator (LCNAF)', 'value' => item_info[labels_and_nicks['Creator (LCNAF)']]})
    names.store('creator_ulan', {'label' => 'Creator (ULAN)', 'value' => item_info[labels_and_nicks['Creator (ULAN)']]})
    names.store('creator_hot', {'label' => 'Creator (HOT)', 'value' => item_info[labels_and_nicks['Creator (HOT)']]})
    names.store('creator_local', {'label' => 'Creator (Local)', 'value' => item_info[labels_and_nicks['Creator (Local)']]})
    names.store('contributor_lcnaf', {'label' => 'Contributor (LCNAF)', 'value' => item_info[labels_and_nicks['Contributor (LCNAF)']]})
    names.store('contributor_ulan', {'label' => 'Contributor (ULAN)', 'value' => item_info[labels_and_nicks['Contributor (ULAN)']]})
    names.store('contributor_hot', {'label' => 'Contributor (HOT)', 'value' => item_info[labels_and_nicks['Contributor (HOT)']]})
    names.store('contributor_local', {'label' => 'Contributor (Local)', 'value' => item_info[labels_and_nicks['Contributor (Local)']]})
    names.store('subj_name_lcnaf', {'label' => 'Subject.Name (LCNAF)', 'value' => item_info[labels_and_nicks['Subject.Name (LCNAF)']]})
    names.store('subj_name_ulan', {'label' => 'Subject.Name (ULAN)', 'value' => item_info[labels_and_nicks['Subject.Name (ULAN)']]})
    names.store('subj_name_hot', {'label' => 'Subject.Name (HOT)', 'value' => item_info[labels_and_nicks['Subject.Name (HOT)']]})
    names.store('subj_name_local', {'label' => 'Subject.Name (Local)', 'value' => item_info[labels_and_nicks['Subject.Name (Local)']]})
    names.store('author_lcnaf', {'label' => 'Author (LCNAF)', 'value' => item_info[labels_and_nicks['Author (LCNAF)']]})
    names.store('author_ulan', {'label' => 'Author (ULAN)', 'value' => item_info[labels_and_nicks['Author (ULAN)']]})
    names.store('author_hot', {'label' => 'Author (HOT)', 'value' => item_info[labels_and_nicks['Author (HOT)']]})
    names.store('author_local', {'label' => 'Author (Local)', 'value' => item_info[labels_and_nicks['Author (Local)']]})
    names.store('artist_lcnaf', {'label' => 'Artist (LCNAF)', 'value' => item_info[labels_and_nicks['Artist (LCNAF)']]})
    names.store('artist_ulan', {'label' => 'Artist (ULAN)', 'value' => item_info[labels_and_nicks['Artist (ULAN)']]})
    names.store('artist_hot', {'label' => 'Artist (HOT)', 'value' => item_info[labels_and_nicks['Artist (HOT)']]})
    names.store('artist_local', {'label' => 'Artist (Local)', 'value' => item_info[labels_and_nicks['Artist (Local)']]})
    names.store('composer_lcnaf', {'label' => 'Composer (LCNAF)', 'value' => item_info[labels_and_nicks['Composer (LCNAF)']]})
    names.store('composer_ulan', {'label' => 'Composer (ULAN)', 'value' => item_info[labels_and_nicks['Composer (ULAN)']]})
    names.store('composer_hot', {'label' => 'Composer (HOT)', 'value' => item_info[labels_and_nicks['Composer (HOT)']]})
    names.store('composer_local', {'label' => 'Composer (Local)', 'value' => item_info[labels_and_nicks['Composer (Local)']]})
    names.store('added_composer_lcnaf', {'label' => 'Added Composers (LCNAF)', 'value' => item_info[labels_and_nicks['Added Composers (LCNAF)']]})
    names.store('added_composer_ulan', {'label' => 'Added Composers (ULAN)', 'value' => item_info[labels_and_nicks['Added Composers (ULAN)']]})
    names.store('added_composer_hot', {'label' => 'Added Composers (HOT)', 'value' => item_info[labels_and_nicks['Added Composers (HOT)']]})
    names.store('added_composer_local', {'label' => 'Added Composers (Local)', 'value' => item_info[labels_and_nicks['Added Composers (Local)']]})
    names.store('interviewer_lcnaf', {'label' => 'Interviewer (LCNAF)', 'value' => item_info[labels_and_nicks['Interviewer (LCNAF)']]})
    names.store('interviewer_ulan', {'label' => 'Interviewer (ULAN)', 'value' => item_info[labels_and_nicks['Interviewer (ULAN)']]})
    names.store('interviewer_hot', {'label' => 'Interviewer (HOT)', 'value' => item_info[labels_and_nicks['Interviewer (HOT)']]})
    names.store('interviewer_local', {'label' => 'Interviewer (Local)', 'value' => item_info[labels_and_nicks['Interviewer (Local)']]})
    names.store('co_creator', {'label' => 'Co-creator', 'value' => item_info[labels_and_nicks['Co-creator']]})
    names
  end

  def break(names, id, pointer)
    collection_names = ""

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
    names['interviewer_lcnaf']['value'].class == Hash ? interviewer_lcnaf = [] : interviewer_lcnaf = split_names('interviewer_lcnaf', names)
    names['interviewer_ulan']['value'].class == Hash ? interviewer_ulan = [] : interviewer_ulan = split_names('interviewer_ulan', names)
    names['interviewer_hot']['value'].class == Hash ? interviewer_hot = [] : interviewer_hot = split_names('interviewer_hot', names)
    names['interviewer_local']['value'].class == Hash ? interviewer_local = [] : interviewer_local = split_names('interviewer_local', names)
    names['co_creator']['value'].class == Hash ? co_creator = [] : co_creator = split_names('co_creator', names)

    # add names to collection names report
    creator_lcnaf.each { |name| collection_names << "#{id}\t#{pointer}\tcreator_lcnaf\t#{name}\n"} if creator_lcnaf[0]
    creator_ulan.each { |name| collection_names << "#{id}\t#{pointer}\tcreator_ulan\t#{name}\n"} if creator_ulan[0]
    creator_hot.each { |name| collection_names << "#{id}\t#{pointer}\tcreator_hot\t#{name}\n"} if creator_hot[0]
    creator_local.each { |name| collection_names << "#{id}\t#{pointer}\tcreator_local\t#{name}\n"} if creator_local[0]
    contributor_lcnaf.each { |name| collection_names << "#{id}\t#{pointer}\tcontributor_lcnaf\t#{name}\n"} if contributor_lcnaf[0]
    contributor_ulan.each { |name| collection_names << "#{id}\t#{pointer}\tcontributor_ulan\t#{name}\n"} if contributor_ulan[0]
    contributor_hot.each { |name| collection_names << "#{id}\t#{pointer}\tcontributor_hot\t#{name}\n"} if contributor_hot[0]
    contributor_local.each { |name| collection_names << "#{id}\t#{pointer}\tcontributor_local\t#{name}\n"} if contributor_local[0]
    subj_name_lcnaf.each { |name| collection_names << "#{id}\t#{pointer}\tsubj_name_lcnaf\t#{name}\n"} if subj_name_lcnaf[0]
    subj_name_ulan.each { |name| collection_names << "#{id}\t#{pointer}\tsubj_name_ulan\t#{name}\n"} if subj_name_ulan[0]
    subj_name_hot.each { |name| collection_names << "#{id}\t#{pointer}\tsubj_name_hot\t#{name}\n"} if subj_name_hot[0]
    subj_name_local.each { |name| collection_names << "#{id}\t#{pointer}\tsubj_name_local\t#{name}\n"} if subj_name_local[0]
    author_lcnaf.each { |name| collection_names << "#{id}\t#{pointer}\tauthor_lcnaf\t#{name}\n"} if author_lcnaf[0]
    author_ulan.each { |name| collection_names << "#{id}\t#{pointer}\tauthor_ulan\t#{name}\n"} if author_ulan[0]
    author_hot.each { |name| collection_names << "#{id}\t#{pointer}\tauthor_hot\t#{name}\n"} if author_hot[0]
    author_local.each { |name| collection_names << "#{id}\t#{pointer}\tauthor_local\t#{name}\n"} if author_local[0]
    artist_lcnaf.each { |name| collection_names << "#{id}\t#{pointer}\tartist_lcnaf\t#{name}\n"} if artist_lcnaf[0]
    artist_ulan.each { |name| collection_names << "#{id}\t#{pointer}\tartist_ulan\t#{name}\n"} if artist_ulan[0]
    artist_hot.each { |name| collection_names << "#{id}\t#{pointer}\tartist_hot\t#{name}\n"} if artist_hot[0]
    artist_local.each { |name| collection_names << "#{id}\t#{pointer}\tartist_local\t#{name}\n"} if artist_local[0]
    composer_lcnaf.each { |name| collection_names << "#{id}\t#{pointer}\tcomposer_lcnaf\t#{name}\n"} if composer_lcnaf[0]
    composer_ulan.each { |name| collection_names << "#{id}\t#{pointer}\tcomposer_ulan\t#{name}\n"} if composer_ulan[0]
    composer_hot.each { |name| collection_names << "#{id}\t#{pointer}\tcomposer_hot\t#{name}\n"} if composer_hot[0]
    composer_local.each { |name| collection_names << "#{id}\t#{pointer}\tcomposer_local\t#{name}\n"} if composer_local[0]
    added_composer_lcnaf.each { |name| collection_names << "#{id}\t#{pointer}\tadded_composer_lcnaf\t#{name}\n"} if added_composer_lcnaf[0]
    added_composer_ulan.each { |name| collection_names << "#{id}\t#{pointer}\tadded_composer_ulan\t#{name}\n"} if added_composer_ulan[0]
    added_composer_hot.each { |name| collection_names << "#{id}\t#{pointer}\tadded_composer_hot\t#{name}\n"} if added_composer_hot[0]
    added_composer_local.each { |name| collection_names << "#{id}\t#{pointer}\tadded_composer_local\t#{name}\n"} if added_composer_local[0]
    interviewer_lcnaf.each { |name| collection_names << "#{id}\t#{pointer}\tinterviewer_lcnaf\t#{name}\n"} if interviewer_lcnaf[0]
    interviewer_ulan.each { |name| collection_names << "#{id}\t#{pointer}\tinterviewer_ulan\t#{name}\n"} if interviewer_ulan[0]
    interviewer_hot.each { |name| collection_names << "#{id}\t#{pointer}\tinterviewer_hot\t#{name}\n"} if interviewer_hot[0]
    interviewer_local.each { |name| collection_names << "#{id}\t#{pointer}\tinterviewer_local\t#{name}\n"} if interviewer_local[0]
    co_creator.each { |name| collection_names << "#{id}\t#{pointer}\tco_creator\t#{name}\n"} if co_creator[0]

    collection_names    
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

end