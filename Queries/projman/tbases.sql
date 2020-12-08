-- SDashboard
with asd(runfolder_name, run_date, gb) as (
select
    fr.runfolder_name as runfolder_name,
    fr.run_date,
    --sum(flr.cycles * flr.pf_clusters / 1e9) as GB
    flr.cycles * flr.pf_clusters / 1e9 as GB
  from flowcell_lane_results flr
    left join flowcell_runfolder fr on fr.flowcell_id = flr.flowcell_id
--group by fr.runfolder_name, run_date having run_date > '2019-01-01')
 where fr.run_date > '2019-01-01')
select sum(gb) from asd
-- 155 257
  go

-- ExportR
with asd(project_id, run_date, gb) as (
select project_id, run_date, sum(cycles * pf_clusters) / 1e9 as "gb"
from sample_results sr
       inner join flowcell_runfolder fr on fr.flowcell_id = sr.flowcell_id
  group by project_id, run_date
having run_date > '2019-01-01'
)
select sum(gb) from asd
--145367