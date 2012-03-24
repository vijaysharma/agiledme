// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var estimate_bugs = false;
var view = "project";
var estimate_chores = false;
var current_offset = 15;
var done_offset = 15;
var backlog_offset = 15;
var icebox_offset = 15;


DraggableDroppable = function() {
    return {
        init : function() {
            $(".draggable").draggable({
                start: function(event, ui) {
                    $(this).addClass('drag-highlight');
                },
                stop: function(event, ui) {
                    $(this).removeClass('drag-highlight');
                },
                zIndex: 9999,
                revert: true,
                revertDuration: 10,
                containment: "#all_panels",
                opacity: 0.7,
                helper: "clone",
                cursor: "move"
            });

            $(".droppable").droppable({
                drop: function(event, ui) {
                    var item_dropped_on = $(this);
                    var item_project_id = $(this).attr('project_id');
                    var item_dropped_on_id = item_dropped_on.attr('id').split('_')[0];
                    var item_dropped_id = $(ui.draggable).attr('id').split('_')[0];
                    $.ajax({
                        type: "PUT",
                        url: "/projects/" + item_project_id + "/workable_items/" + item_dropped_id + "/update_category_and_priority",
                        dataType: "script",
                        data: {
                            item_dropped_on_id: item_dropped_on_id
                        },
                        success: function(data) {
                            $(ui.draggable).insertBefore(item_dropped_on);
                        }
                    })
                },
                addClasses: false,
                hoverClass: "drop_target",
                tolerance: 'intersect'
            });
        }
    }

}();

JQueryFileUpload = function() {
    return {
        init : function() {
            // Initialize the jQuery File Upload widget:
            $('.fileupload').fileupload({
                maxNumberOfFiles: 10,
                acceptFileTypes: /\.(jpg|jpeg|gif|png|JPG|JPEG|GIF|PNG)$/
            });

            // Open download dialogs via iframes, to prevent aborting current uploads:
            $('.fileupload .files a:not([target^=_blank])').live('click', function (e) {
                e.preventDefault();
                $('<iframe style="display:none;"></iframe>')
                        .prop('src', this.href)
                        .appendTo('body');
            });

            $('.fileupload').bind('fileuploadprogressall', function (e, data) {
                var progress = parseInt(data.loaded / data.total * 100, 10);
                console.info(progress);
            });
        }
    }

}();

// Global ajax activity indicators.
$(document).ajaxStart(
        function() {
            $(".spinner").show()
        }).ajaxStop(function() {
    DraggableDroppable.init();
    JQueryFileUpload.init();
    $(".spinner").hide();
});


