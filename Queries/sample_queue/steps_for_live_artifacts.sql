-- Fetch step for selected samples, from Ingvar, by means of stage transition
select distinct p2.displayname, stagetransition.*
from stagetransition
inner join artifact a on stagetransition.artifactid = a.artifactid
inner join artifact_sample_map asm on a.artifactid = asm.artifactid
inner join sample s on asm.processid = s.processid
inner join stage s2 on stagetransition.stageid = s2.stageid
inner join protocolstep p on s2.stepid = p.stepid
inner join processtype p2 on p.processtypeid = p2.typeid
where s.name = 'HiSeqX-TruSeqMetylation-IT7'
and stagetransition.workflowrunid >= 0
order by stagetransition.createddate


/*
HiSeqX-TruSeqPCR-free-Holahola1
HiSeqX-TruSeqMetylation-IT7
*/

select * from processiotracker