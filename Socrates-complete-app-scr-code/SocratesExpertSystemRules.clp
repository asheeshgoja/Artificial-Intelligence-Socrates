;GOJA Single of Married expert advisor
(defrule print-welcome-message
    (declare (salience 5000))
 =>
   (printout t "Welcome to Socrates the 'Marriage Advisor Expert System'. I am here to help you with your nuptial predicament." crlf
        	    "My advice factors in the following criteria:" crlf
		        "	1.	Income compatibility" crlf
				"	2.	Age Factor" crlf
				"	3.	Employment status" crlf
				"	4.	Marriage penalty tax liability" crlf
				"	5.	Cohabitating couple economy" crlf
				"	6.	Health insurance coverage" crlf
				"	7.	Social security benefits" crlf
				"	8.	Family dynamics" crlf
				"	9.	Myers briggs personality type personality compatibility(MBTI)" crlf crlf       
        	   "But before I do that please answer the following questions:" crlf  ))


(deftemplate question
    (slot factor (default none))      
    (slot question-to-ask (default none))
    (multislot choices (default yes no))
    (multislot range (type INTEGER)) 
    (slot has-pre-condition (type SYMBOL) (default no)))
    ;(slot already-asked  (allowed-values yes no)(default no)))


(deffacts questions 
    (question (factor your-MBTI)(question-to-ask "What is your MBTI [choose dont-know if you dont know]?") (choices dont-know ISTJ ISFJ INFJ INTJ ISTP ISFP INFP INTP ESTP ESFP ENFP ENTP ESTJ ESFJ ENFJ ENTJ))
    (question (factor your-partner-MBTI)(question-to-ask "What is MBTI of the person you wish to marry [choose dont-know if you dont know]?") (choices dont-know ISTJ ISFJ INFJ INTJ ISTP ISFP INFP INTP ESTP ESFP ENFP ENTP ESTJ ESFJ ENFJ ENTJ))
    (question (factor you-married-before) (question-to-ask "Were you married before?") )
    (question (factor your-partner-married-before) (question-to-ask "Was the person you wish to marry married before?") )
    (question (factor you-own-a-house) (question-to-ask "Do you own a house?") )
    (question (factor your-partner-owns-a-house) (question-to-ask "Does the person you wish to marry own a house?") )
    (question (factor your-age) (question-to-ask "What is your age?") (range 18 120) )
    (question (factor your-partner-age) (question-to-ask "What is the age of the person you wish to marry?") (range 18 120) )
    (question (factor your-work-status) (question-to-ask "What is your work status?") (choices student employed retired) )
    (question (factor your-partner-work-status) (question-to-ask "What is the work status of the person you wish marry ?") (choices student employed retired) )
         
    (question (factor your-no-of-dependent-children) (question-to-ask "How many dependent children do you have from past marriages?") (range 0 20) )
    (question (factor your-partner-no-of-dependent-children) (question-to-ask "How many dependent children does the person you wish marry have from past marriages?") (range 0 20) )
    (question (factor your-annual-income) (question-to-ask "What is your annual income in USD?") (range 20000 1000000) )
    (question (factor your-partner-annual-income) (question-to-ask "What is your annual income in USD of the person you wish marry?") (range 20000 1000000) )
    (question (factor you-have-health-insurance) (question-to-ask "Do you have health insurance ?") )
    (question (factor your-partner-has-health-insurance) (question-to-ask "Does the person you wish marry have health insurance ?") )    
    (question (factor your-years-since-last-marriage) (question-to-ask "How many years have passed since your last mariage ?")(range 0 50) )    
    (question (factor your-partner-financial-liability) (question-to-ask "Does the person you wish marry have any finanial liabilites?") )
    (question (factor nature-of-your-partners-financial-liability) (question-to-ask "What type of finanial liability does he/she have?")(choices irs-liens personal-lawsuit bad-credit) )
    (question (factor widow-or-widower)(question-to-ask "Is your ex dead?") )        
    (question (factor your-partner-social-security-benfit-more-than-yours)(question-to-ask "Is your partner's social security benefit more than yours?") )
    
    ;personality test
    (question (factor want-to-take-personality-test)(question-to-ask "Do you want to factor in your personality indicator ? (You will be asked 4 more questions)") )
    (question (factor your-personality-test-attitude) (question-to-ask "What is your general attitude ?")(choices  extraversion introversion) )
	(question (factor your-personality-test-information-gathering) (question-to-ask "What best describes your information gathering approach?")(choices  sensing intuition ) )
	(question (factor your-personality-test-decision-making) (question-to-ask "What is best describes your decision making approach?")(choices  thinking feeling ) )
 	(question (factor your-personality-test-lifestyle) (question-to-ask "What is your approach in relating to the outside world?")(choices  judgment perception) )
    
    (question (factor partner-want-to-take-personality-test)(question-to-ask "Do you want to factor in the person you wish to marry personality indicator ? (You will be asked 4 more questions)") )
    (question (factor your-partner-personality-test-attitude) (question-to-ask "What is the person you wish to marry general attitude ?")(choices  extraversion introversion) )
	(question (factor your-partner-personality-test-information-gathering) (question-to-ask "What best describes the person you wish to marry information gathering approach?")(choices  sensing intuition ) )
	(question (factor your-partner-personality-test-decision-making) (question-to-ask "What is best describes the person you wish to marry decision making approach?")(choices  thinking feeling ) )
 	(question (factor your-partner-personality-test-lifestyle) (question-to-ask "What is the person you wish to marry approach in relating to the outside world?")(choices  judgment perception) )
)


