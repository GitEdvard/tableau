select distinct udf.udfname
from project p
inner join entity_udf_view udf on udf.attachtoid = p.projectid and attachtoclassid = 83
where udf.udfname like '%Number%'

select p.name, project_udf.*
    from crosstab(
    'select
	attachtoid,
        udfname,
        udfvalue
     from
	entity_udf_view
     where
	udfname in
	(
	    ''Sequencing instrument'',
	    ''Number of samples''
	)
     order by 1,2',
     $$values
	('Sequencing instrument'::text),
	('Number of samples'::text)$$
     )
     as project_udf
     (
	attachtoid bigint,
	"Sequencing instrument" text,
	"Number of samples" text
     )
inner join project p on p.projectid = project_udf.attachtoid


select distinct  udfs."Sequencing instrument" from (
                select p.name, project_udf.*
                from crosstab(
                         'select
	attachtoid,
        udfname,
        udfvalue
     from
	entity_udf_view
     where
	udfname in
	(
	    ''Sequencing instrument'',
	    ''Number of samples''
	)
     order by 1,2',
                         $$ values
	('Sequencing instrument'::text),
	('Number of samples'::text)$$
                       )
                       as project_udf
                       (
                        attachtoid bigint,
                        "Sequencing instrument" text,
                        "Number of samples" text
                         )
                       inner join project p on p.projectid = project_udf.attachtoid
              ) udfs


select distinct  udfs."Number of samples" from (
                select p.name, project_udf.*
                from crosstab(
                         'select
	attachtoid,
        udfname,
        udfvalue
     from
	entity_udf_view
     where
	udfname in
	(
	    ''Sequencing instrument'',
	    ''Number of samples''
	)
     order by 1,2',
                         $$ values
	('Sequencing instrument'::text),
	('Number of samples'::text)$$
                       )
                       as project_udf
                       (
                        attachtoid bigint,
                        "Sequencing instrument" text,
                        "Number of samples" text
                         )
                       inner join project p on p.projectid = project_udf.attachtoid
              ) udfs