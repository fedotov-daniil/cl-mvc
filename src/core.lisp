;;;; Created on 2011-04-12 14:55:49
(defpackage :core
  (:use :cl :routes :hunchentoot :cl-annot))
(in-package :core)
(annot:enable-annot-syntax)
(defclass mvc-application ()
  ((mapper :initform (make-instance 'routes:mapper))
   (controllers :initform nil)
   (routes :initform nil :accessor app-routes)))
@export
(defparameter *acceptors* nil)
(defparameter *DEFAULT-HOST-REDIRECT* nil)
@export
(defparameter *default-controller-name* "index")
@export
(defparameter *default-action-name* "index")
@export
(defparameter *default-view-type* 'html-view)
@export
(defparameter *mvc-application* (make-instance 'mvc-application))
@export
(defmacro default-mapper ()
  `(slot-value *mvc-application* 'mapper))
@export
(defmacro default-controllers ()
  `(slot-value *mvc-application* 'controllers))
@export
(defmacro default-routes ()
  `(app-routes *mvc-application*))
@export
(defun not-found-if-not (cond)
  "Redirect to 404 page if cond"
  (or cond
      (progn 
        (setf (hunchentoot:return-code*)
              hunchentoot:+HTTP-NOT-FOUND+)
        (hunchentoot:abort-request-handler))))
@export
(defun server-error (&optional err)
  (setf (hunchentoot:return-code*) 
        hunchentoot:+http-internal-server-error+)
  (hunchentoot:abort-request-handler)) 
@export
(defun default-if (cond)
  "Redirect to default page page if cond"
  (when cond
    (hunchentoot:redirect 
     (hunchentoot:request-uri*)
     :host *default-host-redirect*)))
@export
(defun ajax-request-p ()
  (when (boundp 'hunchentoot:*request*)
  (hunchentoot:header-in* "X-Requested-With")))


