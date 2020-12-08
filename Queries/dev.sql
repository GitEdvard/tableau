select * from artifact
where name like 'Chromium-001-Liv7'


select * from sample
where name like 'Chromium-001-Liv7'

select a.*
from artifact a
inner join analyte an on an.artifactid = a.artifactid
where name like 'Chromium-001-Liv7'

select r.firstname, st.*
from artifact a
inner join stagetransition st on st.artifactid = a.artifactid
inner join researcher r on r.researcherid = st.ownerid
inner join artifact_sample_map asm on a.artifactid = asm.artifactid
inner join sample s on asm.processid = s.processid
where s.name like 'Chromium-RML-001-Chromium-RML-001-1'
order by a.artifactid


select *
from artifact a
where a.artifactid = 99551

select a.artifactid, a.name, st.workflowrunid
from artifact a
inner join stagetransition st on a.artifactid = st.artifactid
where a.name like 'RE-1850-11-71017020001'

select r.firstname, a.name, st.*
from artifact a
inner join stagetransition st on st.artifactid = a.artifactid
inner join researcher r on r.researcherid = st.ownerid
where r.firstname = 'Edvard' and a.name like 'Chromi%'

select * from stagetransition

select *
from stage s

select *
from workflowsection wfs
inner join stage s on s.membershipid = wfs.sectionid
inner join stagetransition st on st.stageid = s.stageid
inner join artifact a on a.artifactid = st.artifactid


select s.name
from artifact a
inner join artifact_sample_map asm on a.artifactid = asm.artifactid
inner join sample s on s.processid = asm.processid
where a.name = 'Chromium-RML-001_Pool1_20932_2nM_181116'

--Chromium-RML-001-Chromium-RML-001-1




/*
borttaget prov, remove from workflow, sist i steget
Chromium-001-Liv7
borttaget prov, remove from queue, forst i steget
Chromium-001-Idun3
Prov med ett neg och ett pos workflowid
Chromium-001-Liv4
prov som ar kvar
Chromium-001-Liv2
prov (drift-db) med duplikat, som har gatt igenom 58 steg
RD-1805-ID280
Prov som korts om,
RE-1850-11-71017020001
*/