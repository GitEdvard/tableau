-- Fetch number of live samples per project-step combination
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
where st.workflowrunid >= 0
group by prj.name, prt.protocol_type
order by prj.name