<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>yj</title>
<link rel="stylesheet" type="text/css"
	href="<c:url value='/css/common.css'/>" />
<link rel="stylesheet" type="text/css"
	href="<c:url value='/css/jquery-ui.css'/>" />
<link rel="stylesheet" type="text/css"
	href="<c:url value='/js/tui/tui-grid.css'/>" />

<script src="<c:url value='/js/jquery-1.12.4.min.js'/>"></script>
<script src="<c:url value='/js/jquery.form.js'/>"></script>
<script src="<c:url value='/js/jquery-ui.js'/>"></script>
<script src="<c:url value='/js/tui/tui-grid.js'/>"></script>

<style type="text/css">
:root {
	--color-primary: #4A545F;
	--color-secondary: #2E3742;
	--color-text: #ffffff;
	--color-background: #4A545F;
	--color-info: #00A2E8;
}

html, body {
	width: 100%;
	height: 100%;
	margin: 0px;
	padding: 0px;
	font-family: 'D2Coding';
	font-size: 13px;
	color: #000000;
	overflow: hidden;
}

/* input */
a {
	color: #4A545F;
	font-family: 'D2Coding';
}

a:focus, a:hover, a:active {
	color: #333333;
	font-family: 'D2Coding';
}

input {
	height: 25px;
	border: 1px solid #999999;
	border-radius: 3px;
	font-family: 'D2Coding';
	font-size: 13px;
}

select {
	height: 25px;
	border: 1px solid #999999;
	border-radius: 3px;
	font-family: 'D2Coding';
	font-size: 13px;
}

textarea {
	border: 1px solid #999999;
	border-radius: 3px;
	font-family: 'D2Coding';
	font-size: 13px;
}


.tx-textarea {
	width: calc(100vw - 630px);
	height: calc(100vh - 160px);
	overflow-x:hidden;
	overflow-wrap:normal;
}

.tx-color-primary {
	background-color: var(--color-primary);
}

.tx-color-info {
	background-color: var(--color-info);
}

.tx-container {
	width: 100%;
	height: 100%;
	padding: 0px;
}

.tx-content {
	padding: 10px;
}

.tx-row {
	padding-top: 5px;
	padding-bottom: 5px;
}

.tx-nav {
	padding: 5px;
	background-color: #2E3742;
	color: #FFFFFF;
}

.tx-left {
	width: 550px;
	height: calc(100vh - 100px);
	padding: 10px;
	float: left;
	border: 1px solid #bcbcbc;
	border-radius: 3px;
}

.tx-main {
	width: calc(100vw - 630px);
	height: calc(100vh - 100px);
	padding: 10px;
	float: right;
	border: 1px solid #bcbcbc;
	border-radius: 2px;
}

.tx-button {
	color: var(--color-text);
	border: none;
	padding: 5px 14px;
	text-align: center;
	text-decoration: none;
	display: inline-block;
	font-size: 13px;
	border-radius: 2px;
}
</style>

<script>

let Grid;
let tableGrid;

$(document).ready(function() {

	var height = document.getElementById('left').clientHeight - 110;


	Grid = tui.Grid;

	//tableGrid
	tableGrid = new Grid({
		  el: document.getElementById('tableGrid'),
		  rowHeaders: ['rowNum'],
		  scrollX: false,
		  scrollY: true,
		  bodyHeight: height,
		  rowHeight:30,
		  minRowHeight:30,
		  header: {
		        height: 30
		      },
		  columns: [
			  {
		      header: '테이블',
		      name: 'tableName',
		      width:250
		    },
		    {
		      header: '컬럼',
		      name: 'colCnt',
		      width:50,
		      align: 'center'
		    },
		    {
		      header: '설명',
		      name: 'comments'
		    }
		  ]
	});

	Grid.applyTheme('default',
		{
		  cell: {
			    normal: {
			    	background: '#fff',
			    },
			    header: {
			      background: '#F8F8F8',
			    },
			  }
		}
	);

	tableGrid.on('click', function (ev) {
		var tableName = tableGrid.getValue(ev.rowKey, "tableName");
		fn_tableInfo(tableName);

	});
});

