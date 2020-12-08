select distinct s.name, c2.wellxposition, c2.wellyposition
from container c
inner join containerplacement c2 on c.containerid = c2.containerid
inner join artifact a on c2.processartifactid = a.artifactid
inner join artifact_sample_map asm on a.artifactid = asm.artifactid
inner join sample s on asm.processid = s.processid
where c.name = '000000000-BWHLW'