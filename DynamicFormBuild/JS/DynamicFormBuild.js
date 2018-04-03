var LoaderHTML='<div class="modal fade bs-example-modal-sm" id="DFLoaderProcessing"><div class="modal-dialog modal-sm" id="ModalDialog"><div class="modal-content" id="ModalContent"><div class="modal-body"><div class="progress"><div class="progress-bar progress-bar-striped active" style="width: 100%"></div></div></div></div></div></div>';

var CompleteFormHtml=LoaderHTML+"<div class='row FormSectionOuter'>";

var element="";
var SinglePPickers=[];
var MultiplePPickers=[];
var DatePickers=[];
var FormFieldsObjArray=[];
var DataStorageList="";
var AssetCount=1;
var ImageAssets="ImageAssets";
var IsAttachment=false;

$(function(){
	getListItems("",ImageAssets,"?$Select=*&$orderby=ID desc&$Top=1",GetDynamicFormAssetCount,failuremethod);
});

function GetDynamicFormAssetCount(data)
{
if(data.d.results.length>0)
{
  $.each(data.d.results,function(index,item){
    AssetCount=Number(item.ID)+1;
  });
}

}

function FormBuild(Div,FieldsConfigListName,DataStorageListName)
{
	element=Div;
	DataStorageList=DataStorageListName;
	getListItems("",FieldsConfigListName,"?$Select=*&$orderby=Order0&$filter=Display eq 1",GetFormHTML,failuremethod);
}

