drop table inner_club_pro_contra;
create table inner_club_pro_contra as select period, d.id as discussion_id, c.short_name as club_shortname, coalesce((

select count(*) from discussion_speech
inner join discussion on (discussion.id = discussion_id)
inner join session on (session.id = session_id)
inner join politician on (politician.id = discussion_speech.politician_id)
inner join mandate on (mandate.politician_id = politician.id and session.start_date >= mandate.valid_from and (mandate.valid_until is null or end_date <= mandate.valid_until))
inner join parliament_club on (short_name = club_shortname)
where short_name = c.short_name and discussion_speech.type = 'PRO' and discussion.id = d.id
group by discussion.id

), 0) as pro_count, coalesce((

select count(*) from discussion_speech
inner join discussion on (discussion.id = discussion_id)
inner join session on (session.id = session_id)
inner join politician on (politician.id = discussion_speech.politician_id)
inner join mandate on (mandate.politician_id = politician.id and session.start_date >= mandate.valid_from and (mandate.valid_until is null or end_date <= mandate.valid_until))
inner join parliament_club on (short_name = club_shortname)
where short_name = c.short_name and discussion_speech.type = 'CONTRA' and discussion.id = d.id
group by discussion.id

), 0) as contra_count


  from discussion_speech ds
inner join discussion d on (d.id = ds.discussion_id)
inner join session s on (s.id = d.session_id)
inner join politician p on (p.id = ds.politician_id)
inner join mandate m on (m.politician_id = p.id and s.start_date >= m.valid_from and (m.valid_until is null or s.end_date <= m.valid_until))
inner join parliament_club c on (c.short_name = m.club_shortname)
group by period, d.id, c.short_name;




select * from inner_club_pro_contra where pro_count > 0 and contra_count > 0