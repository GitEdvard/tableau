select distinct lw.workflowname, l.protocolname, w.sectionindex,
                p2.displayname, s.stageindex, prj.name as project,
                p3.processid,
                avg ((select extract (epoch from (p3.createddate - s2.createddate))::integer/60)) as queue_time,
                avg ((select extract (epoch from (p3.daterun - p3.createddate))::integer/60)) as process_time,
                count(distinct a.artifactid) as number_artifacts
from labworkflow lw
inner join workflowsection w on lw.workflowid = w.workflowid
inner join labprotocol l on w.protocolid = l.protocolid
inner join protocolstep p on l.protocolid = p.protocolid
inner join processtype p2 on p.processtypeid = p2.typeid
inner join stage s on p.stepid = s.stepid
inner join stagetransition s2 on s.stageid = s2.stageid
  inner join analyte a on a.artifactid = s2.artifactid
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
--       lw.workflowname ilike 'NovaSeq TruSeq Nano %' and
      p3.createddate > s2.createddate and
      p3.daterun > '2019-06-25'
group by lw.workflowname, l.protocolname, w.sectionindex,
         p2.displayname, s.stageindex, prj.name, p3.processid
