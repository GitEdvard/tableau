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



select distinct pt.displayname as step, lp.protocolname as protocoll
from (
        select sample.sampleid as sample_id, max(process.processid) as maxp
        from sample
             inner join artifact_sample_map on artifact_sample_map.processid = sample.processid
             inner join processiotracker on processiotracker.inputartifactid = artifact_sample_map.artifactid
             inner join process on process.processid = processiotracker.processid
        group by sample.sampleid
  ) max_processid_for_sample
inner join process p on p.processid = max_processid_for_sample.maxp
inner join processtype pt on p.typeid = pt.typeid
inner join processiotracker poit on poit.processid = p.processid
inner join protocolstep ps on ps.processtypeid = pt.typeid
inner join labprotocol lp on lp.protocolid = ps.protocolid
left outer join bioinfo_protocols  bp on lp.protocolname like bp.base_name || '%'
where bp.base_name is null

-- break out query to get protocoll name
select distinct pt.displayname as step, lp.protocolname as protocoll
from process p
inner join processtype pt on p.typeid = pt.typeid
inner join processiotracker poit on poit.processid = p.processid
inner join protocolstep ps on ps.processtypeid = pt.typeid
inner join labprotocol lp on lp.protocolid = ps.protocolid



select prj.name, count(distinct s.name) as number_samples
from (
        select sample.sampleid as sample_id, max(process.processid) as maxp
        from sample
             inner join artifact_sample_map on artifact_sample_map.processid = sample.processid
             inner join processiotracker on processiotracker.inputartifactid = artifact_sample_map.artifactid
             inner join process on process.processid = processiotracker.processid
        group by sample.sampleid
  ) max_processid_for_sample
inner join process p on p.processid = max_processid_for_sample.maxp
inner join processtype pt on p.typeid = pt.typeid
inner join processiotracker poit on poit.processid = p.processid
inner join protocolstep ps on ps.processtypeid = pt.typeid
inner join labprotocol lp on lp.protocolid = ps.protocolid
inner join sample s on s.sampleid = max_processid_for_sample.sample_id
inner join project prj on prj.projectid = s.projectid
left outer join bioinfo_protocols  bp on lp.protocolname like bp.base_name || '%'
where bp.base_name is null
group by prj.name


select sample.sampleid as sample_id, max(process.processid) as maxp
from sample
     inner join artifact_sample_map on artifact_sample_map.processid = sample.processid
     inner join processiotracker on processiotracker.inputartifactid = artifact_sample_map.artifactid
     inner join process on process.processid = processiotracker.processid
group by sample.sampleid
