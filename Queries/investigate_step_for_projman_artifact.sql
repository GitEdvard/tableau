select p2.displayname
from artifact a
inner join processiotracker pt on a.artifactid = pt.inputartifactid
inner join process p on pt.processid = p.processid
inner join processtype p2 on p.typeid = p2.typeid
where a.luid = '2-361813'
