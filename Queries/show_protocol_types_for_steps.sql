select distinct processtype.displayname, process.processid, lp.protocolname
from sample
     inner join artifact_sample_map on artifact_sample_map.processid = sample.processid
     inner join processiotracker on processiotracker.inputartifactid = artifact_sample_map.artifactid
     inner join process on process.processid = processiotracker.processid
     inner join processtype on processtype.typeid = process.typeid
     inner join protocolstep ps on ps.processtypeid = processtype.typeid
     inner join labprotocol lp on lp.protocolid = ps.protocolid
where
      sample.name = 'RD-1805-ID280'
order by process.processid

select *
from labprotocol
where not ishidden
order by protocolname


/*
Ett prov som har omkorning:
RE-1850-11-71017020001

prov med replikat
RD-1805-ID280
*/