(deftemplate question-rule
    	(multislot if (default none))
    	(slot then-ask-question (default none)))

(deffacts question-rules   
    (question-rule (if your-work-status is employed) (then-ask-question your-annual-income))     
    (question-rule (if your-partner-work-status is employed) (then-ask-question your-partner-annual-income))
    (question-rule (if you-married-before is yes) (then-ask-question your-no-of-dependent-children))
    (question-rule (if your-partner-married-before is yes) (then-ask-question your-partner-no-of-dependent-children))
    (question-rule (if your-work-status is employed) (then-ask-question you-have-health-insurance))         
    (question-rule (if your-partner-work-status is employed) (then-ask-question your-partner-has-health-insurance))
    (question-rule (if you-married-before is yes) (then-ask-question your-years-since-last-marriage))
    (question-rule (if you-married-before is yes) (then-ask-question your-partner-financial-liability))
    (question-rule (if you-married-before is yes and your-age is-more-than 60) (then-ask-question widow-or-widower))
    (question-rule (if your-partner-financial-liability is yes) (then-ask-question nature-of-your-partners-financial-liability))    
	(question-rule (if widow-or-widower is yes and your-work-status is retired and your-partner-work-status is retired) (then-ask-question your-partner-social-security-benfit-more-than-yours))
    
    (question-rule (if your-MBTI is dont-know) (then-ask-question want-to-take-personality-test))
    (question-rule (if want-to-take-personality-test is yes) (then-ask-question your-personality-test-attitude))
    (question-rule (if want-to-take-personality-test is yes) (then-ask-question your-personality-test-information-gathering))
    (question-rule (if want-to-take-personality-test is yes) (then-ask-question your-personality-test-decision-making))
    (question-rule (if want-to-take-personality-test is yes) (then-ask-question your-personality-test-lifestyle))
    
    (question-rule (if your-partner-MBTI is dont-know) (then-ask-question partner-want-to-take-personality-test))
    (question-rule (if partner-want-to-take-personality-test is yes) (then-ask-question your-partner-personality-test-attitude))
    (question-rule (if partner-want-to-take-personality-test is yes) (then-ask-question your-partner-personality-test-information-gathering))
    (question-rule (if partner-want-to-take-personality-test is yes) (then-ask-question your-partner-personality-test-decision-making))
    (question-rule (if partner-want-to-take-personality-test is yes) (then-ask-question your-partner-personality-test-lifestyle)) 
)



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
				 (then based-on income-tax the-expert-system-favours-getting-married-with-certainty 80.0 %))  
    
    (domain-rule (if you-own-a-house is yes and 
            		 your-partner-owns-a-house is yes)
				 (then based-on  cohabitating-couple-economy  the-expert-system-favours-getting-married-with-certainty 80.0 %))         
    
    (domain-rule (if your-annual-income is-more-than 100000 and 
            		 your-partner-annual-income is-more-than 100000 and
            		 your-no-of-dependent-children is-more-than 1 and
            		 your-partner-no-of-dependent-children is-more-than 1 )
				 (then based-on income-tax the-expert-system-favours-getting-married-with-certainty 85.0 %))     
    
    (domain-rule (if you-have-health-insurance is yes and 
            		  your-partner-has-health-insurance is yes)
				 (then based-on health-insurance-coverage the-expert-system-favours-getting-married-with-certainty 50.0 %))     
     
    (domain-rule (if you-have-health-insurance is yes and 
            		  your-partner-has-health-insurance is yes and
                      your-no-of-dependent-children is-more-than 2 and
            		  your-partner-no-of-dependent-children is-more-than 2 )
				 (then based-on health-insurance-coverage the-expert-system-favours-getting-married-with-certainty 80.0 % and
            		   based-on income-tax the-expert-system-favours-getting-married-with-certainty 90.0 %))     
    
     (domain-rule (if your-years-since-last-marriage is-more-than 9)
				 (then based-on social-security-benefits the-expert-system-favours-getting-married-with-certainty 40.0 %))   
    
     (domain-rule (if your-partner-social-security-benfit-more-than-yours is no)            			
				 (then based-on social-security-benefits the-expert-system-favours-getting-married-with-certainty 10.0 %))   
        
     (domain-rule (if you-have-health-insurance is yes and 
            		  your-partner-has-health-insurance is no and
                      nature-of-your-partners-financial-liability is irs-liens and
            		  your-partner-no-of-dependent-children is-more-than 2 )
				 (then based-on health-insurance-coverage the-expert-system-favours-getting-married-with-certainty 20.0 % and
            		   based-on income-tax the-expert-system-favours-getting-married-with-certainty 10.0 %))      
    
     (domain-rule (if you-have-health-insurance is yes and 
            		  your-partner-has-health-insurance is no and
                      nature-of-your-partners-financial-liability is irs-liens and
            		  your-partner-no-of-dependent-children is-more-than 2 )
				 (then based-on health-insurance-coverage the-expert-system-favours-getting-married-with-certainty 20.0 % and
            		   based-on income-tax the-expert-system-favours-getting-married-with-certainty 10.0 %))     
     
    (domain-rule (if  your-age is-less-than 40 and 
            		  your-partner-age is-less-than 40 and
                      your-no-of-dependent-children is-more-than 0 and
            		  your-partner-no-of-dependent-children is-more-than 0 )
				 (then based-on health-insurance-coverage the-expert-system-favours-getting-married-with-certainty 20.0 % and
            		   based-on family-dynamics the-expert-system-favours-getting-married-with-certainty 10.0 %)) 
    
    (domain-rule (if  your-age is-less-than 40 and 
            		  your-partner-age is-less-than 40 and
                      your-no-of-dependent-children is-more-than 0 and
            		  your-partner-no-of-dependent-children is-more-than 0 )
				 (then based-on health-insurance-coverage the-expert-system-favours-getting-married-with-certainty 20.0 % and
            		   based-on family-dynamics the-expert-system-favours-getting-married-with-certainty 10.0 %))    
    
    (domain-rule (if  your-age is-less-than 25 and 
            		  your-partner-age is-less-than 25 and
                      you-own-a-house is no and 
            		  your-partner-owns-a-house is no )
				 (then based-on age-factor the-expert-system-favours-getting-married-with-certainty 10.0 % and
            		   based-on family-dynamics the-expert-system-favours-getting-married-with-certainty 5.0 %  and
            		   based-on your-mbti-personality-compatibility the-expert-system-favours-getting-married-with-certainty 5.0 %))        
      
     (domain-rule (if  your-age is-less-than 25 and 
            		   your-partner-age is-less-than 25 and
                       your-work-status is employed and 
            		   your-partner-work-status is-not employed )
				 (then based-on age-factor the-expert-system-favours-getting-married-with-certainty 10.0 % and
            		   based-on family-dynamics the-expert-system-favours-getting-married-with-certainty 5.0 % and
     				   based-on employment-status the-expert-system-favours-getting-married-with-certainty -5.0 % and
            		   based-on your-mbti-personality-compatibility the-expert-system-favours-getting-married-with-certainty 5.0 %))
    
     (domain-rule (if  your-age is-less-than 35 and 
            		   your-partner-age is-less-than 35 and
                       your-work-status is employed and 
            		   your-partner-work-status is-not employed )
				 (then based-on age-factor the-expert-system-favours-getting-married-with-certainty 40.0 % and
            		   based-on family-dynamics the-expert-system-favours-getting-married-with-certainty 25.0 % and
     				   based-on employment-status the-expert-system-favours-getting-married-with-certainty 5.0 % and
            		   based-on your-mbti-personality-compatibility the-expert-system-favours-getting-married-with-certainty 25.0 %))                       
 

    ;Personality Test rules
    ;Source http://www.personalitydesk.com/story/compatibility-and-your-myers-briggs-personality-type
    (domain-rule (if your-personality-category is sensing-thinking-perceiving and
               	 	  your-partner-personality-category is sensing-thinking-perceiving )
				 (then based-on your-mbti-personality-compatibility the-expert-system-favours-getting-married-with-certainty 33.0 %))  
             
     (domain-rule (if your-personality-category is intuitive-feeling-perceiving and
               	 	  your-partner-personality-category is sensing-thinking-judging )
				 (then based-on your-mbti-personality-compatibility the-expert-system-favours-getting-married-with-certainty 42.0 %))     
     
     (domain-rule (if your-personality-category is intuitive-thinking and
               	 	  your-partner-personality-category is intuitive-thinking )
				 (then based-on your-mbti-personality-compatibility the-expert-system-favours-getting-married-with-certainty 59.0 %)) 
        
     (domain-rule (if your-personality-category is sensing-feeling-judgers and
               	 	  your-partner-personality-category is intuitive-feeling-judgers )
				 (then based-on your-mbti-personality-compatibility the-expert-system-favours-getting-married-with-certainty 67.0 %))     
    
     (domain-rule (if your-personality-category is intuitive-feelers and
               	 	  your-partner-personality-category is intuitive-feelers )
				 (then based-on your-mbti-personality-compatibility the-expert-system-favours-getting-married-with-certainty 73.0 %))         
    
    (domain-rule (if your-personality-category is sensing-judgers and
               	 	 your-partner-personality-category is sensing-judgers )
				 (then based-on your-mbti-personality-compatibility the-expert-system-favours-getting-married-with-certainty 79.0 %))    
    
    (domain-rule (if your-personality-category is sensing-feeling-judgers and
               	 	  your-partner-personality-category is intuitive-feeling-perceiving )
				 (then based-on your-mbti-personality-compatibility the-expert-system-favours-getting-married-with-certainty 86.0 %)) 
       
)


