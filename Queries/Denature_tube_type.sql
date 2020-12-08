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
