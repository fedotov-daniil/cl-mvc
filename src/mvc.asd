;;;; 2011-04-05 20:32:08
;;;;
;;;; Think of this as your project file.
;;;; Keep it up to date, and you can reload your project easily
;;;;  by right-clicking on it and selecting "Load Project"

(defpackage #:mvc-asd
  (:use :cl :asdf))

(in-package :mvc-asd)

(defsystem mvc
  :name "mvc"
  :version "0.1"
  :serial t
  :components ((:module "orm"
                 :components ((:file "record")
                              (:file "table" :depends-on ("record"))
                              (:file "defpackage"  :depends-on ("table"))))
               (:file "core")
               (:file "routing" :depends-on ("core"))
               (:module "view"
                 :components ((:file "defpackage")
                              (:file "view" :depends-on ("defpackage"))
                              (:file "template" :depends-on ("defpackage"))
                              (:file "render" :depends-on ("defpackage" "view" "template")))
                 :depends-on ("core" "routing"))
               (:file "defpackage" :depends-on ("core" "routing"))
               ;(:file "debug"  :depends-on ("defpackage"))
               (:file "extensions" :depends-on ("defpackage"))
               (:file "controller" :depends-on ("defpackage" "core" "extensions" "view"))
               (:file "dispatcher" :depends-on ("defpackage" "controller")))
  :depends-on ( #:hunchentoot #:routes #:yaclml #:cl-json #:clsql #:cl-annot))