function GetFormHTML(data)
{

BNumCount=0;

 $.each(data.d.results,function(index,item){
 
	var Title=item.Title;
	var FieldType=item.FieldType;
	var FieldValues=item.FieldValues;
	var FieldList=item.FieldsList;
	var FieldListColumnName=item.FieldListColumnName;
	var IsFieldValues=item.IsFieldValues;
	var OriginalListFieldValue=item.ListFieldValue;
	var ListFieldValue=item.ListFieldValue;//.split(" ").toString();
	var ListFieldType=item.ListFieldType;
	var BNum=item.BootstrapNumber;
	var Validations=item.Validations.results.toString();
	if(Validations.indexOf("Required")>=0)
	{
		var RqdClassname="DFormRequired";
	}
	else
	{
		var RqdClassname="DFormNormal";
	}
	
	var FormFieldObj={};
	FormFieldObj.elemid=ListFieldValue;
	FormFieldObj.ListFieldName=OriginalListFieldValue;
	FormFieldObj.elemType=FieldType;
	FormFieldObj.ListType=ListFieldType;
	FormFieldObj.elemValidations=Validations;
	
	if(FieldType!="Vacant Space")
	{
		FormFieldsObjArray.push(FormFieldObj);
	}
	
	switch(FieldType)
	{
		case "Single Line Input":
			var SLIHtml="<div class='form-group col-lg-"+BNum+" col-md-"+BNum+" col-sm-"+BNum+" col-xs-12'>"+
						 "<label class='control-label col-xs-4 PTLabel "+RqdClassname+"' for='"+ListFieldValue+"'>"+Title+":</label>"+
						  "<div class='col-xs-8 PTDiv'><input type='text' class='form-control' id='"+ListFieldValue+"'></div>"+
						"</div>";
			if(BNumCount<=12)
			{
				CompleteFormHtml+=SLIHtml;
				BNumCount+=BNum;
			}
			else
			{
				CompleteFormHtml+=SLIHtml+"</div><div class='row FormSectionOuter'>";
				BNumCount=0;
			}
	    break;
	    
	    case "Multiple Line Input":
			var MLIHtml="<div class='form-group col-lg-"+BNum+" col-md-"+BNum+" col-sm-"+BNum+" col-xs-12'>"+
						 "<label class='control-label col-xs-4 PTLabel "+RqdClassname+"' for='"+ListFieldValue+"'>"+Title+":</label>"+
						  "<div class='col-xs-8 PTDiv'><textarea rows='4' type='text' class='form-control' id='"+ListFieldValue+"'></textarea></div>"+
						"</div>";
			if(BNumCount<=12)
			{
				CompleteFormHtml+=MLIHtml;
				BNumCount+=BNum;
			}
			else
			{
				CompleteFormHtml+=MLIHtml+"</div><div class='row FormSectionOuter'>";
				BNumCount=0;
			}
	    break;
	    
	    case "Multiple Line Rich Text":
			var MLIRTHtml="<div class='form-group col-lg-"+BNum+" col-md-"+BNum+" col-sm-"+BNum+" col-xs-12'>"+
						 "<label class='control-label col-xs-3 PTLabel "+RqdClassname+"' for='"+ListFieldValue+"'>"+Title+":</label>"+
						  "<div class='col-xs-9 PTDiv'><textarea type='text' class='form-control rich-textbox' id='"+ListFieldValue+"'></textarea></div>"+
						"</div>";
			if(BNumCount<=12)
			{
				CompleteFormHtml+=MLIRTHtml;
				BNumCount+=BNum;
			}
			else
			{
				CompleteFormHtml+=MLIRTHtml+"</div><div class='row FormSectionOuter'>";
				BNumCount=0;
			}
	    break;
	    
	    case "Radio Button":
	        var RadioButtons="";
	        if(IsFieldValues)
	        {
	        	var Values=FieldValues.split(",");
	        	RadioButtons=GetRadioButtonsHTML(Values,ListFieldValue);
	        }
	        else
	        {
	        	getListItemsNonAsync("",FieldList,"?$Select=*",function(data){
	        		var HTML="";
	        		$.each(data.d.results,function(index,item){
	        			var RBid=item.ID;
	        			var RBTitle=item.Title;
	        			HTML+="<label class='RadioBtnCSS'><input class='RadioButtonsTags "+ListFieldValue+"' name='"+ListFieldValue+"' type='radio' value='"+RBid+"'>"+RBTitle+"</label>";
	        		});
	        	RadioButtons=HTML;
	        	},failuremethod)
	        }
			var RBHtml="<div class='form-group col-lg-"+BNum+" col-md-"+BNum+" col-sm-"+BNum+" col-xs-12'>"+
						 "<label class='control-label col-xs-4 PTLabel "+RqdClassname+"' for='"+ListFieldValue+"'>"+Title+":</label>"+
						  "<div class='col-xs-8 PTDiv'>"+RadioButtons+"</div>"+
						"</div>";
			if(BNumCount<=12)
			{
				CompleteFormHtml+=RBHtml;
				BNumCount+=BNum;
			}
			else
			{
				CompleteFormHtml+=RBHtml+"</div><div class='row FormSectionOuter'>";
				BNumCount=0;
			}
	    break;
	    
	    case "Dropdown":
	        var DropdownOptions="";
	        if(IsFieldValues)
	        {
	        	var Values=FieldValues.split(",");
	        	DropdownOptions=GetDropdownOptionsHtml(Values,true);
	        }
	        else
	        {
	        	getListItemsNonAsync("",FieldList,"?$Select=*",function(data){
	        		var HTML="<option value>Select</option>";
	        		$.each(data.d.results,function(index,item){
	        			var DDid=item.ID;
	        			var DDTitle=item.Title;
	        			HTML+="<option value='"+DDid+"'>"+DDTitle+"</option>";
	        		});
	        	DropdownOptions=HTML;
	        	},failuremethod)
	        }
			var DDHtml="<div class='form-group col-lg-"+BNum+" col-md-"+BNum+" col-sm-"+BNum+" col-xs-12'>"+
						 "<label class='control-label col-xs-4 PTLabel "+RqdClassname+"' for='"+ListFieldValue+"'>"+Title+":</label>"+
						  "<div class='col-xs-8 PTDiv'><select class='form-control Dropdown' id='"+ListFieldValue+"'>"+DropdownOptions+"</select></div>"+
						"</div>";
			if(BNumCount<=12)
			{
				CompleteFormHtml+=DDHtml;
				BNumCount+=BNum;
			}
			else
			{
				CompleteFormHtml+=DDHtml+"</div><div class='row FormSectionOuter'>";
				BNumCount=0;
			}
	    break;
	    
	    case "Multi Select Dropdown":
	        var DropdownOptions="";
	        if(IsFieldValues)
	        {
	        	var Values=FieldValues.split(",");
	        	DropdownOptions=GetDropdownOptionsHtml(Values,false);
	        }
	        else
	        {
	        	getListItemsNonAsync("",FieldList,"?$Select=*",function(data){
	        		var HTML="";
	        		$.each(data.d.results,function(index,item){
	        			var DDid=item.ID;
	        			var DDTitle=item.Title;
	        			HTML+="<option value='"+DDid+"'>"+DDTitle+"</option>";
	        		});
	        	DropdownOptions=HTML;
	        	},failuremethod)
	        }
			var DDHtml="<div class='form-group col-lg-"+BNum+" col-md-"+BNum+" col-sm-"+BNum+" col-xs-12'>"+
						 "<label class='control-label col-xs-4 PTLabel "+RqdClassname+"' for='"+ListFieldValue+"'>"+Title+":</label>"+
						  "<div class='col-xs-8 PTDiv'><select class='form-control Dropdown' id='"+ListFieldValue+"' multiple='multiple'>"+DropdownOptions+"</select></div>"+
						"</div>";
			if(BNumCount<=12)
			{
				CompleteFormHtml+=DDHtml;
				BNumCount+=BNum;
			}
			else
			{
				CompleteFormHtml+=DDHtml+"</div><div class='row FormSectionOuter'>";
				BNumCount=0;
			}
	    break;
	    
	    case "Checkbox":
	        var CheckboxOptions="";
	        if(IsFieldValues)
	        {
	        	var Values=FieldValues.split(",");
	        	CheckboxOptions=GetCheckboxOptionsHtml(Values,ListFieldValue);
	        }
	        else
	        {
	        	getListItemsNonAsync("",FieldList,"?$Select=*",function(data){
	        		var HTML="";
	        		$.each(data.d.results,function(index,item){
	        			var CBid=item.ID;
	        			var CBTitle=item.Title;
	        			HTML+="<label class='CheckboxCSS'><input class='CheckboxTags "+ListFieldValue+"' name='"+ListFieldValue+"' type='checkbox' value='"+CBid+"'>"+CBTitle+"</label>";
	        		});
	        	CheckboxOptions=HTML;
	        	},failuremethod)
	        }
			var DDHtml="<div class='form-group col-lg-"+BNum+" col-md-"+BNum+" col-sm-"+BNum+" col-xs-12'>"+
						 "<label class='control-label col-xs-4 PTLabel "+RqdClassname+"' for='"+ListFieldValue+"'>"+Title+":</label>"+
						  "<div class='col-xs-8 PTDiv'>"+CheckboxOptions+"</div>"+
						"</div>";
			if(BNumCount<=12)
			{
				CompleteFormHtml+=DDHtml;
				BNumCount+=BNum;
			}
			else
			{
				CompleteFormHtml+=DDHtml+"</div><div class='row FormSectionOuter'>";
				BNumCount=0;
			}
	    break;
	    
	    case "Single People Picker":
	    	SinglePPickers.push(ListFieldValue);
			var PPHtml="<div class='form-group col-lg-"+BNum+" col-md-"+BNum+" col-sm-"+BNum+" col-xs-12'>"+
						 "<label class='control-label col-xs-4 PTLabel "+RqdClassname+"' for='"+ListFieldValue+"'>"+Title+":</label>"+
						  "<div class='col-xs-8 PTDiv'><div id='"+ListFieldValue+"'></div></div>"+
						"</div>";
			if(BNumCount<=12)
			{
				CompleteFormHtml+=PPHtml;
				BNumCount+=BNum;
			}
			else
			{
				CompleteFormHtml+=PPHtml+"</div><div class='row FormSectionOuter'>";
				BNumCount=0;
			}
	    break;
	    
	    case "Multiple People Picker":
	    	MultiplePPickers.push(ListFieldValue);
			var PPHtml="<div class='form-group col-lg-"+BNum+" col-md-"+BNum+" col-sm-"+BNum+" col-xs-12'>"+
						 "<label class='control-label col-xs-4 PTLabel "+RqdClassname+"' for='"+ListFieldValue+"'>"+Title+":</label>"+
						  "<div class='col-xs-8 PTDiv'><div id='"+ListFieldValue+"'></div></div>"+
						"</div>";
			if(BNumCount<=12)
			{
				CompleteFormHtml+=PPHtml;
				BNumCount+=BNum;
			}
			else
			{
				CompleteFormHtml+=PPHtml+"</div><div class='row FormSectionOuter'>";
				BNumCount=0;
			}
	    break;
	    
	    case "Date":
	    	DatePickers.push(ListFieldValue);
			var PPHtml="<div class='form-group col-lg-"+BNum+" col-md-"+BNum+" col-sm-"+BNum+" col-xs-12'>"+
						 "<label class='control-label col-xs-4 PTLabel "+RqdClassname+"' for='"+ListFieldValue+"'>"+Title+":</label>"+
						  "<div class='col-xs-8 PTDiv input-group date'><input type='text' class='form-control DateField' id='"+ListFieldValue+"'></input><span class='input-group-addon'><i class='glyphicon glyphicon-calendar'></i></span></div>"+
						"</div>";
			if(BNumCount<=12)
			{
				CompleteFormHtml+=PPHtml;
				BNumCount+=BNum;
			}
			else
			{
				CompleteFormHtml+=PPHtml+"</div><div class='row FormSectionOuter'>";
				BNumCount=0;
			}
	    break;
	    
	    case "Vacant Space":
	    
	    	var SpaceHtml="<div class='form-group col-lg-"+BNum+" col-md-"+BNum+" col-sm-"+BNum+" col-xs-12'></div>";
	    	if(BNumCount<=12)
			{
				CompleteFormHtml+=SpaceHtml;
				BNumCount+=BNum;
			}
			else
			{
				CompleteFormHtml+=SpaceHtml+"</div><div class='row FormSectionOuter'>";
				BNumCount=0;
			}
		break;//
		
		case "Attachment":
		
	    	IsAttachment=true;
	    	
	    	var AttachmentsHtml="<div class='form-group col-lg-"+BNum+" col-md-"+BNum+" col-sm-"+BNum+" col-xs-12 DFAttachmentOuterDiv'>"+
	    							"<div class='col-xs-12 BootstrapNoPadding DFAttachmentDiv'>"+
						 				"<label class='control-label col-xs-4 PTLabel "+RqdClassname+"' for=''>"+Title+":</label>"+//"+ListFieldValue+"
						 				"<div class='col-xs-7 PTDiv'><input class='form-control DynamicFormAttachments' type='file'></div>"+
						 				"<div class='col-sm-1 margintop7'><a type='button' id='addArticleFiles' title='Add new file' class='btn-green'>+</a></div>"+
						 			"</div>"+
						 		"</div>";
	    	if(BNumCount<=12)
			{
				CompleteFormHtml+=AttachmentsHtml;
				BNumCount+=BNum;
			}
			else
			{
				CompleteFormHtml+=AttachmentsHtml+"</div><div class='row FormSectionOuter'>";
				BNumCount=0;
			}
		break;

	}
	
 });

CompleteFormHtml+="</div><div class='row FormSectionOuter ButtonsRow'><button onclick=SubmitDynamicForm() type='button' class='btn btn-primary' id='SaveDynamicForm'>Submit</button><button onclick=ResetForm() type='reset' class='btn btn-primary' id='ResetDynamicForm'>Reset</button></div>";

$(element).html(CompleteFormHtml);

console.log(FormFieldsObjArray);

$('.rich-textbox').summernote({
    	dialogsInBody: true,
    	minHeight:100,
    	callbacks: {
		    onImageUpload: function(files) {
		      // upload image to server and create imgNode...
		      //console.log(files);
		      summernoteuploadImage(files[0]);
		      //$summernote.summernote('insertNode', imgNode);
		    },
		   onFocus: function() {
      		 //console.log('Editable area is focused');
      		 //console.log($(this).attr('id'));
      		 summernoteid=$(this).attr('id');
    		}
		  }
});

$("body").on("click",".input-group-addon",function(){
	$(this).closest(".date").find(".DateField").trigger('focus');
});

$(".DFormRequired").each(function(){
	$(this).append("<span class='RequiredSpan'>*</span>");
});

$("body").on("click","#addArticleFiles",function(){
	AddArticlesFileControl();
});
	
$("body").on("click",".removeFile",function(){
	RemoveArticlesFileControl(this);
});


if(SinglePPickers.length>0)
{
	for(var i=0;i<SinglePPickers.length;i++)
	{
		initializePeoplePicker(SinglePPickers[i],false);
	}
}

if(MultiplePPickers.length>0)
{
	for(var i=0;i<MultiplePPickers.length;i++)
	{
		initializePeoplePicker(MultiplePPickers[i],true);
	}
}

if(DatePickers.length>0)
{
	for(var i=0;i<DatePickers.length;i++)
	{
		initializeDatePicker("#"+DatePickers[i]);
	}	
}

}

