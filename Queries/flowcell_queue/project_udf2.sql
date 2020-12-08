select p.name, library_kit.udfvalue as library_kit, instrument.udfvalue as instrument,
       sample_type.udfvalue as sample_type, number_flowcells.udfvalue as number_flowcells,
       number_lanes.udfvalue as number_lanes, read_length.udfvalue as read_length
from project p
inner join entity_udf_view library_kit on
  library_kit.attachtoid = p.projectid and library_kit.udfname = 'Kit for library preparation'
inner join entity_udf_view instrument on
  instrument.attachtoid = p.projectid and instrument.udfname = 'Sequencing instrument'
inner join entity_udf_view sample_type on
  sample_type.attachtoid = p.projectid and sample_type.udfname = 'Type of sample'
inner join entity_udf_view number_flowcells on
  number_flowcells.attachtoid = p.projectid and number_flowcells.udfname = 'Number of flowcells'
inner join entity_udf_view number_lanes on
  number_lanes.attachtoid = p.projectid and number_lanes.udfname = 'Number of lanes'
inner join entity_udf_view read_length on
  read_length.attachtoid = p.projectid and read_length.udfname = 'Read length bp'