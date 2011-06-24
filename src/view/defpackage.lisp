;;;; Created on 2011-06-06 23:38:49
(in-package :common-lisp-user)

(defpackage :view
  (:nicknames :view)
  (:use :cl :json :iterate :core :routing)
  (:export
    #:render-template
    #:render-view
    #:view-params
    #:view-name
    #:view-layout
    :html-view
    :template-view
    :xml-view
    :json-view
    :widget-view
    :javascript-view
    :redirect-view
    :referer-view))