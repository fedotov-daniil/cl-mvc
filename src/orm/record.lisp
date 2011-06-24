;;;; Created on 2011-05-28 20:40:19
(defpackage :orm-record
  (:use :cl)
  (:import-from :clsql
    :update-records-from-instance
    :update-record-from-slots
    :delete-instance-records))
(in-package :orm-record)
(cl-annot:enable-annot-syntax)
@export
(defclass record () ()
  (:documentation "Class for table instances, represents database record."))
@export
(defmethod save ((rec record))
  "Save this instance and reflect slot values to database."
  (update-records-from-instance rec)
  rec)
@export
(defmethod save-slots ((rec record) slots)
  "Save this instance and reflect slot values to database."
  (update-record-from-slots rec slots)
  rec)
@export
(defun pkey-name (view-class-name)
  (clsql-sys::slot-definition-name (car (clsql-sys::keyslots-for-class (find-class view-class-name)))))
@export
(defmethod destroy ((rec record))
  "Delete this instance from the database.
I want to use `delete' for this name, but it is already used in very famous package :p."
  (delete-instance-records rec))
@export
(defmethod destroy ((nothing null))
  nothing)
@export
(defmethod attributes ((rec record))
  "Return a list of slot names."
  (list-attributes rec))