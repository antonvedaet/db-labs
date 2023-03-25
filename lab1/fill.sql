insert into location (id, name)
values
    (1, 'SPb'),
    (2, 'Moscow'),
    (3, 'Tashkent');

insert into person (id, name, birthday)
values
    (1, 'Bogdan', '1990-05-12'),
    (2, 'Oleg', '2004-08-23'),
    (3, 'Magomed', '1988-01-01');


insert into anomaly (id, name, presence)
values
    (1, 'eye', false),
    (2, 'leg', true),
    (3, 'teeth', false);


insert into action_stats (id, name, attribute)
values
    (1, 'swim', 'butterfly'),
    (2, 'dance', 'normally'),
    (3, 'fly', 'fast');


insert into action (id, action, made_or_not)
values
    (1, 1, true),
    (2, 2, false),
    (3, 3, false);


insert into person_characteristics (id, person, gender, current_action, location, anomalies)
values
    (1, 1, 'M', 1, 1, 1),
    (2, 2, 'M', 2, 2, 2),
    (3, 3, 'M', 3, 3, 3);


insert into anomaly_person_chars (person, anomaly)
values
    (1, 1),
    (1, 2),
    (2, 2),
    (3, 3);
