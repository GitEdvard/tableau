select typeid
from processtype

select *
from processparameter


select pt.displayname, pp.parametername, pp.parameterstring, length(pp.parameterstring)
from processtype pt
inner join processparameter pp on pt.typeid = pp.processtypeid
where pt.isvisible = true and pt.isenabled = true
order by length(pp.parameterstring) desc