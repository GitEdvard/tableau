-- Add test for if samples are still active


-- Original all inclusive query
-- 4s, 134 rows
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
inner join project prj on prj.projectid = s.projectid
inner join process p on p.processid = latest_process_for_sample.maxp
inner join processtype pt on p.typeid = pt.typeid
inner join protocolstep ps on ps.processtypeid = pt.typeid
inner join labprotocol lp on lp.protocolid = ps.protocolid
left outer join bioinfo_protocols bp on lp.protocolname like bp.base_name || '%'
where bp.base_name is null
group by prj.name


-- Modified query, check for active samples, 4s, 34 rows
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
left outer join bioinfo_protocols bp on lp.protocolname like bp.base_name || '%'
where bp.base_name is null and st.workflowrunid >= 0
group by prj.name


-- Active samples, do pattern matching on protocoll, to replace temp table for bioinfo protocoll
with protocoltype(protocol_name, protocol_type) as(
  select
    lp.protocolname as protocol_name,
    case
      when lp.protocolname ilike 'SNP&SEQ%Reception QC%' then '1. Reception QC'
      when lp.protocolname ilike 'SNP&SEQ Holding prior library prep%' then '2. Holding prior library prep'
      when lp.protocolname ilike 'SNP&SEQ%library prep%' then '3. Library prep'
    end as protocol_type
  from labprotocol lp
  where
	  lp.protocolname ilike 'SNP&SEQ%library prep%'
	  or lp.protocolname ilike 'SNP&SEQ%Reception QC%'
)
select prj.name, prt.protocol_type, count(distinct s.name) as number_samples
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
inner join protocoltype prt on prt.protocol_name = lp.protocolname
where st.workflowrunid >= 0
group by prj.name, prt.protocol_type

select * from labprotocol


  select
          lp.protocolname,
  case
    when lp.protocolname ilike 'SNP&SEQ%Reception QC%' then 'Reception QC'
    when lp.protocolname ilike 'SNP&SEQ Holding prior library prep%' then 'Holding prior library prep'
    when lp.protocolname ilike 'SNP&SEQ%library prep%' then 'Library prep'
  end as protocol_type
  from labprotocol lp
  where
	  lp.protocolname ilike 'SNP&SEQ%library prep%'
	  or lp.protocolname ilike 'SNP&SEQ%Reception QC%'
