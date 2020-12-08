select select sr.project_id, fr.runfolder_name, fr.run_date, flr.*
from flowcell_runfolder fr
  left outer join flowcell_lane_results flr on flr.flowcell_id = fr.flowcell_id
  left outer join sample_results sr on sr.flowcell_id = flr.flowcell_id
where sr.project_id = 'RI-1940'

select distinct sr.sample_name
from flowcell_runfolder fr
  inner join flowcell_lane_results flr on flr.flowcell_id = fr.flowcell_id
  inner join sample_results sr on sr.flowcell_id = flr.flowcell_id
where sr.project_id = 'RI-1940'


--select sr.project_id, fr.runfolder_name, fr.run_date, flr.*

-- 25152
select distinct sr.project_id, fr.runfolder_name, fr.run_date, flr.*
from flowcell_runfolder fr
  left outer join flowcell_lane_results flr on flr.flowcell_id = fr.flowcell_id
  left outer join sample_results sr on sr.flowcell_id = flr.flowcell_id
where sr.project_id = 'RI-1940' and sr.sample_name = 'Ki-1974-21-294'