function attachTokenInput(item) {
    item.tokenInput(item.data("url"), {
        crossDomain: false,
        prePopulate: item.data("pre"),
        theme: "facebook",
        hintText: "Start typing label name",
        preventDuplicates: true
    });
}
$(document).ready(function () {
    DraggableDroppable.init();
    JQueryFileUpload.init();

    $("#backlog_close").click(function () {
        $("#backlog").hide();
        $("#backlog_control_button").removeClass('selected');
    });

    $("#current_close").click(function () {
        $("#current").hide();
        $("#current_control_button").removeClass('selected');
    });

    $("#done_close").click(function () {
        $("#done").hide();
        $("#done_control_button").removeClass('selected');
    });

    $("#icebox_close").click(function () {
        $("#icebox").hide();
        $("#icebox_control_button").removeClass('selected');
    });

    $("#dev_ready_close").click(function () {
        $("#dev_ready").hide();
        $("#dev_ready_control_button").removeClass('selected');
    });

    $("#in_progress_close").click(function () {
        $("#in_progress").hide();
        $("#in_progress_control_button").removeClass('selected');
    });

    $("#dev_done_close").click(function () {
        $("#dev_done").hide();
        $("#dev_done_control_button").removeClass('selected');
    });

    $("#qa_ready_close").click(function () {
        $("#qa_ready").hide();
        $("#qa_ready_control_button").removeClass('selected');
    });

    $("#qa_done_close").click(function () {
        $("#qa_done").hide();
        $("#qa_done_control_button").removeClass('selected');
    });

    $("#backlog_control_button").click(function () {
        $("#backlog").toggle();
        $("#backlog_control_button").toggleClass('selected');
    });

    $("#current_control_button").click(function () {
        $("#current").toggle();
        $("#current_control_button").toggleClass('selected');
    });

    $("#done_control_button").click(function () {
        $("#done").toggle();
        $("#done_control_button").toggleClass('selected');
    });

    $("#icebox_control_button").click(function () {
        $("#icebox").toggle();
        $("#icebox_control_button").toggleClass('selected');
    });

    $("#dev_ready_control_button").click(function () {
        $("#dev_ready").toggle();
        $("#dev_ready_control_button").toggleClass('selected');
    });

    $("#in_progress_control_button").click(function () {
        $("#in_progress").toggle();
        $("#in_progress_control_button").toggleClass('selected');
    });

    $("#dev_done_control_button").click(function () {
        $("#dev_done").toggle();
        $("#dev_done_control_button").toggleClass('selected');
    });

    $("#qa_ready_control_button").click(function () {
        $("#qa_ready").toggle();
        $("#qa_ready_control_button").toggleClass('selected');
    });

    $("#qa_done_control_button").click(function () {
        $("#qa_done").toggle();
        $("#qa_done_control_button").toggleClass('selected');
    });

    $("#burndown_control_button").click(function () {
        $("#burndown").toggle();
        $("#sprint_panels").toggle();
        $("#burndown_control_button").toggleClass('selected');
    });

    $(".labels").each(function () {
        attachTokenInput($(this));
    });


    $(document).delegate("#add_new_workable_control_button", "click", function () {
        $("#icebox").show();
        $("#no_workable_items").hide();
        $("#icebox_new_workable_item_detail").show();
        $("#icebox_control_button").addClass('selected');
    });

    $(document).delegate('.workable_item_type_select', "change", function() {
        var id = $(this).attr('id');
        var item_type = $(this).attr('value');
        $("#" + id + "_image").attr('src', "/images/" + $(this).attr('value').toLowerCase() + ".png");
        var estimate_id = id.replace("type", "estimate");
        if ((item_type == "Bug" && !estimate_bugs) || (item_type == "Chore" && !estimate_chores)) {
            $("#" + estimate_id).attr("disabled", true);
        } else {
            $("#" + estimate_id).attr("disabled", false);
        }
    });

    $(document).delegate('.member_role', "change", function() {
        var id = $(this).attr('id');
        var project_id = $("#" + id + "_project").val();
        var role = $(this).val();
        $.ajax({
            type: "PUT",
            url: "/projects/" + project_id + "/project_users/" + id,
            dataType: "script",
            data: {
                project_user: {role: role}
            }
        })
    });

    $(document).delegate(".workable_item_estimate_select", "change", function() {
        var id = $(this).attr('id');
        $("#" + id + "_image").attr('src', "/images/estimate" + $(this).attr('value') + "pt.gif");
    });

    $(document).delegate(".toggleExpandedButton", "click", function() {
        var id = $(this).attr('id');
        $("#" + id.replace('editButton', 'preview')).hide();
        $("#" + id.replace('editButton', 'detail')).show();
    });

    $(document).delegate(".cancelEditButton", "click", function() {
        var id = $(this).attr('id');
        $("#" + id.replace('cancel_edit_button', 'preview')).show();
        $("#" + id.replace('cancel_edit_button', 'detail')).hide();
        $("#" + id.replace('cancel_edit_button', 'workable_item_error_message')).hide();
        $("#" + id.replace('cancel_edit_button', 'workable_item_error_message')).html('');

    });

    $(document).delegate(".workable_item_tasks", "mouseenter", function() {
        var id = $(this).attr('id');
        var task_description_id = $(this).attr('id').replace("task", "task_description");
        if (!$("#" + id.replace("task", "task_finish")).attr('checked')) {
            if ($("#" + task_description_id).is(":hidden")) {
                $("#" + id + "_actions").show();
            }

        }
    });

    $(document).delegate(".workable_item_tasks", "mouseleave", function() {
        var id = $(this).attr('id');
        $("#" + id + "_actions").hide();
    });


    $(document).delegate(".commentInfo", "mouseenter", function() {
        $("#" + $(this).attr('id').replace("comment", "delete_comment")).show();
    });

    $(document).delegate(".commentInfo", "mouseleave", function() {
        $("#" + $(this).attr('id').replace("comment", "delete_comment")).hide();
    });

    $(document).delegate(".delete_comment", "click", function() {

        var delete_comment_checkbox = $("#" + $(this).attr('id').replace("delete_comment", "delete_comment_checkbox"));

        if (delete_comment_checkbox.attr('checked')) {
            //trying to mark comment for non deletion
            $(delete_comment_checkbox).attr('checked', false);
            $(this).parent().parent().removeClass('item_to_delete');
        } else {
            //trying to mark task for deletion
            $(delete_comment_checkbox).attr('checked', true);
            $(this).parent().parent().addClass('item_to_delete');
        }
    });

    $(document).delegate(".delete_image", "click", function() {

        var delete_image_checkbox = $("#" + $(this).attr('id').replace("delete_image", "delete_image_checkbox"));
        var image_details = $("#" + $(this).attr('id').replace("delete_image", "image_details"));

        $(delete_image_checkbox).attr('checked', true);
        image_details.hide();
    });

    $(document).delegate(".delete_task", "click", function() {
        var finish_task_id = $(this).attr('id').replace('delete_task', 'task_finish');
        var edit_task_id = $(this).attr('id').replace('delete_task', 'edit_task');

        if ($($(this).children("input:checkbox")[0]).attr('checked')) {
            //trying to mark task for non deletion
            $("#" + finish_task_id).show();
            $("#" + edit_task_id).show();
            $($(this).children("input:checkbox")[0]).attr('checked', false);
            $(this).parent().parent().removeClass('item_to_delete');
        } else {
            //trying to mark task for deletion
            $("#" + finish_task_id).hide();
            $("#" + edit_task_id).hide();
            $($(this).children("input:checkbox")[0]).attr('checked', true);
            $(this).parent().parent().removeClass('finished_task');
            $(this).parent().parent().addClass('item_to_delete');
        }
    });

    $(document).delegate(".edit_task", "click", function() {
        var task_description_id = $(this).attr('id').replace("edit_task", "task_description");
        $("#" + task_description_id).show();

        var task_label_id = $(this).attr('id').replace("edit_task", "task_label");
        $("#" + task_label_id).hide();

        var task_id = $(this).attr('id').replace("edit_task", "task");

        var task_actions_id = $(this).attr('id').replace('edit_task', 'task_actions');
        $("#" + task_actions_id).hide();
    });

    $(document).delegate(".finish_task", "click", function() {
        var task_actions_id = $(this).attr('id').replace('task_finish', 'task_actions');
        if ($(this).attr('checked')) {
            $(this).attr('checked', true);
            $(this).parent().addClass('finished_task');
            $("#" + task_actions_id).hide();
        } else {
            $(this).attr('checked', false);
            $(this).parent().removeClass('finished_task');
            $("#" + task_actions_id).show();
        }

    });

    $(document).delegate(".notice", flash_notice());

    $(document).delegate(".titleInputField", "focusin", function() {
        if ($(this).val() == "As a \<role\>, I want \<goal/desire\> so that \<benefit\>") {
            $(this).val('');
        }
    });

    $(document).delegate(".titleInputField", "focusout", function() {
        if ($(this).val() == '') {
            $(this).val("As a \<role\>, I want \<goal/desire\> so that \<benefit\>");
        }
    });

    $(document).delegate(".new_comment_text", "focusin", function() {
        if ($(this).val() == 'add new comment') {
            $(this).val('');
            $(this).addClass("textAreaFocus");
            var add_link_id = $(this).attr('id').replace('new_comment_description', 'new_comment_add_link');
            $("#" + add_link_id).show();
        }

    });

    $(document).delegate(".new_comment_text", "focusout", function() {
        if ($(this).val() == '') {
            $(this).val('add new comment');
            $(this).removeClass("textAreaFocus");
            var add_link_id = $(this).attr('id').replace('new_comment_description', 'new_comment_add_link');
            $("#" + add_link_id).hide();
        }
    });

    $(document).delegate(".new_task_text", "focusin", function() {
        if ($(this).val() == 'add new task') {
            $(this).val('');
            $(this).addClass("textAreaFocus");
            var add_link_id = $(this).attr('id').replace('new_task_description', 'new_task_add_link');
            $("#" + add_link_id).show();
        }
    });

    $(document).delegate(".new_task_text", "focusout", function() {
        if ($(this).val() == '') {
            $(this).val('add new task');
            $(this).removeClass("textAreaFocus");
            var add_link_id = $(this).attr('id').replace('new_task_description', 'new_task_add_link');
            $("#" + add_link_id).hide();
        }
    });


//    New Project Modal =======================================

    $("#new_project_form:ui-dialog").dialog("destroy");

    var name = $("#name"),
            description = $("#description"),
            start_date = $("#start_date"),
            allFields = $([]).add(name).add(description).add(start_date),
            tips = $(".validateTips");

    function updateTips(t) {
        tips
                .text(t)
                .addClass("ui-state-highlight");
        setTimeout(function() {
            tips.removeClass("ui-state-highlight", 1500);
        }, 500);
    }

    function checkLength(object, object_name, min, max) {
        if (object.val().length > max || object.val().length < min) {
            object.addClass("ui-state-error");
            updateTips("Length of " + object_name + " must be between " +
                    min + " and " + max + ".");
            return false;
        } else {
            return true;
        }
    }

    $("#new_project_form").dialog({
        autoOpen: false,
        height: 350,
        width: 537,
        modal: true,
        addClasses:false,
        buttons: {
            "Create Project": function() {
                var bValid = true;
                allFields.removeClass("ui-state-error");
                bValid = bValid && checkLength(name, "name", 3, 100);

                if (bValid) {
                    $("#new_project").submit();
                    $(this).dialog("close");
                }
            },
            Cancel: function() {
                $(this).dialog("close");
            }
        },
        close: function() {
            allFields.val("").removeClass("ui-state-error");
        }
    });

    $("#create_new_project_button")
            .button()
            .click(function() {
        $("#new_project_form").dialog("open");
    });

//    =======================================

    $(".helpIcon").tooltip({
        effect: 'slide',
        relative: true,
        offset: [15,15],
        position: 'center, right',
        delay: 500,
        predelay: 500
    });

    $('.scrolling_item_list').endlessScroll({
        fireOnce: false,
        callback: function(p) {
            var category = $(this).attr('category');
            var offset = 0;
            if(category == "current"){
                current_offset = current_offset + 15;
                offset = current_offset;
            }
            if(category == "icebox"){
                icebox_offset = icebox_offset + 15;
                offset = icebox_offset;
            }
            if(category == "done"){
                done_offset = done_offset + 15;
                offset = done_offset;
            }
            if(category == "backlog"){
                backlog_offset = backlog_offset + 15;
                offset = backlog_offset;
            }
            $.ajax({
                type: "GET",
                url: "/projects/" + $(this).attr('project_id') + "/show_more_items",
                dataType: "script",
                data: {
                    category : category,
                    offset : offset
                }
            });
        }
    });

});

