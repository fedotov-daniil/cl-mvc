;;;; 2011-04-05 20:32:08
(in-package :common-lisp-user)
(defpackage :mvc
  (:nicknames :mvc)
  (:use :cl :iterate :orm :view :core :routing)
  (:export
    #:fname
    #:start
    #:stop
    #:reset
    #:defilter
    #:defcontroller
    #:defroute
    #:defaction
    #:make-view
    #:render-template
    :table
    :deftable
    :create-instance
    :fetch
    :record
    :save
    :save-slots
    :destroy
    :destroy-instance
    :destroy-records
    ))

