-- Project status Clarity samples
with protocoltype(protocol_name, protocol_type) as (
  select lp.protocolname as protocol_name,
         case
           when lp.protocolname ilike 'SNP&SEQ%Reception QC%' then '1. Reception QC'
           when lp.protocolname ilike 'SNP&SEQ Holding prior library prep%'
             then '2. Holding prior library prep'
           when lp.protocolname ilike 'SNP&SEQ%library prep%' then '3. Library prep'
           when lp.protocolname ilike 'SNP&SEQ Creation of pools: Ready-made libraries%'
             then '4. Pool ready made libraries '
           when lp.protocolname ilike 'SNP&SEQ Library QC%' then '5. Library QC'
           when lp.protocolname ilike 'SNP&SEQ Holding prior sequencing%'
             then '6. Holding prior sequencing'
           when lp.protocolname ilike 'SNP&SEQ Illumina SBS%' then '7. Illumina SBS sequencing'
           else '8. Bioinfo steps'
           end           as protocol_type
  from labprotocol lp
  )
  select distinct prt.protocol_type, prj.name as project_name, pt.displayname,
                  project_udf.instrument, project_udf.read_length
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
inner join (  select p.name, instrument.udfvalue as instrument, sample_type.udfvalue as sample_type,
  kit.udfvalue as kit, number_samples.udfvalue as number_samples,
  read_length.udfvalue as read_length, number_flowcells.udfvalue as number_flowcells,
  number_lanes.udfvalue as number_lanes
  from project p
  inner join entity_udf_view instrument
  on instrument.attachtoid = p.projectid and instrument.udfname = 'Sequencing instrument'
  inner join entity_udf_view sample_type
  on sample_type.attachtoid = p.projectid and sample_type.udfname =
                      'Type of sample'
  inner join entity_udf_view kit
  on kit.attachtoid = p.projectid and kit.udfname =
                      'Kit for library preparation'
  inner join entity_udf_view number_samples
  on number_samples.attachtoid =p.projectid and number_samples.udfname =
                      'Number of samples'
  inner join entity_udf_view read_length
  on read_length.attachtoid =p.projectid and read_length.udfname =
                      'Read length bp'
  inner join entity_udf_view number_flowcells on
  number_flowcells.attachtoid = p.projectid and number_flowcells.udfname =
                      'Number of flowcells'
  inner join entity_udf_view number_lanes on
  number_lanes.attachtoid = p.projectid and number_lanes.udfname =
                      'Number of lanes'
) project_udf on project_udf.name = prj.name
  where st.workflowrunid >= 0
    and not a.name ilike 'phix%'
    and not prt.protocol_type is null
    and prj.closedate is null
    and project_udf.instrument = 'MiSeq'
    and project_udf.read_length = '150x2'
    and protocol_type = '5. Library QC'
-- Project udf


--     and prj.name = 'SD-2143'

