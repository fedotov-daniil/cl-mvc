;;;; Created on 2011-05-30 14:33:29
(in-package :todotree-model)

(defvar *db* nil)
(setf *db*
      (connect '("192.168.0.1" "todolisp" "postgres" "danniill")
       :database-type :postgresql-socket
       :if-exists :old))