;***********************************************derived facts****************************************************************************
;****************************************************************************************************************************************
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

(defrule mark-questions-with-pre-conditions
	?q  <-(question (factor ?f) (has-pre-condition no))
    (question-rule (then-ask-question ?f) (if $?i&:(> (length$ ?i) 0)) )
    =>
   (modify ?q (has-pre-condition yes))  
)

;personality test conclusions
(deffunction cnv (?pt)
	(switch ?pt
     	(case extraversion then (return E))   
        (case introversion then (return I))
        (case sensing then (return S))
        (case intuition then (return N))
        (case thinking then (return T))
        (case feeling then (return F))
        (case judgment then (return J))
        (case perception then (return P))        
     ) 
)


(defrule eval-your-personality-test-attitude
	(answer (known-factor your-personality-test-attitude)(value ?E/I) )
    (answer (known-factor your-personality-test-information-gathering)(value ?S/N) )
    (answer (known-factor your-personality-test-decision-making)(value ?T/F) )
    (answer (known-factor your-personality-test-lifestyle)(value ?J/P) )
    =>
    (assert (answer (known-factor your-MBTI) (value (string-to-field (str-cat (cnv ?E/I)(cnv ?S/N)(cnv ?T/F)(cnv ?J/P))))))
)

(defrule personality-category-sensing-judgers
	(or 
    	(answer (known-factor your-MBTI)(value ESTJ) )
        (answer (known-factor your-MBTI)(value ESFJ) )
        (answer (known-factor your-MBTI)(value ISTJ) )
        (answer (known-factor your-MBTI)(value ISFJ) )
     )    
    =>
    (assert (answer (known-factor your-personality-category) (value sensing-judgers )))
)

