;;;; Created on 2011-05-29 20:21:37

(defpackage :test (:use :cl
        :clsql
        :mvc))
(in-package :test)
(defvar *db* nil)
(setf *db*
      (clsql:connect '("localhost" "testbase" "postgres" "danniill")
       :database-type :postgresql-socket
       :if-exists :old))
(deftable task ()
  ((id 
    :type integer
    :db-kind :key
    :db-constraints (:not-null :auto-increment)
    :initarg :id)
   (name 
    :type string
    :initarg :name
    :accessor task-name)
   (date
    :type clsql:wall-time
    :initarg :date
    :accessor task-description)
   (user-id 
    :type integer)
   (tags
    :reader task-tags
    :db-kind :join
    :db-info (
              :join-class task-tag
              :home-key id
              :foreign-key task-id
              :set t))))

(deftable tag ()
  ((id 
    :type integer
    :db-kind :key
    :db-constraints (:not-null :auto-increment)
    :initarg :id)
   (name 
    :type string)))
(deftable task-tag ()
  ((id :type integer
       :db-kind :key
       :db-constraints (:not-null :auto-increment)
       :initarg :id)
   (task-id
    :type integer
    :db-constraints :not-null
    :initarg :task-id)
   (tag-id
    :type integer
    :db-constraints :not-null
    :initarg :tag-id)))
  
(defun add-link (task tag)
  (create-instance 'task-tag :task-id task :tag-id tag))


(let ((me (make-instance 'task)))
  (setf (task-name me) "задача")
  (setf (task-description me) (clsql:w))
  (save me))

(clsql:select 'task :where (clsql:sql-= (clsql:sql-function "date_trunc" "week" (clsql:sql-expression :attribute "date")) )
(clsql:select 'task :where (clsql:sql-= (clsql:sql-function "date_trunc" "week" (clsql:get-date)) (clsql:sql-function "date_trunc" "week" (clsql:sql-expression :attribute "date"))))
