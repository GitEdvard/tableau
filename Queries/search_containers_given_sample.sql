select distinct p.daterun, a.luid, p2.displayname, a.name as artifact_name, c2.name as container_name, c.wellxposition, c.wellyposition
from sample s
inner join artifact_sample_map asm on s.processid = asm.processid
inner join artifact a on asm.artifactid = a.artifactid
inner join containerplacement c on a.artifactid = c.processartifactid
inner join container c2 on c.containerid = c2.containerid
inner join processiotracker pt on pt.inputartifactid = a.artifactid
inner join process p on pt.processid = p.processid
inner join processtype p2 on p.typeid = p2.typeid
where s.name = 'RE-1850-11-71017020001'
order by p.daterun