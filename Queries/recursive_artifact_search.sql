with recursive expl(artifactid, luid, name) as
       (
         select
                a.artifactid,
                a.luid,
                a.name
         from artifact a
         inner join analyte a3 on a.artifactid = a3.artifactid
         where a.luid = '2-361813'
         union
         select
                child.artifactid,
                child.luid,
                child.name
         from expl parent
         inner join processiotracker piot on piot.inputartifactid = parent.artifactid
         inner join outputmapping o on piot.trackerid = o.trackerid
         inner join artifact child on o.outputartifactid = child.artifactid
         inner join analyte a2 on child.artifactid = a2.artifactid
       )
select
       e.luid as artifact_luid,
       e.name as artifact_name
from expl e



/*projman artifact
2-361813

A picked artifact from denature steg
2-364525*/