function SubmitDynamicForm()
{

ShowDynamicFormLoader();

var FormDataObject={};
var RequiredElems=[];
var RequiredRichTextBoxes=[];
var RequiredPeoplePickers=[];
var RequiredChkBoxes=[];
var RequiredRadioBtns=[];
var OnlyTextElms=[];
var OnlyNumbersElms=[];
var EmailElms=[];

console.log(FormFieldsObjArray);

	$.each(FormFieldsObjArray,function(index,item){
		var elemid=item.elemid;
		var ListFieldName=item.ListFieldName;
		var ListType=item.ListType;
		var elemType=item.elemType;
		var elemValidations=item.elemValidations;
		var valsList=elemValidations.split(",");
		
		if(ListType=="Single Line of Text")
		{
			if(elemType=="Checkbox" || elemType=="Radio Button")
			{
				FormDataObject[ListFieldName]=getChkBxValues($("."+elemid)).toString();
			}
			else
			{
				FormDataObject[ListFieldName]=getValue($("#"+elemid).val());
			}
		}
		else if(ListType=="Multiple Line of Text")
		{
			FormDataObject[ListFieldName]=getValue($("#"+elemid).val());
		}
		else if(ListType=="Date")
		{
			FormDataObject[ListFieldName]=getDateValue($("#"+elemid).val());
		}
		else if(ListType=="Single Lookup")
		{
			if(elemType=="Checkbox" || elemType=="Radio Button")
			{
				FormDataObject[ListFieldName+"Id"]=getChkBxValues($("."+elemid)).toString();
			}
			else
			{
				FormDataObject[ListFieldName+"Id"]=getSingleLookupValue($("#"+elemid).val());
			}
		}
		else if(ListType=="Multiple Lookup")
		{
			if(elemType=="Checkbox" || elemType=="Radio Button")
			{
				FormDataObject[ListFieldName+"Id"]=getChkBxValues($("."+elemid));
			}
			else
			{
				FormDataObject[ListFieldName+"Id"]=$("#"+elemid).val().length!=0?{"results":$("#"+elemid).val()}:{"results":[]};
			}
		}
		else if(ListType=="Single People Picker")
		{
			var PPText=elemid+"_TopSpan";
			console.log(PPText);
			FormDataObject[ListFieldName+"Id"]=getPeopleInPeoplePicker(SPClientPeoplePicker.SPClientPeoplePickerDict[PPText]);
		}
		else if(ListType=="Multiple People Picker")
		{
			var PPText=elemid+"_TopSpan";
			var MulResults=getMultipleUserInPeoplePicker(SPClientPeoplePicker.SPClientPeoplePickerDict[PPText]);
			FormDataObject[ListFieldName+"Id"]=MulResults.length!=0?{"results":MulResults}:{"results":[]};
		}

		
		if(valsList.length>0)
		{
			for(var a=0;a<valsList.length;a++)
			{
				if(valsList[a]=="Required")
				{
					/*if(elemType!="Checkbox" && elemType!="Radio Button" && elemType!="Multiple Line Rich Text" && elemType=="Multiple People Picker" && elemType=="Single People Picker")
					{
						RequiredElems.push("#"+elemid);
					}*/
					if(elemType=="Multiple Line Rich Text")
					{
						RequiredRichTextBoxes.push("#"+elemid);
					}
					else if(elemType=="Multiple People Picker" || elemType=="Single People Picker")
					{
						RequiredPeoplePickers.push("#"+elemid);
					}
					else if(elemType=="Checkbox")
					{
						RequiredChkBoxes.push("."+elemid);
					}
					else if(elemType=="Radio Button")
					{
						RequiredRadioBtns.push("."+elemid);
					}
					else if(elemType=="Attachment")
					{
						RequiredElems.push(".DynamicFormAttachments");
					}
					else
					{
						RequiredElems.push("#"+elemid);
					}
				}
				else if(valsList[a]=="Only Text")
				{
					if(elemType=="Single Line Input" || elemType=="Multiple Line Input")
					{
						OnlyTextElms.push("#"+elemid);
					}
				}
				else if(valsList[a]=="Only Numbers")
				{
					if(elemType=="Single Line Input" || elemType=="Multiple Line Input")
					{
						OnlyNumbersElms.push("#"+elemid);
					}
				}
				else if(valsList[a]=="Email")
				{
					if(elemType=="Single Line Input" || elemType=="Multiple Line Input")
					{
						EmailElms.push("#"+elemid);
					}
				}
			}
		}
	});

console.log(FormDataObject);

var isFormValid = RequiredElems.length>0 ? validate.isValidForm(RequiredElems) : true;

var isRichTextValid = RequiredRichTextBoxes.length>0 ? validate.isValidSummerNotes(RequiredRichTextBoxes) : true;

var isPeoplePickersValid = RequiredPeoplePickers.length>0 ? validate.isValidPeoplePicker(RequiredPeoplePickers) : true;

var isChkBoxValid = RequiredChkBoxes.length>0 ? validate.isAnyCheckBoxChecked(RequiredChkBoxes) : true;

var isRadioBtnsValid = RequiredRadioBtns.length>0 ? validate.isRadioButtonChecked(RequiredRadioBtns) : true;

var isOnlyTextValid = OnlyTextElms.length>0 ? validate.isValidOnlyText(OnlyTextElms) : true;

var isOnlyNumbersValid = OnlyNumbersElms.length>0 ? validate.isValidOnlyNumbers(OnlyNumbersElms) : true;

var isEmail = EmailElms.length>0 ? validate.isEmail(EmailElms) : true;

if(isFormValid && isRichTextValid && isPeoplePickersValid && isChkBoxValid && isRadioBtnsValid && isOnlyTextValid && isOnlyNumbersValid && isEmail)
{
	//alert("success");
	if(!IsAttachment)
	{
		addListItem("",DataStorageList,FormDataObject,SubmitSuccess,SubmitFailed);
	}
	else
	{
		//alert("In Attachment");
		HideDynamicFormLoader();
		
		var attachFile = [];
		
		var Attachments = $(".DynamicFormAttachments");
		
		$.each(Attachments,function(i,ctrl){
			if($(this).val() != ""){
				attachFile.push(ctrl.files[0]);
			}
		});
		
		addNewFileItem("",DataStorageList,FormDataObject,"",attachFile,function(){},function(data){console.log(data);});
	}
}
else
{
	//alert("failure");
	HideDynamicFormLoader();
	
	$.notify({
		message: 'Please verify the highlighted fields. '
	},{
		type: 'danger'
	});
}

}

