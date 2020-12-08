with recursive downstream_artifacts_for_artifact(artifactid, luid, name, luid2) as
       (
         select
                a.artifactid,
                a.luid,
                a.name,
                base_artifact.luid
         from artifact a
         inner join analyte a3 on a.artifactid = a3.artifactid
         inner join artifact base_artifact on base_artifact.luid = a.luid
         union
         select
                child.artifactid,
                child.luid,
                child.name,
                parent.luid2
         from downstream_artifacts_for_artifact parent
         inner join processiotracker piot on piot.inputartifactid = parent.artifactid
         inner join outputmapping o on piot.trackerid = o.trackerid
         inner join artifact child on o.outputartifactid = child.artifactid
         inner join analyte a2 on child.artifactid = a2.artifactid
       )
select distinct
       rec.luid2 as base_artifact_luid,
       rec.luid as artifact_luid,
       rec.name as artifact_name,
       p2.displayname as process_for_input_artifact,
       outtype.displayname as process_for_output_artifact
from downstream_artifacts_for_artifact rec
inner join processiotracker pt on pt.inputartifactid = rec.artifactid
inner join outputmapping om on om.outputartifactid = rec.artifactid
inner join processiotracker outpt on outpt.trackerid = om.trackerid
inner join process outp on outp.processid = outpt.processid
inner join processtype outtype on outtype.typeid = outp.typeid
inner join process p on pt.processid = p.processid
inner join processtype p2 on p.typeid = p2.typeid
where rec.luid2 = '2-361813';



/*projman artifact
2-361813

A picked artifact from denature steg
2-364525*/
select version from
  (select * from software) inner_query