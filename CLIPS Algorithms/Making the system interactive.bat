(batch "Backward chaining algorithm.bat")
(run)

;;retract (answer (known-factor age-difference) (value 31))) as it will now be inferred
(retract 2)

;;Define the question template
(deftemplate question
    (slot factor (default none))      
    (slot question-to-ask (default none))
    (slot has-pre-condition (type SYMBOL) (default no))) 
    
;Inferring the “age-difference” answer
(assert  
    (question 
		(factor your-age) 
		(question-to-ask "What is your age?")))
(assert  
    (question 
        (factor your-partner-age) 
        (question-to-ask "What is the age of the person you wish to marry?")))
   
(defrule calculate-age-difference
    (answer (known-factor your-age) ( value ?your-age))
    (answer (known-factor your-partner-age) ( value ?your-part-age))
    =>
    (assert (answer (known-factor age-difference) (value (abs (- ?your-age ?your-part-age)) )))
)
(defrule ask-question
   ?q <- (question (factor ?factor)
				   (question-to-ask ?question)                   
        	       (has-pre-condition no))
		 (not (answer (known-factor ?factor)))
   =>
    (printout t ?question crlf)
    (assert (answer (known-factor ?factor) (value (read))))     
)
;Question with pre conditions
(assert  
  	(question 
(factor your-annual-income) 
(question-to-ask "What is your annual income in USD?") 
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
	(question-to-ask "What is your work status?")))

(clear-window)