function SubmitSuccess(data)
{
	//alert("success");
	HideDynamicFormLoader();
	
	$("#ResetDynamicForm").click();

	$.notify({
		message: 'Record added successfully'
	},{
		type: 'success'
	});
}

function SubmitFailed(data)
{	
	
	HideDynamicFormLoader();
	
	$.notify({
		message: 'Error occurred - Please contact Admin '
	},{
		type: 'danger'
	});

	console.log("Exception: OnStaticLinksExecutionFailure - Please contact Admin" + JSON.stringify(data));
}

function ResetForm()
{
	if(SinglePPickers.length>0)
	{
		for(var i=0;i<SinglePPickers.length;i++)
		{
			clearPeoplePicker(SinglePPickers[i]);
		}
	}

	if(MultiplePPickers.length>0)
	{
		for(var i=0;i<MultiplePPickers.length;i++)
		{
			clearMultiplePeoplePicker(MultiplePPickers[i]);
		}
	}
	
	$('.rich-textbox').each(function(){
	   $(this).summernote('reset');
	});

}

function GetRadioButtonsHTML(fieldArray,Title)
{
	var HTML="";
	for(var i=0;i<fieldArray.length;i++)
	{
		HTML+="<label class='RadioBtnCSS'><input class='RadioButtonsTags "+Title+"' name='"+Title+"' type='radio' value='"+fieldArray[i]+"'>"+fieldArray[i]+"</label>";
	}
return HTML;
}

