
-- alla artifacter, med lite filter
select a.luid, a2.*
from artifact a
inner join artifacttype a2 on a.artifacttypeid = a2.typeid
where not a.isoriginal and
not a.luid like '2-%' and not a.luid like '92-%'
and not a2.displayname = 'ResultFile'
--where a.luid like '2-%'

-- artifacts linked with samples
select a.*
from artifact a
inner join artifact_sample_map asm on a.artifactid = asm.artifactid
inner join sample s on s.processid = asm.processid
where a.isoriginal and s.name = 'RE-1850-11-71017020001'



/*
Ett prov som har omkorning:
RE-1850-11-71017020001

prov med replikat
RD-1805-ID280
*/