create table governing_parties (
	period integer NOT NULL,
	club_shortname character varying(255) NOT NULL,
	 CONSTRAINT fk_lgperiod_gp FOREIGN KEY (period)
      REFERENCES legislative_period (period) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
      CONSTRAINT fk_club_gp FOREIGN KEY (club_shortname)
      REFERENCES parliament_club (short_name) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);
INSERT INTO governing_parties (period, club_shortname) VALUES (20, 'ÖVP');
INSERT INTO governing_parties (period, club_shortname) VALUES (20, 'SPÖ');
INSERT INTO governing_parties (period, club_shortname) VALUES (21, 'F');
INSERT INTO governing_parties (period, club_shortname) VALUES (21, 'ÖVP');
INSERT INTO governing_parties (period, club_shortname) VALUES (22, 'ÖVP');
INSERT INTO governing_parties (period, club_shortname) VALUES (22, 'F-BZÖ');
INSERT INTO governing_parties (period, club_shortname) VALUES (22, 'F');
INSERT INTO governing_parties (period, club_shortname) VALUES (23, 'SPÖ');
INSERT INTO governing_parties (period, club_shortname) VALUES (23, 'ÖVP');
INSERT INTO governing_parties (period, club_shortname) VALUES (24, 'SPÖ');
INSERT INTO governing_parties (period, club_shortname) VALUES (24, 'ÖVP');
INSERT INTO governing_parties (period, club_shortname) VALUES (25, 'SPÖ');
INSERT INTO governing_parties (period, club_shortname) VALUES (25, 'ÖVP');

select * from governing_parties;

create view gov_opp_relation as select period, ((select SUM(weight) from politician_attitude_relation
inner join discussion d on (d.id = discussion_id)
inner join session s on (s.id = session_id)
inner join politician p1 on (p1.id = politician1_id)
inner join mandate m1 on (m1.politician_id = p1.id and start_date > m1.valid_from and (m1.valid_until is null or start_date < m1.valid_until))
inner join politician p2 on (p2.id = politician2_id)
inner join mandate m2 on (m2.politician_id = p2.id and start_date > m2.valid_from and (m2.valid_until is null or start_date < m2.valid_until))
where m2.club_shortname is not null and m1.club_shortname is not null
and m1.club_shortname in (select club_shortname from governing_parties gp where gp.period = lp.period)
and m2.club_shortname not in (select club_shortname from governing_parties gp where gp.period = lp.period)
and period = lp.period) + (select SUM(weight) from politician_attitude_relation
inner join discussion d on (d.id = discussion_id)
inner join session s on (s.id = session_id)
inner join politician p1 on (p1.id = politician1_id)
inner join mandate m1 on (m1.politician_id = p1.id and start_date > m1.valid_from and (m1.valid_until is null or start_date < m1.valid_until))
inner join politician p2 on (p2.id = politician2_id)
inner join mandate m2 on (m2.politician_id = p2.id and start_date > m2.valid_from and (m2.valid_until is null or start_date < m2.valid_until))
where m2.club_shortname is not null and m1.club_shortname is not null
and m1.club_shortname not in (select club_shortname from governing_parties gp where gp.period = lp.period)
and m2.club_shortname in (select club_shortname from governing_parties gp where gp.period = lp.period)
and period = lp.period)) /

cast(((select count(*) from politician_attitude_relation
inner join discussion d on (d.id = discussion_id)
inner join session s on (s.id = session_id)
inner join politician p1 on (p1.id = politician1_id)
inner join mandate m1 on (m1.politician_id = p1.id and start_date > m1.valid_from and (m1.valid_until is null or start_date < m1.valid_until))
inner join politician p2 on (p2.id = politician2_id)
inner join mandate m2 on (m2.politician_id = p2.id and start_date > m2.valid_from and (m2.valid_until is null or start_date < m2.valid_until))
where m2.club_shortname is not null and m1.club_shortname is not null
and m1.club_shortname in (select club_shortname from governing_parties gp where gp.period = lp.period)
and m2.club_shortname not in (select club_shortname from governing_parties gp where gp.period = lp.period)
and period = lp.period) + (select count(*) from politician_attitude_relation
inner join discussion d on (d.id = discussion_id)
inner join session s on (s.id = session_id)
inner join politician p1 on (p1.id = politician1_id)
inner join mandate m1 on (m1.politician_id = p1.id and start_date > m1.valid_from and (m1.valid_until is null or start_date < m1.valid_until))
inner join politician p2 on (p2.id = politician2_id)
inner join mandate m2 on (m2.politician_id = p2.id and start_date > m2.valid_from and (m2.valid_until is null or start_date < m2.valid_until))
where m2.club_shortname is not null and m1.club_shortname is not null
and m1.club_shortname not in (select club_shortname from governing_parties gp where gp.period = lp.period)
and m2.club_shortname in (select club_shortname from governing_parties gp where gp.period = lp.period)
and period = lp.period)) as double precision)

from legislative_period lp
where period >= 20
order by period asc;

select * from gov_opp_relation where period = 25;

select period, SUM(weight), cast(count(*) as double precision) from politician_attitude_relation
inner join discussion d on (d.id = discussion_id)
inner join session s on (s.id = session_id)
inner join politician p1 on (p1.id = politician1_id)
inner join mandate m1 on (m1.politician_id = p1.id and start_date > m1.valid_from and (m1.valid_until is null or start_date < m1.valid_until))
inner join politician p2 on (p2.id = politician2_id)
inner join mandate m2 on (m2.politician_id = p2.id and start_date > m2.valid_from and (m2.valid_until is null or start_date < m2.valid_until))
where m2.club_shortname is not null and m1.club_shortname is not null
and m1.club_shortname in (select club_shortname from governing_parties gp where gp.period = s.period)
and m2.club_shortname not in (select club_shortname from governing_parties gp where gp.period = s.period)
group by period;

select SUM(weight), cast(count(*) as double precision) from politician_attitude_relation
inner join discussion d on (d.id = discussion_id)
inner join session s on (s.id = session_id)
inner join politician p1 on (p1.id = politician1_id)
inner join mandate m1 on (m1.politician_id = p1.id and start_date > m1.valid_from and (m1.valid_until is null or start_date < m1.valid_until))
inner join politician p2 on (p2.id = politician2_id)
inner join mandate m2 on (m2.politician_id = p2.id and start_date > m2.valid_from and (m2.valid_until is null or start_date < m2.valid_until))
where m2.club_shortname is not null and m1.club_shortname is not null
and not(m1.club_shortname = 'ÖVP' or m1.club_shortname = 'SPÖ')
and (m2.club_shortname = 'ÖVP' or m2.club_shortname = 'SPÖ')
and period = 23;

