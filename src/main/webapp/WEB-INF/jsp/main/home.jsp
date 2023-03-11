<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>영진</title>
<link rel="stylesheet" type="text/css"
	href="<c:url value='/css/common.css'/>" />
<link rel="stylesheet" type="text/css"
	href="<c:url value='/css/jquery-ui.css'/>" />

<script src="<c:url value='/js/jquery-1.12.4.min.js'/>"></script>
<script src="<c:url value='/js/jquery.form.js'/>"></script>
<script src="<c:url value='/js/jquery-ui.js'/>"></script>

<script>
	$(() => {
		$("#tabs").tabs();

		$("#tabs1-tabs").tabs();
		
		$("#tabs2-tabs").tabs();
		
		$("#tabs3-tabs").tabs();

		radioClickEvent();
		thClickEvent();
	});
</script>

<script>
function thClickEvent() {
	
	$("#tableBody tr").each(function() {
		$(this).click(function() {
			$("#updateBtn").attr("disabled", true);
			$("#updateBtn").attr("class", "button color_sub2");
			
			$("#updateEmpNo").val($(this).children().eq(2).text());
			$("#updateName").val($(this).children().eq(4).text());
			$("#updateBirthDate").val($(this).children().eq(3).text());
			if($(this).children().eq(5).text() == 'M')	{<!-- 남성일 경우 -->
				$("input:radio[name=updateGender]:radio[value='M']").prop('checked', true);
			} else {
				$("input:radio[name=updateGender]:radio[value='F']").prop('checked', true);
			}
			$("#updateHireDate").val($(this).children().eq(6).text());
		});
	});
}
</script>

<script>
function radioClickEvent() {
	$("input[name='gender']").click(function() {	// 성별과 관련된 input 입력시(라디오 버튼 클릭시)
		//console.log("클릭 테스트");
		var temp = $(this).val();
		//console.log($(this).val());
		
		$("#tableBody tr").each(function() {
			if(temp == 'A'){		// 입력값이 A(All)이면 보이게
				$(this).show();
			} else {
				if($(this).children().eq(5).text() == temp) {	// 테이블의 7번째 칼럼이 라디오버튼의 value값과 같거나
    				$(this).show();												
    			} else {
    				$(this).hide();
				}
			}
			
		});
	});
}
</script>
	
<script>
function updateInputEvent() {
	$("#updateBtn").attr("disabled", false);
	$("#updateBtn").attr("class", "button color_sub");	<!-- 값 변경시, 버튼 색 바뀌도록-->

}
</script>

<script>
function checkBoxEvent(){
	$("#tableBody tr").each(function () {
		if($(this).find('input:checkbox[name="check"]').is(":checked")) {	//tr에서 하위디렉토리의 체크박스가 체크되었다면 해당 tr 삭제																
			$(this).remove();												// (숨기기로 하면, radio에서 다시 도출됨)
		}
	});
}
</script>

<script>
function addUser() {
	const numChk = /[0-9]/g;
	
	if($('#addName').val().length > 0) {	// 이름 입력 여부
		if($('input[name=addGender]').is(":checked")) {	// 성별 선택 여부
			if($('#addBirthDate') && $('#addBirthDate').val().length == 8 && numChk.test($('#addBirthDate').val())){
				var emp = {
	                    name: $('#addName').val(),
	                    birthDate: $('#addBirthDate').val(),
	                    gender: $('input:radio[name="addGender"]:checked').val()
	            };
				
				$.ajax({
					url : "main/addUser.do",
					type : "post",
					contentType: 'application/json',
					data : JSON.stringify(emp),
					success : function() {
						alert("사원 추가 완료");
						location.reload();	<!--다시불러오는과정에서 조회탭으로 돌아간다 -->
					},
					error : function(xhr, status, error) {
						alert("에러발생");
					}
				});
			} else {
				alert("생년월일은 숫자로 8자리 입니다.");						
			}	
		} else {
			alert("성별을 선택해주세요.")
		}
	} else {
		alert("이름을 입력해주세요.");
	}
}
</script>

