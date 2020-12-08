create temp table bioinfo_protocols(
  base_name varchar(255)
);

insert into bioinfo_protocols
(base_name)
values
('SNP&SEQ Bioinfo');


insert into bioinfo_protocols
(base_name)
values
('SNP&SEQ Delivered data for reporting');


-- Query retreiving the latest step for each sample
select sample.sampleid as sample_id, max(process.processid) as maxp
from sample
     inner join artifact_sample_map on artifact_sample_map.processid = sample.processid
     inner join processiotracker on processiotracker.inputartifactid = artifact_sample_map.artifactid
     inner join process on process.processid = processiotracker.processid
group by sample.sampleid

-- Retreive the protokoll for latest step
-- Joins: bioinfo protocol name, latest step for each sample, on both process and sample
select distinct s.sampleid, prj.name, p.processid, pt.displayname as step, lp.protocolname as protocoll
from process p
inner join processtype pt on p.typeid = pt.typeid
inner join processiotracker poit on poit.processid = p.processid
inner join protocolstep ps on ps.processtypeid = pt.typeid
inner join labprotocol lp on lp.protocolid = ps.protocolid,
     sample s
inner join project prj on prj.projectid = s.projectid


-- Number of samples per project
-- Joins: protocol for latest step, on project
select prj.name, count(distinct s.name) as number_samples
from sample s
inner join project prj on prj.projectid = s.projectid
group by prj.name


-- All inclusive query
select prj.name, count(distinct s.name) as number_samples
from
              (select sample.sampleid as sample_id, max(process.processid) as maxp
                    from sample
                         inner join artifact_sample_map on artifact_sample_map.processid = sample.processid
                         inner join processiotracker on processiotracker.inputartifactid = artifact_sample_map.artifactid
                         inner join process on process.processid = processiotracker.processid
                    group by sample.sampleid
              ) latest_process_for_sample
inner join sample s on s.sampleid = latest_process_for_sample.sample_id
inner join project prj on prj.projectid = s.projectid
inner join process p on p.processid = latest_process_for_sample.maxp
inner join processtype pt on p.typeid = pt.typeid
inner join protocolstep ps on ps.processtypeid = pt.typeid
inner join labprotocol lp on lp.protocolid = ps.protocolid
left outer join bioinfo_protocols bp on lp.protocolname like bp.base_name || '%'
where bp.base_name is null
group by prj.name

do $$
declare
     myvar int;
begin
     raise notice '%', myvar;
end $$;

DO $$
DECLARE
   counter    INTEGER := 1;
   first_name VARCHAR(50) := 'John';
   last_name  VARCHAR(50) := 'Doe';
   payment    NUMERIC(11,2) := 20.5;
BEGIN
   RAISE NOTICE '% % % has been paid % USD', counter, first_name, last_name, payment;
END $$;


select * from artifactstate


select * from sample
where name like 'Chromium-001%'
