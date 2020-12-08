select protocolname
from labprotocol
where not ishidden
order by protocolname

select protocolname
from labprotocol
where not ishidden and
      protocolname ilike '%library prep%'
order by protocolname



select prj.name, count(distinct s.name) as number_samples
from
              (select sample.sampleid as sample_id, max(process.processid) as maxp
                    from sample
                         inner join artifact_sample_map on artifact_sample_map.processid = sample.processid
                         inner join processiotracker on processiotracker.inputartifactid = artifact_sample_map.artifactid
                         inner join process on process.processid = processiotracker.processid
                    group by sample.sampleid
              ) latest_process_for_sample
inner join sample s on s.sampleid = latest_process_for_sample.sample_id
inner join artifact_sample_map asm on asm.processid = s.processid
inner join stagetransition st on st.artifactid = asm.artifactid
inner join project prj on prj.projectid = s.projectid
inner join process p on p.processid = latest_process_for_sample.maxp
inner join processtype pt on p.typeid = pt.typeid
inner join protocolstep ps on ps.processtypeid = pt.typeid
inner join labprotocol lp on lp.protocolid = ps.protocolid
where st.workflowrunid >= 0
      and (
	  lp.protocolname ilike 'SNP&SEQ%library prep%'
	  or lp.protocolname ilike 'SNP&SEQ%Reception QC%'
)
group by prj.name


with samples_for_fc(name) as (
select distinct s.name, c2.wellxposition, c2.wellyposition
from container c
inner join containerplacement c2 on c.containerid = c2.containerid
inner join artifact a on c2.processartifactid = a.artifactid
inner join artifact_sample_map asm on a.artifactid = asm.artifactid
inner join sample s on asm.processid = s.processid
where c.name = 'HHJ25DMXX'
  and not s.name ilike 'phiX%'
  and not s.name ilike 'negative control%'
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
 left outer join process_udf_view on process_udf_view.processid = process.processid and process_udf_view.udfname = 'Comments'
 inner join processtype on processtype.typeid = process.typeid
left outer join escalationevent e on process.processid = e.processid
left outer join escalatedsample e2 on e.eventid = e2.escalationeventid
order by process_luid


select p.name, project_udf.*
    from crosstab(
    'select
	attachtoid,
        udfname,
        udfvalue
     from
	entity_udf_view
     where
	udfname in
	(
	    ''Sequencing instrument'',
	    ''Number of samples''
	)
     order by 1,2',
     $$values
	('Sequencing instrument'::text),
	('Number of samples'::text)$$
     )
     as project_udf
     (
	attachtoid bigint,
	"Sequencing instrument" text,
	"Number of samples" text
     )
inner join project p on p.projectid = project_udf.attachtoid
where not "Number of samples" ~ '^[0-9]+$'


select distinct udf.udfname
  from project p
 inner join entity_udf_view udf on udf.attachtoid = p.projectid and attachtoclassid = 83
where not udf.udfname ilike 'deprecated%'
order by udf.udfname

select distinct s.name
from sample s
where s.name ilike 'neg%'