(defrule personality-category-intuitive-feelers 
	(or 
    	(answer (known-factor your-MBTI)(value ENFP) )
        (answer (known-factor your-MBTI)(value INFP) )
        (answer (known-factor your-MBTI)(value ENFJ) )
        (answer (known-factor your-MBTI)(value INFJ) )
     )    
    =>
    (assert (answer (known-factor your-personality-category) (value intuitive-feelers  )))
)

(defrule personality-category-intuitive-feeling-perceiving 
	(or 
    	(answer (known-factor your-MBTI)(value INFP) )
        (answer (known-factor your-MBTI)(value ENFP) )
     )    
    =>
    (assert (answer (known-factor your-personality-category) (value intuitive-feeling-perceiving  )))
)

(defrule personality-category-sensing-thinking-judging 
	(or 
    	(answer (known-factor your-MBTI)(value ESTJ) )
        (answer (known-factor your-MBTI)(value ISTJ) )
     )    
    =>
    (assert (answer (known-factor your-personality-category) (value sensing-thinking-judging )))
)

(defrule personality-category-sensing-feeling-judgers 
	(or 
    	(answer (known-factor your-MBTI)(value ESFJ ) )
        (answer (known-factor your-MBTI)(value ISFJ) )
     )    
    =>
    (assert (answer (known-factor your-personality-category) (value sensing-feeling-judgers)))
)

