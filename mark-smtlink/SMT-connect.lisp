(in-package "ACL2")
(set-state-ok t)

(defstub acl2-my-prove
    (term fn-lst fn-level fname let-expr new-hypo let-hints hypo-hints main-hints state)
    (mv t nil nil nil nil state))

(program)
(defttag :my-cl-proc)

(include-book "SMT-z3")
(value-triple (tshell-ensure))

(progn

; We wrap everything here in a single progn, so that the entire form is
; atomic.  That's important because we want the use of push-untouchable to
; prevent anything besides my-clause-processor from calling acl2-my-prove.

  (progn!

   (set-raw-mode-on state) ;; conflict with assoc, should use assoc-equal, not assoc-eq
   
   (defun acl2-my-prove (term fn-lst fn-level fname let-expr new-hypo let-hints hypo-hints main-hints state)
     (my-prove term fn-lst fn-level fname let-expr new-hypo let-hints hypo-hints main-hints state)))
  
  ;; put fn-lst level and fname into the hint list
  (defun my-clause-processor (cl hint state)
    (declare (xargs :guard (pseudo-term-listp cl)
                    :mode :program))
    (prog2$ (cw "Original clause(connect): ~q0" (disjoin cl))
    (let ((fn-lst (cadr (assoc ':functions
			       (cadr (assoc ':expand hint)))))
	  ;; 2014-07-01: added function expansion level
	  (fn-level (cadr (assoc ':expansion-level
				 (cadr (assoc ':expand hint)))))
	  (fname (cadr (assoc ':python-file hint)))
	  (let-expr (cadr (assoc ':let hint)))
	  ;; translate formulas in let associate list into underling representation
	  (new-hypo (cadr (assoc ':hypothesize hint)))
	  ;; hints for let bindings' type assertion, hypothesis and the main theorem
	  (let-hints (cadr (assoc ':type
				  (cadr (assoc ':use hint)))))
	  (hypo-hints (cadr (assoc ':hypo
				   (cadr (assoc ':use hint)))))
	  (main-hints (cadr (assoc ':main
				   (cadr (assoc ':use hint))))))
      (mv-let (res expanded-cl type-related-theorem hypo-theorem fn-type-theorem state)
	      (acl2-my-prove (disjoin cl) fn-lst fn-level fname let-expr new-hypo let-hints hypo-hints main-hints state)
	      (if res
		  (let ((res-clause (append (append (append fn-type-theorem type-related-theorem) hypo-theorem)
					    (list (append expanded-cl cl))
					    )))
		    (prog2$ (cw "Expanded clause(connect): ~q0 ~% Success!~%" res-clause)
			    (mv nil res-clause state)))
		  (prog2$ (cw "~|~%NOTE: Unable to prove goal with ~
                                 my-clause-processor and indicated hint.~|")
			  (mv nil (list cl) state)))))))
  
  (push-untouchable acl2-my-prove t)
  )

(define-trusted-clause-processor
  my-clause-processor
  nil
  :ttag my-cl-proc)