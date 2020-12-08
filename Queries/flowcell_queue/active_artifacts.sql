-- noinspection SqlSideEffects


-- Search active artifacts given a list of protocols
-- active artifacts = artifacts not removed from workflow
-- Filter on last steg detected for each sample
with protocoltype(protocol_name, protocol_type) as(
  select
    lp.protocolname as protocol_name,
    case
      when lp.protocolname ilike 'SNP&SEQ%Reception QC%' then '1. Reception QC'
      when lp.protocolname ilike 'SNP&SEQ Holding prior library prep%' then '2. Holding prior library prep'
      when lp.protocolname ilike 'SNP&SEQ%library prep%' then '3. Library prep'
      when lp.protocolname ilike 'SNP&SEQ Creation of pools: Ready-made libraries%' then '4. Pool ready made libraries '
      when lp.protocolname ilike 'SNP&SEQ Library QC%' then '5. Library QC'
      when lp.protocolname ilike 'SNP&SEQ Holding prior sequencing%' then '6. Holding prior sequencing'
      when lp.protocolname ilike 'SNP&SEQ Illumina SBS%' then '7. Illumina SBS sequencing'
    end as protocol_type
  from labprotocol lp
  where
	  lp.protocolname ilike 'SNP&SEQ%library prep%'
	  or lp.protocolname ilike 'SNP&SEQ%Reception QC%'
	  or lp.protocolname ilike 'SNP&SEQ Creation of pools: Ready-made libraries%'
	  or lp.protocolname ilike 'SNP&SEQ Library QC%'
	  or lp.protocolname ilike 'SNP&SEQ Holding prior sequencing%'
	  or lp.protocolname ilike 'SNP&SEQ Illumina SBS%'
)
insert into last_step_query
(sample_name, artifact_name, processid, displayname, projet_name, protocol_type)
select distinct s.name as sample_name, a.name as artifact_name, p.processid, pt.displayname, prj.name as project_name, prt.protocol_type
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
inner join artifact a on a.artifactid = asm.artifactid
inner join stagetransition st on st.artifactid = asm.artifactid
inner join project prj on prj.projectid = s.projectid
inner join process p on p.processid = latest_process_for_sample.maxp
inner join processtype pt on p.typeid = pt.typeid
inner join protocolstep ps on ps.processtypeid = pt.typeid
inner join labprotocol lp on lp.protocolid = ps.protocolid
inner join protocoltype prt on prt.protocol_name = lp.protocolname
where st.workflowrunid >= 0


-- Search for active artifacts given a list of protocolls
-- Do not filter on latest process for each sample
-- Idea: there should only be one one step with active stage transition, for non-duplicate samples
-- But this seem not to be true
with protocoltype(protocol_name, protocol_type) as(
  select
    lp.protocolname as protocol_name,
    case
      when lp.protocolname ilike 'SNP&SEQ%Reception QC%' then '1. Reception QC'
      when lp.protocolname ilike 'SNP&SEQ Holding prior library prep%' then '2. Holding prior library prep'
      when lp.protocolname ilike 'SNP&SEQ%library prep%' then '3. Library prep'
      when lp.protocolname ilike 'SNP&SEQ Creation of pools: Ready-made libraries%' then '4. Pool ready made libraries '
      when lp.protocolname ilike 'SNP&SEQ Library QC%' then '5. Library QC'
      when lp.protocolname ilike 'SNP&SEQ Holding prior sequencing%' then '6. Holding prior sequencing'
      when lp.protocolname ilike 'SNP&SEQ Illumina SBS%' then '7. Illumina SBS sequencing'
    end as protocol_type
  from labprotocol lp
  where
	  lp.protocolname ilike 'SNP&SEQ%library prep%'
	  or lp.protocolname ilike 'SNP&SEQ%Reception QC%'
	  or lp.protocolname ilike 'SNP&SEQ Creation of pools: Ready-made libraries%'
	  or lp.protocolname ilike 'SNP&SEQ Library QC%'
	  or lp.protocolname ilike 'SNP&SEQ Holding prior sequencing%'
	  or lp.protocolname ilike 'SNP&SEQ Illumina SBS%'
)
insert into all_active_query
(sample_name, artifact_name, processid, displayname, projet_name, protocol_type)
select distinct s.name as sample_name, a.name as artifact_name, p.processid, pt.displayname, prj.name as project_name, prt.protocol_type
from
sample s
inner join project prj on prj.projectid = s.projectid
inner join artifact_sample_map asm on asm.processid = s.processid
inner join artifact a on a.artifactid = asm.artifactid
inner join stagetransition st on st.artifactid = asm.artifactid
inner join processiotracker piot on a.artifactid = piot.inputartifactid
inner join process p on p.processid = piot.processid
inner join processtype pt on p.typeid = pt.typeid
inner join protocolstep ps on ps.processtypeid = pt.typeid
inner join labprotocol lp on lp.protocolid = ps.protocolid
inner join protocoltype prt on prt.protocol_name = lp.protocolname
where st.workflowrunid >= 0


select protocolname from labprotocol
where protocolname ilike 'snp%'
order by protocolname

create temp table last_step_query(
  sample_name varchar(255),
  artifact_name varchar(255),
  processid int,
  displayname varchar(255),
  projet_name varchar(255),
  protocol_type varchar(255)
);

create temp table all_active_query(
  sample_name varchar(255),
  artifact_name varchar(255),
  processid int,
  displayname varchar(255),
  projet_name varchar(255),
  protocol_type varchar(255)
);


select * from last_step_query

select * from all_active_query

