select distinct lw.workflowname, l.protocolname, w.sectionindex,
                p2.displayname, s.stageindex
from labworkflow lw
inner join workflowsection w on lw.workflowid = w.workflowid
inner join labprotocol l on w.protocolid = l.protocolid
inner join protocolstep p on l.protocolid = p.protocolid
inner join processtype p2 on p.processtypeid = p2.typeid
inner join stage s on p.stepid = s.stepid
where
      lw.workflowstatus = 'ACTIVE' and
      l.ishidden = false and
      p2.isenabled = true and p2.isvisible = true and
       lw.workflowname ilike 'NovaSeq TruSeq Nano %'
--       p2.displayname ='SNP&SEQ qPCR v1'
order by w.sectionindex, s.stageindex


