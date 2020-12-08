select distinct project_id, run_date, sample_name, s.flowcell_id, lane_num
from flowcell_runfolder fr
  inner join sample_results s on s.flowcell_id = fr.flowcell_id
where project_id = 'QK-1662' and sample_name = 'QK-1662-flo011-b1e1l2p1dr'
