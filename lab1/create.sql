create table if not exists location
(
    id int primary key, 
    name varchar(30)
);

create table if not exists gender
(
  name varchar(20) primary key not null
);

create table if not exists part_of_body
(
    id int primary key,
    name varchar(20),
    presence boolean
);

create table if not exists action
(
    id int primary key,
    name varchar(20),
    attribute varchar(100),
    made_or_not boolean
);


create table if not exists person
(
    id int primary key,
    name varchar(20),
    gender varchar(20) references gender(name),
    current_action int references action(id),
    location int references  location(id),
    deformities int references part_of_body(id)
);

create table if not exists person_part
(
    person int references person(id) on update cascade,
    part_of_body int references part_of_body(id) on update cascade
);

