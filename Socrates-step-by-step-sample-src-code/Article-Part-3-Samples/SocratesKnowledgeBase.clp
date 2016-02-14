;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Organizing  “a priori” question and question dependency rules
(deftemplate question
    (slot factor (default none))      
    (slot question-to-ask (default none))
    (multislot choices (default yes no))
    (multislot range (type INTEGER)) 
    (slot has-pre-condition (type SYMBOL) (default no)))

(deffacts questions 
    (question (factor your-age) (question-to-ask "What is your age?") (range 18 120) )
    (question (factor your-partner-age) (question-to-ask "What is the age of the person you wish to marry?") (range 18 120) )
    (question (factor your-work-status) (question-to-ask "What is your work status?") (choices student employed retired) )
    (question (factor your-partner-work-status) (question-to-ask "What is the work status of the person you wish marry ?") (choices student employed retired) )
    (question (factor your-annual-income) (question-to-ask "What is your annual income in USD?") (range 20000 1000000) )
    (question (factor your-partner-annual-income) (question-to-ask "What is your annual income in USD of the person you wish marry?") (range 20000 1000000) ))

(deftemplate question-rule
    	(multislot if (default none))
    	(slot then-ask-question (default none)))         

(deffacts question-rules   
    (question-rule (if your-work-status is employed) (then-ask-question your-annual-income))     
    (question-rule (if your-partner-work-status is employed) (then-ask-question your-partner-annual-income)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Organizing “a priori” domain rules

(deftemplate domain-rule
    	(multislot if (default none))
    	(multislot then (default none)))

(deffacts domain-rules    
        
    (domain-rule (if age-difference is-more-than 30 )
				 (then based-on age-factor the-expert-system-favours-getting-married-with-certainty 20.0 %)) 
    
    (domain-rule (if income-difference is-more-than 100000 )
				 (then based-on income-compatibility the-expert-system-favours-getting-married-with-certainty 15.0 %)) 
     
    (domain-rule (if income-difference is-more-than 1000 but-less-than 10000 )
				 (then based-on income-compatibility the-expert-system-favours-getting-married-with-certainty 55.0 % and
            		   based-on marriage-penalty-tax-liability the-expert-system-favours-getting-married-with-certainty 25.0 %)) 
         
    (domain-rule (if your-annual-income is-more-than 100000 and 
            		 your-partner-annual-income is-more-than 100000)
				 (then based-on income-tax the-expert-system-favours-getting-married-with-certainty 60.0 %))    
      
    (domain-rule (if your-annual-income is-less-than 100000 and 
            		 your-partner-annual-income is-less-than 100000)
				 (then based-on income-tax the-expert-system-favours-getting-married-with-certainty 80.0 %)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Creating rules to infer additional facts

(deftemplate answer
    (slot known-factor  (default none))
    (slot value (default none)) 
)

(defrule calculate-age-difference
    (answer (known-factor your-age) ( value ?your-age))
    (answer (known-factor your-partner-age) ( value ?your-part-age))
    =>
    (assert (answer (known-factor age-difference) (value (abs (- ?your-age ?your-part-age)) )))
)

(defrule calculate-income-difference
    (answer (known-factor your-annual-income) ( value ?your-inc))
    (answer (known-factor your-partner-annual-income) ( value ?your-part-inc))
    =>
    (assert (answer (known-factor income-difference) (value (abs (- ?your-inc ?your-part-inc)) )))
)

(deftemplate conclusion
    (slot name  (default none))
    (slot confidence-factor (type FLOAT) (default 0.0))
    (slot evaluated (default no))     
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Creating a rule of mark questions with pre conditions
(defrule mark-questions-with-pre-conditions
	?q  <-(question (factor ?f) (has-pre-condition no))
    (question-rule (then-ask-question ?f) (if $?i&:(> (length$ ?i) 0)) )
    =>
   (modify ?q (has-pre-condition yes))  
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Adding the rules to accept and validate user input

(deffunction  check-range ( ?min  ?max ?answer   )
    (if (not (numberp ?answer)) then (return 0)  )  
    (if ( and (>= ?answer ?min) (<= ?answer ?max)  )  
     then (return 1) 
     else (return 0))
)

(deffunction ask 
   (?question ?choices ?range)
   (if (eq (length$ ?range) 0) then (printout t ?question ?choices ":") else (printout t ?question "range-" $?range ":"))
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Implementing the backward changing algorithm for domain-rule
(defrule remove-ask-if-in-domain-rules-with-more-than	
	(declare (salience -100)) 
    ?r <- (domain-rule  (if  ?first-ask-if is-more-than ?min $?rest-of-ifs-true))  
    (answer (known-factor ?f&:(eq ?f ?first-ask-if)) (value ?a&:(> ?a ?min)) )
   => 
   (if (eq (nth$ 1 ?rest-of-ifs-true) and) 
    then (modify ?r (if (rest$ ?rest-of-ifs-true)))
    else (modify ?r (if ?rest-of-ifs-true))))
			
(defrule remove-ask-if-in-domain-rules-with-more-than-but-less-than
   ?r <- (domain-rule  (if  ?first-ask-if is-more-than ?min but-less-than ?max $?rest-of-ifs-true))  
    (answer (known-factor ?f&:(eq ?f ?first-ask-if)) (value ?a&:(and (> ?a ?min) (< ?a ?max)(numberp ?a))) )
   =>
   (if (eq (nth$ 1 ?rest-of-ifs-true) and) 
    then (modify ?r (if (rest$ ?rest-of-ifs-true)))
    else (modify ?r (if ?rest-of-ifs-true)))
)

(defrule fire-domain-rule
   ?r <- (domain-rule 	(if $?a&:(=(length$ ?a) 0))  
    				(then based-on ?factor&:(> (str-length ?factor) 0) the-expert-system-favours-getting-married-with-certainty ?cf % $?rest-of-factors)
                   		)
   =>
   (if (eq (nth$ 1 ?rest-of-factors) and) 
   then (modify ?r (then (rest$ ?rest-of-factors))))       
   (assert (conclusion (name ?factor) (confidence-factor ?cf))) )
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Implementing the question dependency rules
		
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Combining confidence factors
(defrule combine-confidence-factors
  ?rem1 <- (conclusion (name ?n) (confidence-factor ?f1))
  ?rem2 <- (conclusion (name ?n) (confidence-factor ?f2))
  (test (neq ?rem1 ?rem2))
  =>
  (retract ?rem1)
  (modify ?rem2 (confidence-factor (/ (- (* 100 (+ ?f1 ?f2)) (* ?f1 ?f2)) 100))))

  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Formatting and printing the final conclusion

(defrule print-conclusions
    (declare (salience -5000))
    ?c<- (conclusion (confidence-factor ?cf) (name ?n))
    =>
    (printout t "Based on [ " (upcase ?n) " ] expert systems confidence favouring getting married is " ?cf " %" crlf))    