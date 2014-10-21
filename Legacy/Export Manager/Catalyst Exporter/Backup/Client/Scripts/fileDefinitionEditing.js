function AdjustNameIndexes() {
    var defs = $(".studySet");
    for (var j = 0; j < defs.length; j++) {
        var study = $(defs[j]).attr("id").substr(8);
        var rows = $(".row" + study);
        for (var i = 0; i < rows.length; i++) {
            $.each($(rows[i]).find("input:not(:checkbox)"), function () {
                var name = $(this).attr("name");
                $(this).attr("name", name.replace(/{i}/g, i).replace(/{j}/g, j));
                if (endsWith(name, "ColumnOrder")) {
                    $(this).val(i);
                }
            });
            var replacements = $(rows[i]).find("tr");
            for (var x = 0; x < replacements.length; x++) {
                $.each($(replacements[x]).find("input:not(:checkbox)"), function () {
                    var name = $(this).attr("name");
                    $(this).attr("name", name.replace(/{x}/g, x));
                });
            }
        }
    }
}

function endsWith(str, suffix) {
    return str.indexOf(suffix, str.length - suffix.length) !== -1;
}

function selectAll(studyId, areaName) {
    if ($("#" + areaName + "SelectAll" + studyId).is(":checked")) {
        $("#" + areaName + "SelectedFields" + studyId + " > tbody > .row" + studyId).find(":checkbox").attr("checked", "checked");
    } else {
        $("#" + areaName + "SelectedFields" + studyId + " > tbody > .row" + studyId).find(":checkbox").removeAttr("checked");
    }
}

function moveOptionsRight(studyId, objectName, areaName) {
    var newrow = '<tr class="row' + studyId + '"><td><input type="checkbox" /></td>'
    + '<td>{FieldName}<input name="' + objectName + '.Columns[{i}].Id" type="hidden" value="0" />'
    + '<input class="hiddenName" name="' + objectName + '.Columns[{i}].FieldName" type="hidden" value="{FieldName}" />'
    + '<input name="' + objectName + '.Columns[{i}].ColumnOrder" type="hidden" value="{i}" /></td>'
    + '<td><input name="' + objectName + '.Columns[{i}].DisplayName" type="text" value="{FieldName}" /></td>'
    + '<td><table></table><a href="#" class="addReplacement" onclick="addReplacement($(this), \'' + objectName + '\'); return false;">+ Add Replacement </a></td></tr>';

    var selectOptions = $("#" + areaName + "Fields" + studyId).children(":selected");
    $(selectOptions).remove();

    var toSelectList = $("#" + areaName + "ColumnDefs" + studyId);
    for (var i = 0; i < selectOptions.length; i++) {
        var row = newrow.replace(/{FieldName}/g, selectOptions[i].value);
        toSelectList.append(row);
    }
}

function moveOptionsLeft(studyId, areaName) {
    var selectOptions = $("#" + areaName + "SelectedFields" + studyId + " > tbody > .row" + studyId).has(':checkbox:checked');
    $(selectOptions).remove();

    for (var i = 0; i < selectOptions.length; i++) {
        $("#" + areaName + "Fields" + studyId).append("<option>" + $(selectOptions[i]).find(".hiddenName").val() + "</option>");
    }
}

function moveOptionsUp(tbody) {
    var selectOptions = tbody.children("tr");
    for (var i = 1; i < selectOptions.length; i++) {
        var opt = $(selectOptions[i]);
        if (opt.find(":checkbox").is(":checked")) {
            opt.remove();
            opt.insertBefore(tbody.children("tr")[i - 1]);
        }
    }
}

function moveOptionsDown(tbody) {
    var selectOptions = tbody.children("tr");
    for (var i = selectOptions.length - 2; i >= 0; i--) {
        var opt = $(selectOptions[i]);
        if (opt.find(":checkbox").is(":checked")) {
            opt.remove();
            opt.insertAfter(tbody.children("tr")[i]);
        }
    }
}

function addValidation(scheduled) {
    if (scheduled == "True") {
        //Add validation to interval and run day
        $("#Schedule_Interval").attr("data-val", "true");
        $("#Schedule_Interval").attr("data-val-required", "The Interval field is required.");
        $("#Schedule_RunDay").attr("data-val", "true");
        $("#Schedule_RunDay").attr("data-val-required", "The Run Day field is required.");
    } else {
        //Add validation to Start and End date
        $("#StartDate").attr("data-val", "true");
        $("#StartDate").attr("data-val-required", "The Start Date field is required.");
        $("#EndDate").attr("data-val", "true");
        $("#EndDate").attr("data-val-required", "The End Date field is required.");
    }
    $("form").removeData("validator");
    $("form").removeData("unobtrusiveValidation");
    $.validator.unobtrusive.parse("form");
}

function addReplacement(link, objectName) {
    var newrow = '<tr><td><input name="' + objectName + '.Columns[{i}].Replacements[{x}].Id" type="hidden" value="0" />'
    + '<input name="' + objectName + '.Columns[{i}].Replacements[{x}].ColumnDefinitionId" type="hidden" value="0" />'
    + '<input name="' + objectName + '.Columns[{i}].Replacements[{x}].OldText" placeholder="find" type="text" value="" /></td>'
    + '<td><input name="' + objectName + '.Columns[{i}].Replacements[{x}].NewText" placeholder="replace" type="text" value="" /></td>'
    +'<td><a href="#" onclick="removeReplacement($(this).parent(\'td\').parent(\'tr\')); return false;">X</a></td></tr>';

    var grid = link.siblings("table");
    grid.append(newrow);
}

function removeReplacement(row) {
    row.remove();
}