function GetCheckboxOptionsHtml(fieldArray,Title)
{
	var HTML="";
	for(var i=0;i<fieldArray.length;i++)
	{
		HTML+="<label class='CheckboxCSS'><input class='CheckboxTags "+Title+"' name='"+Title+"' type='checkbox' value='"+fieldArray[i]+"'>"+fieldArray[i]+"</label>";
	}
return HTML;
}


function GetDropdownOptionsHtml(fieldArray,IsNull)
{
	if(IsNull)
	{
		var HTML="<option value>Select</option>";
	}
	else
	{
		var HTML="<option value>Select</option>";
	}
	
	for(var i=0;i<fieldArray.length;i++)
	{
		HTML+="<option value='"+fieldArray[i]+"'>"+fieldArray[i]+"</option>";
	}
return HTML;
}

function getFileBuffer(file) {
	   var deferred = $.Deferred();
	   var reader = new FileReader();
		   reader.onload = function(e) {
		    deferred.resolve(e.target.result);
		   }
		   reader.onerror = function(e) {
		    deferred.reject(e.target.error);
		   }
		   reader.readAsArrayBuffer(file);
		   return deferred.promise();
}

function summernoteuploadImage(field)
{
ShowDynamicFormLoader();
  //console.log(field);
  getFileBuffer(field).then(function(buffer) {
    
    var ext=field.name.split(".")[1];
  	var filename=field.name;
  	filename=AssetCount+"."+ext;
  	//console.log(filename);
  	//console.log(buffer);
  	
  	addFileToDocumentLibrarySummerNote(ImageAssets,"",filename,buffer);
  	
  });
  
}