function fn_tab(evt, tab, tabId) {
  var i;
  var x = document.getElementsByClassName(tab);
  for (i = 0; i < x.length; i++) {
    x[i].style.display = "none";
  }
  document.getElementById(tabId).style.display = "block";


  tablinks = document.getElementsByClassName("tx-tab");
  for (i = 0; i < x.length; i++) {
    tablinks[i].className = tablinks[i].className.replace("tx-color-info", "tx-color-primary");
  }
  evt.currentTarget.className += " tx-color-info";
}


function fn_tableList() {
	var frmData = $("#tabs1-frm").serializeArray();

	$.ajax({
		 url :"<c:url value='/main/tableList.do'/>"
		,type:"post"
		,dataType:"json"
		,data:frmData
		,success:function(data){
			tableGrid.resetData(data.list);
		}
	    ,error: function(xhr,status, error){
	    	alert("에러발생");
	    }
	});
}

//
function fn_tableInfo(searchTableName){

	//param
	$("#searchTableName").val(searchTableName);

	var frmData = $("#tabs1-frm").serializeArray();

	$.ajax({
		 url :"<c:url value='/main/tableInfo.do?cmd=tableInfo'/>"
		,type:"post"
		,dataType:"json"
		,data:frmData
		,success:function(data){
			$("#tabs1-tabs1-input").val(data.tableInfo);
			$("#tabs1-tabs2-input").val(data.tableSql);
		}
	    ,error: function(xhr,status, error){
	    	alert("에러발생");
	    }
	});
}


</script>
</head>
<body>

	<div class="tx-container">
		<div class="tx-nav">
			<table width="100%">
				<tbody>
					<tr>
						<th style="width: 200px; text-align: left;">yj</th>
						<td>
							<button class="tx-button tx-color-primary">DB</button>
							<button class="tx-button tx-color-primary">변환</button>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="tx-content">
			<form id="tabs1-frm" name="tabs1-frm" method="post"
				onSubmit="return false;">
				<input type="hidden" id="searchTableName" name="searchTableName" />
				<input type="hidden" id="searchObjectType" name="searchObjectType" />
				<input type="hidden" id="searchObjectName" name="searchObjectName" />
				<input type="hidden" id="searchTriggerName" name="searchTriggerName" />
				<div id="left" class="tx-left">
					<div class="tx-row">
						<select id="owner" name="owner" style="width: 100px">
							<c:forEach items="${db}" var="item">
								<option value="${item.owner}">${item.desc}</option>
							</c:forEach>
						</select>
						<select id="searchOpt" name="searchOpt" style="width: 120px">
							<option value="tableList">테이블</option>
							<option value="dataDicList">데이터사전</option>
							<option value="objectList">오브젝트</option>
							<option value="triggerList">트리거</option>
						</select> <input type="text" id="searchKey" name="searchKey" style="width: 230px;" onkeypress="fn_onKeyDown(event);" />
						<button class="tx-button tx-color-primary" onclick="javascript:fn_tableList();">조회</button>
					</div>
					<div class="tx-row">
						<div id="tableGrid"></div>
					</div>
				</div>
				<div class="tx-main">
					<div class="tx-row">
						<button class="tx-button tx-color-info tx-tab" onclick="fn_tab(event,'tab1','tab11')">정보</button>
						<button class="tx-button tx-color-primary tx-tab" onclick="fn_tab(event,'tab1','tab12')">쿼리</button>
					</div>

					<div class="tx-row">
						<div class="tab1" id="tab11">
							<textarea id="tabs1-tabs1-input" name="tabs1-tabs1-input" class="tx-textarea " wrap="off" ></textarea>
						</div>
						<div class="tab1" id="tab12" style="display:none">
							<textarea id="tabs1-tabs2-input" name="tabs1-tabs2-input" class="tx-textarea" wrap="off" ></textarea>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
</body>
</html>