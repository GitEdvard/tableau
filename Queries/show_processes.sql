-- visa processer i tidsordning

select processtype.displayname, process.processid
from sample
     inner join artifact_sample_map on artifact_sample_map.processid = sample.processid
     inner join processiotracker on processiotracker.inputartifactid = artifact_sample_map.artifactid
     inner join process on process.processid = processiotracker.processid
     inner join processtype on processtype.typeid = process.typeid
where
      sample.name = 'Chromium-RML-001-Chromium-RML-001-1'
order by process.processid


-- Show all information on processer
select distinct processtype.displayname, process.processid, processtype.*
from sample
     inner join artifact_sample_map on artifact_sample_map.processid = sample.processid
     inner join processiotracker on processiotracker.inputartifactid = artifact_sample_map.artifactid
     inner join process on process.processid = processiotracker.processid
     inner join processtype on processtype.typeid = process.typeid
where
      sample.name = 'RE-1850-11-71017020001'
order by process.processid desc

-- show process with max processid
select max(process.processid)
from sample
     inner join artifact_sample_map on artifact_sample_map.processid = sample.processid
     inner join processiotracker on processiotracker.inputartifactid = artifact_sample_map.artifactid
     inner join process on process.processid = processiotracker.processid
     inner join processtype on processtype.typeid = process.typeid
where
      sample.name = 'RE-1850-11-71017020001'

-- link max process id with display name

select pt.displayname from (
select max(process.processid) as maxp
from sample
     inner join artifact_sample_map on artifact_sample_map.processid = sample.processid
     inner join processiotracker on processiotracker.inputartifactid = artifact_sample_map.artifactid
     inner join process on process.processid = processiotracker.processid
     inner join processtype on processtype.typeid = process.typeid
where
      sample.name = 'RE-1850-11-71017020001') max_processid
inner join process p on p.processid = max_processid.maxp
inner join processtype pt on p.typeid = pt.typeid


-- link latest step with list of bio-info steps
-- preparation
create temp table bioinfosteps(
  name varchar(255)
);
insert into bioinfosteps
(name)
values
('SNP&SEQ Reporting choice')

-- query
select a.artifactid, pt.displayname from (
select max(process.processid) as maxp
from sample
     inner join artifact_sample_map on artifact_sample_map.processid = sample.processid
     inner join processiotracker on processiotracker.inputartifactid = artifact_sample_map.artifactid
     inner join process on process.processid = processiotracker.processid
     inner join processtype on processtype.typeid = process.typeid
where
      sample.name = 'RD-1805-ID280') max_processid
inner join process p on p.processid = max_processid.maxp
inner join processtype pt on p.typeid = pt.typeid
inner join processiotracker poit on poit.processid = p.processid
inner join artifact a on a.artifactid = poit.inputartifactid
inner join artifact_sample_map asm on asm.artifactid = a.artifactid
inner join sample s on s.processid = asm.processid
inner join bioinfosteps b on pt.displayname not like b.name || 'b%'
where s.name = 'RD-1805-ID280'


/*
Ett prov som har omkorning:
RE-1850-11-71017020001

prov med replikat
RD-1805-ID280
*/

