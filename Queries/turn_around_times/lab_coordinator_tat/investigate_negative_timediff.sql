select distinct a.name, a.luid,
                p2.displayname, s.stageindex, prj.name as project, s2.createddate as queue_timestamp
                , p3.createddate as process_timestamp, p3.daterun as process_completed_timestamp,
                p3.processid,
                (select extract (epoch from (p3.createddate - s2.createddate))::integer/60 as timediff)
from labworkflow lw
inner join workflowsection w on lw.workflowid = w.workflowid
inner join labprotocol l on w.protocolid = l.protocolid
inner join protocolstep p on l.protocolid = p.protocolid
inner join processtype p2 on p.processtypeid = p2.typeid
inner join stage s on p.stepid = s.stepid
inner join stagetransition s2 on s.stageid = s2.stageid
  inner join artifact a on s2.artifactid = a.artifactid
  inner join analyte anl on a.artifactid = anl.artifactid
  inner join artifact_sample_map asm on a.artifactid = asm.artifactid
  inner join sample smp on asm.processid = smp.processid
  inner join project prj on smp.projectid = prj.projectid
inner join process p3 on s2.completedbyid = p3.processid
inner join researcher r on r.researcherid = p3.ownerid
inner join processiotracker p4 on p3.processid = p4.processid
where
      lw.workflowstatus = 'ACTIVE' and
      l.ishidden = false and
      p2.isenabled = true and p2.isvisible = true and
      lw.workflowname ilike 'NovaSeq TruSeq Nano %' and
      p3.createddate > s2.createddate and
--       p2.displayname ='SNP&SEQ qPCR v1' and
--     (select extract (epoch from (p3.createddate - s2.createddate))::integer/60)  < 0
      a.name = 'HiSeqX-TruSeqNano-Tjillevipp2'
order by s2.createddate desc

-- HiSeqX-TruSeqNano-Tjillevipp2

-- Test-1212_Pool1_12300_2nM_180108
