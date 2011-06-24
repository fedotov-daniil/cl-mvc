;;;; Created on 2011-04-09 21:43:20
(in-package :mvc)
(defmacro defparameter-in-package
  (name 
   package
   &optional val
   &aux 
   (n (typecase name 
                (string (string-upcase name))
                (symbol (symbol-name name))))
   (pcg (typecase package 
                  (string (find-package package))
                  (symbol package)
                  (package package))))
  "Define parameter for package."
  `(let* ((s (intern ,n ,pcg)))
     (setf (symbol-value s) ,val)))
(defmacro find-symbol-value (name 
                             &optional package 
                             &aux 
                             (n (typecase name 
                                          (null *package*)
                                          (string (string-upcase name))
                                          (symbol (symbol-name name)))))
  `(let ((pcg ,package)) 
     (symbol-value (find-symbol ,n (typecase pcg 
                                             (string (find-package pcg))
                                             (symbol pcg)
                                             (package pcg))))))
(defmacro defun-in-package
  (name 
   package
   (&rest args) 
   &body body 
   &aux 
   (n  (typecase name 
                 (string (string-upcase name))
                 (symbol (symbol-name name))))
   (pcg (typecase package 
                  (string (find-package package))
                  (symbol package)
                  (package package))))
  "Define function for package."
  `(let* ((s (intern ,n ,pcg)))
     (setf (symbol-function s) #'(lambda ,args ,@body))))
(defun to-list (x)
  (if (listp x) x (list x)))

  