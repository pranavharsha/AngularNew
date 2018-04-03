var validate = (function () {
	
	var validateObj = {};
	
	function addError(elem,errmsg) {
		$(elem).css({
		   "border": "1px solid #ff0033",
         });
		$(elem).tooltip({title:errmsg});//$(elem).data("errormsg")
  	}
  
	function removeError(elem){
		  $(elem).css({
			"border": "",
		  });
		 $(elem).tooltip('destroy'); 
		  
	}
	
	function addErrorSummerNotes(elem,errmsg){
		 var ctrl = $(elem).next('div.note-editor');
                    ctrl.css({
                        "border": "1px solid #ff0033",
                    });
                   ctrl.tooltip({title:errmsg});     
		
	}
	function removeErrorSummerNotes(elem){
		var ctrl = $(elem).next('div.note-editor');
                    ctrl.css({
                        "border": "",
                    });
                   	ctrl.tooltip('destroy');
		
	}
	
	function addCheckError(elem){
		$.each(elem, function( i, ctrl ) { 
			$(ctrl).css({"outline": "1px solid #ff0033",});
			$(ctrl).tooltip({title: "Please select at least one"});	
		});	
	}
	
	function removeCheckError(elem){
		$.each(elem, function( i, ctrl ) { 
			$(ctrl ).css({"outline": "",});
		 	$(ctrl ).tooltip('destroy'); 
		});	
	}

	
	validateObj.isValidForm = function (ctrlsArr) {
		 var isValid = true;
            jQuery.each(ctrlsArr, function( i, ctrl ) {
				if ($.trim($(ctrl).val()) == '') {
                    isValid = false;
                     addError(ctrl,"Input is required for this field");
                     //return isValid;       
                }else {
                   removeError(ctrl);
                }				
		});                
     return isValid;
	};
	
	validateObj.isValidPeoplePicker = function (ctrlsArr) {
		 var isValid = true;
            jQuery.each(ctrlsArr, function( i, ctrl ) {
				if ($.trim($(ctrl).find("input").val()) == '[]' || $.trim($(ctrl).find("input").val()) == '') {
                    isValid = false;
                     addError(ctrl,"Input is required for this field");
                     //return isValid;       
                }else {
                   removeError(ctrl);
                }				
		});                
     return isValid;
	};
	
	validateObj.isValidOnlyText = function (ctrlsArr) {
		 var isValid = true;
            jQuery.each(ctrlsArr, function( i, ctrl ) {
            	var letters = /^[a-zA-Z ]*$/;
				if (!$.trim($(ctrl).val()).match(letters)) {
                    isValid = false;
                     addError(ctrl,"Only Text is allowed for this field");
                     //return isValid;       
                }else {
                   removeError(ctrl);
                }				
		});                
     return isValid;
	};
	
	validateObj.isValidOnlyNumbers = function (ctrlsArr) {
		 var isValid = true;
            jQuery.each(ctrlsArr, function( i, ctrl ) {
            	var letters =/^[0-9]+$/;
				if (!$.trim($(ctrl).val()).match(letters)) {
                    isValid = false;
                     addError(ctrl,"Only Numbers are allowed for this field");
                     //return isValid;       
                }else {
                   removeError(ctrl);
                }				
		});                
     return isValid;
	};
	
	validateObj.isEmail = function (ctrlsArr) {
		 var isValid = true;
            jQuery.each(ctrlsArr, function( i, ctrl ) {
            	var letters =/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
				if (!$.trim($(ctrl).val()).match(letters)) {
                    isValid = false;
                     addError(ctrl,"Enter a valid Email Address");
                     //return isValid;       
                }else {
                   removeError(ctrl);
                }				
		});                
     return isValid;
	};
	
	validateObj.isValidDate= function(ctrlsArr){
	  var isValid=true;
	  jQuery.each(ctrlsArr, function( i, ctrl ) {
	    if($.trim($(ctrl).val()) == ""){
	        console.log($.trim($(ctrl).val()));
	        console.log(typeof($.trim($(ctrl).val())));
	        isValid = false;
            addError(ctrl,"Select a valid Date");
            //return isValid;
	     }else{
            removeError(ctrl);
         }
	  });
	 return isValid;
	};
	
	validateObj.isValidSummerNotes = function (ctrlsArr) {
	var isValid = true;
	  jQuery.each(ctrlsArr, function( i, ctrl ) {
		   		/*var summernoteText= $(ctrl).summernote('code');
           		var  stringText = $(summernoteText).text().replace(/\s+/g, '');
                if (stringText  == '') {
                    isValid = false;
					addErrorSummerNotes(ctrl);
					return isValid; 
                }else {
                	removeErrorSummerNotes(ctrl);
                }*/
               var isEmpty = $(ctrl).summernote('isEmpty');	
               if (isEmpty){
                    isValid = false;
					addErrorSummerNotes(ctrl,"Input is required for this field");
					//return isValid; 
                }else {
                	removeErrorSummerNotes(ctrl);
                }	  
	  });
	return isValid;
	};
	
	validateObj.isCheckBoxChecked = function (chkArr) {
		var isValid = true;
		  jQuery.each(chkArr, function( i, ctrl ) {
		  		if($(ctrl).is(":checked")){
	                    removeError(ctrl);
	                   
	                }else {
	                	 isValid = false;
						addError(ctrl,"Check Box is Mandetory");
						return isValid; 
	                }		  
		  });
		return isValid;
	};
	
	validateObj.isAnyCheckBoxChecked = function (chkArr) {
		var isValid = false;
		  jQuery.each(chkArr, function( i, ctrl ) {
		  		if($(ctrl).is(":checked")){                   
	             	 isValid = true;
	            }		  
		  });
		  if(!isValid){
		  	addCheckError(chkArr);
		  }else{
		  	removeCheckError(chkArr);
		  }
		return isValid;
	};
	
	validateObj.isRadioButtonChecked = function (chkArr) {
		var isValid = false;
		  jQuery.each(chkArr, function( i, ctrl ) {
		  		if($(ctrl).is(":checked")){                   
	             	 isValid = true;
	            }		  
		  });
		  if(!isValid){
		  	addCheckError(chkArr);
		  }else{
		  	removeCheckError(chkArr);
		  }
		return isValid;
	};
	
	validateObj.isValidImage = function (imgArr){
		var isValid = true;
		  jQuery.each(imgArr, function( i, ctrl ) {		
		  	if($(ctrl).val() != null && $(ctrl).val() != ""){
		  		var validImgExtensionArr = ['jpg', 'JPG', 'jpeg', 'JPEG', 'png', 'PNG', 'gif', 'GIF', 'bmp', 'BMP'];	
		  		 if ($.inArray($(ctrl).val().split('.').pop().toLowerCase(), validImgExtensionArr) == -1) {
           				 isValid = false;
           				 addError(ctrl,"Select a valid Image");
           				 return isValid
        		}else{
        			removeError(ctrl);
        		} 
        	}else{
        		removeError(ctrl);
        	}
		  });
		 return isValid;
	}



	return validateObj;
}());