select p1.sur_name, m1.club_shortname, m2.club_shortname, SUM(weight) / cast(count(*) as double precision) from politician_attitude_relation
inner join discussion d on (d.id = discussion_id)
inner join session s on (s.id = session_id)
inner join politician p1 on (p1.id = politician1_id)
inner join mandate m1 on (m1.politician_id = p1.id and start_date > m1.valid_from and (m1.valid_until is null or start_date < m1.valid_until))
inner join politician p2 on (p2.id = politician2_id)
inner join mandate m2 on (m2.politician_id = p2.id and start_date > m2.valid_from and (m2.valid_until is null or start_date < m2.valid_until))
where m2.club_shortname is not null and m1.club_shortname is not null
and period = 25
group by p1.sur_name, m1.club_shortname, m2.club_shortname
order by p1.sur_name;



select p1.sur_name, m1.club_shortname, m2.club_shortname, SUM(weight) / cast(count(*) as double precision) from politician_attitude_relation
inner join discussion d on (d.id = discussion_id)
inner join session s on (s.id = session_id)
inner join politician p1 on (p1.id = politician1_id)
inner join mandate m1 on (m1.politician_id = p1.id and start_date > m1.valid_from and (m1.valid_until is null or start_date < m1.valid_until))
inner join politician p2 on (p2.id = politician2_id)
inner join mandate m2 on (m2.politician_id = p2.id and start_date > m2.valid_from and (m2.valid_until is null or start_date < m2.valid_until))
where m2.club_shortname is not null and m1.club_shortname is not null
and m1.club_shortname = m2.club_shortname
and period = 24
group by p1.sur_name, m1.club_shortname, m2.club_shortname
having SUM(weight) / cast(count(*) as double precision) < 1;