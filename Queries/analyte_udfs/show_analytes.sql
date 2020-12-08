select a.name, udf.udfname, udf.udfvalue
from analyte an
inner join artifact a on an.artifactid = a.artifactid
inner join artifact_udf_view udf on a.artifactid = udf.artifactid