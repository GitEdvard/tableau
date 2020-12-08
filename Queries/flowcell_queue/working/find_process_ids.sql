select p.luid,p2.displayname,
       p2.typeid,
       displayname,
       typename,
       isenabled,
       contextcode,
       isvisible,
       style,
       showinexplorer,
       showinbuttonbar,
       openpostprocess,
       iconconstant,
       outputcontextcode,
       useprotocol,
       p2.ownerid,
       p2.datastoreid,
       p2.isglobal,
       p2.createddate,
       p2.lastmodifieddate,
       p2.lastmodifiedby,
       behaviourname,
       metadata,
       canedit,
       modulename,
       expertname
from process p
inner join processtype p2 on p.typeid = p2.typeid
where p.luid ilike '122%' 

select distinct typename 
from processtype
where displayname ilike 'snp&seq%'
 