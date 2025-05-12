(deftemplate roles
    (slot graphic-designer)
    (slot job-giver)
    (slot rent-type)
    (slot day (type SYMBOL) (allowed-symbols Hetfo Kedd Szerda Csutortok Pentek))
)

(deffacts starting-state
    (graphic-designer Gabreilla)
    (graphic-designer Gabor)
    (graphic-designer Gaspar)
    (graphic-designer Gerda)
    (graphic-designer Gizella)

    (job-giver Gedeon)
    (job-giver Gergely)
    (job-giver Geza)
    (job-giver Greta)
    (job-giver Gusztav)

    (rent-type Furgon)
    (rent-type Kamion)
    (rent-type Mikrobusz)
    (rent-type Szemelyauto)
    (rent-type Teherauto)

    (day Hetfo)
    (day Kedd)
    (day Szerda)
    (day Csutortok)
    (day Pentek)

    (next-day Hetfo Kedd)
    (next-day Kedd Szerda)
    (next-day Szerda Csutortok)
    (next-day Csutortok Pentek)
)

(deffunction day-difference (?day1 ?day2)
    (bind ?day-list (create$ Hetfo Kedd Szerda Csutortok Pentek))
    (bind ?index1 (member$ ?day1 ?day-list))
    (bind ?index2 (member$ ?day2 ?day-list))
    (if (and ?index1 ?index2)
        (return (abs (- ?index1 ?index2)))
        (return -1)
    )
)

(defrule first-rule
    (roles (graphic-designer Gabor) (job-giver ?jGivGabor) (rent-type Teherauto) (day ?dayGabor))
    (roles (graphic-designer ?gDesSzemelyauto) (job-giver ?jGivSzemelyauto) (rent-type Szemelyauto) (day ?daySzemelyauto))
    (roles (graphic-designer ?gDes3) (job-giver ?jGiv3) (rent-type ?rType3) (day ?dayGaborAfter))
    (next-day ?daySzemelyauto ?dayGabor)
    (next-day ?dayGabor ?dayGaborAfter)
    (test (neq ?jGivGabor Gedeon))
    (test (neq ?jGiv3 Gedeon))
    =>
)

(defrule violateFirstRule
    ?a <- (roles (graphic-designer Gabor) (job-giver Gedeon) (rent-type ?rType) (day ?d))
    =>
    (retract ?a)
)

(defrule second-rule
    (roles (graphic-designer ?gDesFurgon) (job-giver ?jGivFurgon) (rent-type Furgon) (day ?dayFurgon))
    (roles (graphic-designer ?gDes2) (job-giver ?jGiv2) (rent-type ?rType2) (day ?day2))
    (test (neq ?gDesFurgon ?gDes2))
    (test (neq ?gDes2 Geza))
    (test (or (= (day-difference ?dayFurgon ?day2) 3)(= (day-difference ?day2 ?dayFurgon) 3)))
    =>
)

(defrule third-rule
    (roles (graphic-designer ?gDesGreta) (job-giver Greta) (rent-type ?rTypeGreta) (day ?dayGreta))
    (roles (graphic-designer ?gDesFurgon) (job-giver ?jGivFurgon) (rent-type Furgon) (day ?dayFurgon))
    (next-day ?dayGreta ?dayFurgon)
    =>
)

(deffacts genderKnowledge
    (gender Gizella Female)
    (gender Gerda Female)
    (gender Gabor Male)
    (gender Gaspar Male)
    (gender Gusztav Male)
)

(defrule fourth-rule
    (roles (graphic-designer Gizella) (job-giver ?jGivGizzela) (rent-type ?rType1) (day ?dayGizella))
    (roles (graphic-designer ?gDes2) (job-giver ?jGiv2) (rent-type ?rType2) (day ?day2))
    (roles (graphic-designer ?gDesKamion) (job-giver ?jGiv3) (rent-type Kamion) (day ?dayKamion))
    (gender ?gDes2 ?gender2)
    (gender ?gDesKamion ?gender3)
    (test (eq ?gender2 ?gender3))
    (test (or (= (day-difference ?dayGizella ?day2) 3)(= (day-difference ?day2 ?dayGizella) 3)))
    =>
)

