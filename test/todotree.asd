;;;; 2011-05-29 15:16:59
;;;;
;;;; Think of this as your project file.
;;;; Keep it up to date, and you can reload your project easily
;;;;  by right-clicking on it and selecting "Load Project"

(defpackage #:todotree-asd
  (:use :cl :asdf))

(in-package :todotree-asd)

(defsystem todotree
  :name "todotree"
  :version "0.1"
  :serial t
  :components ((:module "model"
                 :components ((:file "defpackage")
                              (:file "database" :depends-on ("defpackage"))
                              (:file "tables" :depends-on ("defpackage"))
                              (:file "CRUD" :depends-on ("defpackage" "tables"))
                              (:file "send-mail" :depends-on ("defpackage"))
                              (:file "user" :depends-on ("defpackage" "send-mail"))
                              (:file "tasks" :depends-on ("defpackage" "CRUD"))
                              (:file "tabs" :depends-on ("defpackage" "CRUD"))                              
                              ))
               (:file "defpackage")
               (:file "authorization" :depends-on ("defpackage"))
               (:file "routes" :depends-on ("defpackage"))
               (:file "dash" :depends-on ("defpackage" "authorization"))
               (:file "tabs" :depends-on ("defpackage" "authorization"))
               (:file "tasks" :depends-on ("defpackage" "authorization"))
               (:file "start"))
  :depends-on (#:mvc #:ironclad #:local-time #:cl-smtp))