function draw_burndown_chart(chart_point_start, chart_point_interval, actual_chart_data_series, idle_chart_data_series) {
    new Highcharts.Chart({
        chart: {
            renderTo: 'burndown_chart'
        },
        title: {
            text: 'Burndown Chart'
        },
        xAxis: {
            gridLineWidth: 1,
            lineColor: '#000',
            tickColor: '#000',
            type: "datetime",
            title: {
                text: 'Sprint'
            }
        },
        yAxis: {
            minorTickInterval: 'auto',
            lineColor: '#000',
            lineWidth: 1,
            tickWidth: 1,
            tickColor: '#000',
            min: 0,
            title: {
                text: 'Velocity'
            }
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'top',
            floating: true,
            shadow: true
        },

        series: [
            {
                name: "Actual",
                pointStart: chart_point_start,
                pointInterval: chart_point_interval,
                data: actual_chart_data_series
            },
            {
                name: "Idle",
                pointStart: chart_point_start,
                pointInterval: chart_point_interval,
                data: idle_chart_data_series
            }
        ]
    });
}

function draw_velocity_trend_chart(chart_point_start, chart_point_interval, chart_data_series) {
    new Highcharts.Chart({
        chart: {
            renderTo: 'velocity_chart',
            defaultSeriesType: 'column'
        },
        title: {
            text: 'Velocity Trend'
        },
        xAxis: {
            type: "datetime",
            title: {
                text: 'Sprint'
            }
        },
        yAxis: {
            title: {
                text: 'Velocity'
            }
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'top',
            floating: true,
            shadow: true
        },

        plotOptions: {
            column: {
                pointPadding: 0.0,
                borderWidth: 0
            }
        },
        series: [
            {
                name: "Points",
                pointStart: chart_point_start,
                pointInterval: chart_point_interval,
                data: chart_data_series
            }
        ]
    });
}

