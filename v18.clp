(deffacts init
    (megbizas 1)
    (megbizas 2)
    (megbizas 3)
    (megbizas 4)
    (megbizas 5)
)

(defrule solve
    ;Szabaly1
    ;Gábor (nem ő kapta Gedeontól a feladatot) a teherautó-kölcsönzéssel
    ;foglalkozó cég megbízását egy nappal a személyautó-kölcsönző
    ;megrendelése után, és egy nappla egy másik megrendelés előtt kapta,
    ;ami szintén nem Gedeoné volt.
    (megbizas ?GEDEON)
    (megbizas ?GEZA&~?GEDEON)
    (megbizas ?GERGELY&~?GEZA&~?GEDEON)
    (megbizas ?GRETA&~?GERGELY&~?GEZA&~?GEDEON)
    (megbizas ?GUSZTAV&~?GRETA&~?GERGELY&~?GEZA&~?GEDEON)
    (megbizas ?GABOR)
    (megbizas ?TEHERAUTO&?GABOR&~?GEDEON)
    (megbizas ?SZEMELYAUTO&~?TEHERAUTO)
    (test 
        (or
            (and 
                (= (- ?GABOR ?SZEMELYAUTO ) 1)
                (= (- ?GEZA ?GABOR ) 1)    
            )
            (and 
                (= (- ?GABOR ?SZEMELYAUTO ) 1)
                (= (- ?GERGELY ?GABOR ) 1)    
            )
            (and 
                (= (- ?GABOR ?SZEMELYAUTO ) 1)
                (= (- ?GRETA ?GABOR ) 1)    
            )
            (and 
                (= (- ?GABOR ?SZEMELYAUTO ) 1)
                (= (- ?GUSZTAV ?GABOR ) 1)    
            )
        )
    )

    ;Szabaly2
    ;Az a grafikus, akit a furgon-kölcsönző bízott meg,
    ;vagy három nappal előbb, vagy három nappal később kapta a feladatot
    ;mint egyik kollegája aki nem Gézától kapta a megbízást
    (megbizas ?FURGON&~?SZEMELYAUTO&~?TEHERAUTO)
    (test
        (or           
            (= 3 (abs (- ?FURGON ?GEDEON)))           
            (= 3 (abs (- ?FURGON ?GERGELY)))            
            (= 3 (abs (- ?FURGON ?GRETA)))
            (= 3 (abs (- ?FURGON ?GUSZTAV)))        
        )
    )

    ;Szabaly3
    ;Gizella és a Gréta által megbízott művész: 
    ;aki egy nappal a furgonosok előtt kapta a munkát
    ;és a kamionos-logót vagy a személyautó-kölcsönző megbízását
    ;teljesítő tervező, valamilyen sorrendben
    (megbizas ?GRETA&~?GEZA&~?GEDEON)
    (megbizas ?GIZELLA&~?GABOR)
    (megbizas ?KAMION&~?FURGON&~?SZEMELYAUTO&~?TEHERAUTO)
    (megbizas ?MIKROBUSZ&~?KAMION&~?FURGON&~?SZEMELYAUTO&~?TEHERAUTO)
    (test (= (- ?GIZELLA ?FURGON ) -1))
    (test (or 
        (= ?GRETA ?KAMION)
        (= ?GRETA ?SZEMELYAUTO)
    ))

    ;Szabaly4
    ;Gizella vagy három nappal korábban, vagy három nappal később
    ;kapta a megbízást, mint az a grafikus, aki ugyanolyan nemű, mint
    ;aki a kamionos megbízást kapta
    (megbizas ?GABRIELLA&~?GABOR&~?GIZELLA)
    (megbizas ?GERDA&~?GABRIELLA&~?GABOR&~?GIZELLA)
    (megbizas ?GASPAR&~?GERDA&~?GABRIELLA&~?GABOR&~?GIZELLA)
    (test
        (or
            (and 
                (or 
                    (= ?GABRIELLA ?KAMION) 
                    (= ?GERDA ?KAMION) 
                )
                (or 
                    (= (abs (- ?GIZELLA ?GABRIELLA)) 3)
                    (= (abs (- ?GIZELLA ?GERDA)) 3)
                )
            )
            (and 
                (or 
                    (= ?GABOR ?KAMION) 
                    (= ?GASPAR ?KAMION)
                )
                (or 
                    (= (abs (- ?GIZELLA ?GABOR)) 3)
                    (= (abs (- ?GIZELLA ?GASPAR)) 3)
                )
            )
        )
    )

    ;Szabaly5
    ;Az öt grafikus közül három:
    ;Gizella; akit a furgon-kölcsönző bízott meg;
    ;és aki csütörtökön kapta a megbízást
    (megbizas ?CSUTORTOK&~?GIZELLA&4)
    (megbizas ?FURGON&~?CSUTORTOK)

    ;Szabaly6
    ;Az öt grafikus közül három, akik egymás utáni napon kapták a megbízást:
    ;a személyautó-kölcsönző által megbízott
    ;a teherutó-kölcsönző megbízását kapó
    ;és Gáspár, aki két nappal azután kapta a feladatot, hogy Gréta
    ;megbízott valaki
    (test
        (and 
            (= (- ?GASPAR ?GRETA) 2)
            (or
                (and
                    (= (- ?SZEMELYAUTO ?TEHERAUTO) -1)
                    (= (- ?TEHERAUTO ?GASPAR) -1)
                )
                (and
                    (= (- ?SZEMELYAUTO ?GASPAR) -1)
                    (= (- ?GASPAR ?TEHERAUTO) -1)
                )
                (and
                    (= (- ?TEHERAUTO ?SZEMELYAUTO) -1)
                    (= (- ?SZEMELYAUTO ?GASPAR) -1)
                )
                (and
                    (= (- ?TEHERAUTO ?GASPAR) -1)
                    (= (- ?GASPAR ?SZEMELYAUTO) -1)
                )
                (and
                    (= (- ?GASPAR ?SZEMELYAUTO) -1)
                    (= (- ?SZEMELYAUTO ?TEHERAUTO) -1)
                )
                (and
                    (= (- ?GASPAR ?TEHERAUTO) -1)
                    (= (- ?TEHERAUTO ?SZEMELYAUTO) -1)
                )
            )
        )
    )

    ;Szabaly7
    ;Gerda a Gergely által képviselt furgon-, vagy a 
    ;kamion-kölcsönző megbízását kapta
    (megbizas ?GERGELY&~?GEDEON&~?GEZA&~?GRETA)
    (megbizas ?GUSZTAV&~?GERGELY&~?GEDEON&~?GEZA&~?GRETA)
    (and
        (megbizas ?GERGELY&?GERDA)
        (or
            (megbizas ?GERGELY&?FURGON)
            (megbizas ?GERGELY&?KAMION)
        )
    )

    (megbizas ?HETFO)
    (test (= ?HETFO 1))
    (megbizas ?KEDD&~?HETFO)
    (test (= ?KEDD 2))
    (megbizas ?SZERDA&~?KEDD&~?HETFO)
    (test (= ?SZERDA 3))
    (megbizas ?CSUTORTOK&~?SZERDA&~?KEDD&~?HETFO)
    (test (= ?CSUTORTOK 4))
    (megbizas ?PENTEK&~?CSUTORTOK&~?SZERDA&~?KEDD&~?HETFO)
    (test (= ?PENTEK 5))
    
    =>

    (printout t "Megoldás:" crlf)
    (loop-for-count (?i 1 5)
        (printout t ?i ": ")
        ; Először a grafikusok
        (if (= ?GABOR ?i) then (printout t "Gábor-"))
        (if (= ?GASPAR ?i) then (printout t "Gáspár-"))
        (if (= ?GERDA ?i) then (printout t "Gerda-"))
        (if (= ?GIZELLA ?i) then (printout t "Gizella-"))
        (if (= ?GABRIELLA ?i) then (printout t "Gabriella-"))
        ; Aztán a megbízók
        (if (= ?GEDEON ?i) then (printout t "Gedeon-"))
        (if (= ?GERGELY ?i) then (printout t "Gergely-"))
        (if (= ?GEZA ?i) then (printout t "Géza-"))
        (if (= ?GRETA ?i) then (printout t "Gréta-"))
        (if (= ?GUSZTAV ?i) then (printout t "Gusztáv-"))
        ; Majd a járművek
        (if (= ?FURGON ?i) then (printout t "Furgon-"))
        (if (= ?KAMION ?i) then (printout t "Kamion-"))
        (if (= ?MIKROBUSZ ?i) then (printout t "Mikrobusz-"))
        (if (= ?SZEMELYAUTO ?i) then (printout t "Személyautó-"))
        (if (= ?TEHERAUTO ?i) then (printout t "Teherautó-"))
        ; Végül a napok
        (if (= ?HETFO ?i) then (printout t "Hétfő"))
        (if (= ?KEDD ?i) then (printout t "Kedd"))
        (if (= ?SZERDA ?i) then (printout t "Szerda"))
        (if (= ?CSUTORTOK ?i) then (printout t "Csütörtök"))
        (if (= ?PENTEK ?i) then (printout t "Péntek"))
        (printout t crlf)
    )
)
