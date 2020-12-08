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
	    ''Type of sample'',
	    ''Kit for library preparation'',
	    ''Number of samples''
	)
     order by 1,2',
     $$values 
	('Sequencing instrument'::text),
	('Type of sample'::text),
	('Kit for library preparation'::text),
	('Number of samples'::text)$$
     )
     as project_udf
     (
	attachtoid bigint,
	"Sequencing instrument" text,
	"Type of sample" text,
	"Kit for library preparation" text,
	"Number of samples" text
     )
inner join project p on p.projectid = project_udf.attachtoid
