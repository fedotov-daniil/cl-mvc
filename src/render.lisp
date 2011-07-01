;;;; Created on 2011-05-15 16:36:12
(in-package :mvc)

(defmethod render-view ((text string))
  text)

(defmethod render-view ((view-func function))
  (funcall view-func))

(defmethod render-view :before ((code integer))
  (setf (hunchentoot:return-code*) code))

(defmethod render-view ((octets vector))
  octets)

(defmethod render-view ((file pathname))
  (if (probe-file file)
      (hunchentoot:handle-static-file file
                                      (or (hunchentoot:mime-type file)
                                          (hunchentoot:content-type hunchentoot:*reply*)))
      (not-found-if-not nil)))

(defmethod render-view ((object (eql nil)))
  (render-view hunchentoot:+http-not-found+))

(defmethod render-view (object)
  (error "Unknown as render ~A " object))

(defmethod render-view ((data list)))

(defmethod render-view ((view template-view))
  (render-template (not-found-if-not (view-name view)) (view-params view)))

(defmethod render-view ((view json-view))
  (json:encode-json-plist-to-string (view-params view)))

(defmethod render-view :around ((view html-view))
  (if (ajax-request-p)
      (progn 
        (hunchentoot:no-cache) 
        (call-next-method))
      (progn
        (render-template (not-found-if-not (view-layout view)) (append (list :template (view-name view)) (view-params view)))            
        )))

(defmethod render-view ((view redirect-view))
  (hunchentoot:redirect (redirect-view-url view)))
