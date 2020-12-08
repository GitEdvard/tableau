
-- visa alla steg i tidsordning, prov som har duplikat
select processtype.displayname, process.processid
from sample
     inner join artifact_sample_map on artifact_sample_map.processid = sample.processid
     inner join processiotracker on processiotracker.inputartifactid = artifact_sample_map.artifactid
     inner join process on process.processid = processiotracker.processid
     inner join processtype on processtype.typeid = process.typeid
where
      sample.name = 'RD-1805-ID280'
order by process.processid


-- visa antal input artifact och output artifact for specifikt prov, for varje steg
select processtype.displayname, process.processid, count(distinct a_in.luid) as N_input, count(distinct a_out.luid) as N_output
from sample
     inner join artifact_sample_map on artifact_sample_map.processid = sample.processid
     inner join processiotracker on processiotracker.inputartifactid = artifact_sample_map.artifactid
     inner join outputmapping om on om.trackerid = processiotracker.trackerid
     inner join process on process.processid = processiotracker.processid
     inner join processtype on processtype.typeid = process.typeid
     inner join artifact a_in on a_in.artifactid = processiotracker.inputartifactid
     inner join artifact a_out on a_out.artifactid = om.outputartifactid
     inner join analyte a on a_out.artifactid = a.artifactid
where
      sample.name = 'RD-1805-ID280'
group by processtype.displayname, process.processid
order by process.processid
