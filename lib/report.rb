class Report

  attr_reader :name, :dir, :collection_dir, :file_dir, :collection_data, :repository_data, :header, :number_of_columns, :type, :format

  def initialize(type, repository, collection, download_dir_name, format)
    @name = "#{collection.title}_#{type}_#{Time.now.strftime('%Y%m%d_%k%M%S')}.#{format}"
    @dir = File.join(repository.download_dir, download_dir_name)
    @collection_dir = File.join(@dir, collection.title)
    @file_dir = File.join(@collection_dir, 'files')
    @collection_data = String.new
    @repository_data = String.new
    @type = type
    @format = format
    @header = String.new
    @number_of_columns = 0
    case type
    when 'digi'
      delimiter = "\t"
      # @header = "OBJECT\tFILE\tFilename\tdc.title\tdcterms.alternative\tdcterms.creator\tdcterms.contributor\tdcterms.publisher\tdcterms.temporal\tdcterms.spatial\tdcterms.description\tdcterms.subject\tedm.hasType\tdc.language\tdc.format\tdcterms.type\tdcterms.extent\tdcterms.isPartOf\tdc.rights\tdcterms.identifier\n"
      @header << 'OBJECT' + delimiter
      @header << 'FILE' + delimiter
      @header << 'Filename' + delimiter
      @header << 'dc.title' + delimiter
      @header << 'dcterms.creator' + delimiter
      @header << 'dcterms.date' + delimiter
      @header << 'dcterms.description' + delimiter
      @header << 'dcterms.publisher' + delimiter
      @header << 'dcterms.isPartOf' + delimiter
      @header << 'dc.rights' + delimiter
      @header << 'dcterms.identifier' + delimiter
      @header << 'url' + delimiter
      @header << "\n"
    when 'open_refine'
      delimiter = "\t"
      @header << "OBJECT\tFILE\turl\tfile_name\tdc_format_file\t"
      # 
      # descriptive metadata
      # 
      @header << 'dc_title' + delimiter
      @header << 'bf_series' + delimiter
      @header << 'dcterms_alternative' + delimiter
      @header << 'dcterms_creator_lcnaf' + delimiter
      @header << 'dcterms_creator_hot' + delimiter
      @header << 'dcterms_creator_ulan' + delimiter
      @header << 'dcterms_creator_uhlib' + delimiter
      @header << 'dcterms_contributor_lcnaf' + delimiter
      @header << 'dcterms_contributor_hot' + delimiter
      @header << 'dcterms_contributor_ulan' + delimiter
      @header << 'dcterms_contributor_uhlib' + delimiter
      @header << 'dcterms_publisher' + delimiter
      @header << 'dcterms_temporal_lcsh' + delimiter
      @header << 'dcterms_temporal_hot' + delimiter
      @header << 'dcterms_temporal_uhlib' + delimiter
      @header << 'dcterms_spatial_poc_tgn' + delimiter
      @header << 'dcterms_spatial_poc_hot' + delimiter
      @header << 'dcterms_spatial_poc_uhlib' + delimiter
      @header << 'dcterms_spatial_subgeo_tgn' + delimiter
      @header << 'dcterms_spatial_subgeo_hot' + delimiter
      @header << 'dcterms_spatial_subgeo_uhlib' + delimiter
      @header << 'wgs84_pos_lat' + delimiter
      @header << 'wgs84_pos_lon' + delimiter
      @header << 'dc_date_edtf' + delimiter
      @header << 'dc_date_natural_language' + delimiter
      @header << 'dcterms_description' + delimiter
      @header << 'uhlib_note' + delimiter
      @header << 'dcterms_description_caption' + delimiter
      @header << 'dcterms_description_inscription' + delimiter
      @header << 'dcterms_provenance' + delimiter
      @header << 'dcterms_subject_topical_lcsh' + delimiter
      @header << 'dcterms_subject_topical_tgm' + delimiter
      @header << 'dcterms_subject_topical_aat' + delimiter
      @header << 'dcterms_subject_topical_saa' + delimiter
      @header << 'dcterms_subject_topical_uhlib' + delimiter
      @header << 'dcterms_subject_name_lcnaf' + delimiter
      @header << 'dcterms_subject_name_hot' + delimiter
      @header << 'dcterms_subject_name_ulan' + delimiter
      @header << 'dcterms_subject_name_uhlib' + delimiter
      @header << 'edm_hasType_aat' + delimiter
      @header << 'edm_hasType_pbcore' + delimiter
      @header << 'edm_hasType_uhlib' + delimiter
      @header << 'dc_language_natural' + delimiter
      @header << 'dc_language_iso' + delimiter
      @header << 'dc_format_object' + delimiter
      @header << 'dcterms_type' + delimiter
      @header << 'dcterms_extent' + delimiter
      @header << 'dcterms_isPartOf_physical_collection' + delimiter
      @header << 'dcterms_isPartOf_digital_collection' + delimiter
      @header << 'dcterms_isPartOf_repository' + delimiter
      @header << 'dc_rights' + delimiter
      @header << 'dcterms_identifier' + delimiter
      @header << 'dcterms_source'
      # 
      # 
      # 
      @header << "\n"
    when 'date_iso'
      @header << "Collection\tURL\tInvalid ISO Date\tDate String\n"
    end
    case format
    when 'tsv'
      @number_of_columns = @header.count("\t") + 1
    end
  end

  def write(dir, name, content)
    File.open(File.join(dir, name), 'w') do |f|
      f.puts content
      f.close
    end
  end

  def append(dir, name, content)
    File.open(File.join(dir, name), 'a') do |f|
      f.puts content
      f.close
    end
  end

end