(defrule personality-category-feeling-perceivers 
	(or 
    	(answer (known-factor your-MBTI)(value ENFP) )
        (answer (known-factor your-MBTI)(value INFP) )
     )    
    =>
    (assert (answer (known-factor your-personality-category) (value feeling-perceivers)))
)

(defrule personality-category-intuitive-feeling-judgers 
	(or 
    	(answer (known-factor your-MBTI)(value ENFJ) )
        (answer (known-factor your-MBTI)(value INFJ) )
     )    
    =>
    (assert (answer (known-factor your-personality-category) (value intuitive-feeling-judgers )))
)

(defrule personality-category-sensing-thinking-perceiving 
	(or 
    	(answer (known-factor your-MBTI)(value ISTP ) )
        (answer (known-factor your-MBTI)(value ESTP) )
     )    
    =>
    (assert (answer (known-factor your-personality-category) (value sensing-thinking-perceiving )))
)

(defrule personality-category-intuitive-thinking 
	(or 
    	(answer (known-factor your-MBTI)(value ENTP ) )
        (answer (known-factor your-MBTI)(value INTP) )
        (answer (known-factor your-MBTI)(value ENTJ) )
        (answer (known-factor your-MBTI)(value INTJ) )
     )    
    =>
    (assert (answer (known-factor your-personality-category) (value intuitive-thinking )))
 )
    
;; partner personality test
 (defrule eval-your-partner-personality-test-attitude
	(answer (known-factor your-partner-personality-test-attitude)(value ?E/I) )
    (answer (known-factor your-partner-personality-test-information-gathering)(value ?S/N) )
    (answer (known-factor your-partner-personality-test-decision-making)(value ?T/F) )
    (answer (known-factor your-partner-personality-test-lifestyle)(value ?J/P) )
    =>
    (assert (answer (known-factor your-partner-MBTI) (value (string-to-field (str-cat (cnv ?E/I)(cnv ?S/N)(cnv ?T/F)(cnv ?J/P))))))
)

(defrule partner-personality-category-sensing-judgers
	(or 
    	(answer (known-factor your-partner-MBTI)(value ESTJ) )
        (answer (known-factor your-partner-MBTI)(value ESFJ) )
        (answer (known-factor your-partner-MBTI)(value ISTJ) )
        (answer (known-factor your-partner-MBTI)(value ISFJ) )
     )    
    =>
    (assert (answer (known-factor your-partner-personality-category) (value sensing-judgers )))
)

(defrule partner-personality-category-intuitive-feelers 
	(or 
    	(answer (known-factor your-partner-MBTI)(value ENFP) )
        (answer (known-factor your-partner-MBTI)(value INFP) )
        (answer (known-factor your-partner-MBTI)(value ENFJ) )
        (answer (known-factor your-partner-MBTI)(value INFJ) )
     )    
    =>
    (assert (answer (known-factor your-partner-personality-category) (value intuitive-feelers  )))
)

(defrule partner-personality-category-intuitive-feeling-perceiving 
	(or 
    	(answer (known-factor your-partner-MBTI)(value INFP) )
        (answer (known-factor your-partner-MBTI)(value ENFP) )
     )    
    =>
    (assert (answer (known-factor your-partner-personality-category) (value intuitive-feeling-perceiving  )))
)

(defrule partner-personality-category-sensing-thinking-judging 
	(or 
    	(answer (known-factor your-partner-MBTI)(value ESTJ) )
        (answer (known-factor your-partner-MBTI)(value ISTJ) )
     )    
    =>
    (assert (answer (known-factor your-partner-personality-category) (value sensing-thinking-judging )))
)

