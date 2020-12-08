-- Fetch all live artifacts up to bio info steps
-- Include udf values, number of flowcells, number of lanes
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
select distinct prt.protocol_type, a.name, a.luid, auv.udfname, auv.udfvalue
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
inner join artifact_udf_view auv on auv.artifactid = a.artifactid
where st.workflowrunid >= 0
and (auv.udfname = 'Pooling' or auv.udfname = 'Number of lanes')
order by a.name

select distinct  udfvalue
from artifact_udf_view
where udfname ilike 'Pooling'


/*
                    select p.*
from artifact a
inner join processoutputtype p on a.processoutputtypeid = p.typeid
where a.name =  'RK-2015_Pool4_75369_1nM_190211'

select distinct outputnamestring, * from processoutputtype
*/