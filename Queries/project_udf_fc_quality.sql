select p.name, library_kit.udfvalue as library_kit, instrument.udfvalue as instrument
from project p
inner join entity_udf_view library_kit on
  library_kit.attachtoid = p.projectid and library_kit.udfname = 'Kit for library preparation'
inner join entity_udf_view instrument on
  instrument.attachtoid = p.projectid and instrument.udfname = 'Sequencing instrument'
