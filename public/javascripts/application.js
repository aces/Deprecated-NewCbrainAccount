

$(
 function() {

   $(document).delegate(".select_all", "click", function(){
     var header_box = $(this);
     var checkbox_class = header_box.attr("data-checkbox-class");

     $('.' + checkbox_class).each(function(index, element) {
        element.checked = header_box.prop('checked');
      });
   });

});

