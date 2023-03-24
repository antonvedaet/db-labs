#367970
Он не обнаружил других следов разума на берегах лавового потока. Один раз наткнулся, однако, на жуткое подобие человека, плывущего кролем, - но у того не было ни глаз, ни ноздрей, лишь огромный беззубый рот, жадно поглощавший питание из воды, которая его окружала.

1. Person
    1.1 id (int autoincrement)
    1.2 name (varchar (20))
    1.3 gender (varchar (20)) references Gender(id)
    1.4 current_action (int ) references action(id)
2. Limbs
3. Gender
    1.1 id (1)
4. Action
    1.1 id (int)
    1.2 name (varchar (20))
5. SwimmingMethod 