(defrule partner-personality-category-sensing-feeling-judgers 
	(or 
    	(answer (known-factor your-partner-MBTI)(value ESFJ ) )
        (answer (known-factor your-partner-MBTI)(value ISFJ) )
     )    
    =>
    (assert (answer (known-factor your-partner-personality-category) (value sensing-feeling-judgers)))
)

(defrule partner-personality-category-feeling-perceivers 
	(or 
    	(answer (known-factor your-partner-MBTI)(value ENFP) )
        (answer (known-factor your-partner-MBTI)(value INFP) )
     )    
    =>
    (assert (answer (known-factor your-partner-personality-category) (value feeling-perceivers)))
)

(defrule partner-personality-category-intuitive-feeling-judgers 
	(or 
    	(answer (known-factor your-partner-MBTI)(value ENFJ) )
        (answer (known-factor your-partner-MBTI)(value INFJ) )
     )    
    =>
    (assert (answer (known-factor your-partner-personality-category) (value intuitive-feeling-judgers )))
)

(defrule partner-personality-category-sensing-thinking-perceiving 
	(or 
    	(answer (known-factor your-partner-MBTI)(value ISTP ) )
        (answer (known-factor your-partner-MBTI)(value ESTP) )
     )    
    =>
    (assert (answer (known-factor your-partner-personality-category) (value sensing-thinking-perceiving )))
)

(defrule partner-personality-category-intuitive-thinking 
	(or 
    	(answer (known-factor your-partner-MBTI)(value ENTP ) )
        (answer (known-factor your-partner-MBTI)(value INTP) )
        (answer (known-factor your-partner-MBTI)(value ENTJ) )
        (answer (known-factor your-partner-MBTI)(value INTJ) )
     )    
    =>
    (assert (answer (known-factor your-partner-personality-category) (value intuitive-thinking )))
        
    
) 
   





;***********************************************backward rule chaining algorithms*********************************************************
;***********************************************backward rule chaining algorithms**********************************************************

(deffunction  check-range ( ?min  ?max ?answer   )
    (if (not (numberp ?answer)) then (return 0)  )  
    (if ( and (>= ?answer ?min) (<= ?answer ?max)  )  
     then (return 1) 
     else (return 0)))
     
;(deffunction list-to-field (?elements ?index)
;    (return (string-to-field (implode$ (subseq$ ?elements ?index ?index))) )
;)

