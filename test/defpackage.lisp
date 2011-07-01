;;;; 2011-05-29 15:16:59
(in-package :common-lisp-user)
(defpackage :todotree
  (:nicknames :todotree)
  (:use :cl :mvc :todotree-model)
  (:export :*user* :user-id))

