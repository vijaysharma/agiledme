// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var estimate_bugs = false;
var estimate_chores = false;

$(document).ready(function () {
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
    $("#add_new_workable_control_button").click(function () {
        $("#icebox").show();
        $("#no_workable_items").hide();
        $("#icebox_new_workable_item_detail").show();
        $("#icebox_control_button").addClass('selected');
    });
    $(".toggleExpandedButton").click(function() {
        var id = $(this).attr('id');
        $("#" + id.replace('editButton', 'preview')).hide();
        $("#" + id.replace('editButton', 'detail')).show();
    });
    $(".cancelEditButton").click(function() {
        var id = $(this).attr('id');
        $("#" + id.replace('cancel_edit_button', 'preview')).show();
        $("#" + id.replace('cancel_edit_button', 'detail')).hide();
    });

    $('.workable_item_type_select').change(function() {
        var id = $(this).attr('id');
        var item_type = $(this).attr('value');
        $("#" + id + "_image").attr('src', "/images/" + $(this).attr('value') + ".png");
        var estimate_id = id.replace("type", "estimate");
        if ((item_type == "Bug" && !estimate_bugs) || (item_type == "Chore" && !estimate_chores)) {
            $("#" + estimate_id).attr("disabled", true);
        } else {
            $("#" + estimate_id).attr("disabled", false);
        }
    });

    $('.workable_item_estimate_select').change(function() {
        var id = $(this).attr('id');
        $("#" + id + "_image").attr('src', "/images/estimate" + $(this).attr('value') + "pt.gif");
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

    $(".new_task_text").focusin(function() {
        $(this).val('');
        $(this).addClass("textAreaFocus");
        var add_link_id = $(this).attr('id').replace('new_task_description', 'new_task_add_link');
        $("#" + add_link_id).show();
    });

    $(".new_task_text").focusout(function() {
        if ($(this).val() == '') {
            $(this).val('add new task');
            $(this).removeClass("textAreaFocus");
            var add_link_id = $(this).attr('id').replace('new_task_description', 'new_task_add_link');
            $("#" + add_link_id).hide();
        }
    });

    $(".titleInputField").focusin(function() {
        if ($(this).val() == 'Enter title of the item') {
            $(this).val('');
        }

    });

    $(".titleInputField").focusout(function() {
        if ($(this).val() == '') {
            $(this).val('Enter title of the item');
        }
    });

    $(".new_comment_text").focusin(function() {
        $(this).val('');
        $(this).addClass("textAreaFocus");
        var add_link_id = $(this).attr('id').replace('new_comment_description', 'new_comment_add_link');
        $("#" + add_link_id).show();
    });

    $(".new_comment_text").focusout(function() {
        if ($(this).val() == '') {
            $(this).val('add new comment');
            $(this).removeClass("textAreaFocus");
            var add_link_id = $(this).attr('id').replace('new_comment_description', 'new_comment_add_link');
            $("#" + add_link_id).hide();
        }
    });

    $(".draggable").draggable({
        addClasses: false,
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
            var droppable_id = $(this).attr('id');

            var item_dropped_id = $(ui.draggable).attr('id');
            var priority_to_set = $("#"+droppable_id.replace('preview', 'priority')).val();
            var id = item_dropped_id.split('_')[2];

            $.ajax({
                type: "PUT",
                url: "/workable_items/" + id + "/update_category_and_priority",
                dataType: "script",
                data: {
                    id: id,
                    workable_item: {priority: (parseInt(priority_to_set) + 1),
                    category: droppable_id.split('_')[0]}
                },
                success: function(data) {
                    $(ui.draggable).insertBefore($("#" + droppable_id));
                    $(ui.draggable).addClass("drag-highlight");
                }
            })
        },
        addClasses: false,
        hoverClass: "drop_target",
        tolerance: 'intersect'
    });

});

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

function flash_notice() {
    $('.notice').fadeOut(4000);
}
