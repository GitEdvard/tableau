select a.name, pooling.udfvalue, lanes.udfvalue
from artifact a
inner join artifact_udf_view pooling on pooling.artifactid = a.artifactid
    and pooling.udfname = 'Pooling'
inner join artifact_udf_view lanes on lanes.artifactid = a.artifactid
    and lanes.udfname = 'Number of lanes'
where pooling.udfvalue is not null and lanes.udfvalue is not null

--select distinct substring(lanes.udfvalue from '[0-9]*\s*(\w*\s*/\s*\w*)\s*$'), count(lanes.artifactid) as N
select distinct lanes.udfvalue, count(lanes.artifactid) as N
from artifact_udf_view lanes
where lanes.udfname = 'Number of lanes' and lanes.udfvalue is not null
group by lanes.udfvalue
order by N desc

--select distinct pooling.udfvalue, count(pooling.artifactid) as n
select distinct substring(pooling.udfvalue from '[0-9]*\s*(\w*\s*/\s*\w*)\s*$'), count(pooling.artifactid) as n
from artifact_udf_view pooling
where pooling.udfname = 'Pooling' and pooling.udfvalue is not null
--group by pooling.udfvalue
group by substring(pooling.udfvalue from '[0-9]*\s*(\w*\s*/\s*\w*)\s*$')
order by n desc


select distinct instrument.udfvalue
from artifact_udf_view instrument
where instrument.udfname = 'Sequencing instrument' and instrument.udfvalue is not null


select distinct lanes.udfvalue, instrument.udfvalue, count(lanes.artifactid) as N
from artifact_udf_view lanes inner join artifact_udf_view instrument
    on instrument.artifactid =lanes.artifactid and lanes.udfname = 'Number of lanes' and lanes.udfvalue is not null
where instrument.udfname = 'Sequencing instrument' and instrument.udfvalue is not null
group by lanes.udfvalue, instrument.udfvalue
order by N desc


select distinct conf_fc.udfvalue, count(conf_fc.artifactid) as n
from artifact_udf_view conf_fc
where conf_fc.udfname = 'conc FC' and conf_fc.udfvalue is not null
--group by pooling.udfvalue
group by conf_fc.udfvalue
order by n desc

select distinct substring(conf_fc.udfvalue from '\s*[0-9\.]+\s*(?:pM)?\s*'), count(conf_fc.artifactid) as n
from artifact_udf_view conf_fc
where conf_fc.udfname = 'conc FC' and conf_fc.udfvalue is not null
--group by pooling.udfvalue
group by substring(conf_fc.udfvalue from '\s*[0-9\.]+\s*(?:pM)?\s*')
order by n desc
