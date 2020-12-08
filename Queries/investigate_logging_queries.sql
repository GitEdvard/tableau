select st.*
from stagetransition st
inner join stage stage on st.stageid=stage.stageid
inner join workflowsection wfs on stage.membershipid=wfs.sectionid
inner join labworkflow wf on wfs.workflowid = wf.workflowid
inner join artifact a on st.artifactid = a.artifactid
where
      --st.workflowrunid>=0 and
      a.name = 'RE-1850-11-71017020001'
order by st.workflowrunid DESC


select

/*
borttaget prov, remove from workflow, sist i steget
Chromium-001-Liv7
borttaget prov, remove from queue, forst i steget
Chromium-001-Idun3
Prov med ett neg och ett pos workflowid
Chromium-001-Liv4
prov som ar kvar
Chromium-001-Liv2
prov (drift-db) som har gatt igenom 58 steg
RD-1805-ID280
prov, omkorning
RE-1850-11-71017020001
*/