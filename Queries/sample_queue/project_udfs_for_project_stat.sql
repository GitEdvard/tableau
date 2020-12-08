select p.name, instrument.udfvalue as instrument, sample_type.udfvalue as sample_type,
       kit.udfvalue as kit, number_samples.udfvalue as number_samples
from project p
inner join entity_udf_view instrument
  on instrument.attachtoid = p.projectid and instrument.udfname = 'Sequencing instrument'
inner join entity_udf_view sample_type
  on sample_type.attachtoid = p.projectid and sample_type.udfname = 'Type of sample'
inner join entity_udf_view kit
  on kit.attachtoid = p.projectid and kit.udfname = 'Kit for library preparation'
inner join entity_udf_view number_samples
  on number_samples.attachtoid =p.projectid and number_samples.udfname = 'Number of samples'