(defrule fifth-rule
    (roles (graphic-designer Gizella) (job-giver ?jGivGizzela) (rent-type ?rTypeGizella) (day ?dayGizella))
    (roles (graphic-designer ?gDesFurgon) (job-giver ?jGiveFurgon) (rent-type Furgon) (day ?dayFurgon))
    (roles (graphic-designer ?gDesCsutortok) (job-giver ?jGivCsutortok) (rent-type ?rTypeCsutortok) (day Csutortok))
    (test (neq Gizella ?gDesFurgon))
    (test (neq Gizella ?gDesCsutortok))
    (test (neq ?gDesFurgon ?gDesCsutortok))
    =>
)

(defrule sixth-rule
    (roles (graphic-designer ?gDesSzemelyauto)(job-giver ?jGivSzemelyauto)(rent-type Szemelyauto)(day ?daySzemelyauto))
    (roles (graphic-designer ?gDesTeherauto)(job-giver ?jGivTeherauto)(rent-type Teherauto)(day ?dayTeherauto))
    (roles (graphic-designer Gaspar)(job-giver ?jGivGaspar)(rent-type ?rTypeGaspar)(day ?dayGaspar))
    (roles (graphic-designer ?gDesGreta)(job-giver Greta)(rent-type ?rTypeGreta)(day ?dayGreta))

    (next-day ?dayGreta ?dayAfterGreta)
    (next-day ?dayAfterGreta ?dayGaspar)

    (test (neq ?gDesSzemelyauto ?gDesTeherauto))
    (test (neq ?gDesSzemelyauto Gaspar))
    (test (neq ?gDesTeherauto Gaspar))

    (bind ?day-list (create$ Hetfo Kedd Szerda Csutortok Pentek))
    (bind ?idxSzemelyauto (member$ ?daySzemelyauto ?day-list))
    (bind ?idxTeherauto (member$ ?dayTeherauto ?day-list))
    (bind ?idxGaspar (member$ ?dayGaspar ?day-list))
    (test (and (neq ?idxSzemelyauto -1) (neq ?idxTeherauto -1) (neq ?idxGaspar -1)))
    (bind ?indices (create$ ?idxSzemelyauto ?idxTeherauto ?idxGaspar))
    (bind ?sorted-indices (sort ?indices <))
    (test (and (= (nth$ 2 ?sorted-indices) (+ (nth$ 1 ?sorted-indices) 1)) (= (nth$ 3 ?sorted-indices) (+ (nth$ 2 ?sorted-indices) 1))))
    =>
)

(defrule seventh-rule
    (roles (graphic-designer Gerda) (job-giver Gergely) (rent-type ?rTypeGG) (day ?dayGG))
    (test (or (eq ?rTypeGG Furgon) (eq ?rTypeGG Kamion)))
    =>
)

(defrule violateSeventhRule
    ?a <- (roles (graphic-designer Gerda) (job-giver Gergely) (rent-type ?rTypeGG) (day ?dayGG))
    (test (not (or (eq ?rTypeGG Furgon) (eq ?rTypeGG Kamion))))
    =>
    (retract ?a)
)

(defrule removeEntriesWithSameProperties
    (roles (graphic-designer ?gDes1) (job-giver ?jGiv1) (rent-type ?rType1) (day ?day1))
    ?a <- (roles (graphic-designer ?gDes2) (job-giver ?jGiv2) (rent-type ?rType2) (day ?day2))
    (test (or (neq ?jGiv1 ?jGiv2) (neq ?rType1 ?rType2) (neq ?day1 ?day2)))
    (test (neq ?a (fact-address 1)))
    =>
    (retract ?a)
)

(deffacts solutionFromPaper
    (roles (graphic-designer Gizella) (job-giver Gedeon) (rent-type Mikrobusz) (day Hetfo))
    (roles (graphic-designer Gerda) (job-giver Gergely) (rent-type Furgon) (day Kedd))
    (roles (graphic-designer Gabreilla) (job-giver Greta) (rent-type Szemelyauto) (day Szerda))
    (roles (graphic-designer Gabor) (job-giver Geza) (rent-type Teherauto) (day Csutortok))
    (roles (graphic-designer Gaspar) (job-giver Gusztav) (rent-type Kamion) (day Pentek))
)

(defrule displayData
    (declare (salience -10))
    (roles (graphic-designer ?gDes1) (job-giver ?jGiv1) (rent-type ?rType1) (day ?day1))
    =>
    (printout t "Grafikus: " ?gDes1 ", Megbizo: " ?jGiv1 ", Kolcsonzo: " ?rType1 ", Nap: " ?day1 crlf)
)

(reset)
(run)