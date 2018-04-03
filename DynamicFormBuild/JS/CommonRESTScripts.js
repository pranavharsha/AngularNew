var RequestDigestValue = "";

function GetRequestDigestContext(url)
{
 if(url == "")
	url  = _spPageContextInfo.webAbsoluteUrl;

 $.ajax({
        url: url +"/_api/contextinfo",
        type: "POST",
        headers: { "accept": "application/json; odata=verbose","content-type":"application/json;odata=verbose"},
        async: false,
        success: function (data) {
           RequestDigestValue = data.d.GetContextWebInformation.FormDigestValue;
			// $('#__REQUESTDIGEST').val(data.d.GetContextWebInformation.FormDigestValue);
           // EnsureScriptFunc('sharing.js', 'DisplaySharingDialog', function () { DisplaySharingDialog(projecturl) });

        },
        error: function (data, errorCode, errorMessage) {
            alert(errorMessage)
        }
    });
}

/* Scripts to Access sharepoint using REST Services */

/* url : Sharepoint site URL
	list name: The name of the list to pull the data
	PropString: 
*/
function getListItemProp(url, listname,PropString, complete, failure) {
	// Getting our list items
	if(url == "")
	url  = _spPageContextInfo.webAbsoluteUrl;
	
	$.ajax({
		url: url + "/_api/web/lists/getbytitle('" + listname + "')" + PropString+ "",
		method: "GET",
		headers: { "Accept": "application/json; odata=verbose" },
		success: function (data) {
			// Returning the results
			complete(data);
		},
		error: function (data) {
			failure(data);
			//alert(JSON.stringify(data));

		}
		});
}




function getListItem(url, listname, id, complete, failure) {
	// Getting our list items
	if(url == "")
	url  = _spPageContextInfo.webAbsoluteUrl;

	$.ajax({
		url: url + "/_api/web/lists/getbytitle('" + listname + "')/items(" + id + ")",
		method: "GET",
		headers: { "Accept": "application/json; odata=verbose" },
		success: function (data) {
			// Returning the results
			complete(data);
		},
		error: function (data) {
			failure(data);

		}
		});
}


// Getting the item type for the list
function getListItemType(name) {
	var SpaceReplace = '_x0020_';
    return"SP.Data." + name[0].toUpperCase() +  name.split(" ").join(SpaceReplace).slice(1) + "ListItem";
}

//getListItems("{sitename}Or{blank for defaultsite}", "{List name}", "?$select=<Field1>,<Field2>,<Field3>...", <OnExecutionMethodName>, <OnExecutionFailureMethodName>)

// Getting list items based on ODATA Query
function getListItemsSVCService(url, listname, query, complete, failure) {
	if(url == "")
	url  = _spPageContextInfo.webAbsoluteUrl;
	url = url + "/_vti_bin/ListData.svc/" + listname + query;
	//$('#txtCntctName').text(url);
    // Executing our items via an ajax request
    $.ajax({
        url: url,
        method: "GET",
        headers: { "Accept": "application/json; odata=verbose" },
        success: function (data) {
            complete(data); // Returns JSON collection of the results
        },
        error: function (data) {
            failure(data);
        }
    });

}


// Getting list items based on ODATA Query
function getListItems(url, listname, query, complete, failure) {
	if(url == "")
	url  = _spPageContextInfo.webAbsoluteUrl;
	url = url + "/_api/web/lists/getbytitle('" + listname + "')/items" + query;
	//$('#txtCntctName').text(url);
    // Executing our items via an ajax request
    $.ajax({
        url: url,
        method: "GET",
        headers: { "Accept": "application/json; odata=verbose" },
        success: function (data) {
            complete(data); // Returns JSON collection of the results
        },
        error: function (data) {
            failure(data);
        }
    });

}
function getListItemsNonAsync(url, listname, query, complete, failure) {
	if(url == "")
	url  = _spPageContextInfo.webAbsoluteUrl;
	url = url + "/_api/web/lists/getbytitle('" + listname + "')/items" + query;
	//$('#txtCntctName').text(url);
    // Executing our items via an ajax request
    $.ajax({
        url: url,
        method: "GET",
        headers: { "Accept": "application/json; odata=verbose" },
        async: false,
        success: function (data) {
            complete(data); // Returns JSON collection of the results
        },
        error: function (data) {
            failure(data);
        }
    });

}