<script>
function delUser() {
	var temp = [];
	$("#tableBody tr").each(function () {
		if($(this).find('input:checkbox[name="check"]').is(":checked")) {	
			temp.push(($(this).children().eq(2).text()));
		}
	});
	var res = {"empNoList" : temp};
	
	var delOk = confirm("삭제 하시겠습니까?");
	if(delOk){
		$.ajax({
			url : "main/delUser.do",
			type : "post",
			data : res,
			success : function() {
				location.reload();
			},
			error : function(xhr, status, error) {
				alert("에러발생");
			}
		});
	}
}
</script>

<script>
function updateUser() {
	const numChk = /[0-9]/g;
	
	if($('#updateName').val().length > 0 && $('#updateBirthDate').val().length > 0 &&
			$('input[name=updateGender]').val().length > 0 && $('#updateHireDate').val().length > 0 ) {	<!-- 수정값 존재 여부 -->
		if($('#updateBirthDate').val().length == 8 && numChk.test($('#updateBirthDate').val())){	<!-- 생년월일 유효성 검사-->
			if($('#updateHireDate').val().length == 8 && numChk.test($('#updateHireDate').val())) {	<!-- 입사일 유효성 검사 -->
				var updateEmp = {
						empNo: $("#updateEmpNo").val(),
	                    name: $('#updateName').val(),
	                    birthDate: $('#updateBirthDate').val(),
	                    gender: $('input:radio[name="updateGender"]:checked').val(),
	                    hireDate: $('#updateHireDate').val()
	            };
				
				$.ajax({
					url : "main/updateUser.do",
					type : "post",
					contentType: 'application/json',
					data : JSON.stringify(updateEmp),
					success : function(data) {
						if(data == 0) {
							alert("수정 된 사항이 없습니다.");
						}
						location.reload();
					},
					error : function(xhr, status, error) {
						alert("에러발생");
					}
				});
			} else {
					alert("입사일자는 yyyyMMdd형식의 숫자 8자리 입니다.")
			}
		} else {
			alert("생년월일은 yyyyMMdd형식의 숫자 8자리 입니다.");						
		}
	} else {
		alert("수정할 이름, 생년월일, 성별, 입사일자를 모두 입력해주세요.")
	}
	
}
</script>

<script>
//임시 테이블 조회   //EMPLOYEES  이걸로 고정
function fn_search() {
	$.ajax({
		url : "main/getUser.do",
		type : "post",
		dataType : "json",
		data : {
				"input" : $("#input").val(),
				"condition" : $("#condition option:selected").val()
				},
		success : function(data) {
			var list = data;

			var htmlBody = "";
			$("#tableBody").empty();
			for (i = 0; i < list.length; i++) {
				var item = list[i];
				htmlBody += "<tr>";
				htmlBody += "<th width='20px'><input type='checkbox' name='check'/></th>"
				htmlBody += "<th width='20px'>" + (i + 1) + "</th>"
				htmlBody += "<th width='55px'>" + item["empNo"] + "</th>";
				htmlBody += "<th width='55px'>" + item["birthDate"] + "</th>";
				htmlBody += "<th width='70px'>" + item["name"] + "</th>";
				htmlBody += "<th width='40px'>" + item["gender"] + "</th>";
				htmlBody += "<th width='120px'>" + item["hireDate"] + "</th>";
				htmlBody += "</tr>";
			}

			$("#tableBody").html(htmlBody);
			
			thClickEvent();		<!-- row에 대한 클릭이벤트를 다시 실행해서 살린다 -->
		},
		error : function(xhr, status, error) {
			alert("에러발생");
		}
	});
	
}
</script>

