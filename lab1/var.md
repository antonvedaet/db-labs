367970
### Он не обнаружил других следов разума на берегах лавового потока. Один раз наткнулся, однако, на жуткое подобие человека, плывущего кролем, - но у того не было ни глаз, ни ноздрей, лишь огромный беззубый рот, жадно поглощавший питание из воды, которая его окружала.


1. Person
    \
    1.1 id (int) - primary key
    \
    1.2 name (varchar (20))
    \
    1.3 gender (varchar (20)) references Gender(name)
    \
    1.4 current_action (int) references action(id) 
    \
    1.5 location (int) references Location(id)
    \
    1.6 deformities (int[]) references part_of_body(id)
2. Part_of_body
    \
    2.1 id (int) - primary key
    \
    2.2 name (varchar (20))
    \
    2.3 presence (boolean) 
3. Gender
    \
    3.1 name (varchar (20)) - primary key
4. Action
    \
    4.1 id (int) - primary key
    \
    4.2 name (varchar (20))
    \
    4.3 attribute (varchar (100))
    \
    4.4 made_or_not (boolean)
5. Location
    \
    5.1 id (int) - primary key
    \
    5.2 name (varchar (30)) 