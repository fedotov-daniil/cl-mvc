;;;; Created on 2011-04-10 00:58:59

(in-package :view)

(defclass view-base () ())
(defclass data-view (view-base) 
  ((params :initarg :params :initform nil :accessor view-params :type list)))

;;;
;  TEMPLATE views
;;;
(defclass template-view (data-view) 
  ((name :initarg :name :accessor view-name :type string)))
(defclass html-view (template-view) 
  ((layout :initarg :layout :accessor view-layout :type string)))
(defclass xml-view (template-view) ())

;;;
;  Data views
;;;
;(defclass xml-plist-view (data-view) ())
(defclass json-view (data-view) ())

;;;
;  Advanced views
;;;
(defclass widget-view (view-base) ())
(defclass javascript-view (view-base) ())

;;;
;  Redirect views
;;;
(defclass redirect-view (view-base) 
  ((url :initarg :url :accessor redirect-view-url)))
(defclass referer-view (redirect-view) ())

(defmethod initialize-instance :after ((view redirect-view) &rest route-params &key route-name &allow-other-keys)
  (when route-name
    (let ((route (find-route route-name)))
      (when route
        (setf (slot-value view 'url) (apply #'genurl route (alexandria:remove-from-plist route-params :url :route-name)))))))

(defmethod initialize-instance  :after ((view referer-view) &rest args)
  (declare (ignore args))
  (setf (slot-value view 'url) (hunchentoot:referer)))