(deffunction ask 
   (?question ?choices ?range)
   (if (eq (length$ ?range) 0) then (printout t ?question ?choices ":") else (printout t ?question "range-" $?range ":"))
   (bind ?answer (read) )
   (if (eq (length$ ?range) 0)
	then  (while (not (member$ ?answer ?choices)) do
;		  (printout t ?question ?choices)
          (printout t "Invalid option! Please specify one of these options" ?choices ":" ) 
		  (bind ?answer (read))
		  (if (lexemep ?answer) then (bind ?answer (lowcase ?answer))))
    ;else  (while (eq (check-range (list-to-field ?range 1) (list-to-field ?range 2) ?answer) 0 )   do
    else  (while (eq (check-range (nth$ 1 ?range ) (nth$ 2 ?range ) ?answer) 0 )   do
		      (printout t "Invalid input! Please specify a value within the range" $?range ":")
		      (bind ?answer (read))
		      (if (lexemep ?answer) then (bind ?answer (lowcase ?answer))))
     )
   (printout t crlf)        
   ?answer
 )

(defrule ask-question
   ?q <- (question ;(already-asked no)
                   (question-to-ask ?question)
                   (factor ?factor)
                   (range $?range)
                   (choices $?choices)
        		   (has-pre-condition no))
    (not (answer (known-factor ?factor)))
   =>
    (assert (answer (known-factor ?factor)
                      (value (ask ?question ?choices ?range))))
;    (modify ?q (already-asked yes)) 
)


;**********************domain rule backward rule chaining operations**********************************
;*****************************************************************************************************

(defrule remove-ask-if-in-domain-rules-with-equal-to
   ?r <- (domain-rule  (if  ?first-ask-if is ?val $?rest-of-ifs-true))  
    (answer (value ?val) (known-factor ?first-ask-if))
   =>
   (if (eq (nth$ 1 ?rest-of-ifs-true) and) 
    then (modify ?r (if (rest$ ?rest-of-ifs-true)))
    else (modify ?r (if ?rest-of-ifs-true)))
)

(defrule remove-ask-if-in-domain-rules-with-not-equal-to
   ?r <- (domain-rule  (if  ?first-ask-if is-not ?val $?rest-of-ifs-true))  
    (answer (value ~?val) (known-factor ?f&:(eq ?f ?first-ask-if)))
   =>
   (if (eq (nth$ 1 ?rest-of-ifs-true) and) 
    then (modify ?r (if (rest$ ?rest-of-ifs-true)))
    else (modify ?r (if ?rest-of-ifs-true)))
)

(defrule remove-ask-if-in-domain-rules-with-more-than
    (declare (salience -100))     
    ?r <- (domain-rule  (if  ?first-ask-if is-more-than ?min $?rest-of-ifs-true))  
    (answer (known-factor ?f&:(eq ?f ?first-ask-if)) (value ?a&:(> ?a ?min)) )
   => 
   (if (eq (nth$ 1 ?rest-of-ifs-true) and) 
    then (modify ?r (if (rest$ ?rest-of-ifs-true)))
    else (modify ?r (if ?rest-of-ifs-true)))
)

(defrule remove-ask-if-in-domain-rules-with-less-than
    ?r <- (domain-rule  (if  ?first-ask-if is-less-than ?min $?rest-of-ifs-true))  
    (answer (known-factor ?f&:(eq ?f ?first-ask-if)) (value ?a&:(< ?a ?min)) )
   => 
   (if (eq (nth$ 1 ?rest-of-ifs-true) and) 
    then (modify ?r (if (rest$ ?rest-of-ifs-true)))
    else (modify ?r (if ?rest-of-ifs-true)))
)

(defrule remove-ask-if-in-domain-rules-with-more-than-but-less-than

   ?r <- (domain-rule  (if  ?first-ask-if is-more-than ?min but-less-than ?max $?rest-of-ifs-true))  
    (answer (known-factor ?f&:(eq ?f ?first-ask-if)) (value ?a&:(and (> ?a ?min) (< ?a ?max)(numberp ?a))) )
   =>
   (if (eq (nth$ 1 ?rest-of-ifs-true) and) 
    then (modify ?r (if (rest$ ?rest-of-ifs-true)))
    else (modify ?r (if ?rest-of-ifs-true)))
)

(defrule fire-domain-rule
   ?r <- (domain-rule 	(if $?a&:(=(length$ ?a) 0))  ; only when you have no antecedents
    					(then based-on ?factor&:(> (str-length ?factor) 0) the-expert-system-favours-getting-married-with-certainty ?cf % $?rest-of-factors)
                   		)
   =>
    (if (eq (nth$ 1 ?rest-of-factors) and) 
    then (modify ?r (then (rest$ ?rest-of-factors))))       
   (assert (conclusion (name ?factor) (confidence-factor ?cf)))
) 


;**********************question  rules backward rule chaining operations *********************************
;*********************************************************************************************************


(defrule remove-ask-if-in-question-rules
   ?r <- (question-rule  (if  ?first-ask-if is ?val $?rest-of-ifs-true))
    (answer (value ?val) (known-factor ?f&:(eq ?f ?first-ask-if)))
   =>
   (if (eq (nth$ 1 ?rest-of-ifs-true) and) 
    then (modify ?r (if (rest$ ?rest-of-ifs-true)))
    else (modify ?r (if ?rest-of-ifs-true)))
)

(defrule remove-ask-if-not-in-question-rules
   ?r <- (question-rule  (if  ?first-ask-if is-not ?val $?rest-of-ifs-true))
    (answer (value ~?val) (known-factor ?f&:(eq ?f ?first-ask-if)))
   =>
   (if (eq (nth$ 1 ?rest-of-ifs-true) and) 
    then (modify ?r (if (rest$ ?rest-of-ifs-true)))
    else (modify ?r (if ?rest-of-ifs-true)))
)



(defrule remove-ask-if-in-question-rules-with-more-than
   ?r <- (question-rule  (if  ?first-ask-if is-more-than ?min $?rest-of-ifs-true))
    (answer (known-factor ?f&:(eq ?f ?first-ask-if)) (value ?a&:(> ?a ?min)) )
   =>
   (if (eq (nth$ 1 ?rest-of-ifs-true) and) 
    then (modify ?r (if (rest$ ?rest-of-ifs-true)))
    else (modify ?r (if ?rest-of-ifs-true)))
)


(defrule set-pre-condition-when-no-antecedents
   ?r <- (question-rule (if $?a&:(=(length$ ?a) 0))  ; only when you have no antecedents
    					(then-ask-question ?f))
   ?q <- (question  (factor ?f) (has-pre-condition yes) )
    (not (answer (known-factor ?f)))
   =>
   (modify ?q (has-pre-condition no))
   (retract ?r) 
) 


;***********************************************combine confidence and print results*****************************************************
;****************************************************************************************************************************************
(deffacts final-conclusion   
    (conclusion (name final-get-married-factor))
)

(defrule combine-confidence-factors
  (declare (salience -500))
  ?rem1 <- (conclusion (name ?n) (confidence-factor ?f1))
  ?rem2 <- (conclusion (name ?n) (confidence-factor ?f2))
  (test (neq ?rem1 ?rem2))
  =>
  (retract ?rem1)
  (modify ?rem2 (confidence-factor (/ (- (* 100 (+ ?f1 ?f2)) (* ?f1 ?f2)) 100))))


(defrule create-final-factor
  (declare (salience -800))
  ?c1 <- (conclusion   (confidence-factor ?f1) (name ?n1&~final-get-married-factor) (evaluated no))
;  ?c2 <- (conclusion  (confidence-factor ?f2) (name ?n2&~final-get-married-factor) (evaluated no))
  ?c2   <- (conclusion (confidence-factor ?f2) (name final-get-married-factor))
;  (test (neq ?c1 ?c2))
  =>
  (modify ?c1 (evaluated yes))
; (modify ?c2 (evaluated yes))
  (modify ?c2 (confidence-factor (/ (- (* 100 (+ ?f1 ?f2)) (* ?f1 ?f2)) 100))))

(deffunction ExpressCfAsChance (?cf)
   
    (if (and (>= ?cf 0) (< ?cf 20)) then (return "extremely low"))
    (if (and (>= ?cf 20) (< ?cf 40)) then (return "low"))
    (if (and (>= ?cf 40) (< ?cf 60)) then (return "average"))
    (if (and (>= ?cf 60) (< ?cf 80)) then (return "high"))
    (if (and (>= ?cf 80) (<= ?cf 100)) then (return "extremely high"))
)

(defrule print-final-factor
    (declare (salience -900))
    ?f <- (conclusion  (name final-get-married-factor) (confidence-factor ?cf&:(> ?cf 0.0)) (evaluated no) )
    =>
    (modify ?f (evaluated yes))
    (printout t crlf crlf)
    (printout t "Based on your responses and following factors I think that you have a '" (ExpressCfAsChance ?cf) "' chance of a successful marriage." crlf
        		"To be exact my confidence favouring getting married is " ?cf " % and" crlf 
        		"staying single is " (- 100 ?cf) " %" crlf crlf)
     (printout results_file "Based on your responses and following factors I think that you have a '" (ExpressCfAsChance ?cf) "' chance of a successful marriage." crlf
        		"To be exact my confidence favouring getting married is " ?cf " % and" crlf 
        		"staying single is " (- 100 ?cf) " %" crlf crlf)
    ;    (printout t crlf crlf "Based on your responses and following factors the marriage advisor's confidence favouring " crlf "getting married is " ?cf " % and" crlf "staying single is " (- 100 ?cf) " %" crlf crlf)
;	(printout results_file "Based on your responses and following factors the marriage advisor's confidence favouring " crlf "getting married is " ?cf " % and" crlf "staying single is " (- 100 ?cf) " %" crlf crlf)        
)

(defrule print-conclusions
    (declare (salience -5000))
    ?c<- (conclusion (confidence-factor ?cf) (name ?n&~final-get-married-factor))
;    (not (exists (question (factor ?factor) (has-pre-condition no ) )))
;    (answer (known-factor ?factor))
    =>
    (printout t ".  	Factor " (upcase ?n) ", confidence rating:" ?cf " %" crlf)    
    (printout results_file ".  	Factor " (upcase ?n) ", confidence rating:" ?cf " %" crlf)
)

(defrule print-questions-answerd
    (declare (salience -10000))
    (question (question-to-ask ?q) (factor ?f) )
    (answer (known-factor ?f) (value ?a))

    =>
    (printout t ".  	QUESTION: " ?q crlf ".  	ANSWER: " ?a crlf)   
    (printout questions_file ".  	QUESTION: " ?q crlf ".  	ANSWER: " ?a crlf)    
)

