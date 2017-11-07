;; Copyright (C) 2015, University of British Columbia
;; Written by Yan Peng (June 26th 2017)
;;
;; License: A 3-clause BSD license.
;; See the LICENSE file distributed with this software
;;

(in-package "SMT")
(include-book "centaur/sv/tutorial/support" :dir :system)
(include-book "examples/examples")

;; ------------------------------------------------------- ;;
;;    Documentation

(include-book "xdoc/save" :dir :system)  ;; load xdoc::save

(defxdoc Smtlink
  :parents (ACL2::top)
  :short "Tutorial and documentation for the ACL2 book, Smtlink."
  :long "<h3>Introduction</h3>
<p>A framework for integrating external SMT solvers into ACL2 based on the
  @(see ACL2::clause-processor) and the @(tsee ACL2::computed-hint)
  mechanism.</p>

<h4>Overview</h4>
<p>@('Smtlink') is a framework for representing suitable ACL2 theorems as a SMT
(Satisfiability Modulo Theories) formula, and calling SMT solvers from within
ACL2.  Two phases of translation happen in the framework.  The first
translation is fully verified using several verified clause processor
interleaved with computed hints, therefore is ensured to be sound.  The second
phase involves a partial transliteration from ACL2's LISP language to the
target SMT solver's language.  This phase is done through a trusted clause
processor and thus is not verified in ACL2 to be sound.</p>

<p>SMT solvers combine domain-specific techniques together into a SAT
(Satisfiability) Solver and solves domain-specific satisfiability problems.
Typical domain specific procedures include procedures in integer and real,
linear and non-linear arithmetic, array theory, and uninterpreted function
theory.  Modern SMT solvers benefit from the development of both the SAT
solvers and the domain-specific techniques and have become very fast at solving
some relatively large problems.</p>

<p>@('Smtlink') can be used both in ACL2 and ACL2(r).  The macro @(see
Real/rationalp) should make one's proof portable between ACL2 and ACL2(r).</p>

<p>@('Smtlink') currently only supports <a
href='https://github.com/Z3Prover/z3/wiki'>Z3</a>.  We will be adding an
interface to include the <a href='http://smtlib.cs.uiowa.edu/'>SMT-LIB</a> in
near future.</p>

<h3>Using Smtlink</h3>
<h4>Requirements</h4>
<ul>
<li>Python 2 is properly installed.</li>
<li>Z3 is properly installed.
<p>One needs to build Z3 on one's own instead of using the binary release.</p>
<p>One can check it by running below program:</p>
@({
  from z3 import *
  x = Real('x')
  y = Real('y')
  s = Solver()
  s.add(x + y > 5, x > 1, y > 1)
  print(s.check())
  print(s.model())
  })
<p>One should expect some results like:</p>
@({
>>> print(s.check())
sat
>>> print(s.model())
[y = 4, x = 2]
  })
</li>
<li>ACL2 and the system books are properly installed.</li>
<li>@('Smtlink') uses Unix commands.</li>
</ul>

<h4>Build Smtlink</h4>
<ul>
<li>Setup smtlink configuration in file smtlink-config in directory $HOME.  The
configuration takes below format:</li>
@({
  interface-dir=...
  smt-module=...
  smt-class=...
  smt-cmd=...
  pythonpath=...
  })
<table>

<li>Below table explains what they stand for.</li>
<tr>
<th>Option</th>
<th>Explanation</th>
<th>Example</th>
</tr>
<tr>
<td>@('interface-dir')</td>
<td>The directory where the SMT solver interface module files are</td>
<td>/Users/.../smtlink/z3_interface</td>
</tr>
<tr>
<td>@('smt-module')</td>
<td>The module name (i.e. the file name)</td>
<td>ACL2_to_Z3</td>
</tr>
<tr>
<td>@('smt-class')</td>
<td>The class name</td>
<td>ACL22SMT</td>
</tr>
<tr>
<td>@('smt-cmd')</td>
<td>The command for running the SMT solver</td>
<td>/usr/local/bin/python</td>
</tr>
<tr>
<td>@('pythonpath')</td>
<td>Set up PYTHONPATH if one wants to use a specific library</td>
<td>/some/path/to/python/libraries</td>
</tr>
</table>
<p>Note that @('smt-cmd') for running Z3 is the Python command since we are
using the Python interface. The Z3 library is imported into Python in the
scripts written out by Smtlink like is shown in \"Requirements\".</p>
<li>Certify the book top.lisp in the Smtlink directory, to bake setup into
certified books.
<p>This took about 2.5mins on my 4-core mac with hyperthreading @('-j 2').</p>
</li>

</ul>

<h4>Load and Setup Smtlink</h4>
<p>To use @('Smtlink'), one needs to include book:</p>
@({
  (include-book \"/dir/to/smtlink/top\")
  })
<p>Then one needs to enable @(tsee acl2::tshell) by doing:</p>
@({
  (value-triple (tshell-ensure))
  })
<p>@(tsee value-triple) makes sure the form @('(tshell-ensure)') can be
submitted in an event context and therefore is certifiable.</p>

<p>For a detail description of how to setup and get started using @('Smtlink'),
see @(tsee tutorial) and @(tsee SMT-hint).</p>

<h3>Reference</h3>
<p>@('Smtlink') has experienced a great interface and infrastructure change
since its first publication at ACL2 workshop 2015.  But you may still find below
paper useful in understanding basics of @('Smtlink'):</p>

<p>Yan Peng and Mark R. Greenstreet. <a
href='https://arxiv.org/abs/1509.06082'>Extending ACL2 with SMT Solvers</a>In
ACL2 Workshop 2015. October 2015. EPTCS 192. Pages 61-77.</p>")


(defxdoc z3-py
  :parents (Trusted)
  :short "The Z3 python interface related books."
  :long "<h3>Introduction</h3>")

(defxdoc Trusted
  :parents (Developer)
  :short "Trusted part of Smtlink."
  :long "<h3>Introduction</h3>")

(defxdoc Verified
  :parents (Developer)
  :short "Verified part of Smtlink"
  :long "<h3>Introduction</h3>")

(defxdoc Developer
  :parents (Smtlink)
  :short "The developer's reference to Smtlink."
  :long "<h3>Introduction</h3>")

(sv::deftutorial Tutorial
  :parents (Smtlink)
  :short "A tutorial to walk you through how to use Smtlink to prove ACL2 theorems."
  :long "<h3>Prerequisites</h3>
<p>Following instructions in :doc @(see Smtlink), one should have setup a file
in @('$HOME') named as smtlink-config for configurations and have certified the
Smtlink book afterwards to bake in the configurations.</p>
<p>Then the header of the ACL2 script should look like:</p>
@({
  (in-package \"ACL2\")
  (include-book \"/dir/to/Smtlink/top\")
  (tshell-ensure)
})
<p>Smtlink uses a sequence of computed hints and clause processors to perform
different stages.  In order to install the first computed-hint, one needs to
@(see add-default-hints).</p>
@({
  (add-default-hints '((SMT::SMT-process-hint clause)))
})
<p>The rest of this document contains three pieces of arithmetic examples to
show what one can do with Smtlink and how.  The first one shows a regular
example, the second one is proved using the extended version called
smtlink-custom and the third one is a theorem that does not pass Smtlink.</p>"
  )

(defxdoc SMT-hint
  :parents (Smtlink SMT-hint-interface)
  :short "Describes the hints interface for Smtlink."
  :long "
@({Examples:

:smtlink(-custom)
(:functions ((my-expt :formals ((r rationalp)
                                (i rationalp))
                      :returns ((ex rationalp :hints (:in-theory (enable my-expt))))
                      :level 0)
             ...)
 :hypotheses (((< (my-expt z n) (my-expt z m))
               :hints (:use ((:instance hypo1-hint (x x)))))
              ((< 0 (expt z m)))
              ((< 0 (expt z n)))
              ...)
 :main-hint (:use ((:instance main-hint (n n) (x x))))
 :int-to-rat t
 :smt-fname \"my-smt-problem.lisp\"
 :smt-dir \"/home/tmp\"
 :rm-file t)

})

<p>@(':smtlink') is a customized argument option to @(see acl2::hints).
 @('smtlink-custom') is used when one wants to use the customized version of
 Smtlink.  The next argument to @(':smtlink') we call @(see smt-hint).  These
 are the hints one wants to provide to Smtlink so that it can figure out the
 proof easily.  Let's take a look at each one of them:</p>

 <dl>

 <dt>@(':functions')</dt><p/>

 <dd><p>@('functions') are for dealing with recursive functions.  Smtlink
 translate a basic set of ACL2 functions (See @(see smt-basics)) into SMT
 functions.  Non-recursive functions defined with the basic functions are
 automatically expanded in the verified clause processor.  Recursive functions
 can be specified to expand to a given level.  The innermost function call is
 translated into an uninterpreted function.  When level equals 0, no expansion
 is done.</p>

 <p>The argument to @(':functions') is a list of functions.  For each of the
 function, for example,</p>

 @({
(my-expt :formals ((r rationalp)
                   (i rationalp))
         :returns ((ex rationalp :hints (:in-theory (enable my-expt))))
         :level 0)
})

 <p>@('my-expt') is function that has already been defined.  It has two formals,
 named as @('r') with type @('rationalp') and @('i') with type @('rationalp').
 It returns an argument called @('ex') with type @('rationalp').  Return types
 of functions are proved as one of the clauses returned by the verified clause
 processor.  One can give hints to the proof.  The hints uses a similar form as
 in @(see acl2::hints).  The only difference is that the hints will only go to a
 specific subgoal, therefore no goal specifier is needed.  @('level') is the
 expansion level.</p>
 </dd>

 <dt>@(':hypotheses')</dt><p/>

 <dd><p>@(':hypotheses') are \"facts\" that the user believes to be true and
 should help with the proof.  The facts will be returned as auxiliary clauses
 to be proved from the verified clause processor.  One can provide hints for
 proving any of the hypotheses.  It follows the format of the @(see acl2::hints),
 except that no goal specifier is needed.</p></dd>

 <dt>@(':main-hint')</dt><p/>

 <dd><p>@(':main-hint') provides a hint to the main returned auxiliary theorem.
 This theorem proves the expanded clause implies the original clause.  The
 format of the hint follows that of the @(see acl2::hints), except that no goal
 specifier is needed.</p></dd>

 <dt>@(':int-to-rat')</dt><p/>

 <dd><p>Z3 has a limited solver for mixed Integer and Real number theories, but
 have a better solver for solving pure Real number problems.  Sometimes one
 might want to try raising all Integers to Reals to prove a theorem.</p></dd>

 <dt>@(':smt-fname')</dt><p/>

 <dd><p>@(':smt-fname') provides a user specified file name for the generated
 Z3 problem, instead of the default one.</p></dd>

 <dt>@(':smt-dir')</dt><p/>

 <dd><p>@(':smt-dir') provides a user specified directory for the generated Z3
 file, instead of the default one in /tmp.</p></dd>

 <dt>@(':rm-file')</dt><p/>

 <dd><p>@(':rm-file') specified whether one wants the generated Z3 file to be
 preserved, in default case, it is removed.</p></dd>

 </dl>
")

(defxdoc Status
  :parents (Smtlink)
  :short "A discussion of what theories are supported in Smtlink and what we
  intend to support in the future."
  :long "<h3>SMT solvers</h3>
<p>Currently only Z3 is supported.</p>

<h3>Theories</h3>
<p>The current Smtlink supports basic linear and nonlinear arithmetic proofs
involving functions defined with basic functions in @(see smt-basics).</p>

<h3>Wishlist</h3>
<ul>
<li>Adding support for SMT-LIB.</li>
<li>Adding support for algebraic data types (FTY).</li>
<li>Adding support for lists.</li>
<li>Build a computed hint for Smtlink so that it's automatically fired on goals
that seems likely to be solved by Smtlink.</li>
<li>Generalize @(':smtlink-custom') to be verified.</li>
<li>Fully verified Smtlink.</li>
</ul>"
  )

(xdoc::save "./manual" :redef-okp t)  ;; write the manual
