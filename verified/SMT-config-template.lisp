;; Copyright (C) 2015, University of British Columbia
;; Written (originally) by Yan Peng (August 4th 2016)
;;
;; License: A 3-clause BSD license.
;; See the LICENSE file distributed with this software


(in-package "SMT")
(include-book "centaur/fty/top" :dir :system)

(defprod smtlink-config
  ((interface-dir stringp)
   (SMT-files-dir stringp)
   (SMT-module    stringp)
   (SMT-class     stringp)
   (SMT-cmd       stringp)
   (file-format   stringp)))

(defconst *default-smtlink-config* (make-smtlink-config :interface-dir "" :SMT-files-dir "" :SMT-module "" :SMT-class "" :SMT-cmd "" :file-format ""))

(defstub smt-cnf () => *)

(defun default-smtlink-config ()
  (declare (xargs :guard t))
  (change-smtlink-config *default-smtlink-config*))

(defattach smt-cnf default-smtlink-config)