// Adding a list item with the metadata provided
function addListItem(url, listname, metadata, success, failure) {
	if(url == "")
	url  = _spPageContextInfo.webAbsoluteUrl;
	GetRequestDigestContext(url);
    // Prepping our update
    var item = $.extend({
        "__metadata": { "type": getListItemType(listname)}
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
            success(data); // Returns the newly created list item information
        },
        error: function (data) {
            failure(data);
        }
    });

}

function updateListItem(url, listname, id, metadata, success, failure) {
	if(url == "")
	url  = _spPageContextInfo.webAbsoluteUrl;
	GetRequestDigestContext(url);
    // Prepping our update
    var item = $.extend({
        "__metadata": { "type": getListItemType(listname) }
    }, metadata);

    getListItem(url, listname, id, function (data) {
        $.ajax({
            url: data.d.__metadata.uri,
            type: "POST",
            contentType: "application/json;odata=verbose",
            data: JSON.stringify(item),
            headers: {
                "Accept": "application/json;odata=verbose",
                "X-RequestDigest": RequestDigestValue,
                "X-HTTP-Method": "MERGE",
                "If-Match": data.d.__metadata.etag
            },
            success: function (data) {
                success(data);
            },
            error: function (data) {
                failure(data);
            }
        });

    }, function (data) {
        failure(data);
    });

}
function getListItemNonAsync(url, listname, id, complete, failure) {
	// Getting our list items
	if(url == "")
	url  = _spPageContextInfo.webAbsoluteUrl;

	$.ajax({
		url: url + "/_api/web/lists/getbytitle('" + listname + "')/items(" + id + ")",
		method: "GET",
		async: false,
		headers: { "Accept": "application/json; odata=verbose" },
		success: function (data) {
			// Returning the results
			complete(data);
		},
		error: function (data) {
			failure(data);

		}
		});
}

function updateListItemNonAsync(url, listname, id, metadata, success, failure) {
	if(url == "")
	url  = _spPageContextInfo.webAbsoluteUrl;
	GetRequestDigestContext(url);
    // Prepping our update
    var item = $.extend({
        "__metadata": { "type": getListItemType(listname) }
    }, metadata);

    getListItemNonAsync(url, listname, id, function (data) {
        $.ajax({
            url: data.d.__metadata.uri,
            type: "POST",
            contentType: "application/json;odata=verbose",
            data: JSON.stringify(item),
            headers: {
                "Accept": "application/json;odata=verbose",
                "X-RequestDigest": RequestDigestValue ,
                "X-HTTP-Method": "MERGE",
                "If-Match": data.d.__metadata.etag
            },
            success: function (data) {
                success(data);
            },
            error: function (data) {
                failure(data);
            }
        });

    }, function (data) {
        failure(data);
    });

}

// Deleting a List Item based on the ID
function deleteListItem(url, listname, id, success, failure) {
	if(url == "")
	url  = _spPageContextInfo.webAbsoluteUrl;
	GetRequestDigestContext(url);
    // getting our item to delete, then executing a delete once it's been returned
    getListItem(url, listname, id, function (data) {
        $.ajax({
            url: data.d.__metadata.uri,
            type: "POST",
            headers: {
                "Accept": "application/json;odata=verbose",
                "X-Http-Method": "DELETE",
                "X-RequestDigest": RequestDigestValue,
                "If-Match": data.d.__metadata.etag
            },
            success: function (data) {
                success(data);
            },
            error: function (data) {
                failure(data);
            }
        });
    });

};