-- the flowcell query
with samples_for_fc(name) as (
select distinct s.name, c2.wellxposition, c2.wellyposition
from container c
inner join containerplacement c2 on c.containerid = c2.containerid
inner join artifact a on c2.processartifactid = a.artifactid
inner join artifact_sample_map asm on a.artifactid = asm.artifactid
inner join sample s on asm.processid = s.processid
where c.name = 'HHJ25DMXX' and not s.name like 'PhiX%'
)
select distinct process.daterun,
              process.processid as process_luid,
              a.luid as artifact_luid,
              a.name,
              processtype.displayname,
     udfvalue as process_comment,
     case when e2.escalationeventid is null  then null else e.escalationcomment end as review_comment,
    case when e2.escalationeventid is null  then null else e.reviewcomment end as reviewer_anser
from sample
  inner join samples_for_fc sff on sff.name = sample.name
   inner join artifact_sample_map on artifact_sample_map.processid = sample.processid
   inner join processiotracker on processiotracker.inputartifactid = artifact_sample_map.artifactid
   inner join process on process.processid = processiotracker.processid
   inner join artifact a on a.artifactid = artifact_sample_map.artifactid
   left outer join process_udf_view on process_udf_view.processid = process.processid
   inner join processtype on processtype.typeid = process.typeid
left outer join escalationevent e on process.processid = e.processid
left outer join escalatedsample e2 on e.eventid = e2.escalationeventid
                                        and e2.artifactid = artifact_sample_map.artifactid
where
--      sample.name = 'RE-1850-11-71017020001' and
    process_udf_view.udfname = 'Comments' and
not (
  udfvalue is null and
  case when e2.escalationeventid is null  then null else e.escalationcomment end  is null and
  case when e2.escalationeventid is null  then null else e.reviewcomment end is null
  )
order by process_luid

-- search for samples for flowcell, OK
select distinct s.name
from container c
inner join containerplacement c2 on c.containerid = c2.containerid
inner join artifact a on c2.processartifactid = a.artifactid
inner join artifact_sample_map asm on a.artifactid = asm.artifactid
inner join sample s on asm.processid = s.processid
where c.name = 'HHJ25DMXX'
order by s.name
