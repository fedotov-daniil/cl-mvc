;;;; Created on 2011-04-12 15:02:47
(defpackage :routing 
  (:use :cl :core :cl-annot :iterate)
  (:export 
    :route-action
    :route-controller
    :route-name
    :route-defaults))
(in-package :routing)
(annot:enable-annot-syntax)
@export
(defclass route (routes:route)
  ((controller :initarg :controller :initform *default-controller-name* :accessor route-controller)
   (action :initarg :action :initform *default-action-name* :accessor route-action)
   (defaults :initarg :defaults  :accessor route-defaults)
   (name :initarg :name :accessor route-name)
   (method :initarg :method)
   (requirements :initarg :requirements)))
@export
(defun nil-if-empty (string)
  (if (and (stringp string) (string= string ""))
      nil
      string))
@export
(defun defroute (name 
                 template 
                 &key 
                 action 
                 controller 
                 defaults
                 (method :any)
                 requirements
                 parse-vars)
  (let ((route (make-instance 'route 
                              :name name
                              :template (routes:parse-template template parse-vars)
                              :controller controller
                              :action (or action *default-action-name*)
                              :defaults defaults
                              :method method
                              :requirements requirements)))
    (routes:connect (default-mapper)  route)
    (push route (default-routes))
    route))
@export
(defun clear-routes ()
  (routes:reset-mapper (default-mapper))
  (setf (mvc::default-routes) nil)
  )
@export
(defun find-route (route-name)
  (find-if (lambda (route) (string= (route-name route) route-name)) (default-routes)))
@export
(defun genurl-full (route &rest args)
  (let ((uri (genurl/impl (route-template route)  args)))
    (setf (puri:uri-scheme uri)
          :http)
    (setf (puri:uri-host uri)
          (if (boundp 'hunchentoot:*request*)
                      (hunchentoot:host)
                      "localhost"))
    (puri:render-uri uri nil)))
@export
(defun genurl (route &rest args)
  (puri:render-uri (genurl/impl (route-template route)  args) nil))
(defun route-template (route)
  (routes:route-template route))
(defun genurl/impl (tmpl args)
  (let ((uri (make-instance 'puri:uri)))
    (setf (puri:uri-parsed-path uri)
          (cons :absolute
                (routes::apply-bindings 
                 tmpl 
                 (iterate (for (key value) :on args :by #'cddr)
                   (collect (cons key (if (listp value) value (princ-to-string value))))))))
    uri))

