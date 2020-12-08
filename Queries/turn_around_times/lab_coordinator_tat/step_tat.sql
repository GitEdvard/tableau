select distinct lw.workflowname, l.protocolname, w.sectionindex,
                p2.displayname, s.stageindex, s2.createddate as queue_timestamp
                , p3.createddate as process_timestamp, p3.daterun as process_completed_timestamp,
                count(distinct p4.inputartifactid) as number_samples
from labworkflow lw
inner join workflowsection w on lw.workflowid = w.workflowid
inner join labprotocol l on w.protocolid = l.protocolid
inner join protocolstep p on l.protocolid = p.protocolid
inner join processtype p2 on p.processtypeid = p2.typeid
inner join stage s on p.stepid = s.stepid
inner join stagetransition s2 on s.stageid = s2.stageid
inner join process p3 on s2.completedbyid = p3.processid
inner join researcher r on r.researcherid = p3.ownerid
inner join processiotracker p4 on p3.processid = p4.processid
where
      lw.workflowstatus = 'ACTIVE' and
      l.ishidden = false and
      p2.isenabled = true and p2.isvisible = true and
      lw.workflowname ilike 'NovaSeq TruSeq Nano %'
--       p2.displayname ='SNP&SEQ qPCR v1'
group by lw.workflowname, l.protocolname, w.sectionindex,
                p2.displayname, s.stageindex, s2.createddate, p3.createddate, p3.daterun,
                r.firstname
order by s2.createddate desc
