select p.name, instrument.udfvalue as instrument, sample_type.udfvalue as sample_type,
       kit.udfvalue as kit, number_samples.udfvalue as number_samples,
       read_length.udfvalue as read_length, number_flowcells.udfvalue as number_flowcells,
       number_lanes.udfvalue as number_lanes
from project p
inner join entity_udf_view instrument
  on instrument.attachtoid = p.projectid and instrument.udfname = 'Sequencing instrument'
inner join entity_udf_view sample_type
  on sample_type.attachtoid = p.projectid and sample_type.udfname = 'Type of sample'
inner join entity_udf_view kit
  on kit.attachtoid = p.projectid and kit.udfname = 'Kit for library preparation'
inner join entity_udf_view number_samples
  on number_samples.attachtoid =p.projectid and number_samples.udfname = 'Number of samples'
inner join entity_udf_view read_length
  on read_length.attachtoid =p.projectid and read_length.udfname = 'Read length bp'
inner join entity_udf_view number_flowcells on
  number_flowcells.attachtoid = p.projectid and number_flowcells.udfname = 'Number of flowcells'

  inner join entity_udf_view number_lanes on
  number_lanes.attachtoid = p.projectid and number_lanes.udfname = 'Number of lanes'
