;;;; 2011-05-28 20:35:00


(in-package :common-lisp-user)

(defpackage :orm
  (:use :cl)
  (:import-from :orm-table
    :table
    :deftable
    :create-instance
    :fetch
    :destroy-instance
    :destroy-records
    )
  (:import-from :orm-record
    :record
    :save
    :save-slots
    :destroy)
  (:export 
    :table
    :deftable
    :create-instance
    :fetch
    :record
    :save
    :save-slots
    :destroy
    :destroy-instance
    :destroy-records))
(in-package :orm)

