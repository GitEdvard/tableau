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
      else '8. Bioinfo steps'
    end as protocol_type
  from labprotocol lp
)
select prj.name as project, prt.protocol_type, count(distinct a.luid) as number_samples
from stagetransition st
inner join artifact a on st.artifactid = a.artifactid
inner join artifact_sample_map asm on a.artifactid = asm.artifactid
inner join sample s on asm.processid = s.processid
inner join project prj on prj.projectid = s.projectid
inner join stage stage on st.stageid = stage.stageid
inner join protocolstep ps on stage.stepid = ps.stepid
inner join processtype pt on ps.processtypeid = pt.typeid
inner join labprotocol lp on ps.protocolid = lp.protocolid
inner join protocoltype prt on prt.protocol_name = lp.protocolname
where st.workflowrunid >= 0 and prj.name = 'RL-2022'
group by prj.name, prt.protocol_type


-- Fetch number of artifacts per project-step-pooling value
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
      else '8. Bioinfo steps'
    end as protocol_type
  from labprotocol lp
)
select distinct prt.protocol_type, prj.name as project_name, pt.displayname,
                cast(substring(lower(number_lanes.udfvalue) from '([0-9\.]+)\s*lane[s]?/(pool|library)') as int) as lanes_per_pool,
                cast(substring(lower(number_lanes.udfvalue) from '([0-9\.]+)\s*flowcell[s]?/(pool|library)') as int) as flowcells_per_pool,
                count(distinct a.name) as number_artifacts,
                case when pt.typename ilike 'poolsamples%' or prt.protocol_type not ilike '%Illumina SBS%' then
                cast(substring(pooling.udfvalue from '([0-9\.]+).*') as int)
                else
                  -- At illumina sbs, read udf for pooling from artifact level. Before pooling --> pooling udf is set
                  -- after pooling --> pooling udf is null --> number of pools = number of artifacts
                cast(substring(pooling_artifact.udfvalue from '([0-9\.]+).*') as int)
                end as lib_per_pool
from stagetransition st
inner join artifact a on st.artifactid = a.artifactid
inner join artifact_sample_map asm on a.artifactid = asm.artifactid
inner join sample s on asm.processid = s.processid
inner join sample_udf_view pooling
  on pooling.sampleid = s.sampleid and pooling.udfname = 'Pooling'
inner join sample_udf_view number_lanes
  on number_lanes.sampleid = s.sampleid and number_lanes.udfname = 'Number of lanes'
inner join project prj on prj.projectid = s.projectid
inner join stage stage on st.stageid = stage.stageid
inner join protocolstep ps on stage.stepid = ps.stepid
inner join processtype pt on ps.processtypeid = pt.typeid
inner join labprotocol lp on ps.protocolid = lp.protocolid
inner join protocoltype prt on prt.protocol_name = lp.protocolname
left outer join artifact_udf_view pooling_artifact
  on pooling_artifact.artifactid = a.artifactid and pooling_artifact.udfname = 'Pooling'
where st.workflowrunid >= 0
  and not a.name ilike 'phix%'
  and not prt.protocol_type is null
  and prj.closedate is null
group by prt.protocol_type, prj.name, pt.typename, pt.displayname,
         pooling_artifact.udfvalue, pooling.udfvalue, number_lanes.udfvalue
