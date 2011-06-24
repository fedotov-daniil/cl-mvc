;;;; Created on 2011-04-12 22:03:35
; MAIN TODO: controller and action
; CURRENT TODO: action filter stack
(mvc::reset)
(mvc:defcontroller :init)
(in-package :init)
;(defun some-action (&key some variable) (write-to-string (list some variable)))
(defun http-hello-world-2(&rest args)
  (declare (ignore args))
  
  "Привет мир!")

(mvc:defaction some-action (some variable) ()
               (write-to-string *route-params*)
               ;(hunchentoot:abort-request-handler)
               (mvc:make-view (list :vars (list (list :id 1 :name "name"))) :name "template-name" :layout "some" :type :html))


;(mvc:defilter (lambda () (setf (getf *route-params* :some) "value")) :before)
(mvc:defroute "some-route" "" :action "some-action" :controller "init")
(mvc:defroute "some-route1" ":some/:variable" :action "some-action" :controller "init")
(mvc:defroute "some-other-route" ":some/:variable/with-other" :defaults (list :other "value") :action "some-action" :controller "init")
(mvc:start)







(let* ((package (symbol-package (type-of (first (get-tabs nil)))))
       (func (find-symbol (string-upcase "sort-order") package)))
  (when (fboundp func) "found")
  )