function SummernoteImageUploadSuccess(data)
{
  AssetCount=AssetCount+1;
  var imgurl=data.d.ServerRelativeUrl;
  //console.log(imgurl);
  var imgNode = $('<img>').attr('src',imgurl);
  $('#'+summernoteid).summernote('insertImage', imgurl);
  
  HideDynamicFormLoader();
}


function failuremethod(data)
{
console.log("Exception: OnStaticLinksExecutionFailure - Please contact Admin" + JSON.stringify(data));
}

function ShowLoader()
{
  $("#LoaderOuter").css("display","block");
  $("#s4-workspace").css("overflow","hidden");
}

function HideLoader()
{
  $("#LoaderOuter").hide();
  $("#s4-workspace").css("overflow","auto");
}


function addFileToDocumentLibrarySummerNote(libname,folderName,fileName,arrayBuffer){
	             
        // Construct the endpoint.
        if(folderName!="")
        {
        	var folder = libname+'/'+folderName;
        }
        else
        {
        	var folder = libname;
        }
        var fileCollectionEndpoint = _spPageContextInfo.webAbsoluteUrl+"/_api/web/getfolderbyserverrelativeurl('"+folder+"')/files/add(overwrite=true, url='"+fileName+"')";      
        jQuery.ajax({
            url: fileCollectionEndpoint,
            type: "POST",
            data: arrayBuffer,
            processData: false,
            headers: {
                "accept": "application/json;odata=verbose",
                "X-RequestDigest": $("#__REQUESTDIGEST").val(),
                "content-length": arrayBuffer.byteLength
            },
            success: function(data){      
	               //alert("Uploaded successfully");
	               //console.log(data);
	               //AssetCount=AssetCount+1;
	               SummernoteImageUploadSuccess(data);      
	        },
	        error: function(data){
	               alert("Error occured." + data.responseText);
	        }

        });
    
}

function initializePeoplePicker(peoplePickerElementId,isMutipleValue) {
    var schema = {};
    schema['PrincipalAccountType'] = 'User,DL,SecGroup,SPGroup';
    schema['SearchPrincipalSource'] = 15;
    schema['ResolvePrincipalSource'] = 15;
    schema['AllowMultipleValues'] = isMutipleValue;
    schema['MaximumEntitySuggestions'] = 50;
    //schema['Width'] = '280px';
    SPClientPeoplePicker_InitStandaloneControlWrapper(peoplePickerElementId, null, schema);
}

