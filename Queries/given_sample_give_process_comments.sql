select a.luid as input_artifact_luid, a.name as input_artifact_name,
       sample.sampleid, process.daterun, processtype.displayname, process.processid,
       udfvalue as process_comment,
       case when e2.escalationeventid is null  then '' else e.escalationcomment end as review_comment,
       case when e2.escalationeventid is null  then '' else e.reviewcomment end as reviewer_anser
from sample
     inner join artifact_sample_map on artifact_sample_map.processid = sample.processid
     inner join processiotracker on processiotracker.inputartifactid = artifact_sample_map.artifactid
     inner join artifact a on a.artifactid = processiotracker.inputartifactid
     inner join process on process.processid = processiotracker.processid
     left outer join process_udf_view on process_udf_view.processid = process.processid
     inner join processtype on processtype.typeid = process.typeid
  left outer join escalationevent e on process.processid = e.processid
  left outer join escalatedsample e2 on e.eventid = e2.escalationeventid
where
      sample.name = 'RE-1850-11-71017020001' and
      process_udf_view.udfname = 'Comments'

/*Ett prov skickat till review, som Ingvar visar xml, dar finns bade reivew och svar pa review
RL-2027-c49F
Ett annat prov skickat till review
RL-2027-1A

RE-1850-11-71017020001
*/

select distinct sample.sampleid, process.daterun, processtype.displayname, process.processid,
       case when e2.escalationeventid is null  then '' else e.escalationcomment end as review_comment,
       case when e2.escalationeventid is null  then '' else e.reviewcomment end as reviewer_anser
from sample
     inner join artifact_sample_map on artifact_sample_map.processid = sample.processid
     inner join processiotracker on processiotracker.inputartifactid = artifact_sample_map.artifactid
     inner join process on process.processid = processiotracker.processid
     inner join processtype on processtype.typeid = process.typeid
  left outer join escalationevent e on process.processid = e.processid
  left outer join escalatedsample e2 on e.eventid = e2.escalationeventid
where
      sample.name = 'RE-1850-11-71017020001'

select isnull(null, '##')


select distinct process.daterun, processtype.displayname, process.processid,
       udfvalue as process_comment,
       case when e2.escalationeventid is null  then '' else e.escalationcomment end as review_comment,
       case when e2.escalationeventid is null  then '' else e.reviewcomment end as reviewer_anser
from sample
     inner join artifact_sample_map on artifact_sample_map.processid = sample.processid
     inner join processiotracker on processiotracker.inputartifactid = artifact_sample_map.artifactid
     inner join artifact a on a.artifactid = processiotracker.inputartifactid
     inner join process on process.processid = processiotracker.processid
     left outer join process_udf_view on process_udf_view.processid = process.processid
     inner join processtype on processtype.typeid = process.typeid
  left outer join escalationevent e on process.processid = e.processid
  left outer join escalatedsample e2 on e.eventid = e2.escalationeventid
where
      sample.name = 'RE-1850-11-71017020001' and
      process_udf_view.udfname = 'Comments'
order by daterun
