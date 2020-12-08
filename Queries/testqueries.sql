select
    artifact0_.luid as artifact_luid,
    process3_.luid as process_luid,
    sample2_.*
--    process3_.*
from
    artifact artifact0_
       cross join artifact_sample_map artifactsa1_
        cross join sample sample2_, process process3_
where
    sample2_.processid=process3_.processid
         and (artifact0_.luid in ('2-101090'))
         and artifactsa1_.artifactid=artifact0_.artifactid
         and sample2_.processid=artifactsa1_.processid


select
  p2.*
from artifact a
  inner join artifact_sample_map asm on a.artifactid = asm.artifactid
  inner join sample s on asm.processid = s.processid
  inner join process p on s.processid = p.processid
  inner join processtype p2 on p.typeid = p2.typeid
where a.luid = '2-101090'


SELECT
processtype.displayname,
sample.name,
process.daterun
FROM
process,
processiotracker,
artifact,
artifact_sample_map,
sample,
processtype
WHERE
process.processid = processiotracker.processid
AND process.typeid = processtype.typeid
AND processiotracker.inputartifactid = artifact.artifactid
AND artifact.artifactid = artifact_sample_map.artifactid
AND artifact_sample_map.processid = sample.processid
AND sample.name = 'QK-1633-AA-Mad-A8'
ORDER BY name, daterun

SELECT artifact.name as artifact_name, containertype.name as container_type
FROM processtype
INNER JOIN process ON process.typeid = processtype.typeid
INNER JOIN processiotracker ON processiotracker.processid = process.processid
INNER JOIN outputmapping on outputmapping.trackerid = processiotracker.trackerid
INNER JOIN artifact on artifact.artifactid = outputmapping.outputartifactid
INNER JOIN containerplacement ON containerplacement.processartifactid = artifact.artifactid
INNER JOIN container ON container.containerid = containerplacement.containerid
INNER JOIN containertype ON containertype.typeid = container.typeid
WHERE processtype.displayname LIKE 'SNP&SEQ Denature (NovaSeq)%'



SELECT
       artifact.name as artifact_name,
       artifact.luid as artifact_luid,
       containertype.name as container_type,
       s.name as sample_name
FROM processtype
INNER JOIN process ON process.typeid = processtype.typeid
INNER JOIN processiotracker ON processiotracker.processid = process.processid
INNER JOIN outputmapping on outputmapping.trackerid = processiotracker.trackerid
INNER JOIN artifact on artifact.artifactid = outputmapping.outputartifactid
INNER JOIN containerplacement ON containerplacement.processartifactid = artifact.artifactid
INNER JOIN container ON container.containerid = containerplacement.containerid
INNER JOIN containertype ON containertype.typeid = container.typeid
inner join artifact_sample_map asm on artifact.artifactid = asm.artifactid
inner join sample s on asm.processid = s.processid
WHERE processtype.displayname LIKE 'SNP&SEQ Denature (NovaSeq)%'
and s.name = 'RK-2009-AN02738'

--2-364525

with recursive expl(artifactid, luid, name) as
       (
         select
                a.artifactid,
                a.luid,
                a.name
         from artifact a
         where a.luid = '2-364525'
         union
         select
                child.artifactid,
                child.luid,
                child.name
         from expl parent
         inner join processiotracker piot on piot.inputartifactid = parent.artifactid
         inner join outputmapping o on piot.trackerid = o.trackerid
         inner join artifact child on o.outputartifactid = child.artifactid
       )
select artifactid, luid, name
from expl

select *
from artifact a
where a.luid = '2-361813'
