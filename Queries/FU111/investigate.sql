select sr.project_id, fr.runfolder_name, fr.run_date, flr.*
from flowcell_runfolder fr
  left outer join flowcell_lane_results flr on flr.flowcell_id = fr.flowcell_id
  left outer join sample_results sr on sr.flowcell_id = flr.flowcell_id



select * from sample_results

select sr.project_id, fr.runfolder_name, fr.run_date, flr.*
from flowcell_runfolder fr
  left outer join flowcell_lane_results flr on flr.flowcell_id = fr.flowcell_id
  left outer join sample_results sr on sr.flowcell_id = flr.flowcell_id