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

-- link with samples prepared by Ingvar
select *
from last_step_query lsq
where lsq.sample_name = 'HiSeqX-TruSeqPCR-free-Holahola4'

select *
from all_active_query aaq
where aaq.sample_name = 'HiSeqX-TruSeqPCR-free-Holahola4'

-- The first sample in Reception QC choice, in queue to 1st step
-- have no processiotracker....
select s.name, a.luid
from sample s
inner join artifact_sample_map asm on s.processid = asm.processid
inner join artifact a on asm.artifactid = a.artifactid
where s.name = 'HiSeqX-TruSeqPCR-free-Holahola1'

-- Fetch all artifacts and steps for above samples
select s.name as sample_name, a.name as artifact_name, a.artifactid, pt.displayname, prc.daterun
from sample s
inner join artifact_sample_map asm on s.processid = asm.processid
inner join artifact a on asm.artifactid = a.artifactid
inner join processiotracker piot on a.artifactid = piot.inputartifactid
inner join process prc on prc.processid = piot.processid
inner join processtype pt on pt.typeid = prc.typeid
where s.name = 'HiSeqX-TruSeqPCR-free-Holahola2'

-- Fetch stage transitions for samples
select s.name as sample_name, a.name as artifact_name, pt.displayname, prc.daterun, s2.*
from sample s
inner join artifact_sample_map asm on s.processid = asm.processid
inner join artifact a on asm.artifactid = a.artifactid
inner join processiotracker piot on a.artifactid = piot.inputartifactid
inner join process prc on prc.processid = piot.processid
inner join processtype pt on pt.typeid = prc.typeid
inner join stagetransition s2 on a.artifactid = s2.artifactid
where s.name = 'HiSeqX-TruSeqPCR-free-Holahola2'

-- Fetch stage transitions based on stepid
select s.name as sample_name, a.name as artifact_name, a.artifactid, prc.processid, pt.displayname, prc.daterun, s2.*
from sample s
inner join artifact_sample_map asm on s.processid = asm.processid
inner join artifact a on asm.artifactid = a.artifactid
inner join processiotracker piot on a.artifactid = piot.inputartifactid
inner join process prc on prc.processid = piot.processid
inner join processtype pt on pt.typeid = prc.typeid
inner join protocolstep ps on ps.processtypeid = pt.typeid
inner join stage st on st.stepid = ps.stepid
inner join stagetransition s2 on a.artifactid = s2.artifactid and s2.stageid = st.stageid
where s.name = 'HiSeqX-TruSeqPCR-free-Holahola2'


-- Find all proces steps regardless of stage transition, is the last step included, in which
-- the sample now is queued?
select s.name as sample_name, a.name as artifact_name, a.artifactid, prc.processid, pt.displayname, prc.daterun
from sample s
inner join artifact_sample_map asm on s.processid = asm.processid
inner join artifact a on asm.artifactid = a.artifactid
inner join processiotracker piot on a.artifactid = piot.inputartifactid
inner join process prc on prc.processid = piot.processid
inner join processtype pt on pt.typeid = prc.typeid
where s.name = 'HiSeqX-TruSeqPCR-free-Holahola2'
-- last steg is not included here


-- investigate artifactstate
select s.name as sample_name, a.name as artifact_name, a.artifactid, a2.*
from sample s
inner join artifact_sample_map asm on s.processid = asm.processid
inner join artifact a on asm.artifactid = a.artifactid
inner join analyte an on an.artifactid = a.artifactid
inner join artifactstate a2 on a.artifactid = a2.artifactid
where s.name = 'HiSeqX-TruSeqPCR-free-Holahola4'

-- investigate experiment
select s.name as sample_name, a.name as artifact_name, a.artifactid, a.luid, e.*
from sample s
inner join artifact_sample_map asm on s.processid = asm.processid
inner join artifact a on asm.artifactid = a.artifactid
inner join exp_artifact_map eam on a.artifactid = eam.artifactid
inner join experiment e on eam.experimentid = e.experimentid
where s.name = 'HiSeqX-TruSeqPCR-free-Holahola3'


-- investigate stage
select s.*, stagetransition.*
from stagetransition
inner join stage s on stagetransition.stageid = s.stageid
inner join protocolstep ps on ps.stepid = s.stepid
inner join artifact a on stagetransition.artifactid = a.artifactid
inner join artifact_sample_map asm on a.artifactid = asm.artifactid
inner join sample s2 on asm.processid = s2.processid
where s2.name = 'HiSeqX-TruSeqPCR-free-Holahola1'

-- investigate stage 2
select *
from stage
where stepid = 852 and membershipid = 1563

-- investigate protocolstep
select l.protocolname, ps.*
from protocolstep ps
inner join processtype pt on ps.processtypeid = pt.typeid
inner join labprotocol l on ps.protocolid = l.protocolid
where pt.displayname = 'SNP&SEQ Reception QC Choice 1 v1'


select s.name as sample_name, a.name as artifact_name, a.artifactid, prc.processid, pt.displayname, prc.daterun
from sample s
inner join artifact_sample_map asm on s.processid = asm.processid
inner join artifact a on asm.artifactid = a.artifactid
inner join processiotracker piot on a.artifactid = piot.inputartifactid
inner join process prc on prc.processid = piot.processid
inner join processtype pt on pt.typeid = prc.typeid
where s.name = 'HiSeqX-TruSeqPCR-free-Holahola2'


select *
from processtype pt
where pt.displayname = 'SNP&SEQ Reception QC Choice 2 v1'

select * from artifact a where a.artifactid = 106818

select distinct w.*
from processtype p
inner join protocolstep p2 on p.typeid = p2.processtypeid
inner join stage s on p2.stepid = s.stepid
inner join workflowsection w on s.membershipid = w.sectionid
where p.typeid = 117


select now()

select * from experiment

select * from task