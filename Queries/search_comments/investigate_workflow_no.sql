-- RJ-1967-96-13

-- Show all process steps for sample
select distinct sample.sampleid, st.createddate, processtype.displayname,
                st.artifactid, st.workflowrunid, c.name as container
 from sample
   inner join artifact_sample_map on artifact_sample_map.processid = sample.processid
   inner join containerplacement cp on cp.processartifactid = artifact_sample_map.artifactid
   inner join container c on c.containerid = cp.containerid
   inner join stagetransition st on st.artifactid = artifact_sample_map.artifactid
   inner join stage stage on st.stageid = stage.stageid
   inner join protocolstep ps on ps.stepid = stage.stepid
     inner join processiotracker on processiotracker.inputartifactid = artifact_sample_map.artifactid
       inner join process on process.processid = processiotracker.processid
       inner join processtype on processtype.typeid = process.typeid and processtype.typeid = ps.processtypeid
left outer join artifact_ancestor_map aam_pre on aam_pre.artifactid = artifact_sample_map.artifactid
left outer join artifact_ancestor_map aam_post on aam_post.ancestorartifactid = artifact_sample_map.artifactid
 where sample.name = 'RJ-1967-96-13'
order by st.createddate

-- Have been run one time:
--RJ-1991-7

-- Have been run two times
-- RJ-1967-96-13


select distinct stage.membershipid
 from sample
   inner join artifact_sample_map on artifact_sample_map.processid = sample.processid
   inner join stagetransition st on st.artifactid = artifact_sample_map.artifactid
   inner join stage stage on st.stageid = stage.stageid
     inner join processiotracker on processiotracker.inputartifactid = artifact_sample_map.artifactid
       inner join process on process.processid = processiotracker.processid
       inner join processtype on processtype.typeid = process.typeid
 where sample.name = 'RJ-1967-96-13'
