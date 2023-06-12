<%@page import="fmscar.FmscarDAO"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Date"%>
<%@page import="java.time.format.TextStyle"%>
<%@page import="java.time.DayOfWeek"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="fmsuser.fmsuser"%>
<%@page import="fmsuser.FmsuserDAO"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.tomcat.util.buf.StringUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>   

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- 루트 폴더에 부트스트랩을 참조하는 링크 -->
<link rel="stylesheet" href="../css/css/bootstrap.css">
<!-- // 폰트어썸 이미지 사용하기 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<title>FMS</title>
<link href="../css/index.css" rel="stylesheet" type="text/css">
</head>



<body>
	<!--  ********* 세션(session)을 통한 클라이언트 정보 관리 *********  -->
	<%
		FmsuserDAO userDAO = new FmsuserDAO(); //사용자 정보
	
		// 메인 페이지로 이동했을 때 세션에 값이 담겨있는지 체크
		String id = null;
		if(session.getAttribute("id") != null){
			id = (String)session.getAttribute("id");
		}
		if(id == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 필요한 서비스입니다.')");
			script.println("location.href='../login.jsp'");
			script.println("</script>");
		}
		
		// ********** 담당자를 가져오기 위한 메소드 *********** 
		String workSet;
		ArrayList<String> code = userDAO.getCode(id); //코드 리스트 출력(fmsmgrs에 접근하여, task_num을 가져옴.)
		List<String> works = new ArrayList<String>();
		
		if(code.size() == 0) {
			//1. 담당 업무가 없는 경우,
			workSet = "";
		} else {
			//2. 담당 업무가 있는 경우
			for(int i=0; i < code.size(); i++) {
				if(i < code.size()-1) {
					//task_num을 받아옴.
					String task_num = code.get(i);
					// task_num을 통해 업무명을 가져옴.
					String manager = userDAO.getManager(task_num);
					works.add(manager+"/"); //즉, work 리스트에 모두 담겨 저장됨
				} else {
					//task_num을 받아옴.
					String task_num = code.get(i);
					// task_num을 통해 업무명을 가져옴.
					String manager = userDAO.getManager(task_num);
					works.add(manager); //즉, work 리스트에 모두 담겨 저장됨
				}
			}
			workSet = String.join("\n",works) + "\n";
		}
		
		// 사용자 정보 담기
		ArrayList<fmsuser> ulist = userDAO.getUser(id);
		String password = ulist.get(0).getUser_pwd();
		String name = ulist.get(0).getUser_name();
		String rank = ulist.get(0).getUser_rk();
		//이메일  로직 처리
		String Staticemail = ulist.get(0).getUser_em();
		String[] email;
		email = Staticemail.split("@");
		String pl = ulist.get(0).getUser_fd();
		String rk = ulist.get(0).getUser_rk();
		//사용자의 AU(Authority) 권한 가져오기 (일반/PL/관리자)
		String au = ulist.get(0).getUser_au();
		
		//현재날짜 구하기
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		LocalDate nowdate = LocalDate.now();
		DayOfWeek dayOfWeek = nowdate.getDayOfWeek(); // 요일을 구하기 위한 객체 구하기
		String now = nowdate.format(formatter);
		
		//포맷을 변경하여 지정
		DateTimeFormatter simpleformatter = DateTimeFormatter.ofPattern("yyyy.MM.dd");
		
		String formatNow = nowdate.format(simpleformatter);
		String day = dayOfWeek.getDisplayName(TextStyle.SHORT, Locale.KOREAN);
		 
	%>

	<!-- fmsModal 불러오기 (심각도(등급)을 구하기 위함) -->
	<jsp:include page="../fmsModal.jsp"></jsp:include>
	
	<!-- nav바 불러오기 -->
    <jsp:include page="../Nav.jsp"></jsp:include>
	
	<!-- ********** 게시판 글쓰기 양식 영역 ********* -->
		<div class="container">
			<table class="table table-striped" style="text-align: center; cellpadding:50px;" >
				<thead>
					<tr>
						<th colspan="5" style=" text-align: center; color:blue "></th>
					</tr>
				</thead>
			</table>
		</div>
		
		<div class="container">
		<form method="post" action="/FMS/user/action/fmsAction.jsp" id="main" name="main">
			<table class="table" id="fmsTable" style="text-align: center; border: 1px solid #dddddd; border-collapse: collapse;" >
				<thead>
					<tr>
						<th colspan="6" style="background-color: #eeeeee; text-align: center;">장애 보고서 작성<br><h6>필수 작성 사항은<span style="color:#3104B4; font-weight : bold;"> 파란색</span>으로 표시됩니다.</h6></th>
					</tr>
				</thead>
				<tbody id="tbody">
							<tr class="ui-state-default ui-state-disabled">
								<th colspan="6" style="text-align: center; border: 1px solid #dddddd; background-color: #A4A4A4;">장애 개요
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd; color:#3104B4;">보고자</th>
								<th style="text-align: center; border: 1px solid #dddddd; display:none"><textarea class="textarea"  id="user_id" name="user_id"><%= id %></textarea></th>
								<th style="text-align: center; border: 1px solid #dddddd;"><%= name %> <%= rank %></th>
								<th style="text-align: center; border: 1px solid #dddddd;  color:#3104B4;">작성일</th>
								<th style="text-align: center; border: 1px solid #dddddd; display:none"><textarea class="textarea"  id="fms_doc" name="fms_doc"><%= formatNow %></textarea></th>
								<th style="text-align: center; border: 1px solid #dddddd;" data-toggle="tooltip" data-placement="bottom" title="작성일을 기준으로 자동 입력됩니다."><%= formatNow %> (<%= day %>)</th>
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd;  color:#3104B4;">장애 내용</th>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><textarea class="textarea" placeholder="장애 요약 내용" class="textarea" id="fms_con" name="fms_con" style="width:100%; border:none; resize:none" required></textarea></th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; border: 1px solid #dddddd;  color:#3104B4;">장애 발생 일자</th>
								<th style="text-align:center"><input id="fms_str" type="datetime-local" name="fms_str" required></th>
								<th style="text-align: center; border: 1px solid #dddddd;">조치 완료 일자</th>
								<th style="text-align:center"><input id="fms_end" type="datetime-local" name="fms_end"></th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; border: 1px solid #dddddd;  color:#3104B4;">장애 인지 일자</th>
								<th style="text-align:center"><input id="fms_rec" type="datetime-local" name="fms_rec" required></th>
								<th style="text-align: center; border: 1px solid #dddddd;">장애시간 / 복구 목표시간</th>
								<th style="text-align:center"><input id="fms_fov" name="fms_fov" style="width:35%; text-align:right; border:none;" readonly data-toggle="tooltip" data-html="true" data-placement="bottom" title="장애 인지 일자, 조치 완료 일자 선택 시 자동으로 계산됩니다." placeholder="장애복구시간"></input>/190분</th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; border: 1px solid #dddddd;  color:#3104B4;" onClick="dataSEV()">심각도(등급)</th>
								<th style="text-align:center" onClick="dataSEV()"><input id="fms_sev" name="fms_sev" style="width:10%; border:none" readonly data-toggle="tooltip" data-html="true" data-placement="bottom" title="A / B / C 등급 선택으로 산정됩니다." value="-"></input>등급 &nbsp;&nbsp; <button id="sev" type="button">설정</button></th>
								<th style="text-align: center; border: 1px solid #dddddd;  color:#3104B4;">장애 인지 경로</th>
								<th style="text-align:center">
									<select name="fms_rte" id="fms_rte" style="width:120px; text-align-last:center;" onchange="rteFunction()" required>
											 <option>[선택]</option>
											 <option value="메신저(Flow)">메신저(Flow)</option>
											 <option value="메일">메일</option>
											 <option value="전화">전화</option>
											 <option value="기타">기타</option>
									</select>
									<div><input id="etc_val" placeholder="인지 경로 작성" style="display:none; margin-top:10px; width:120px; height:40px; text-align-last:center;"></input></div>
								</th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; border: 1px solid #dddddd;  color:#3104B4;">장애 분야</th>
								<th style="text-align:center">
									<select name="fms_dif" id="fms_dif" style="width:120px; text-align-last:center;">
											 <option> 어플리케이션 </option>
									</select>
								</th>
								<th style="text-align: center; border: 1px solid #dddddd;  color:#3104B4;">중복장애 여부</th>
								<th style="text-align:center">
									<select name="fms_dcd" id="fms_dcd" style="width:120px; text-align-last:center;">
											 <option value="FD02">N</option>
											 <option value="FD01">Y</option>
									</select>
								</th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; border: 1px solid #dddddd;  color:#3104B4;">장애 처리자</th>
								<th style="text-align:center"><%= name %> <%= rank %></th>
								<th style="text-align: center; border: 1px solid #dddddd;  color:#3104B4;">장애 시스템</th>
								<th style="text-align:center">
									 <select name="fms_sys" id="fms_sys" style="height:45px; width:120px; text-align-last:center;">
											 <option>[선택]</option>
											 <%
											 for(int count=0; count < works.size(); count++) {
												 String nwo = works.get(count).replaceAll("/", "");
											 %>
											 	<option> <%= nwo %> </option>
											 <%
											 }
											 %>
											 <option><%= userDAO.getManager("00") %></option>
									</select>
								</th>
							</tr>
							
							
							<!-- 세부 장애 내용 -->
							<tr class="ui-state-default ui-state-disabled">
								<th colspan="6" style="text-align: center; border: 1px solid #dddddd; background-color: #A4A4A4;">세부 장애 내용
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd;">장애 증상</th>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><textarea class="textarea" placeholder="장애 증상 기재" class="textarea" id="fms_sym" name="fms_sym" style="width:100%; border:none; resize:none"></textarea></th>
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd;">조치 내용<br>(긴급)</th>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><textarea class="textarea" placeholder="조치 내용(긴급) 기재" class="textarea" id="fms_emr" name="fms_emr" style="width:100%; border:none; resize:none"></textarea></th>
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd;">조치 사항<br>(후속)</th>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><textarea class="textarea" placeholder="조치 사항(후속) 기재"  class="textarea" id="fms_dfu" name="fms_dfu" style="width:100%; border:none; resize:none"></textarea></th>
							</tr>	
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd;">업무 영향</th>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><textarea class="textarea" placeholder="업무 영향 기재"  class="textarea" id="fms_eff" name="fms_eff" style="width:100%; border:none; resize:none"></textarea></th>
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd;">장애 원인</th>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><textarea class="textarea" placeholder="장애 원인 기재"  class="textarea" id="fms_cau" name="fms_cau" style="width:100%; border:none; resize:none"></textarea></th>
							</tr>
							<tr class="ui-state-default" style="display:none">
								<th><textarea class="textarea"  id="fms_res" name="fms_res"></textarea></th>
								<th><textarea class="textarea"  id="fms_sla" name="fms_sla"></textarea></th>
								<th><textarea class="textarea"  id="fms_acd" name="fms_acd"></textarea></th>
								<th><textarea class="textarea"  id="fms_bcd" name="fms_bcd"></textarea></th>
								<th><textarea class="textarea"  id="fms_ccd" name="fms_ccd"></textarea></th>			
							</tr>

							<!-- 향후 대책 -->
							<tr class="ui-state-default ui-state-disabled">
								<th colspan="6" style="text-align: center; border: 1px solid #dddddd; background-color: #A4A4A4;">향후 대책
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th colspan="6" style="text-align: center; border: 1px solid #dddddd;"><textarea class="textarea" placeholder="향후 대책 요약 내용" class="textarea" id="fms_dre" name="fms_dre" style="width:100%; border:none; resize:none"></textarea>
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="2">실행계획</th>
								<th style="text-align: center; border: 1px solid #dddddd;  color:#3104B4;">담당자</th>
								<th style="text-align: center; border: 1px solid #dddddd;">완료 예정일</th>
							</tr>
							<tr>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="2"><textarea class="textarea" placeholder="실행계획 기재" class="textarea" id="fms_drp" name="fms_drp" style="width:100%; border:none; resize:none"></textarea></th>
								<th style="text-align: center; border: 1px solid #dddddd;"><%= name %></th>
								<th style="text-align: center; border: 1px solid #dddddd;"><input id="fms_endc" style="border:none; text-align:center" required data-toggle="tooltip" data-placement="bottom" title="조치 완료 일자를 기준으로 작성됩니다." readonly></input></th>
							</tr>
							</tbody>
						</table>
						<div id="wrapper" style="width:100%; text-align: center;">
							<!-- 저장 버튼 생성 -->
							<button type="button" onClick="SaveData()" style="margin-bottom:50px; margin-left:20px" class="btn btn-primary pull-right" data-toggle="tooltip" data-html="true" data-placement="bottom" title="작성된 내용이 저장합니다.<br>목록에서 수정하실 수 있습니다."> 저장 </button>		
							<button type="button" style="margin-bottom:50px" class="btn btn-info pull-right" onClick="empty()" data-toggle="tooltip" data-placement="bottom" title="작성된 내용을 지웁니다."> 비우기 </button>	
							<button type="Submit" id="fmssave" style="display:none"></button>								
						</div>
					</form>
				</div>	

	<!-- 현재 날짜에 대한 데이터 -->
	<textarea class="textarea"  class="textarea" id="now" style="display:none " name="now"><%= now %></textarea>
	
	<!-- 부트스트랩 참조 영역 -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="https://code.jquery.com/ui/1.12.0/jquery-ui.min.js"></script>
	<script src="../css/js/bootstrap.js"></script>
	<script src="../modalFunction.js"></script>
	<script src="https://rawgit.com/jackmoore/autosize/master/dist/autosize.min.js"></script>
	
	 <script>
	 // 장애발생 일자(str), 조치완료 일자(end)의 값을 확인하여 '장애시간(fov)'을 도출한다.
      $( document ).ready( function() {
        $( '#fms_str, #fms_rec, #fms_end' ).change( function() {
          var t = new Date($( '#fms_str' ).val());
          var a = new Date($( '#fms_rec' ).val());
          var b = new Date($( '#fms_end' ).val());
          var c = (b-a) / 60000; //분으로 표시
          var c2 = (b-t) / 60000; //분으로 표시
          
          if(c2 <= 0) { 
        	  alert("장애 발생 일자가 조치 완료 일자에 대한 설정이 올바르지 않습니다.\n조치 완료 일자보다 이전인 날짜로 설정해 주십시오."); 
        	  $( '#fms_str' ).val("");
          }

          if(a != "Invalid Date" && b != "Invalid Date") {
	          if(c > 0) { //양수인 경우, 즉, 완료일이 발생일자보다 적지 않은경우!
	          	$( '#fms_fov' ).attr('value', c);
	          	$('#fms_endc').attr('value', b.getFullYear() + "-" + (b.getMonth() + 1) + "-" + b.getDate());
	          } else {
	        	  //장애발생 일자 및 조치완료 일자가 잘못된 경우,
	        	  $( '#fms_rec' ).val("");
	        	  alert("장애 인지 일자가 조치 완료 일자에 대한 설정이 올바르지 않습니다.\n조치 완료 일자보다 이전인 날짜로 설정해 주십시오."); 
	          }
          }
         });
        
        // 기타 옵션 선택 후, 작성시
        $('#etc_val').on("input", function(event) {
        	  //var text = event.target.value;
        	var text = $("#etc_val").val();
      	  	var a = $("#fms_rte").val();
      	  	var b = $("#fms_rte option[value='"+a+"']").val(text);
      	  	//alert($("#fms_rte").val());
        }); 
      });
    </script>
	
	<script>
	function empty() {
		var check = confirm("작성된 내용이 삭제됩니다. 정말 비우시겠습니까?");
		if(check ){
			location.href='/FMS/user/main.jsp';
		}
	}
	</script>
	
	<script>
	function SaveData() {
		if($("#fms_sev").val() == '-') {
			//심각도 산정이 완료되지 않음!
			alert("심각도(등급) 설정이 완료되지 않았습니다. 해당 항목 선택하여 지정하여 주십시오.");
		} else if($("#fms_rte").val().indexOf("선택") == 1) {
			// 선택사항이 완료되지 않음! (장애 인지 경로)
			alert("장애 인지 경로 설정이 완료되지 않았습니다. 해당 항목 선택하여 지정하여 주십시오.");
			
		} else if($("#fms_sys").val().indexOf("선택") == 1) {
			// 선택사항이 완료되지 않음! (장애 시스템)
			alert("장애 시스템 설정이 완료되지 않았습니다. 해당 항목 선택하여 지정하여 주십시오.");
		}else {
			//지정이 완료됨. (Submit 타입으로 변경)
			var sdbtn = document.getElementById("fmssave");
			
			if($("#fms_sym").val() == "" || $("#fms_emr").val() == "" || $("#fms_dfu").val() == "" || $("#fms_eff").val() == "" || $("#fms_cau").val() == "" || $("#fms_dre").val() == "" || $("#fms_drp").val() == "") {
				if(confirm("작성되지 않은 내용이 있습니다. 저장하시겠습니까?\n(제출 시, 모든 항목이 작성되어 있어야 합니다.)")) {
					sdbtn.click();
				}
			} else {
			sdbtn.click();
			}
		}
	}
	</script>
	
	<script>
	// 기타 옵션 선택시, 작성할 수 있도록 함!
	function rteFunction() {
		const etc_val = document.getElementById("etc_val");
		if($("#fms_rte").val().indexOf("기타") == -1) {
			etc_val.style.display = 'none';
			etc_val.required = false;
		} else { 
			//alert("기타 선택");
			etc_val.style.display = '';
			etc_val.required = true;
		}
	}
	</script>
	
	<textarea class="textarea"  class="textarea" id="workSet" name="workSet" style="display:none;" readonly><%= workSet %></textarea>

	
</body>