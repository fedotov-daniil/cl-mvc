function setSortable(obj) {
    obj.sortable({axis : "y"});
    obj.find(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
            .find(".portlet-header")
            .addClass("ui-widget-header ui-corner-all")
            .append("<span class='ui-icon ui-icon-circle-plus add-subtask'></span>")
            .append("<span class='ui-icon ui-icon-minusthick'></span>")
            .end()
            .find(".portlet-content");


    var $subtask_dialog = $("#add_dialog").dialog({
        autoOpen: false,
        modal: true,
        buttons: {
            Add: function() {
                addSubtask();
                $(this).dialog("close");
            },
            Cancel: function() {
                $(this).dialog("close");
            }
        },
        open: function() {
            $("#subtask_name").focus();
        },
        close: function() {
            $subtask_form[ 0 ].reset();
            $parent_task = null;
        }
    });
    var $subtask_form = $("form", $subtask_dialog).submit(function() {
        addSubtask();
        $subtask_dialog.dialog("close");
        return false;
    });

    var $parent_task = null;

    function addSubtask() {
        $.ajax({
            url: "tasks/add-subtask/" + $parent_task.attr("id").substr(8),
            dataType: "json",
            data: {
                name : $("#subtask_name").val(),
                priority : $("#subtask_priority").val()
            },
            success: function (data) {
                $.jstree._reference($("#content_" + data.id)).refresh(-1);
            }
        });
    }


    obj.find(".portlet-header .ui-icon").click(function() {
        if ($(this).hasClass("add-subtask")) {
            $parent_task = $(this).closest(".portlet").find(".portlet-content");
            $subtask_dialog.dialog("open");
        }
        else {
            $(this).toggleClass("ui-icon-minusthick").toggleClass("ui-icon-plusthick");
            $(this).parents(".portlet:first").find(".portlet-content").toggle();
        }
    });


}

function initCheckboxes() {
    $(".root_checkbox").hide();
    $(".root_checkbox_unchecked").live("click", function() {
        $(".root_checkbox", $(this).parent()).attr("checked", "checked");
        $.jstree._reference($(this).closest(".portlet").find(".portlet-content")).check_all();
        $(this).attr("class", "root_checkbox_checked");
        $.ajax({
            url:"/tasks/check/" + $(this).closest(".portlet").find(".portlet-content").attr("id").substr(8) + "/true"
        });
    });
    $(".root_checkbox_checked").live("click", function() {
        $(".root_checkbox", $(this).parent()).removeAttr("checked");
        $.jstree._reference($(this).closest(".portlet").find(".portlet-content")).uncheck_all();
        $(this).attr("class", "root_checkbox_unchecked");
        $.ajax({
            url:"/tasks/check/" + $(this).closest(".portlet").find(".portlet-content").attr("id").substr(8) + "/false"
        });
    });
}
function initTree() {
    var $tree = $(".portlet-content").jstree({
        "html_data" : {
            "ajax" : {
                "url" : "/tasks/get-children" ,
                "data" : function(n) {
                    return {id : n.attr ? n.attr("id") : this.data.html_data.original_container_html.context.id.substr(8)};
                }
            }
        },
        "dnd": {
            "drag_finish" : function (node) {
                alert(node);
            }
        },
        "themeroller" : {
            "item_leaf" : false,
            "item_open" : false,
            "item_clsd" : false
        },
        "checkbox":{
          "real_checkboxes" : true
        },
        "plugins" : [ "checkbox", "ui", "dnd", "themeroller", "html_data" ]
    });
    $(".portlet-content").bind("change_state.jstree", function (e, d) {
        $.ajax({
            url:"/tasks/check/" + d.rslt[0].id + ($(d.rslt[0]).hasClass("jstree-checked") ? "/true" : "/false")
        });
    });
}
