-- duplicate samples?
select *
from sample_results sr
inner join flowcell_runfolder fr on fr.flowcell_id = sr.flowcell_id
where sr.sample_name = 'RJ-1967-485-17'


-- re runned ?
select *
from sample_results sr
inner join flowcell_runfolder fr on fr.flowcell_id = sr.flowcell_id
where sr.sample_name = 'RJ-1967-96-13'


-- RJ-1967-96-13

-- RJ-1967-485-17
-- RJ-1967-67-04
-- RL-2022-ajv054-b1e3l1drp1
-- SB-2079-B1A2