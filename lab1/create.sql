create table if not exists location
(
    id int primary key, 
    name varchar(30)
);

create table if not exists person
(
    id int primary key,
    name varchar(20),
    birthday:date
)

create table if not exists anomaly
(
    id int primary key,
    name varchar(20),
    presence boolean
);

create table if not exists action_stats
(
    id int primary key,
    name varchar(20),
    attribute varchar(100),
);

create table if not exists action
(
    id int primary key,
    action int references action_stats(id),
    made_or_not boolean
);


create table if not exists person_characteristics
(
    id int primary key,
    person int references person(id),
    gender varchar(1) check (gender = "M" or gender = "F"),
    current_action int references action(id),
    location int references  location(id),
    anomalies int references anomaly(id)
);

create table if not exists anomaly_person_chars
(
    person int references person_characteristics(id) on update cascade,
    anomaly int references anomaly(id) on update cascade
);

