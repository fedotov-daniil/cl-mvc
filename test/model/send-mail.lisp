;;;; Created on 2011-06-01 13:54:36
(in-package :todotree-model)
(defparameter *new-user-format* "<div><div><h1>������, ��� ������: ~a </h1><p>�� ������ �������, ��� ��� �� ������ �� ��������.<br>������� �� ����������� �������� ��� �� ����� ������ � ������� ����������.</p><p>---- <br>�������������</p></div></div>")
(defgeneric send-mail (email object &key type))
(defmethod send-mail (email (object null) &key type)
  (declare (ignore email object type))
  "Error in send-mail! No object specified")
(defmethod send-mail (email (value string) &key type)
  (case type
    (:new-user
      (bordeaux-threads:make-thread (lambda() (smtp-send email "New user registration" (format nil *new-user-format* value)))))
    (otherwise "Error sending email! No such email type")))
(defparameter *smtp-account*
  (list :host "smtp.gmail.com"
        :authentication (list "hairyhum@gmail.com" "danniill")
        :from "noreply@gmail.com"
        :ssl t))
(defun smtp-send (to topic message)
  (handler-case
   (cl-smtp:send-email (getf *smtp-account* :host) 
                       (getf *smtp-account* :from) 
                       to 
                       topic
                       message
                       :ssl (getf *smtp-account* :ssl) 
                       :authentication (getf *smtp-account* :authentication))
   (error nil)))