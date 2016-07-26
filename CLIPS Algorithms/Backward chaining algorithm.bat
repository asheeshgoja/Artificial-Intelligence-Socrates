(clear)
(clear-window)

;;Algorithm step 1-2 implementation
(deftemplate domain-rule
    	(multislot if (default none))
    	(multislot then (default none)))
(assert 
  (domain-rule 
     (if age-difference is-more-than 30 )
     (then based-on age-factor the-expert-system-favours-getting-married-with-certainty 20.0 %))
)

;;Algorithm step 3, 4, 5, 6 implementation
(deftemplate answer
    (slot known-factor  (default none))
    (slot value (default none)) 
)
(defrule remove-ask-if-in-domain-rules-with-more-than
    ?r <- (domain-rule  (if  ?first-ask-if is-more-than ?min $?rest-of-ifs-true))  
    (answer (known-factor ?f&:(eq ?f ?first-ask-if)) (value ?a&:(> ?a ?min)) )
   => 
   (if (eq (nth$ 1 ?rest-of-ifs-true) and) 
    then (modify ?r (if (rest$ ?rest-of-ifs-true)))
    else (modify ?r (if ?rest-of-ifs-true))))
(assert 
    (answer (known-factor age-difference) (value 31)))


;;Algorithm step 7,8 implementation
(deftemplate conclusion
    (slot name  (default none))
    (slot confidence-factor (type FLOAT) (default 0.0))    
)

(defrule fire-domain-rule
   ?r <- (domain-rule 	(if $?a&:(=(length$ ?a) 0))  
    				(then based-on ?factor&:(> (str-length ?factor) 0) the-expert-system-favours-getting-married-with-certainty ?cf % $?rest-of-factors)
                   		)
   =>
   (if (eq (nth$ 1 ?rest-of-factors) and) 
   then (modify ?r (then (rest$ ?rest-of-factors))))       
   (assert (conclusion (name ?factor) (confidence-factor ?cf))) )

;;Algorithm step 9 implementation
(assert
(domain-rule 
   (if your-age is-more-than 40 )
   (then based-on age-factor the-expert-system-favours-getting-married-with-certainty 45.0 %)) 
)
(assert 
    (answer (known-factor your-age) (value 47)))

(defrule combine-confidence-factors
  ?rem1 <- (conclusion (name ?n) (confidence-factor ?f1))
  ?rem2 <- (conclusion (name ?n) (confidence-factor ?f2))
  (test (neq ?rem1 ?rem2))
  =>
  (retract ?rem1)
  (modify ?rem2 (confidence-factor (/ (- (* 100 (+ ?f1 ?f2)) (* ?f1 ?f2)) 100))))
  
 (clear-window)
 