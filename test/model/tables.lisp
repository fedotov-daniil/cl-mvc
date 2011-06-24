;;;; Created on 2011-05-30 14:34:58
(in-package :todotree-model)

(deftable user ()
  ((id
    :type integer
    :db-kind :key
    :db-constraints (:not-null :auto-increment)
    :accessor id
    :initarg :id)
   (email
    :type string
    :accessor user-email)
   (password
    :type string
    :accessor user-password)
   (first-name 
    :type string
    :initform ""
    :accessor user-first-name)
   (last-name 
    :type string
    :initform ""
    :accessor user-last-name)))
(deftable task ()
  ((id 
    :type integer
    :db-kind :key
    :db-constraints (:not-null :auto-increment)
    :initarg :id
    :accessor id)
   (name 
    :type string
    :initarg :name
    :accessor task-name)
   (user-id 
    :type integer
    :initarg :user-id
    :accessor task-user-id)
   (priority 
    :type keyword
    :initarg :priority
    :accessor task-priority)
   (date-due
    :type clsql:date
    :initarg :date-due
    :accessor task-date-due)
   (completed
    :type boolean
    :initarg :completed
    :accessor task-completed)
   (tab-id
    :type integer
    :initform 0
    :initarg :tab-id
    :accessor task-tab-id)
   (parent-task-id
    :type integer
    :initform 0
    :initarg :parent-task-id
    :accessor task-parent-task-id)))
(deftable tab ()
  ((id 
    :type integer
    :db-kind :key
    :db-constraints (:not-null :auto-increment)
    :accessor id
    :initarg :id)
   (name
    :type string
    :initarg :name
    :accessor tab-name)
   (sort-order 
    :type integer
    :initarg :sort-order
    :accessor tab-sort-order)
   (type 
    :type keyword
    :initarg :type
    :accessor tab-type)
   (date
    :type clsql:date
    :initarg :date
    :accessor tab-date)
   (user-id
    :type integer
    :initarg :user-id
    :accessor tab-user-id)
   (tasks
    :db-kind :virtual
    :accessor tab-tasks
    :initform nil)))
