-- export R
with asd(project_id, run_date, number_samples) as (
select project_id, run_date, count(sample_name) nbr_of_samples
  from (
      select distinct project_id, run_date, sample_name
        from sample_results sr
          inner join flowcell_runfolder fr on fr.flowcell_id = sr.flowcell_id
      where read_num = 1
      ) t
 group by project_id, run_date
having run_date > '2019-01-01'
)
select sum(asd.number_samples) from asd
go
-- 8353

-- SDashboard
select last_run_date, count(distinct t.project_id + t.sample_name) sample_count
  from (select s.project_id, s.sample_name, max(fr.run_date) last_run_date
          from flowcell_runfolder fr
            inner join sample_results s on s.flowcell_id = fr.flowcell_id
         group by s.project_id, s.sample_name) t
  group by last_run_date
  having last_run_date > '2000-01-01'


-- SDashboard, total sum
with asd(last_run_date, sample_count) as (
select last_run_date, count(distinct t.project_id + t.sample_name) sample_count
  from (select s.project_id, s.sample_name, max(fr.run_date) last_run_date
          from flowcell_runfolder fr
            inner join sample_results s on s.flowcell_id = fr.flowcell_id
         group by s.project_id, s.sample_name) t
  group by last_run_date
  having last_run_date > '2019-01-01'
)
select SUM(sample_count) from asd
-- 8084

select sr.sample_name, count(distinct sr.project_id)
from flowcell_runfolder fr
inner join sample_results sr on fr.flowcell_id = sr.flowcell_id
group by sr.sample_name having count(distinct sr.project_id) > 1

select distinct sr.sample_name, sr.project_id
from flowcell_runfolder fr
inner join sample_results sr on fr.flowcell_id = sr.flowcell_id
where sr.sample_name = '115'

      select distinct project_id, run_date, sample_name
        from sample_results sr
          inner join flowcell_runfolder fr on fr.flowcell_id = sr.flowcell_id
      where read_num = 1


-- Export R, new
select project_id, last_run_date, count(distinct t.project_id + t.sample_name) sample_count
  from (select s.project_id, s.sample_name, max(fr.run_date) last_run_date
          from flowcell_runfolder fr
            inner join sample_results s on s.flowcell_id = fr.flowcell_id
         group by s.project_id, s.sample_name) t
  group by project_id, last_run_date
  having last_run_date > '2000-01-01'


-- samples per project, orig
select project_id, run_date, count(sample_name) nbr_of_samples
  from (
      select distinct project_id, run_date, sample_name
        from sample_results sr
          inner join flowcell_runfolder fr on fr.flowcell_id = sr.flowcell_id
      where read_num = 1
      ) t
 group by project_id, run_date
having run_date > '1900-01-01'

-- bases per project, orig
  select project_id, run_date, sum(cycles * pf_clusters) / 1e9 as "gb"
from sample_results sr
       inner join flowcell_runfolder fr on fr.flowcell_id = sr.flowcell_id
  group by project_id, run_date

-- lanes per project, orig
select project_id, run_date, count(lane_num) lanes
from (
     select distinct project_id, sr.flowcell_id, lane_num, run_date
       from sample_results sr
            inner join flowcell_runfolder fr on fr.flowcell_id = sr.flowcell_id
     ) t
 group by project_id, run_date

-- re-runned samples
   select sum(re_runs) from
   (select project_id, sample_name, run_date, count(sample_name) - 1 as re_runs
from sample_results sr
  inner join flowcell_runfolder fr on fr.flowcell_id = sr.flowcell_id
where project_id = 'RI-1940'
group by project_id, sample_name, run_date having run_date > '2000-01-01') t

-- Project summarization new
select project_id, run_date, sample_name, s.flowcell_id, lane_num, sum(cycles * pf_clusters) / 1e9 as "gb"
from flowcell_runfolder fr
  inner join sample_results s on s.flowcell_id = fr.flowcell_id
where run_date > '2000-01-01'
group by project_id, run_date, sample_name, s.flowcell_id, lane_num


  -- sample_count
select last_run_date, count(distinct t.project_id + t.sample_name) sample_count
  from (select s.project_id, s.sample_name, max(fr.run_date) last_run_date
          from flowcell_runfolder fr
            inner join sample_results s on s.flowcell_id = fr.flowcell_id
         group by s.project_id, s.sample_name) t
  group by last_run_date
  having last_run_date > '2000-01-01'


select s.project_id, s.sample_name, max(fr.run_date) last_run_date
          from flowcell_runfolder fr
            inner join sample_results s on s.flowcell_id = fr.flowcell_id
         group by s.project_id, s.sample_name

select s.project_id, s.sample_name, fr.run_date, fr.runfolder_name, s.flowcell_id, s.lane_num
from flowcell_runfolder fr
  inner join sample_results s on s.flowcell_id = fr.flowcell_id
