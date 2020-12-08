with artifact_for_flowcell(artifactid1, artifactid2) as (
  select a.artifactid, aam.ancestorartifactid
  from container c
         inner join containerplacement c2 on c.containerid = c2.containerid
         inner join artifact a on c2.processartifactid = a.artifactid
         inner join artifact_ancestor_map aam on aam.artifactid = a.artifactid
  where c.name = 'HYFTVCCXY'
)
select distinct p2.daterun, p2.luid, a.name, a.luid, p3.displayname
from (
       select artifactid1
       from artifact_for_flowcell
       union
       select artifactid2
       from artifact_for_flowcell
     ) artifacts_for_flowcell_flattened
inner join (
  select m.artifactid
  from artifact a
  inner join artifact_ancestor_map m on a.artifactid = m.ancestorartifactid
  where a.name = 'RJ-1967-5194-08'
  union
  select a.artifactid
  from artifact a
  where a.name = 'RJ-1967-5194-08'
  ) selected_artifact on selected_artifact.artifactid = artifacts_for_flowcell_flattened.artifactid1
inner join artifact a on artifacts_for_flowcell_flattened.artifactid1 = a.artifactid
inner join processiotracker p on a.artifactid = p.inputartifactid
inner join process p2 on p.processid = p2.processid
inner join processtype p3 on p2.typeid = p3.typeid
left outer join process_udf_view puv on puv.processid = p2.processid and puv.udfname = 'Comments'
left outer join escalationevent e on p2.processid = e.processid
left outer join escalatedsample e2 on e.eventid = e2.escalationeventid
where
 not a.name ilike 'phiX%'
 and not a.name ilike 'negative control%'
order by p2.daterun


--RJ-1967-5194-08
