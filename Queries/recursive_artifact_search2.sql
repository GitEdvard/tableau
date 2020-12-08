with recursive downstream_artifacts_for_artifact(artifactid, luid, name) as
       (
         select
                a.artifactid,
                a.luid,
                a.name
         from artifact a
         inner join analyte a3 on a.artifactid = a3.artifactid
         where a.luid = 'LAN587A1PA1'
         union
         select
                child.artifactid,
                child.luid,
                child.name
         from downstream_artifacts_for_artifact parent
         inner join processiotracker piot on piot.inputartifactid = parent.artifactid
         inner join outputmapping o on piot.trackerid = o.trackerid
         inner join artifact child on o.outputartifactid = child.artifactid
         inner join analyte a2 on child.artifactid = a2.artifactid
       )
select distinct
       rec.luid as artifact_luid,
       rec.name as artifact_name,
       p2.displayname as process_for_input_artifact,
       outtype.displayname as process_for_output_artifact,
       p.processid,
       p.daterun
from downstream_artifacts_for_artifact rec
inner join processiotracker pt on pt.inputartifactid = rec.artifactid
inner join outputmapping om on om.outputartifactid = rec.artifactid
inner join processiotracker outpt on outpt.trackerid = om.trackerid
inner join process outp on outp.processid = outpt.processid
inner join processtype outtype on outtype.typeid = outp.typeid
inner join process p on pt.processid = p.processid
inner join processtype p2 on p.typeid = p2.typeid
order by p.processid;



/*

projman artifact
2-361813

A picked artifact from denature steg
2-364525

master artifact for re-runned sample
LAN587A1PA1
*/
select version from
  (select * from software) inner_query