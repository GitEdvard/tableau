with artifact_steps(daterun, processid, stepp,
  artifact_name, artifact_type, artifactid,
  transition_type, udfname, udfvalue, udftype) as
       (
         select process.daterun,
                process.processid,
                processtype.displayname as stepp,
                artifact.name            as artifact_name,
                artifacttype.displayname as artifact_type,
                artifact_in_process.artifactid,
                artifact_in_process.transition_type,
                artifact_udf_view.udfname,
                artifact_udf_view.udfvalue,
                artifact_udf_view.udftype
         from (
                select artifact_sample_map.artifactid, 'input' as transition_type, processiotracker.processid
                from sample
                       inner join artifact_sample_map on artifact_sample_map.processid = sample.processid
                       inner join processiotracker on processiotracker.inputartifactid = artifact_sample_map.artifactid
                where sample.name = 'RL-2027-c49F' -- Parameter is repeated as a hack to ensure a sensible query plan
                union
                select distinct artifact_sample_map.artifactid, 'output' as transition_type, processiotracker.processid
                from sample
                       inner join artifact_sample_map on artifact_sample_map.processid = sample.processid
                       inner join outputmapping on outputmapping.outputartifactid = artifact_sample_map.artifactid
                       inner join processiotracker on processiotracker.trackerid = outputmapping.trackerid
                where sample.name = 'RL-2027-c49F'
              ) artifact_in_process
                inner join process on process.processid = artifact_in_process.processid
                inner join processtype on processtype.typeid = process.typeid
                inner join artifact on artifact.artifactid = artifact_in_process.artifactid
                inner join artifacttype on artifacttype.typeid = artifact.artifacttypeid
                inner join artifact_udf_view on artifact_udf_view.artifactid = artifact.artifactid -- joining this makes this very slow
         where artifact_udf_view.udfname like '%Comment%'
       )
select distinct ars.artifactid, ars.stepp, e.escalationcomment, e.reviewcomment
from artifact_steps ars
left outer join escalationevent e on ars.processid = e.processid



/*Ett prov skickat till review, som Ingvar visar xml, dar finns bade reivew och svar pa review
RL-2027-c49F
Ett annat prov skickat till review
RL-2027-1A
*/
select distinct p2.displayname from escalationevent e
inner join process p on e.processid = p.processid
inner join processtype p2 on p.typeid = p2.typeid
--where e.eventid = 1


select distinct displayname from processtype
where not displayname like 'SNP&SEQ%'
order by displayname


select *
from artifact a
where a.luid = '2-368848'

select *
from escalationevent e
where e.escalationcomment like 'Jag skickar dessa prover vidare till qPCR så får vi se hur %'