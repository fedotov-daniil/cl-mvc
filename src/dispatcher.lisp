;;;; Created on 2011-04-10 17:19:02
(in-package :mvc)
(defclass mvc-generic-acceptor () ())
(defclass mvc-acceptor (hunchentoot:acceptor mvc-generic-acceptor) ())
(defclass mvc-ssl-acceptor (hunchentoot:ssl-acceptor mvc-generic-acceptor) ())
(defun dispatch-request (acceptor request)
  "Parse route and execute its processing"
  (declare (ignore acceptor))
  (let ((mapper 
         (slot-value *mvc-application* 'core::mapper))
        (hunchentoot:*request* request))
    (not-found-if-not mapper)
    (handler-case 
     (multiple-value-bind (route bindings) (routes:match mapper (hunchentoot:request-uri*))
       (not-found-if-not route)
       (process-route route (alexandria:alist-plist bindings)))
     (condition (err) (format nil "~a" err)))))
(defgeneric process-route (route bindings)
  (:documentation "Select controller. Init controller context and call action"))
(defparameter *bindings* nil)
(defparameter *route* nil)
(defmethod process-route 
  ((route route) bindings &aux (bindings (apply-defaults bindings route)))
  (let* ((controller 
          (not-found-if-not 
           (find-package (string-upcase 
                          (or (getf bindings :controller) 
                              (route-controller route))))))
         (action 
          (find-symbol (string-upcase 
                        (or (nil-if-empty (getf bindings :action)) 
                            (route-action route))) 
                       controller))
         (*route* route)) 
    (not-found-if-not (fboundp action))
    (process-controller controller action bindings)))
(defun apply-defaults (bindings route)
  (concatenate 'list bindings (route-defaults route)))
(defun start (&key 
              ssl-certificate-file 
              ssl-privatekey-file 
              ssl-privatekey-password
              (port (if ssl-certificate-file 443 80)))
  "Start mvc acceptor"
  (unless (find port *acceptors* :key #'hunchentoot:acceptor-port)
  (push (hunchentoot:start
         (if ssl-certificate-file
             (make-instance 'mvc-ssl-acceptor
                            :ssl-certificate-file ssl-certificate-file
                            :ssl-privatekey-file ssl-privatekey-file
                            :ssl-privatekey-password ssl-privatekey-password
                            :port port)
             (make-instance 'mvc-acceptor 
                            :port port)))
        *acceptors*)))
(defun stop ()
  (mapcar #'hunchentoot:stop *acceptors*)
  (setq *acceptors* nil))
(defun reset ()
  (stop)
  (setf (default-routes) nil)
  (routes:reset-mapper (default-mapper)))
(setf hunchentoot:*hunchentoot-default-external-format* (flex:make-external-format :utf-8 :eol-style :lf))
(defmethod hunchentoot:handle-request ((acceptor mvc-acceptor) request)
  (setf (hunchentoot:reply-external-format*) (flex:make-external-format :utf-8 :eol-style :lf))
  (setf (hunchentoot:content-type*) "text/html; charset=utf-8")
  (dispatch-request acceptor request))

