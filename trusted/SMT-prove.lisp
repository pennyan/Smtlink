;; Copyright (C) 2015, University of British Columbia
;; Written by Yan Peng (August 2nd 2016)
;;
;; License: A 3-clause BSD license.
;; See the LICENSE file distributed with this software
;;

(in-package "SMT")
(include-book "centaur/fty/top" :dir :system)
(include-book "xdoc/top" :dir :system)
(include-book "std/util/define" :dir :system)
(include-book "centaur/misc/tshell" :dir :system)

(include-book "../verified/SMT-hint-interface")
(include-book "../verified/SMT-config")
(include-book "./z3-py/SMT-names")
(include-book "./z3-py/SMT-translator")

(defttag :tshell)
(value-triple (tshell-ensure))

;; (defsection SMT-prove
;;   :parents (Smtlink)
;;   :short "SMT-prove is the main functions for transliteration into SMT languages and calling the external SMT solver."

(encapsulate ()

(local (defthm lemma-1
         (implies (and (string-listp x) x) (consp x))))

(local (defthm lemma-2
         (b* (((mv ?exit-status ?lines)
               (tshell-call cmd :print print :save save)))
           (implies lines (consp lines)))))

(local (defthm lemma-3
         (implies (and (string-listp x) x) (stringp (car x)))))

(local (defthm lemma-4
         (b* (((mv ?exit-status ?lines)
               (tshell-call cmd :print print :save save)))
           (implies lines (stringp (car lines))))))

  (define make-fname ((dir stringp) (fname stringp) (suffix stringp))
    :returns (full-fname stringp)
    :guard-debug t
    (b* ((dir (mbe :logic (str-fix dir) :exec dir))
         (fname (mbe :logic (str-fix fname) :exec fname))
         (suffix (mbe :logic (str-fix suffix) :exec suffix))
         (dir (if (equal dir "") "/tmp/py_file" dir))
         ((unless (equal fname ""))
          (concatenate 'string dir "/" (lisp-to-python-names fname) suffix))
         (cmd (concatenate 'string "mkdir -p " dir " && "
                           "mktemp " dir "/smtlink" suffix ".XXXXX")))
      (mv-let (exit-status lines)
        (time$ (tshell-call cmd
                            :print t
                            :save t)
               :msg "; mktemp: `~s0`: ~st sec, ~sa bytes~%"
               :args (list cmd))
        (if (and (equal exit-status 0) (not (equal lines nil)))
            (car lines)
          (prog2$ (er hard? 'SMT-prove=>make-fname "Error: Generate file error.")
                  "")))))
)

  ;; ;; (defun write-SMT-file (py-term smt-file)
  ;; ;;   (declare (ignore py-term smt-file))
  ;; ;;   )

  (define SMT-prove ((term pseudo-term-listp) (smtlink-hint smtlink-hint-p))
    :ignore-ok t
    :returns (proved? booleanp)
    (b* ((term (mbe :logic (pseudo-term-list-fix term) :exec term))
         (smtlink-hint (mbe :logic (smtlink-hint-fix smtlink-hint) :exec smtlink-hint))
         ((smtlink-hint h) smtlink-hint)
         ((smtlink-config c) h.smt-cnf)
         (smt-file (make-fname c.SMT-files-dir h.smt-fname c.file-format))
         (smt-term (SMT-translation (disjoin term) smtlink-hint))
         ;; (state (write-SMT-file translated-py-term smt-file))
         ;; (result (run-SMT-solver smt-file))
         (result t))
      result))
;;)
