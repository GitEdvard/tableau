select distinct a.name, a.luid, a2.name, a2.luid
from artifact a
inner join artifact_sample_map asm on a.artifactid = asm.artifactid
inner join sample s on asm.processid = s.processid
inner join artifact_ancestor_map aam on a.artifactid = aam.ancestorartifactid
inner join artifact a2 on a2.artifactid = aam.artifactid
inner join analyte an on an.artifactid = a2.artifactid
inner join processiotracker piot on a.artifactid = piot.inputartifactid
inner join process p on p.processid = piot.processid
inner join processtype pt on p.typeid = pt.typeid
where s.name = 'RD-1805-ID280'
and a.isoriginal
order by a2.name



select distinct a.name, a.luid, pt.displayname, a2.name, a2.luid
from artifact a
inner join artifact_sample_map asm on a.artifactid = asm.artifactid
inner join sample s on asm.processid = s.processid
inner join processiotracker piot on a.artifactid = piot.inputartifactid
inner join outputmapping om on om.trackerid = piot.trackerid
inner join process p on p.processid = piot.processid
inner join processtype pt on p.typeid = pt.typeid
inner join artifact_ancestor_map aam on a.artifactid = aam.ancestorartifactid
inner join artifact a2 on a2.artifactid = aam.artifactid and a2.artifactid = om.outputartifactid
inner join analyte an on an.artifactid = a2.artifactid
where s.name = 'RD-1805-ID280'
and a.isoriginal

select distinct a.name, a.luid, pt.displayname
from artifact a
inner join artifact_sample_map asm on a.artifactid = asm.artifactid
inner join sample s on asm.processid = s.processid
inner join processiotracker piot on a.artifactid = piot.inputartifactid
inner join process p on p.processid = piot.processid
inner join processtype pt on p.typeid = pt.typeid
where s.name = 'RD-1805-ID280'
and a.isoriginal




with recursive downstream_artifacts_for_sample() as (

)


/*
Ett prov som har omkorning:
RE-1850-11-71017020001

prov med replikat
RD-1805-ID280
*/
