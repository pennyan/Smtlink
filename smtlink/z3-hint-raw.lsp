(include-book "./helper")
(include-book "./SMT-formula")
(include-book "./SMT-translator")
(include-book "./SMT-run")
(include-book "./SMT-interpreter")
(include-book "./SMT-function")

(tshell-ensure)

(mutual-recursion
;; lisp-code-print-help
(defun lisp-code-print-help (lisp-code-list indent)
  "lisp-code-print-help: make a printable lisp code list"
  (if (endp lisp-code-list)
      nil
    (list #\Space
	  (lisp-code-print (car lisp-code-list) indent)
	  (lisp-code-print-help (cdr lisp-code-list) indent))))
 
;; lisp-code-print: make printable lisp list
(defun lisp-code-print (lisp-code indent)
  "lisp-code-print: make a printable lisp code list"
  (cond ((equal lisp-code 'nil) "nil") ;; 
	((equal lisp-code 'quote) "'") ;; quote
	((atom lisp-code) lisp-code)
	((and (equal 2 (length lisp-code))
	      (equal (car lisp-code) 'quote))
	 (cons "'"
	       (lisp-code-print (cadr lisp-code)
				(cons #\Space
				      (cons #\Space indent)))))
	(t
	 (list #\Newline indent '\(
	       (cons (lisp-code-print (car lisp-code)
				      (cons #\Space
					    (cons #\Space indent)))
		     (lisp-code-print-help (cdr lisp-code)
					   (cons #\Space
						 (cons #\Space indent))))
	       '\) ))))
)

;; my-prove-SMT-formula
(defun my-prove-SMT-formula (term)
  "my-prove-SMT-formula: check if term is a valid SMT formula"
  (let ((decl-list (cadr (cadr term)))
	(hypo-list (caddr (cadr term)))
	(concl-list (caddr term)))
    (SMT-formula '()
		 decl-list
		 hypo-list
		 concl-list)))

;; my-prove-write-file
(defun my-prove-write-file (term fdir)
  "my-prove-write-file: write translated term into a file"
  (write-SMT-file fdir
		  (translate-SMT-formula
		   (my-prove-SMT-formula term))
		  state))

;; my-prove-write-expander-file
(defun my-prove-write-expander-file (expanded-term fdir)
  "my-prove-write-expander-file: write expanded term into a log file"
  (write-expander-file fdir
		       expanded-term
		       state))

;; create-level
(defun create-level (level index)
  "create-level: creates a name for a level"
  (intern-in-package-of-symbol
   (concatenate 'string level (str::natstr index)) 'ACL2))

;; my-prove-build-log-file
(defun my-prove-build-log-file (expanded-term-list index)
  "my-prove-build-log-file: write the log file for expanding the functions"
  (if (endp expanded-term-list)
      nil
      (cons (list (create-level "level " index) '\:
		  (lisp-code-print
		   (car expanded-term-list) '())
		  #\Newline #\Newline)
	    (my-prove-build-log-file
	     (cdr expanded-term-list) (1+ index)))))

;; my-prove
(defun my-prove (term fn-lst level fname)
  "my-prove: return the result of calling SMT procedure"
  (let ((file-dir (concatenate 'string
			       *dir-files*
			       "/"
			       fname
			       ".py"))
	(expand-dir (concatenate 'string
				 *dir-expanded*
				 "/"
				 fname
				 "\_expand.log")))
    (mv-let (expanded-term-list num)
	    (expand-fn term fn-lst level state)
	    (prog2$ (cw "expand: ~q0" expanded-term-list)
	    (prog2$ (my-prove-write-expander-file
		     (my-prove-build-log-file
		      (cons term expanded-term-list) 0)
		     expand-dir)
		    (prog2$ (my-prove-write-file
			     expanded-term-list
			     file-dir)
			    (if (car (SMT-interpreter file-dir))
				(mv t expanded-term-list)
				(mv nil expanded-term-list))))))))