function setPeopleInPeoplePicker(ctrlId,userId){
ctrlId+="_TopSpan";
	if(userId != null && userId != "" && userId!=0){
		var userNameList = getUserEmailList([userId]);	
		$.each(userNameList,function(i,userName){
			var fieldName = 'Enter a name or email address...';
			var peoplePickerDiv = $("[id$='"+ctrlId+"'][title='"+fieldName+"']");
			var peoplePickerEditor = peoplePickerDiv.find("[title='"+fieldName+"']"); 
			var spPeoplePicker = SPClientPeoplePicker.SPClientPeoplePickerDict[peoplePickerDiv[0].id]; 
			peoplePickerEditor.val(userName); 
			spPeoplePicker.AddUnresolvedUserFromEditor(true);
			spPeoplePicker.SetEnabledState(true);
		});
	}
}

function setMultiplePeopleInPeoplePicker(ctrlId,userIdList){
ctrlId+="_TopSpan";
	 if(userIdList != null && userIdList.results.length > 0){
	  var userNameList = getUserEmailList(userIdList.results); 
	  $.each(userNameList,function(i,userName){
	   var fieldName = 'Enter names or email addresses...';
	   var peoplePickerDiv = $("[id$='"+ctrlId+"'][title='"+fieldName+"']"); 
	   var peoplePickerEditor = peoplePickerDiv.find("[title='"+fieldName+"']"); 
	   var spPeoplePicker = SPClientPeoplePicker.SPClientPeoplePickerDict[peoplePickerDiv[0].id]; 
	   peoplePickerEditor.val(userName); 
	   spPeoplePicker.AddUnresolvedUserFromEditor(true);
	   spPeoplePicker.SetEnabledState(true);
	  });
	 }
}

function clearPeoplePicker(ctrlId)
{
	var fieldName = 'Enter a name or email address...';
	ctrlId+="_TopSpan";
	var peoplePickerDiv = $("[id$='"+ctrlId+"'][title='"+fieldName+"']");
	var ppobject = SPClientPeoplePicker.SPClientPeoplePickerDict[peoplePickerDiv[0].id];
	var usersobject = ppobject.GetAllUserInfo();
 	usersobject.forEach(function (index) {
   		ppobject.DeleteProcessedUser(usersobject[index]);
  	});
}

function clearMultiplePeoplePicker(ctrlId)
{
	ctrlId=ctrlId+"_TopSpan";
	var fieldName = 'Enter names or email addresses...';
	var peoplePickerDiv = $("[id$='"+ctrlId+"'][title='"+fieldName+"']"); 
	var ppobject = SPClientPeoplePicker.SPClientPeoplePickerDict[peoplePickerDiv[0].id];
	var usersobject = ppobject.GetAllUserInfo();
 	usersobject.forEach(function (index) {
   		ppobject.DeleteProcessedUser(usersobject[index]);
  	});
}

function getPeopleInPeoplePicker(peoplePicker){
   	var users = peoplePicker.GetAllUserInfo();
    var userNames = new Array();
	$.each(users,function(i,v){
	userNames.push(users[0].Key)
	var loginName = userNames[i];
	ensureUser(_spPageContextInfo.webAbsoluteUrl,loginName)
   .done(function(data)
   {
       console.log('User has been added');
   })
   .fail(function(error){
       console.log('An error occured while adding user');
   });
   
   });
  	var userId = getUserIdList(userNames);
	return userId[0] != null && userId[0] != "" ? userId[0] : "0" ;

}

function getMultipleUserInPeoplePicker(peoplePicker) {
//debugger;
    var users = peoplePicker.GetAllUserInfo(); 
    var userNames = new Array();
  $.each(users,function(i,v){
   userNames.push(users[i].Key)
   
    var loginName = userNames[i];
   ensureUser(_spPageContextInfo.webAbsoluteUrl,loginName)
   .done(function(data)
   {
       console.log('User has been added');
   })
   .fail(function(error){
       console.log('An error occured while adding user');
   });
   
   });
  var userIdList = getUserIdList(userNames );
 return userIdList;
}

function ensureUser(webUrl,loginName)
{
   var payload = { 'logonName': loginName }; 
   return $.ajax({
      url: webUrl + "/_api/web/ensureuser",
      async:false,
      type: "POST",
      contentType: "application/json;odata=verbose",
      data: JSON.stringify(payload),
      headers: {
         "X-RequestDigest": $("#__REQUESTDIGEST").val(),
         "accept": "application/json;odata=verbose"
      }
   });  
}

function getUserIdList(userNames) {
	var userArr = new Array();
		$.each(userNames,function(i,userName){
	        var siteUrl = _spPageContextInfo.siteAbsoluteUrl;
	        $.ajax({
	            url: siteUrl + "/_api/web/siteusers(@v)?@v='" +encodeURIComponent(userName) + "'",
	            async:false,
	            method: "GET",
	            headers: { "Accept": "application/json; odata=verbose" },
	            success: function (data) {
	                userArr.push(data.d.Id);
	            },
	            error: function (data) {
	                alert(JSON.stringify(data));
	            }
	        });
	    });
	  return userArr ;
}

