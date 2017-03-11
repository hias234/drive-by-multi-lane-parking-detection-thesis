select p1.sur_name, p2.sur_name, m1.club_shortname, m2.club_shortname, SUM(weight) / cast(count(*) as double precision) from politician_attitude_relation
inner join politician p1 on (p1.id = politician1_id)
inner join mandate m1 on (m1.politician_id = p1.id)
inner join politician p2 on (p2.id = politician2_id)
inner join mandate m2 on (m2.politician_id = p2.id)
where m1.club_shortname = 'ÖVP' and m2.club_shortname = 'FPÖ'
group by p1.sur_name, p2.sur_name, m1.club_shortname, m2.club_shortname
having sum(weight) > 0 and count(*) > 3

select count(*) from discussion_speech
inner join discussion on (discussion.id = discussion_id)
inner join session on (session.id = session_id)
inner join politician on (politician.id = discussion_speech.politician_id)
inner join mandate on (mandate.politician_id = politician.id and session.start_date >= mandate.valid_from and (mandate.valid_until is null or end_date <= mandate.valid_until))
inner join parliament_club on (short_name = club_shortname)
where period = 25 and discussion_speech.type = 'PRO' and not(short_name = 'ÖVP' or short_name = 'SPÖ')