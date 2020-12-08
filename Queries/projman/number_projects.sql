-- SDashboard
select last_run_date, count(*) project_count
  from (select s.project_id, max(fr.run_date) last_run_date
          from flowcell_runfolder fr
            inner join sample_results s on s.flowcell_id = fr.flowcell_id
         group by s.project_id) last_project_runs
  group by last_run_date
 having last_run_date > '2019-01-01'

-- SDashboard, summed up
  with asd(last_run_date, project_count) as (
    select last_run_date, count(*) project_count
    from (select s.project_id, max(fr.run_date) last_run_date
          from flowcell_runfolder fr
                 inner join sample_results s on s.flowcell_id = fr.flowcell_id
          group by s.project_id) last_project_runs
    group by last_run_date
    having last_run_date > '2018-01-01'
  )
  select sum(project_count) from asd

-- ExportR
  select project_id, run_date, count(sample_name) nbr_of_samples
  from (
      select distinct project_id, run_date, sample_name
        from sample_results sr
          inner join flowcell_runfolder fr on fr.flowcell_id = sr.flowcell_id
      where read_num = 1
      ) t
 group by project_id, run_date
having run_date > '1900-01-01'

-- ExportR, summed up
  with asd(project_id, run_date, nbr_of_samples) as (
    select project_id, run_date, count(sample_name) nbr_of_samples
    from (
           select distinct project_id, run_date, sample_name
           from sample_results sr
                  inner join flowcell_runfolder fr on fr.flowcell_id = sr.flowcell_id
           where read_num = 1
         ) t
    group by project_id, run_date
    having run_date > '2018-01-01'
  )
select count(distinct project_id) from asd


select distinct project_id, run_date, sample_name, year(run_date)
from sample_results sr
      inner join flowcell_runfolder fr on fr.flowcell_id = sr.flowcell_id

select year(run_date) as year, count(distinct project_id) as number_projects
from sample_results sr
      inner join flowcell_runfolder fr on fr.flowcell_id = sr.flowcell_id
group by year(run_date) having year(run_date) > 2000


select
    fr.runfolder_name as runfolder_name,
    fr.run_date,
    -- sum(flr.cycles * flr.pf_clusters / 1e9) as GB
    flr.cycles * flr.pf_clusters / 1e9 as GB
  from flowcell_lane_results flr
    left join flowcell_runfolder fr on fr.flowcell_id = flr.flowcell_id
 where fr.run_date > '2000-01-01'

select year(run_date) as year, count(distinct project_id) as number_projects
from sample_results sr
      inner join flowcell_runfolder fr on fr.flowcell_id = sr.flowcell_id
group by year(run_date) having year(run_date) > 2000

select project_id, run_date, sample_name, s.flowcell_id, lane_num, sum(cycles * pf_clusters) / 1e9 as "gb"
from flowcell_runfolder fr
  inner join sample_results s on s.flowcell_id = fr.flowcell_id
where run_date > '2000-01-01'
group by project_id, run_date, sample_name, s.flowcell_id, lane_num