function initializeDatePicker(ctrl){
	var ctrlId = $(ctrl);
	ctrlId .datepicker({
		format: "mm/dd/yyyy",
		autoclose: true
	});
}

function setDateInDatePicker(id,date)
{
	var inDate = new Date(date.getFullYear(), date.getMonth(), date.getDate());	
	$(id).datepicker('setDate', inDate);
}

function getValue(value){
	return txt = value != null && value != ""?value:"";
}

function getSingleLookupValue(value){
   return val=value != null && value != ""?value:null;
}

function getDateValue(value){
   return val=value != null && value != ""?value:null;
}

function getChkBxValues(ctrl){
var results=[];
	$(ctrl).each(function(){
		if($(this).is(":checked"))
		{
			results.push($(this).val());
		}
	});
return results;
}

function ShowDynamicFormLoader()
{
  $("#DFLoaderProcessing").modal("show");
}

function HideDynamicFormLoader()
{
  $("#DFLoaderProcessing").modal("hide");
}

function AddArticlesFileControl(){
				var ctrl = '<div class="col-xs-12 BootstrapNoPadding DFAttachmentDiv"><div class="col-xs-4"></div>'+
						     '<div class="col-xs-7 PTDiv"><input class="form-control DynamicFormAttachments" type="file"></div>'+
						     '<div class="col-xs-1 margintop7"><a title="delete file" class="btn-red removeFile">x</a></div></div>';
						     
				$(".DFAttachmentOuterDiv").append(ctrl);
						
}

function RemoveArticlesFileControl(ctrl){
$(ctrl).closest('.DFAttachmentDiv').remove();
}


function addNewFileItem(url,listname,metadata,file,attach,complete,failure){		
	if(url == "")
	url  = _spPageContextInfo.webAbsoluteUrl;
	GetRequestDigestContext(url);
    // Prepping our update
    var item = $.extend({
        "__metadata": { "type": getListFileItemType(listname)}
    }, metadata);

    // Executing our add
    $.ajax({
        url: url + "/_api/web/lists/getbytitle('" + listname + "')/items",
        type: "POST",
        contentType: "application/json;odata=verbose",
        data: JSON.stringify(item),
        headers: {
            "Accept": "application/json;odata=verbose",
            "X-RequestDigest": RequestDigestValue
                },
        success: function (data) {
        	var id = data.d.ID;

        	if (attach != null && attach.length > 0){
        		$.each(attach,function(i,file){
        			uploadAttachment(listname,id,file,attach.length);  
        		});   		
        	}else{    
        		//onUploadSuccess(data);
        		SubmitSuccess(data);
        	}
		},
        error: function (data) {
            failure(data);
        }
    });
} 

function GetRequestDigestContext(url){
 if(url == "")
	url  = _spPageContextInfo.webAbsoluteUrl;

 $.ajax({
        url: url +"/_api/contextinfo",
        type: "POST",
        headers: { "accept": "application/json; odata=verbose","content-type":"application/json;odata=verbose"},
        async: false,
        success: function (data) {
           RequestDigestValue = data.d.GetContextWebInformation.FormDigestValue;
        },
        error: function (data, errorCode, errorMessage) {
            //alert(errorMessage)
        }
    });
}

function getListFileItemType(name) {
	var SpaceReplace = '_x0020_';
    return"SP.Data." + name[0].toUpperCase() +  name.split(" ").join(SpaceReplace).slice(1) + "ListItem";
}

var count = 0;

function uploadAttachment(listname,Id,file,length){
	 count = count +1;
	 //console.log(file);
	 getFileBuffer(file).then(function(buffer) {
	 		var ext  = file.name.split('.')[1];
	 		var fileName = file.name;
	 		/*if(file.attachType == "thumbnail"){
	 			fileName  = "thumbnail."+ext
	 		}
	 		else if(file.attachType == "qfactimage"){
	 			fileName  = "qfactimage."+ext
	 		}*/
		   $.ajax({
			    url: _spPageContextInfo.webAbsoluteUrl +
			     "/_api/web/lists/getbytitle('" + listname + "')/items(" + Id + ")/AttachmentFiles/add(FileName='" +fileName+ "')",
			    method: 'POST',
			    data: buffer,
			    processData: false,
			    async :false,
			    headers: {
			     "Accept": "application/json; odata=verbose",
			     "content-type": "application/json; odata=verbose",
			     "X-RequestDigest": document.getElementById("__REQUESTDIGEST").value,
			     "content-length": buffer.byteLength
			    },
			    success: function (data) {
			    	if(count == length){
			    		//onUploadSuccess(data);
			    		SubmitSuccess(data);
			    	}
				}
		   });
		 });
 }
 
 