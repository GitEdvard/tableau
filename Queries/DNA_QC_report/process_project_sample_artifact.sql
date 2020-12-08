select
	process.processid,
	process.daterun,
  processtype.typeid as pt_typeid,
	processtype.displayname as pt_displayname,
	project.projectid as projectid,
  project.name as project_name,
  sample.sampleid as sampleid,
  sample.name as sample_name,
  c.name as container_name,
  cp.wellxposition,
  cp.wellyposition,
  artifact.artifactid
  from
  	processiotracker
      inner join artifact on artifact.artifactid = processiotracker.inputartifactid
  	    inner join containerplacement cp on cp.processartifactid = artifact.artifactid
  	      inner join container c on c.containerid = cp.containerid
        inner join artifact_sample_map on artifact_sample_map.artifactid = artifact.artifactid
          inner join sample on sample.processid = artifact_sample_map.processid
            inner join project on project.projectid = sample.projectid
      inner join process on process.processid = processiotracker.processid
        inner join processtype on processtype.typeid = process.typeid
