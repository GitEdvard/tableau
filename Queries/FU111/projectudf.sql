select p.name, substring(instrument.udfvalue from 'NovaSeq (.*)') as flowcell_type
from project p
inner join entity_udf_view instrument on
  instrument.attachtoid = p.projectid and instrument.udfname = 'Sequencing instrument'
where instrument.udfvalue ilike 'novaseq%'
