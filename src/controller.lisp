;;;; Created on 2011-04-09 15:41:36
(in-package :mvc)
(defparameter *view-types*
  (list (cons :html  'html-view)
        (cons :partial  'template-view)
        (cons :xml  'template-view)
        (cons :json 'json-view)))
(defparameter *action* nil)
(defparameter *around-list* nil)
(defmacro defcontroller 
  (name &rest params 
        &key
        options
        view-type
        view-layout
        &allow-other-keys)
  "Define packeage with given name. TODO define some variables"
  (declare (ignore params))
  (let ((defpackage-options (remove-if #'(lambda (opt)
                                           (member (car opt)
                                                   '(:export)))
                                       (remove-if-not #'listp options))))
    `(eval-when (:compile-toplevel :load-toplevel :execute)
       (let ((package (defpackage ,name ,@defpackage-options (:use :cl :mvc))))
         (push package (default-controllers))
         (defparameter-in-package *mapper* package (default-mapper))
         (defun-in-package index package ())
         (defparameter-in-package *default-action-name* package "index")
         (defparameter-in-package *filters* package (list :before nil :after nil :around nil))
         (defparameter-in-package *view-type* package ,(if view-type `',(cdr (assoc view-type *view-types*)) `*default-view-type*))
         ;(defparameter-in-package *view-name* package ,@(if view-name view-type *default-view-name*))
         (defparameter-in-package *view-layout* package ,(if view-layout view-layout))
         package))))
(defparameter *default-controller* (defcontroller "Index"))
(defun process-controller (controller action bindings)
  (init-context controller action bindings)
  (let ((*package* controller))
    (render-view (apply-with-filters action))))
(defmacro make-view (&optional params &key name layout type)
  (let* ((view-type (or (cdr (assoc type *view-types*))
                        (cdr (assoc (get *action* :view-type) *view-types*))
                        (find-symbol-value *view-type*)))
         (view-name (or name 
                        (get *action* :view-name)
                        (when (symbolp *action*) (symbol-name *action*))))
         (view-layout (if (or (not (eql 'html-view view-type)) (ajax-request-p)) 
                          nil 
                          (or layout 
                              (get *action* :view-layout)
                              (find-symbol-value *view-layout*)
                              (package-name *package*)))))
    `(make-instance ',view-type 
                    ,@(if (and view-name (not (eql view-type 'json-view))) `(:name ,view-name)) 
                    ,@(if (and view-layout (not (eql view-type 'json-view))) `(:layout ,view-layout))
                    :params ,params)))
(defun init-context (controller action bindings)
  (declare (ignore action))
  (defparameter-in-package *session* controller hunchentoot:*session*)
  (defparameter-in-package *cookies-in* controller (hunchentoot:cookies-in*))
  (defparameter-in-package *cookies-out* controller (hunchentoot:cookies-out*))
  (defparameter-in-package *route-params* controller bindings))
(defun apply-with-filters (action)
  (let  ((*action* action)
          (around (get-filters *package* action :around))
          (before (get-filters *package* action :before))
          (after (get-filters *package* action :after)))
    (flet ((apply-filters (filters) 
             (mapcar #'funcall filters)))
      (apply-filters before)
      (let ((res (apply-around around))) 
        (apply-filters after)
        res))))
(defmethod apply-around ((around list))
  (let ((*around-list* (rest around))
        (current (first around)))
    (typecase current
              (function (funcall current))
              (null (apply *action* (get-action-params)))
              (t (call-next-filter)))))
(defun get-action-params ()
  (find-symbol-value *route-params*))
(defun call-next-filter ()
  (apply-around *around-list*))
(defun get-filters (controller action keyword &aux (action-filter (get action keyword)))
  (flet ((is-for-action (filter action)
           (if (find action (filter-actions filter))
               (not (slot-value filter 'inverse-actions))
               (slot-value filter 'inverse-actions))))
    (concatenate 
     'list 
     (remove-if-not 
      #'functionp 
      (mapcar #'filter-func 
              (remove-if-not 
               (lambda (filter) 
                 (is-for-action filter action)) 
               (getf (find-symbol-value *filters* controller) keyword))))
     (to-list action-filter))))
(defclass filter ()
  ((function :initarg :function :accessor filter-func)
   (actions :initform nil :accessor filter-actions)
   (inverse-actions :initform t)))
(defmethod initialize-instance :after ((f filter) &key only except)
  (if only
      (let ((only (to-list only)))
        (setf (slot-value f 'inverse-actions) nil) 
        (setf (filter-actions f) only))
      (when except 
        (let ((except (to-list except))) 
          (setf (filter-actions f) except)))))
(defun defilter (func keyword &key only except)
  (push (make-instance 'filter :function func :only only :except except) 
        (getf (symbol-value (find-symbol "*FILTERS*")) keyword)))
(defmacro defaction (name (&rest variables)
                          (&key 
                           (method :any) 
                           before-filter 
                           after-filter 
                           around-filter 
                           (view-type 'html-view)
                           view-name
                           view-layout)
                          &body body)
  `(let ((action (defun ,name (,@(if variables `(&key ,@variables &allow-other-keys))) ,@body)))
     (setf (symbol-plist action) 
           (list :before-filter ,before-filter
                 :after-filter ,after-filter
                 :around-filter ,around-filter
                 :view-type ',view-type
                 :view-name ,view-name
                 :method ,method
                 :view-layout ,view-layout))
     action))