<script>
function searchDetail() {
	$("#tableBody tr").each(function () {
		
		if($(this).find('input:checkbox[name="check"]').is(":checked")) {
			var gender = $(this).children().eq(5).text();
			var birthDate = $(this).children().eq(3).text();
			var hireDate = $(this).children().eq(6).text();
			
			<!-- 성별 표기 -->
			if(gender == "M" ) {	gender = "남";	} 
			else if(gender == "F") {	gender = "여";	}
			
			<!-- 생년월일 및 입사일  -->
			birthDate = birthDate.substring(0, 4) + '.' + birthDate.substring(4, 6) + '.' + birthDate.substring(6, 8);
			hireDate = hireDate.substring(0, 4) + '년' + hireDate.substring(4, 6) + '월' + hireDate.substring(6, 8) + '일';
			
		    alert("사원정보\n\n" +
		          "사번 : " + $(this).children().eq(2).text() + "\n" +
		          "이름 : " + $(this).children().eq(4).text() + "\n" +
		          "성별 : " + gender + "\n" + 
		          "생년월일 : " + birthDate + "\n" +
		          "입사일 : " + hireDate
		    );
		}	
	});
}
</script>

</head>
<body>
	<div class="container">
		<div id="tabs">
			<div class="header">
				<table width="100%">
					<tbody>
						<tr>
							<th style="width: 200px; text-align: left;">BTONE</th>
							<td>
								<ul>
									<li><a href="#tabsUserList">조회</a></li>
									<li><a href="#tabsUserAdd">사원 추가</a></li>
									<li><a href="#tabsLogin">로그인</a></li>
								</ul>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- tabs2 -->
			<div id="tabsUserList">
				<form id="tabs1-frm" name="tabs1-frm" method="post"
					onSubmit="return false;">
					<input type="hidden" id="searchTableName" name="searchTableName" />
					<input type="hidden" id="searchObjectType" name="searchObjectType" />
					<input type="hidden" id="searchObjectName" name="searchObjectName" />
					<input type="hidden" id="searchTriggerName"
						name="searchTriggerName" />

					<div class="content">
						<div class="">
							<div class="layout">
								<div class="div_select">
									<label class="selection" for="condition"> <select
										id="condition">
											<option value="emp_no" selected>사번</option>
											<option value="birth_date">생년월일</option>
											<option value="name">이름</option>
											<option value="gender">성별</option>
											<option value="hire_date">입사일</option>
									</select>
									</label> <input type="text" id="input" />
									<button class="button color_sub" onclick="fn_search();">조회
									</button>
									<button class="button color_sub" onclick="searchDetail();">상세조회
									</button>
								</div>
								<div class="div_showAndHide">
									<input type="radio" id="all" name="gender" value="A" />
									<label for="all">전체</label> 
									<input type="radio" id="male"name="gender" value="M" />
									<label for="male">남</label>
									<input type="radio" id="female" name="gender" value="F" />
									<label for="female">여</label>
									<button class="button color_sub2" onclick="checkBoxEvent();">숨기기
									</button>								
									<button class="button color_sub2" onclick="delUser();">삭제</button>
								</div>
							<!--<div class="div_crud">
									<input type="text" id="addName" placeholder="이름"/>
						    		<input type="text" id="addBirthDate" placeholder="생년월일"/>
						    		성별<input type="radio" id="addMale" name="addGender" value="M" />
								   	<label for="addMale">남</label>
								   	<input type="radio" id="addFemale" name="addGender" value="F" />
								   	<label for="addFemale">여</label>
									<button class="button color_sub" onclick="addUser();">추가</button>
									<button class="button color_sub2" onclick="delUser();">삭제</button>
								</div> -->
							</div>
							<div class="layout">
								<div class="fixedTable">
									<div class="fixedBox" style="overflow-x:hidden; height:500px">
										<table>
											<thead id="tableHead">
												<tr>
													<th width='20px'></th>
													<th width='20px'>No</th>
													<th width='55px'>사번</th>
													<th width='55px'>생년월일</th>
													<th width='70px'>이름</th>
													<th width='40px'>성별</th>
													<th width='120px'>입사일</th>
												</tr>
											</thead>
											<tbody class="table" id="tableBody">
												<c:forEach var="item" items="${list}" varStatus="status">
													<tr>
														<th width='20px'><label><input
																type="checkbox" name="check"></label></th>
														<th width='20px'>${status.count}</th>
														<th width='55px'>${item.empNo}</th>
														<th width='55px'>${item.birthDate}</th>
														<%--<th width='55px'>${fn:substring(item.birthDate, 0, 4)}
																			.${fn:substring(item.birthDate, 4, 6)}
																			.${fn:substring(item.birthDate, 6, 8)}</th>--%>
														<th width='70px'>${item.name}</th>
														<th width='40px'>${item.gender}</th>
														<th width='120px'>${item.hireDate}</th>
														<%--<th width='120px'>${fn:substring(item.hireDate, 0, 4)}년
																			${fn:substring(item.hireDate, 4, 6)}월
																			${fn:substring(item.hireDate, 6, 8)}일</th>--%>
													</tr>
												</c:forEach>
											</tbody>
										</table>
									</div>
								</div>
								<div class="div_update">
									<fieldset onchange="updateInputEvent();" style="border: none">
										<input type="text" id="updateEmpNo" placeholder="사번" readonly/>
										<input type="text" id="updateName"  placeholder="이름" />
								    	<input type="text" id="updateBirthDate" placeholder="생년월일" />
								    	성별<input type="radio" id="updateMale" name="updateGender" value="M"/>
										   <label for="updateMale">남</label>
										   <input type="radio" id="updateFemale" name="updateGender" value="F"/>
										   <label for="updateFemale">여</label>
								    	<input type="text" id="updateHireDate" placeholder="입사일"/>
								    	<button class="button color_sub2" id='updateBtn'
											disabled="disabled" onclick="updateUser();">수정</button>
									</fieldset>
								</div>
							</div>
						</div>
					</div>
				</form>
			</div>
			<!-- // tabs1 -->

			<!-- tab2 -->
			<div id="tabsLogin">
				<form id="tabs2-frm" name="tabs2-frm" method="post"
					onSubmit="return false;">
					<div class="content">
						<table>
							<tr>
								<th width='100px'>아이디</th>
								<td width='200px'><input type="text" id="username"
									name="username" style="width: 200px;" value="kss" /></td>
							</tr>
							<tr>
								<th width='100px'>비밀번호</th>
								<td width='200px'><input type="text" id="password"
									name="password" style="width: 200px;" value="1" /></td>
							</tr>
							<tr>
								<th width='100px' colspan="2">
									<button class="button color_sub"
										onclick="javascript:fn_login();">로그인</button>
								</th>
							</tr>
						</table>
					</div>
				</form>
			</div>
			<!-- // tabs3 -->
			<div id='tabsUserAdd'>
				<form id="tabs3-frm" name="tabs3-frm" method="post"
					onSubmit="return false;">
					<div class="content">
						<div class="div_add" style="display:inline-block;">
							<table>
								<tr>
									<th width='100px' style="text-align: left"> 사원명</th>
									<td width='200px'> <input type="text" id="addName" placeholder="이름"/> </td>
						    	</tr>
						    	<tr>
						    		<th width='100px' style="text-align: left">생년월일</th>
						    		<td width='200px'><input type="text" id="addBirthDate" placeholder="생년월일"/></td>
						    	</tr>
						    	<tr>
						    		<th width='100px' style="text-align: left">성별</th>
						    		<td>
							    		<input type="radio" id="addMale" name="addGender" value="M" />
									   	<label for="addMale">남</label>
									   	<input type="radio" id="addFemale" name="addGender" value="F" />
									   	<label for="addFemale">여</label>
						    		</td>
						    		<td width='200px'>
						    			<button class="button color_sub" onclick="addUser();">추가</button>
						    		</td>
						    	</tr>	
							</table>
						</div>
					</div>
				</form>
			
			</div>
			<!-- tabs4 -->
			<!-- tabs6 -->

			<!-- // tabs6 -->


		</div>
	</div>


	<!-- popup  -->
	<div id="popupBox" title="테이블"></div>

</body>
</html>