String.IsNullOrEmpty = function(value) {
    var isNullOrEmpty = true;
    if (value) {
        if (typeof (value) == 'string') {
            if (value.length > 0)
                isNullOrEmpty = false;
        }
    }
    return isNullOrEmpty;
}
var $tabs = null;
function initTabs() {
    var $tab_title_input = $("#tab_title"),
            $tab_type_select = $("#tab_type"),
            $tab_date_input = $("#tab_date");
    var tab_counter = $("#tabs > div").length;

    $tabs = $("#tabs").tabs({
        ajaxOptions: {
            error: function(xhr, status, index, anchor) {
                $(anchor.hash).html(
                        "Couldn't load this tab. We'll try to fix this as soon as possible. " +
                                "If this wouldn't be a demo.");
            },
            success: function() {
                $(".btn_task").button();
                setSortable($(".column"));
                initTree();
                initCheckboxes();
                initClear();
            }

        },
        tabTemplate: "<li><a href='#{href}'>#{label}</a> <span class='ui-icon ui-icon-close'>Remove Tab</span></li>",
        add: function(event, ui) {
            //Logic to add new context
        }
    });
    $tabs.addClass('ui-tabs-vertical ui-helper-clearfix').find(".ui-tabs-nav").sortable({ axis: "y" });
    $("#tabs li").removeClass('ui-corner-top').addClass('ui-corner-left');

    var $dialog = $("#dialog").dialog({
        autoOpen: false,
        modal: true,
        buttons: {
            Add: function() {
                addTab();
                $(this).dialog("close");
            },
            Cancel: function() {
                $(this).dialog("close");
            }
        },
        open: function() {
            $tab_title_input.focus();
        },
        close: function() {
            $form[ 0 ].reset();
        }
    });


    function addTab() {
        var tab_title = $tab_title_input.val() || "Tab " + tab_counter;
        //TODO AJAX TAB CREATE
        $.ajax({
            url: "/tabs/create",
            data: { name: tab_title, type : $tab_type_select.val(), date: $tab_date_input.val() },
            success: addTabSuccess,
            type : "POST",
            dataType: "json"
        });
        $("#tab_placeholder").show();
    }

    function addTabSuccess(data) {
        $("#tab_placeholder").hide();
        if (data.id) {
            var tab_id = data.id;
            var tab_name = data.name;
            $tabs.tabs("add", "/tabs/load/" + tab_id, tab_name);
            $tab_title_input.val("");
            tab_counter++;
            $("#tabs > .ui-tabs-nav").append($("#tab_placeholder"));
            $("#tabs > .ui-tabs-nav").append($("#unsorted"));
            $("#tabs > .ui-tabs-nav").append($("#add_tab_li"));

            $("#task_tab").append($("option").val(data.id).text(data.name));

        }
    }

    var $form = $("form", $dialog).submit(function() {
        addTab();
        $dialog.dialog("close");
        return false;
    });


    $("#add_tab")
            .button()
            .click(function() {
                $dialog.dialog("open");
            });
    $("#tabs span.ui-icon-close").live("click", function() {
        $.ajax({
            url: "/tabs/delete/" + $(this).closest("li").find("input:hidden").val(),
            method: "POST",
            dataType: "json",
            success: function(data) {
                var index = $("li", $tabs).index($("input:hidden[value=" + data.id + "]", $tabs).closest("li"));
                $tabs.tabs("remove", index);
                $("#task_tab").remove($("#task_tab option[value='" + data.id + "']"));
            }
        });

    });
    $tab_type_select.change(function () {
        if ($tab_type_select.val() == "CUSTOM") {
            $tab_date_input.show();
            $("label[for='tab_date']").show();
        }
        else {
            $tab_date_input.hide();
            $("label[for='tab_date']").hide();
        }
    });
    $tab_date_input.datepicker({ minDate: -2, maxDate: "+1Y" });
}

function initAdd() {
    $("#task_date").datepicker({ minDate: -2, maxDate: "+1Y" });
    $(".btn_task").button();
    $(".btn_task").live("load", function() {
        this.button()
    });
    $("#toggle_extended").click(function() {
        $('.extanded_add_task').toggle();
        $('.ui-icon', $(this)).toggleClass('ui-icon-triangle-1-e').toggleClass('ui-icon-triangle-1-se');
        return false;
    });
    $(".extanded_add_task").toggle();
}
function addTask() {
    var task_name = $("#task_name").val();
    var task_tab = $("#task_tab").val();
    var task_priority = $("#extended_add_task").is(":visible") ? $("#task_priority").val() : "Normal";
    var task_date = $("#extended_add_task").is(":visible") ? $("#task_date").val() : "";
    $.ajax({
        url : "/tasks/add/" + $("#task_tab").val(),
        method : "POST",
        data:{
            name: task_name,
            priority: task_priority,
            date: task_date
        },
        dataType: "json",
        success: function(data) {
            if ($("#tab_" + data.tabId).length > 0) {
                $tabs.tabs("load", $("div", $tabs).index($("#tab_" + data.tabId)));
            }
        }
    });
}
function initClear() {
    $(".delete_completed").click(function() {
        $.ajax(
                {
                    url: "tasks/delete-completed/" + $(this).closest(".ui-tabs-panel").attr("id").substr(4),
                    type: "GET",
                    dataType: "json",
                    success: function(data) {
                        if ($("#tab_" + data.tabId).length > 0) {
                            $tabs.tabs("load", $tabs.index($("#tab_" + data.tabId)));
                        }
                    }
                }
        );
    });
}


