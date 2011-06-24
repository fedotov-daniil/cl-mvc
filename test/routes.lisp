;;;; Created on 2011-06-10 20:14:51
(defroute "tab-content" "/tabs/content/:id"  :action "content" :controller "tabs")
(defroute "delete-tab" "/tabs/delete/:id" :action "delete-action" :controller "tabs")
(defroute "create-tab" "/tabs/create" :action "create" :controller "tabs")
(defroute "task-children" "/tasks/get-children" :action "get-children" :controller "tasks")
(defroute "delete-task" "/tasks/delete-completed/:tab-id" :action "delete-completed" :controller "tasks")
(defroute "add-task" "/tasks/add/:tab-id" :action "add" :controller "tasks")
(defroute "check-task" "/tasks/check/:id/:checked" :action "check" :controller "tasks")
(defroute "add-subtask" "/tasks/add-subtask/:parent-id" :action "add-subtask" :controller "tasks")