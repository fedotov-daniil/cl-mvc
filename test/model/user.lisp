;;;; Created on 2011-06-02 14:08:22
(in-package :todotree-model)
(defun generate-password (&optional length)
  (map 'string 
       (lambda(arg)
         (declare (ignore arg)) 
         (char "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$^*" (random 68))) 
       (make-list (or length 8))))
(defun register-user (email)
  (if (fetch 'user :first :conditions (list :email email))
      "Email already exist!"
      (let ((password (generate-password)))
        (add-user email password)
        (send-mail email password :type :new-user))))
(defmethod get-user ((nithing (eql nil)))
  nil)
(defmethod get-user ((id integer))
  (fetch 'user id))
(defmethod get-user ((email string))
  (fetch 'user :first :conditions (list :email email)))

(defun get-user* (email password &optional password-hashed)
  (fetch 'user 
         :first
         :conditions (list :email email 
                           :password (if password-hashed password (hash-password password)))))