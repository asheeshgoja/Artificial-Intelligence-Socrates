(batch "Backward chaining algorithm.bat")
(run)

;;retract (answer (known-factor age-difference) (value 31))) as it will now be inferred
(retract 2)

;;Define the question template with validation constaints slots
(deftemplate question
    (slot factor (default none))      
    (slot question-to-ask (default none))
    (slot has-pre-condition (type SYMBOL) (default no)) 
    (multislot choices (default yes no))
    (multislot range (type INTEGER))) 

    
;Inferring the “age-difference” answer
(assert  
    (question 
		(factor your-age) 
		(question-to-ask "What is your age?") 
		(range 18 120)))
(assert  
    (question 
        (factor your-partner-age) 
        (question-to-ask "What is the age of the person you wish to marry?") 
  (range 18 120) ))
   
(defrule calculate-age-difference
    (answer (known-factor your-age) ( value ?your-age))
    (answer (known-factor your-partner-age) ( value ?your-part-age))
    =>
    (assert (answer (known-factor age-difference) (value (abs (- ?your-age ?your-part-age)) )))
)

;; ask-question with validation

;check-range
(deffunction  check-range ( ?min  ?max ?answer   )
    (if (not (numberp ?answer)) then (return 0)  )  
    (if ( and (>= ?answer ?min) (<= ?answer ?max)  )  
     then (return 1) 
     else (return 0)))

;ask	 
(deffunction ask 
   (?question ?choices ?range)
   (if   (eq (length$ ?range) 0) 
    then (printout t ?question ?choices ":") 
    else (printout t ?question "range-" $?range ":")
    )
   (bind ?answer (read) )
   (if (eq (length$ ?range) 0)
    then  (while (not (member$ ?answer ?choices)) do
          (printout t "Invalid option! Please specify one of these options" ?choices ":" ) 
		  (bind ?answer (read))
		  (if (lexemep ?answer) then (bind ?answer (lowcase ?answer))))
    else  (while (eq (check-range (nth$ 1 ?range ) (nth$ 2 ?range ) ?answer) 0 )   do
		      (printout t "Invalid input! Please specify a value within the range" $?range ":")
		      (bind ?answer (read))
		      (if (lexemep ?answer) then (bind ?answer (lowcase ?answer))))
    )
   (printout t crlf)        
   ?answer
 ) 

; ask-question
(defrule ask-question
   ?q <- (question (question-to-ask ?question)
                   (factor ?factor)
                   (range $?range)
                   (choices $?choices)
        	    (has-pre-condition no))
    (not (answer (known-factor ?factor)))
   =>
    (assert (answer (known-factor ?factor)
                    (value (ask ?question ?choices ?range)))))
					
;Question with pre conditions
(assert  
  	(question 
(factor your-annual-income) 
(question-to-ask "What is your annual income in USD?") 
(range 20000 1000000)
(has-pre-condition yes)))

(deftemplate question-rule
    	(multislot if (default none))
    	(slot then-ask-question (default none)))

(assert  
 	(question-rule (if your-work-status is employed) (then-ask-question your-annual-income)))
		
;Implementing the question dependency rules
		
(defrule remove-ask-if-in-question-rules
   ?r <- (question-rule  (if  ?first-ask-if is ?val $?rest-of-ifs-true))
    (answer (value ?val) (known-factor ?f&:(eq ?f ?first-ask-if)))
   =>
   (if (eq (nth$ 1 ?rest-of-ifs-true) and) 
    then (modify ?r (if (rest$ ?rest-of-ifs-true)))
    else (modify ?r (if ?rest-of-ifs-true)))
)

(defrule set-pre-condition-when-no-antecedents
   ?r <- (question-rule (if $?a&:(=(length$ ?a) 0))  (then-ask-question ?f))
   ?q <- (question  (factor ?f) (has-pre-condition yes) )
   (not (answer (known-factor ?f)))
   =>
   (modify ?q (has-pre-condition no))
)

(assert  
    (question 
	(factor your-work-status) 
	(question-to-ask "What is your work status?") 
	(choices student employed retired)))

(clear-window)
