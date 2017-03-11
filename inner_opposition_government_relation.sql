-- inner opposition relation
select period, SUM(weight) / cast(count(*) as double precision) from politician_attitude_relation
inner join discussion d on (d.id = discussion_id)
inner join session s on (s.id = session_id)
inner join politician p1 on (p1.id = politician1_id)
inner join mandate m1 on (m1.politician_id = p1.id and start_date >= m1.valid_from and (m1.valid_until is null or start_date <= m1.valid_until))
inner join politician p2 on (p2.id = politician2_id)
inner join mandate m2 on (m2.politician_id = p2.id and start_date >= m2.valid_from and (m2.valid_until is null or start_date <= m2.valid_until))
where m1.mandate_type = 'NationalCouncilMember' and m2.mandate_type = 'NationalCouncilMember'
and m2.club_shortname not in (select club_shortname from governing_parties gp where gp.period = s.period)
and m1.club_shortname not in (select club_shortname from governing_parties gp where gp.period = s.period)
group by period
order by period asc;


-- inner government relation
select period, SUM(weight) / cast(count(*) as double precision) from politician_attitude_relation
inner join discussion d on (d.id = discussion_id)
inner join session s on (s.id = session_id)
inner join politician p1 on (p1.id = politician1_id)
inner join mandate m1 on (m1.politician_id = p1.id and start_date >= m1.valid_from and (m1.valid_until is null or start_date <= m1.valid_until))
inner join politician p2 on (p2.id = politician2_id)
inner join mandate m2 on (m2.politician_id = p2.id and start_date >= m2.valid_from and (m2.valid_until is null or start_date <= m2.valid_until))
where m1.mandate_type = 'NationalCouncilMember' and m2.mandate_type = 'NationalCouncilMember'
and m2.club_shortname in (select club_shortname from governing_parties gp where gp.period = s.period)
and m1.club_shortname in (select club_shortname from governing_parties gp where gp.period = s.period)
group by period
order by period asc;