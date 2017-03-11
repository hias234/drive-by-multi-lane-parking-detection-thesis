select politician_id, sum(age(coalesce(valid_until, current_date), valid_from)) from mandate
where mandate_type = 'NationalCouncilMember'
group by politician_id
order by sum(age(coalesce(valid_until, current_date), valid_from)) desc



select avg(age(coalesce(valid_until, current_date), valid_from)) from mandate
where mandate_type = 'NationalCouncilMember'
and (valid_from >= to_date('01.01.1980', 'dd.MM.yyyy') or valid_until is null)



select * from mandate
inner join ncm_period on (mandate.id = ncm_id)
where mandate_type = 'NationalCouncilMember'
and period = 23
and club_shortname = 'ohne Klubzugehörigkeit'