function add_task_fields(link, association, content) {
    var new_id = new Date().getTime();
    var id_regexp = new RegExp("new_" + association, "g");

    var tasks_list_id = $(link).attr('id').replace("add_task", "tasks");
    $("#" + tasks_list_id).prepend(content.replace(id_regexp, new_id + "_" + association));

    var new_task_description_id = $(link).attr('id').replace("add_task", "new_task_description");
    $("#" + new_id + "_task_description").val($("#" + new_task_description_id).val());

    var new_task_label_id = $(link).attr('id').replace("add_task", "task_label");
    $("#" + new_id + "_task_label").text($("#" + new_task_description_id).val());
}

function add_comment_fields(link, association, content) {
    var new_id = new Date().getTime();
    var id_regexp = new RegExp("new_" + association, "g");

    var comments_list_id = $(link).attr('id').replace("add_comment", "comments");
    $("#" + comments_list_id).prepend(content.replace(id_regexp, new_id + "_" + association));

    var new_comment_description_id = $(link).attr('id').replace("add_comment", "new_comment_description");
    $("#" + new_id + "_comment_description").val($("#" + new_comment_description_id).val());

    var new_comment_label_id = $(link).attr('id').replace("add_comment", "comment_label");
    $("#" + new_id + "_comment_label").text($("#" + new_comment_description_id).val());
}

function ajax_flash_notice(message) {
    $(".notice").text(message);
    $(".notice").show();
    flash_notice();
}

function highlight_item(item) {
    item.effect("highlight", {color: "#ffd900"}, 2000);
}

function flash_notice() {
    $('.notice').fadeOut(4000);
}