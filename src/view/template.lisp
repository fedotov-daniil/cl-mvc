;;;; Created on 2011-05-22 21:25:05
(in-package :view)
(defvar *view-dir* (merge-pathnames #p"views/"))

(defvar *generator*
(make-instance 'yaclml:file-system-generator
                 :root-directories (list *view-dir*))
  "A filesystem-based TAL generator that looks for templates only in
  current directory.")

(defun plist-tal-env (pairs)
  "Creates a fresh tal environment from the plist PAIRS."
  (labels ((keyword-to-symbol (keyword)
             (if (keywordp keyword)
                 (intern (symbol-name keyword))
                 keyword))
           (list-tal-env (value)
             (if (first value)
                 (if (keywordp (first value))
                     (plist-tal-env value)
                     (mapcar (lambda (val) (if (listp val) (list-tal-env val) (list val)))  value))
                 nil)))
    (list
     (iterate (for (key value) :on (if (and (listp pairs) (keywordp (first pairs))) pairs (list pairs)) :by #'cddr)
       (collect 
           (cons (keyword-to-symbol key) 
                 (if (listp value)
                     (list-tal-env value)
                     value)))))))
(defun render-template (name env &key template)
  (let ((env-tal (if (listp env)
                     (if  (keywordp (first env))
                         (plist-tal-env env)
                         env)
                     (list env))))
    (if template
        (yaclml:with-yaclml-output-to-string (funcall (yaclml:compile-tal-string template) env-tal nil))
        (let ((template (yaclml:load-tal *generator* (concatenate 'string name ".tal"))))
          (when template
            (YACLML:WITH-YACLML-OUTPUT-TO-STRING (funcall template 
                                                          env-tal
                                                          *generator*)))))))