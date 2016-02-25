jQuery(document).ready(
    function () {
        jQuery('input:file').change(
            function () {
                jQuery('button:submit').attr('disabled', !jQuery(this).val());
            }
            );
    });