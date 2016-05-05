class Cdmeta

  attr_reader :report_type, :report_format, :number_of_columns,
              :item_level, :item_url, :object_type,
              :file_name, :dc_format_file,
              # 
              # descriptive metadata
              # 
              :dc_title,
              :bf_series,
              :dcterms_alternative,
              :dcterms_creator_lcnaf,
              :dcterms_creator_hot,
              :dcterms_creator_ulan,
              :dcterms_creator_uhlib,
              :dcterms_contributor_lcnaf,
              :dcterms_contributor_hot,
              :dcterms_contributor_ulan,
              :dcterms_contributor_uhlib,
              :dcterms_publisher,
              :dcterms_temporal_lcsh,
              :dcterms_temporal_hot,
              :dcterms_temporal_uhlib,
              :dcterms_spatial_poc_tgn,
              :dcterms_spatial_poc_hot,
              :dcterms_spatial_poc_uhlib,
              :dcterms_spatial_subgeo_tgn,
              :dcterms_spatial_subgeo_hot,
              :dcterms_spatial_subgeo_uhlib,
              :wgs84_pos_lat,
              :wgs84_pos_lon,
              :dc_date_edtf,
              :dc_date_natural_language,
              :dcterms_description,
              :uhlib_note,
              :dcterms_description_caption,
              :dcterms_description_inscription,
              :dcterms_provenance,
              :dcterms_subject_topical_lcsh,
              :dcterms_subject_topical_tgm,
              :dcterms_subject_topical_aat,
              :dcterms_subject_topical_saa,
              :dcterms_subject_topical_uhlib,
              :dcterms_subject_name_lcnaf,
              :dcterms_subject_name_hot,
              :dcterms_subject_name_ulan,
              :dcterms_subject_name_uhlib,
              :edm_hasType_aat,
              :edm_hasType_pbcore,
              :edm_hasType_uhlib,
              :dc_language_natural,
              :dc_language_iso,
              :dc_format_object,
              :dcterms_type,
              :dcterms_extent,
              :dcterms_isPartOf_physical_collection,
              :dcterms_isPartOf_digital_collection,
              :dcterms_isPartOf_repository,
              :dc_rights,
              :dcterms_identifier,
              :dcterms_source

  def initialize(collection_alias, report, item, object_type=nil)

    @report_type = report.type
    @report_format = report.format
    @number_of_columns = report.number_of_columns
    @item_level = item.level
    @item_url = item.url
    @object_type = object_type

    begin
      # 
      # file_name
      # 
      item.fields['File Name'] == "{}" ? @file_name = "" : @file_name = item.fields['File Name'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dc_format_file
      # 
      item.fields['Format (IMT)'] == "{}" ? @dc_format_file = "" : @dc_format_file = item.fields['Format (IMT)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dc_title
      # 
      item.fields['Title'] == "{}" ? @dc_title = "" : @dc_title = item.fields['Title'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # bf_series
      # 
      item.fields['Series Title'] == "{}" ? @bf_series = "" : @bf_series = item.fields['Series Title'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dcterms_alternative
      # 
      item.fields['Alternative Title'] == "{}" ? @dcterms_alternative = "" : @dcterms_alternative = item.fields['Alternative Title'].delete("\n").gsub("\t", " ").chomp(';')

      if collection_alias == 'p15195coll16' # historic texas postcards
        # 
        # dcterms_creator_lcnaf
        # 
        item.fields['Creator (Printer) (LCNAF)'] == "{}" ? @dcterms_creator_lcnaf = "" : @dcterms_creator_lcnaf = item.fields['Creator (Printer) (LCNAF)'].delete("\n").gsub("\t", " ").chomp(';')

        # 
        # dcterms_creator_hot
        # 
        item.fields['Creator (Printer) (HOT)'] == "{}" ? @dcterms_creator_hot = "" : @dcterms_creator_hot = item.fields['Creator (Printer) (HOT)'].delete("\n").gsub("\t", " ").chomp(';')

        # 
        # dcterms_creator_ulan
        # 
        item.fields['Creator (Printer) (ULAN)'] == "{}" ? @dcterms_creator_ulan = "" : @dcterms_creator_ulan = item.fields['Creator (Printer) (ULAN)'].delete("\n").gsub("\t", " ").chomp(';')

        # 
        # dcterms_creator_uhl
        # 
        item.fields['Creator (Printer) (Local)'] == "{}" ? @dcterms_creator_uhlib = "" : @dcterms_creator_uhlib = item.fields['Creator (Printer) (Local)'].delete("\n").gsub("\t", " ").chomp(';')

      elsif collection_alias == 'p15195coll15' # ship of fools woodcuts
        # 
        # dcterms_creator_lcnaf
        # 
        item.fields['Author (LCNAF)'] == "{}" ? @dcterms_creator_lcnaf = "" : @dcterms_creator_lcnaf = item.fields['Author (LCNAF)'].delete("\n").gsub("\t", " ").chomp(';')

        # 
        # dcterms_creator_hot
        # 
        item.fields['Author (HOT)'] == "{}" ? @dcterms_creator_hot = "" : @dcterms_creator_hot = item.fields['Author (HOT)'].delete("\n").gsub("\t", " ").chomp(';')

        # 
        # dcterms_creator_ulan
        # 
        item.fields['Author (ULAN)'] == "{}" ? @dcterms_creator_ulan = "" : @dcterms_creator_ulan = item.fields['Author (ULAN)'].delete("\n").gsub("\t", " ").chomp(';')

        # 
        # dcterms_creator_uhl
        # 
        item.fields['Author (Local)'] == "{}" ? @dcterms_creator_uhlib = "" : @dcterms_creator_uhlib = item.fields['Author (Local)'].delete("\n").gsub("\t", " ").chomp(';')

      else
        # 
        # dcterms_creator_lcnaf
        # 
        item.fields['Creator (LCNAF)'] == "{}" ? @dcterms_creator_lcnaf = "" : @dcterms_creator_lcnaf = item.fields['Creator (LCNAF)'].delete("\n").gsub("\t", " ").chomp(';')

        # 
        # dcterms_creator_hot
        # 
        item.fields['Creator (HOT)'] == "{}" ? @dcterms_creator_hot = "" : @dcterms_creator_hot = item.fields['Creator (HOT)'].delete("\n").gsub("\t", " ").chomp(';')

        # 
        # dcterms_creator_ulan
        # 
        item.fields['Creator (ULAN)'] == "{}" ? @dcterms_creator_ulan = "" : @dcterms_creator_ulan = item.fields['Creator (ULAN)'].delete("\n").gsub("\t", " ").chomp(';')

        # 
        # dcterms_creator_uhl
        # 
        item.fields['Creator (Local)'] == "{}" ? @dcterms_creator_uhlib = "" : @dcterms_creator_uhlib = item.fields['Creator (Local)'].delete("\n").gsub("\t", " ").chomp(';')
      end

      if collection_alias == 'reims'
        # 
        # dcterms_contributor_lcnaf
        # 
        item.fields['Scribe (LCNAF)'] == "{}" ? @dcterms_contributor_lcnaf = "" : @dcterms_contributor_lcnaf = item.fields['Scribe (LCNAF)'].delete("\n") + ", scribe"

        # 
        # dcterms_contributor_hot
        # 
        item.fields['Scribe (HOT)'] == "{}" ? @dcterms_contributor_hot = "" : @dcterms_contributor_hot = item.fields['Scribe (HOT)'].delete("\n") + ", scribe"

        # 
        # dcterms_contributor_ulan
        # 
        item.fields['Scribe (ULAN)'] == "{}" ? @dcterms_contributor_ulan = "" : @dcterms_contributor_ulan = item.fields['Scribe (ULAN)'].delete("\n") + ", scribe"

        # 
        # dcterms_contributor_uhl
        # 
        item.fields['Scribe (Local)'] == "{}" ? @dcterms_contributor_uhlib = "" : @dcterms_contributor_uhlib = item.fields['Scribe (Local)'].delete("\n") + ", scribe"

      elsif collection_alias == 'p15195coll15' # ship of fools woodcuts
        # 
        # dcterms_contributor_lcnaf
        # 
        item.fields['Artist (LCNAF)'] == "{}" ? @dcterms_contributor_lcnaf = "" : @dcterms_contributor_lcnaf = item.fields['Artist (LCNAF)'].delete("\n") + ", artist"

        # 
        # dcterms_contributor_hot
        # 
        item.fields['Artist (HOT)'] == "{}" ? @dcterms_contributor_hot = "" : @dcterms_contributor_hot = item.fields['Artist (HOT)'].delete("\n") + ", artist"

        # 
        # dcterms_contributor_ulan
        # 
        item.fields['Artist (ULAN)'] == "{}" ? @dcterms_contributor_ulan = "" : @dcterms_contributor_ulan = item.fields['Artist (ULAN)'].delete("\n") + ", artist"

        # 
        # dcterms_contributor_uhl
        # 
        item.fields['Artist (Local)'] == "{}" ? @dcterms_contributor_uhlib = "" : @dcterms_contributor_uhlib = item.fields['Artist (Local)'].delete("\n") + ", artist"
      else
        # 
        # dcterms_contributor_lcnaf
        # 
        item.fields['Contributor (LCNAF)'] == "{}" ? @dcterms_contributor_lcnaf = "" : @dcterms_contributor_lcnaf = item.fields['Contributor (LCNAF)'].delete("\n").gsub("\t", " ").chomp(';')

        # 
        # dcterms_contributor_hot
        # 
        item.fields['Contributor (HOT)'] == "{}" ? @dcterms_contributor_hot = "" : @dcterms_contributor_hot = item.fields['Contributor (HOT)'].delete("\n").gsub("\t", " ").chomp(';')

        # 
        # dcterms_contributor_ulan
        # 
        item.fields['Contributor (ULAN)'] == "{}" ? @dcterms_contributor_ulan = "" : @dcterms_contributor_ulan = item.fields['Contributor (ULAN)'].delete("\n").gsub("\t", " ").chomp(';')

        # 
        # dcterms_contributor_uhl
        # 
        item.fields['Contributor (Local)'] == "{}" ? @dcterms_contributor_uhlib = "" : @dcterms_contributor_uhlib = item.fields['Contributor (Local)'].delete("\n").gsub("\t", " ").chomp(';')
      end

      if collection_alias == 'sham'
        # 
        # convert printer field to dcterms_contributor_uhlib
        # 
        item.fields['Printer'] == "{}" ? printer = "" : printer = item.fields['Printer'].delete("\n").gsub("\t", " ").chomp(';')
        unless printer == ""
          @dcterms_contributor_uhlib == "" ? @dcterms_contributor_uhlib << printer + ", printer" : @dcterms_contributor_uhlib << "; " + printer + ", printer"
        end
        @dcterms_publisher = ""
      else
        # 
        # dcterms_publisher
        # 
        item.fields['Publisher'] == "{}" ? @dcterms_publisher = "" : @dcterms_publisher = item.fields['Publisher'].delete("\n").gsub("\t", " ").chomp(';')
      end

      # 
      # dcterms_temporal_lcsh
      # 
      item.fields['Subject.Time Period (LCSH)'] == "{}" ? @dcterms_temporal_lcsh = "" : @dcterms_temporal_lcsh = item.fields['Subject.Time Period (LCSH)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dcterms_temporal_hot
      # 
      item.fields['Subject.Time Period (HOT)'] == "{}" ? @dcterms_temporal_hot = "" : @dcterms_temporal_hot = item.fields['Subject.Time Period (HOT)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dcterms_temporal_uhlib
      # 
      item.fields['Subject.Time Period (Local)'] == "{}" ? @dcterms_temporal_uhlib = "" : @dcterms_temporal_uhlib = item.fields['Subject.Time Period (Local)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dcterms_spatial_poc_tgn
      # 
      item.fields['Place of Creation (TGN)'] == "{}" ? @dcterms_spatial_poc_tgn = "" : @dcterms_spatial_poc_tgn = item.fields['Place of Creation (TGN)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dcterms_spatial_poc_hot
      # 
      item.fields['Place of Creation (HOT)'] == "{}" ? @dcterms_spatial_poc_hot = "" : @dcterms_spatial_poc_hot = item.fields['Place of Creation (HOT)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dcterms_spatial_poc_uhlib
      # 
      item.fields['Place of Creation (Local)'] == "{}" ? @dcterms_spatial_poc_uhlib = "" : @dcterms_spatial_poc_uhlib = item.fields['Place of Creation (Local)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dcterms_spatial_subgeo_tgn
      # 
      item.fields['Subject.Geographic (TGN)'] == "{}" ? @dcterms_spatial_subgeo_tgn = "" : @dcterms_spatial_subgeo_tgn = item.fields['Subject.Geographic (TGN)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dcterms_spatial_subgeo_hot
      # 
      item.fields['Subject.Geographic (HOT)'] == "{}" ? @dcterms_spatial_subgeo_hot = "" : @dcterms_spatial_subgeo_hot = item.fields['Subject.Geographic (HOT)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dcterms_spatial_subgeo_uhlib
      # 
      item.fields['Subject.Geographic (Local)'] == "{}" ? @dcterms_spatial_subgeo_uhlib = "" : @dcterms_spatial_subgeo_uhlib = item.fields['Subject.Geographic (Local)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # wgs84_pos_lat
      # wgs84_pos_lon
      # 
      if item.fields['Geographic Coordinates'] == "{}"
        @wgs84_pos_lat = ""
        @wgs84_pos_lon = ""
      else
        geo_coordinates = item.split_geographic(item.fields['Geographic Coordinates'])
        @wgs84_pos_lat = geo_coordinates[0]
        @wgs84_pos_lon = geo_coordinates[1]
      end

      # 
      # dc_date_edtf
      # 
      item.fields['Date (ISO 8601)'] == "{}" ? @dc_date_edtf = "" : @dc_date_edtf = item.fields['Date (ISO 8601)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dc_date_natural_language
      # 
      item.fields['Date'] == "{}" ? @dc_date_natural_language = "" : @dc_date_natural_language = item.fields['Date'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dcterms_description
      # 
      item.fields['Description'] == "{}" ? @dcterms_description = "" : @dcterms_description = item.fields['Description'].gsub("\n", " ").gsub("\t", " ").chomp
      if collection_alias == 'p15195coll16' # historic texas postcards
        item.fields['About the Date'] == "{}" ? about_the_date = "" : about_the_date = item.fields['About the Date'].gsub("\n", " ").gsub("\t", " ").chomp
        @dcterms_description == "" ? @dcterms_description << about_the_date : @dcterms_description << " " + about_the_date
      end

      # 
      # uhlib_note
      # 
      item.fields['Note'] == "{}" ? @uhlib_note = "" : @uhlib_note = item.fields['Note'].gsub("\n", " ").gsub("\t", " ").chomp

      # 
      # uhlib_note_caption
      # 
      item.fields['Caption'] == "{}" ? @dcterms_description_caption = "" : @dcterms_description_caption = item.fields['Caption'].gsub("\n", " ").gsub("\t", " ").chomp(';')

      # 
      # uhlib_note_inscription
      # 
      item.fields['Inscription'] == "{}" ? @dcterms_description_inscription = "" : @dcterms_description_inscription = item.fields['Inscription'].gsub("\n", " ").gsub("\t", " ").chomp(';')

      # 
      # dcterms_provenance
      # 
      item.fields['Donor'] == "{}" ? @dcterms_provenance = "" : @dcterms_provenance = item.fields['Donor'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dcterms_subject_topical_lcsh
      # 
      item.fields['Subject.Topical (LCSH)'] == "{}" ? @dcterms_subject_topical_lcsh = "" : @dcterms_subject_topical_lcsh = item.fields['Subject.Topical (LCSH)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dcterms_subject_topical_tgm
      # 
      item.fields['Subject.Topical (TGM-1)'] == "{}" ? @dcterms_subject_topical_tgm = "" : @dcterms_subject_topical_tgm = item.fields['Subject.Topical (TGM-1)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dcterms_subject_topical_aat
      # 
      item.fields['Subject.Topical (AAT)'] == "{}" ? @dcterms_subject_topical_aat = "" : @dcterms_subject_topical_aat = item.fields['Subject.Topical (AAT)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dcterms_subject_topical_saa
      # 
      item.fields['Subject.Topical (SAA)'] == "{}" ? @dcterms_subject_topical_saa = "" : @dcterms_subject_topical_saa = item.fields['Subject.Topical (SAA)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dcterms_subject_topical_uhlib
      # 
      item.fields['Subject.Topical (Local)'] == "{}" ? @dcterms_subject_topical_uhlib = "" : @dcterms_subject_topical_uhlib = item.fields['Subject.Topical (Local)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dcterms_subject_name_lcnaf
      # 
      item.fields['Subject.Name (LCNAF)'] == "{}" ? @dcterms_subject_name_lcnaf = "" : @dcterms_subject_name_lcnaf = item.fields['Subject.Name (LCNAF)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dcterms_subject_name_hot
      # 
      item.fields['Subject.Name (HOT)'] == "{}" ? @dcterms_subject_name_hot = "" : @dcterms_subject_name_hot = item.fields['Subject.Name (HOT)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dcterms_subject_name_ulan
      # 
      item.fields['Subject.Name (ULAN)'] == "{}" ? @dcterms_subject_name_ulan = "" : @dcterms_subject_name_ulan = item.fields['Subject.Name (ULAN)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dcterms_subject_name_uhlib
      # 
      item.fields['Subject.Name (Local)'] == "{}" ? @dcterms_subject_name_uhlib = "" : @dcterms_subject_name_uhlib = item.fields['Subject.Name (Local)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # edm_hasType_aat
      # 
      item.fields['Genre (AAT)'] == "{}" ? @edm_hasType_aat = "" : @edm_hasType_aat = item.fields['Genre (AAT)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # edm_hasType_pbcore
      # 
      item.fields['Genre (PBCore)'] == "{}" ? @edm_hasType_pbcore = "" : @edm_hasType_pbcore = item.fields['Genre (PBCore)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # edm_hasType_uhlib
      # 
      item.fields['Genre (Local)'] == "{}" ? @edm_hasType_uhlib = "" : @edm_hasType_uhlib = item.fields['Genre (Local)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dc_language_natural
      # 
      item.fields['Language'] == "{}" ? @dc_language_natural = "" : @dc_language_natural = item.fields['Language'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dc_language_iso
      # 
      item.fields['Language Code (ISO 639.2)'] == "{}" ? @dc_language_iso = "" : @dc_language_iso = item.fields['Language Code (ISO 639.2)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dc_format_object
      # 
      item.fields['Physical Description'] == "{}" ? @dc_format_object = "" : @dc_format_object = item.fields['Physical Description'].gsub("\n", " ").gsub("\t", " ").chomp(';')

      # 
      # dcterms_type
      # 
      item.fields['Type (DCMI)'] == "{}" ? @dcterms_type = "" : @dcterms_type = item.fields['Type (DCMI)'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dcterms_extent
      # 
      item.fields['Original Item Extent'] == "{}" ? @dcterms_extent = "" : @dcterms_extent = item.fields['Original Item Extent'].gsub("\n", " ").chomp(';')

      # 
      # dcterms_isPartOf_physical_collection
      # 
      item.fields['Original Collection'] == "{}" ? @dcterms_isPartOf_physical_collection = "" : @dcterms_isPartOf_physical_collection = item.fields['Original Collection'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dcterms_isPartOf_digital_collection
      # 
      item.fields['Digital Collection'] == "{}" ? @dcterms_isPartOf_digital_collection = "" : @dcterms_isPartOf_digital_collection = item.fields['Digital Collection'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dcterms_isPartOf_repository
      # 
      item.fields['Repository'] == "{}" ? @dcterms_isPartOf_repository = "" : @dcterms_isPartOf_repository = item.fields['Repository'].delete("\n").gsub("\t", " ").chomp(';')

      # 
      # dc_rights
      # 
      item.fields['Use and Reproduction'] == "{}" ? @dc_rights = "" : @dc_rights = item.fields['Use and Reproduction'].gsub("\n", " ").gsub("\t", " ").chomp

      # 
      # dcterms_identifier
      # 
      item.fields['Identifier'] == "{}" ? @dcterms_identifier = "" : @dcterms_identifier = item.fields['Identifier'].delete("\n").gsub("\t", " ").chomp

      # 
      # dcterms_source
      # 
      item.fields['Original Item Location'] == "{}" ? @dcterms_source = "" : @dcterms_source = item.fields['Original Item Location'].delete("\n").gsub("\t", " ").chomp

    rescue Exception => e
      # no method error for mystery objects
    end
    
  end

  def add_triples(m)
    triples = String.new
    case m.report_format
    when 'nt'
      uri = "<#{m.item_url}>"
      dcterms = "http://purl.org/dc/terms/"
      dc = "http://purl.org/dc/elements/1.1/"
      dcterms_description.gsub!('"', '\"')
      triples << uri + " <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://pcdm.org/models#Object> .\n"
      triples << uri + " <#{dcterms}title> \"#{dc_title}\"@en .\n" unless dc_title == ""
      triples << uri + " <#{dcterms}publisher> \"#{dcterms_publisher}\"@en .\n" unless dcterms_publisher == ""
      triples << uri + " <#{dc}date> \"#{dc_date_natural_language}\"@en .\n" unless dc_date_natural_language == ""
      triples << uri + " <#{dcterms}description> \"#{dcterms_description}\"@en .\n" unless dcterms_description == ""
      triples << uri + " <#{dcterms}isPartOf> \"#{dcterms_isPartOf_digital_collection}\"@en .\n" unless dcterms_isPartOf_digital_collection == ""
      triples << uri + " <#{dc}rights> \"#{dc_rights}\"@en .\n" unless dc_rights == ""
    end
  end

  def add_row(m)
    row = String.new

    if m.dc_title == nil
      row = ""
    else
      if m.item_level == 'file'
        case m.report_format
        when 'tsv'
          row << "\tx\t" + m.item_url + "\t" + m.file_name + "\t" + m.dc_format_file + "\t"
          row << open_refine_descriptive_metadata(m, "\t")
          row << "\n"
        end
      elsif m.item_level == 'object' && m.object_type == 'single'
        case m.report_format
        when 'tsv'
          row << "x\t\t" + m.item_url + "\t\t\t"
          row << open_refine_descriptive_metadata(m, "\t")
          row << "\n"
          # 
          # file metadata
          # 
          row << "\tx\t\t" + m.file_name + "\t" + m.dc_format_file + "\t"
          tabs = "\t" * (m.number_of_columns - 5)
          row << tabs
          row << "\n"
        end
      else # compound object top level metadata      
        case m.report_format
        when 'tsv'
          row << "x\t\t" + m.item_url + "\t\t\t"
          row << open_refine_descriptive_metadata(m, "\t")
          row << "\n"
        end
      end
    end
  end

  def open_refine_descriptive_metadata(m, delimiter)
    row = String.new
    row << m.dc_title + delimiter
    row << m.bf_series + delimiter
    row << m.dcterms_alternative + delimiter
    row << m.dcterms_creator_lcnaf + delimiter
    row << m.dcterms_creator_hot + delimiter
    row << m.dcterms_creator_ulan + delimiter
    row << m.dcterms_creator_uhlib + delimiter
    row << m.dcterms_contributor_lcnaf + delimiter
    row << m.dcterms_contributor_hot + delimiter
    row << m.dcterms_contributor_ulan + delimiter
    row << m.dcterms_contributor_uhlib + delimiter
    row << m.dcterms_publisher + delimiter
    row << m.dcterms_temporal_lcsh + delimiter
    row << m.dcterms_temporal_hot + delimiter
    row << m.dcterms_temporal_uhlib + delimiter
    row << m.dcterms_spatial_poc_tgn + delimiter
    row << m.dcterms_spatial_poc_hot + delimiter
    row << m.dcterms_spatial_poc_uhlib + delimiter
    row << m.dcterms_spatial_subgeo_tgn + delimiter
    row << m.dcterms_spatial_subgeo_hot + delimiter
    row << m.dcterms_spatial_subgeo_uhlib + delimiter
    row << m.wgs84_pos_lat + delimiter
    row << m.wgs84_pos_lon + delimiter
    row << m.dc_date_edtf + delimiter
    row << m.dc_date_natural_language + delimiter
    row << m.dcterms_description + delimiter
    row << m.uhlib_note + delimiter
    row << m.dcterms_description_caption + delimiter
    row << m.dcterms_description_inscription + delimiter
    row << m.dcterms_provenance + delimiter
    row << m.dcterms_subject_topical_lcsh + delimiter
    row << m.dcterms_subject_topical_tgm + delimiter
    row << m.dcterms_subject_topical_aat + delimiter
    row << m.dcterms_subject_topical_saa + delimiter
    row << m.dcterms_subject_topical_uhlib + delimiter
    row << m.dcterms_subject_name_lcnaf + delimiter
    row << m.dcterms_subject_name_hot + delimiter
    row << m.dcterms_subject_name_ulan + delimiter
    row << m.dcterms_subject_name_uhlib + delimiter
    row << m.edm_hasType_aat + delimiter
    row << m.edm_hasType_pbcore + delimiter
    row << m.edm_hasType_uhlib + delimiter
    row << m.dc_language_natural + delimiter
    row << m.dc_language_iso + delimiter
    row << m.dc_format_object + delimiter
    row << m.dcterms_type + delimiter
    row << m.dcterms_extent + delimiter
    row << m.dcterms_isPartOf_physical_collection + delimiter
    row << m.dcterms_isPartOf_digital_collection + delimiter
    row << m.dcterms_isPartOf_repository + delimiter
    row << m.dc_rights + delimiter
    row << m.dcterms_identifier + delimiter
    row << m.dcterms_source
  end
end
