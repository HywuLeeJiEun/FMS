<%@page import="java.util.Arrays"%>
<%@page import="fmsrept.fmsrept"%>
<%@page import="fmsrept.FmsreptDAO"%>
<%@page import="fmscar.fmscarc"%>
<%@page import="fmscar.fmscarb"%>
<%@page import="fmscar.fmscara"%>
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
		FmsreptDAO fms = new FmsreptDAO(); //rept 정보
	
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
		
				
		String fmsr_cd = request.getParameter("fmsr_cd");
		String user_id = request.getParameter("user_id");
		
		if(user_id == null || user_id.isEmpty()) {
			user_id = id;
		}
		
		if(fmsr_cd == null || fmsr_cd.isEmpty()) {
			//비어 있는 경우, 데이터가 없거나 사라짐
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 보고서입니다. 코드번호 및 게시글 정보를 확인해주시길 바랍니다.')");
			script.println("location.href='/FMS/user/fbbs.jsp'");
			script.println("</script");
		}
		
		//데이터 가져오기
		ArrayList<fmsrept> flist = fms.getfmsOne(fmsr_cd, user_id);
		
		//현재날짜 구하기
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		LocalDate nowdate = LocalDate.parse(flist.get(0).getFms_doc());
		DayOfWeek dayOfWeek = nowdate.getDayOfWeek(); // 요일을 구하기 위한 객체 구하기
		String now = nowdate.format(formatter);
		
		//포맷을 변경하여 지정
		DateTimeFormatter simpleformatter = DateTimeFormatter.ofPattern("yyyy.MM.dd");
		
		String formatNow = nowdate.format(simpleformatter);
		String day = dayOfWeek.getDisplayName(TextStyle.SHORT, Locale.KOREAN);
		
		
		// 보고서에 사용될 정보들
		String fname = userDAO.getName(user_id);
	
	%>
	<!-- fmsAdminModal 불러오기 (심각도(등급) 선택 사항 확인을 위함.) -->
	<jsp:include page="../fmsAdminModal.jsp">
		<jsp:param value="<%= fmsr_cd %>" name="fmsr_cd"/>
		<jsp:param value="<%= flist.get(0).getFms_sco() %>" name="fms_sco"/>
	</jsp:include>
	
	<!-- nav바 불러오기 -->
    <jsp:include page="../Nav.jsp"></jsp:include>
	
	<!-- ********** 게시판 글쓰기 양식 영역 ********* -->
		<div class="container">
			<table class="table table-striped" style="text-align: center; cellpadding:50px;" >
				<thead>
					<tr>
						<th colspan="5" style=" text-align: center; color:#3104B4 "></th>
					</tr>
				</thead>
			</table>
		</div>
		
		<div class="container">
		<form method="post" action="/FMS/user/action/fmsUpdateAction.jsp" id="main" name="main">
			<table class="table" id="fmsTable" style="text-align: center; border: 1px solid #dddddd; border-collapse: collapse;" >
				<thead>
					<tr>
						<th colspan="6" style="background-color: #eeeeee; text-align: center;">장애 보고서 검토 (수정 및 승인)<br><h6>장애보고 확인 및 수정 후 승인이 진행됩니다.</h6></th>
					</tr>
				</thead>
				<tbody id="tbody">
							<tr class="ui-state-default ui-state-disabled">
								<th colspan="6" style="text-align: center; border: 1px solid #dddddd; background-color: #A4A4A4;">장애 개요
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd;">보고자</th>
								<th style="text-align: center; border: 1px solid #dddddd; display:none"><textarea class="textarea"  id="user_id" name="user_id"><%= user_id %></textarea></th>
								<th style="text-align: center; border: 1px solid #dddddd;"><%= userDAO.getName(user_id) %> <%= userDAO.getRank(user_id) %></th>
								<th style="text-align: center; border: 1px solid #dddddd;">작성일</th>
								<th style="text-align: center; border: 1px solid #dddddd; display:none"><textarea class="textarea"  id="fms_doc" name="fms_doc"><%= formatNow %></textarea></th>
								<th style="text-align: center; border: 1px solid #dddddd;" data-toggle="tooltip" data-placement="bottom" title="작성일을 기준으로 자동 입력됩니다."><%= formatNow %> (<%= day %>)</th>
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; color:#3104B4; border: 1px solid #dddddd;">장애 내용</th>
								<th style="text-align: center;border: 1px solid #dddddd;" colspan="3"><textarea maxlength="1000" class="textarea"  class="textarea" id="fms_con" name="fms_con" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_con() %></textarea></th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; border: 1px solid #dddddd;">장애 발생 일자</th>
								<th style="text-align:center"><input readonly id="fms_str" type="datetime-local" name="fms_str" required value="<%= flist.get(0).getFms_str() %>"></th>
								<th style="text-align: center; border: 1px solid #dddddd;">조치 완료 일자</th>
								<th style="text-align:center"><input readonly id="fms_end" type="datetime-local" name="fms_end" required value="<%= flist.get(0).getFms_end() %>"></th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; border: 1px solid #dddddd;">장애 인지 일자</th>
								<th style="text-align:center"><input readonly id="fms_rec" type="datetime-local" name="fms_rec" required value="<%= flist.get(0).getFms_rec() %>"></th>
								<th style="text-align: center; border: 1px solid #dddddd;">장애시간 / 복구 목표시간</th>
								<th style="text-align:left"><input id="fms_fov" name="fms_fov" style="width:35%; border:none; text-align:right;" readonly data-toggle="tooltip" data-html="true" data-placement="bottom" title="장애발생 일자, 조치 완료 일자 선택 시 자동으로 계산됩니다." value="<%= flist.get(0).getFms_fov() %>"></input>/190분</th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; border: 1px solid #dddddd;" onClick="dataSEV()">심각도(등급)</th>
								<th style="text-align:center" onClick="dataSEV()"><input name="fms_sev" style="width:10px; border:none; text-align:left" readonly value="<%= flist.get(0).getFms_sev()%>"></input>등급<button style="margin-left:5px" id="sev" type="button">확인</button><input type="hidden" name="fms_sco" value="<%= flist.get(0).getFms_sco() %>"></th>
								<th style="text-align: center; color:#3104B4; border: 1px solid #dddddd;">장애 인지 경로</th>
								<th style="text-align:center"><textarea id="fms_rte" name="fms_rte"  class="textarea"  class="textarea" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_rte() %></textarea></th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; color:#3104B4; border: 1px solid #dddddd;">장애 분야</th>
								<th style="text-align:center">
									<select name="fms_dif" id="fms_dif" style="width:120px; text-align-last:center;">
											 <option selected> 어플리케이션 </option>
									</select>
								</th>
								<th style="text-align: center; color:#3104B4; border: 1px solid #dddddd;">중복장애 여부</th>
								<th style="text-align:center; display:none"><textarea id="fms_dcd" name="fms_dcd" required><%= flist.get(0).getFms_dcd() %></textarea></th>
								<% String dcd = "N"; if(flist.get(0).getFms_dcd().equals("FD01")){ dcd = "Y"; } %>
								<th style="text-align:center"><textarea  class="textarea"  class="textarea" style="width:100%; border:none; resize:none" required><%= dcd %></textarea></th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; border: 1px solid #dddddd;">장애 처리자</th>
								<th style="text-align:center"><%= userDAO.getName(user_id) %> <%= userDAO.getRank(user_id) %></th>
								<th style="text-align: center; color:#3104B4; border: 1px solid #dddddd;">장애 시스템</th>
								<th style="text-align:center; display:none"><textarea id="fms_sys" name="fms_sys" required><%= flist.get(0).getFms_sys() %></textarea></th>
								<th style="text-align:center"><textarea  class="textarea"  class="textarea" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_sys() %></textarea></th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; color:#3104B4; border: 1px solid #dddddd;">장애 책임</th>
								<th style="text-align:center" colspan="3"><textarea id="fms_res" name="fms_res" class="textarea"  class="textarea" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_res() %></textarea></th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; color:#3104B4; border: 1px solid #dddddd;">SLA 대상여부</th>
								<th style="text-align:left" colspan="3">
									<select name="fms_sla" id="fms_sla" style="width:120px; text-align-last:center;" onchange="slaOption()">
									<% 
										ArrayList<String> sla =  new ArrayList<String>(Arrays.asList("N","Y")); 
										for (int i=0; i < sla.size(); i++) {
											String slaVal = "비해당";
											if(sla.get(i).equals("Y")) { slaVal = "해당"; }
									%>
										<option <%= flist.get(0).getFms_rte().equals(sla.get(i))?"selected":"" %> value="<%= sla.get(i) %>"><%= slaVal %></option>	 
									<%
										}
									%>
									</select>
								</th>
							</tr>
							<!--  SLA 대상 여부가 비해당인 경우, 사유 입력 -->
							<tr id="reaTr" class="ui-state-default ui-state-disabled">
								<th style="text-align: center; color:#3104B4; border: 1px solid #dddddd;">사유</th>
								<th style="text-align:center" colspan="3"><textarea id="sla_rea" name="sla_rea" class="textarea" maxlength="1000"  class="textarea" style="width:100%; border:none; resize:none" required><%= flist.get(0).getSla_rea() %></textarea></th>
							</tr>
							
							<!-- 세부 장애 내용 -->
							<tr class="ui-state-default ui-state-disabled">
								<th colspan="6" style="text-align: center; border: 1px solid #dddddd; background-color: #A4A4A4;">세부 장애 내용
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; color:#3104B4; border: 1px solid #dddddd;">장애 증상</th>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><textarea class="textarea" maxlength="800"  class="textarea" id="fms_sym" name="fms_sym" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_sym() %></textarea></th>
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; color:#3104B4; border: 1px solid #dddddd;">조치 내용<br>(긴급)</th>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><textarea class="textarea" maxlength="800" class="textarea" id="fms_emr" name="fms_emr" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_emr() %></textarea></th>
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; color:#3104B4; border: 1px solid #dddddd;">조치 사항<br>(후속)</th>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><textarea class="textarea" maxlength="800" class="textarea" id="fms_dfu" name="fms_dfu" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_dfu() %></textarea></th>
							</tr>	
							<tr class="ui-state-default">
								<th style="text-align: center; color:#3104B4; border: 1px solid #dddddd;">업무 영향</th>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><textarea class="textarea" maxlength="800" class="textarea" id="fms_eff" name="fms_eff" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_eff() %></textarea></th>
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; color:#3104B4; border: 1px solid #dddddd;">장애 원인</th>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><textarea class="textarea" maxlength="800" class="textarea" id="fms_cau" name="fms_cau" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_cau() %></textarea></th>
							</tr>
							<tr class="ui-state-default" style="display:none">
								<th><textarea id="fms_res" name="fms_res"><%= flist.get(0).getFms_res() %></textarea></th>
								<th><textarea id="fms_sla" name="fms_sla"><%= flist.get(0).getFms_sla() %></textarea></th>
								<th><textarea id="fms_acd" name="fms_acd"><%= flist.get(0).getFms_acd() %></textarea></th>
								<th><textarea id="fms_bcd" name="fms_bcd"><%= flist.get(0).getFms_bcd() %></textarea></th>
								<th><textarea id="fms_ccd" name="fms_ccd"><%= flist.get(0).getFms_ccd() %></textarea></th>		
								<th><textarea id="fmsr_cd" name="fmsr_cd"><%= flist.get(0).getFmsr_cd() %></textarea></th>
								<th><textarea id="fms_sig" name="fms_sig">승인</textarea></th>
							</tr>
							
							<!-- 향후 대책 -->
							<tr class="ui-state-default ui-state-disabled">
								<th colspan="6" style="text-align: center; color:#3104B4; border: 1px solid #dddddd; background-color: #A4A4A4;">향후 대책
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th colspan="6" style="text-align: center; border: 1px solid #dddddd;"><textarea class="textarea" maxlength="800" class="textarea" id="fms_dre" name="fms_dre" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_dre() %></textarea>
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; color:#3104B4; border: 1px solid #dddddd;" colspan="2">실행계획</th>
								<th style="text-align: center; border: 1px solid #dddddd;">담당자</th>
								<th style="text-align: center; border: 1px solid #dddddd;">완료 예정일</th>
							</tr>
							<tr>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="2"><textarea class="textarea" maxlength="500" class="textarea" id="fms_drp" name="fms_drp" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_drp() %></textarea></th>
								<th style="text-align: center; border: 1px solid #dddddd;"><%= userDAO.getName(user_id) %></th>
								<th style="text-align: center; border: 1px solid #dddddd;"><input style="text-align:center; border:none" id="fms_endc" required data-toggle="tooltip" data-placement="bottom" title="조치 완료 일자를 기준으로 작성됩니다." readonly value="<%= flist.get(0).getFms_end().substring(0,10) %>"></input></th>
							</tr>
							</tbody>
						</table>
						<div id="wrapper" style="width:100%; text-align: center;">
							<!-- 저장 버튼 생성 -->
							<a type="button" href="/FMS/user/fbbs.jsp" style="margin-bottom:50px; margin-left:20px" class="btn btn-primary pull-right"> 목록 </a>
							<%
								if(flist.get(0).getFms_sig().equals("제출")) { // '제출' - 사용(개발자)가 승인 수령을 위해 보고를 제출한 상태
							%>
							<button type="button" onClick="SaveData()" style="margin-bottom:50px" class="btn btn-success pull-right" data-toggle="tooltip" data-html="true" data-placement="bottom" data-html="true" title="승인 처리를 진행합니다. <br>데이터 수정이 발생한 경우, 수정된 데이터를 승인합니다."> 승인 </button>	
							<button onClick="return confirm('승인하시겠습니까?\n수정된 데이터가 있는 경우, 해당 데이터로 승인됩니다.')" type="Submit" id="fmssave" style="display:none"></button>						
							<%
								} else if (flist.get(0).getFms_sla().equals("Y")){
							%>
							<a type="button" href="/FMS/user/action/fmsSignAction.jsp?fmsr_cd=<%= flist.get(0).getFmsr_cd() %>&fms_sig=저장" onClick="returnfirm('제출하시겠습니까?\n제출 시, 수정/삭제가 불가하며 관리자에게 보고 됩니다.')" style="margin-bottom:50px; margin-left:20px" class="btn btn-success pull-right" data-toggle="tooltip" data-html="true" data-placement="bottom" title="제출을 취소하여 수정/삭제가 가능하도록 합니다.">출력</a>		
							<%
								}

							%>
						</div>
					</form>
				</div>	

	<!-- 현재 날짜에 대한 데이터 -->
	<textarea class="textarea"  class="textarea" id="now" style="display:none " name="now"><%= now %></textarea>
	
	<!-- 부트스트랩 참조 영역 -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="https://code.jquery.com/ui/1.12.0/jquery-ui.min.js"></script>
	<!-- auto size를 위한 라이브러리 -->
	<script src="https://rawgit.com/jackmoore/autosize/master/dist/autosize.min.js"></script>
	<script src="../css/js/bootstrap.js"></script>
	<script src="../modalFunction.js"></script>

	
	<script>
	function SaveData() {
		if($("#fms_sev").val() == '-') {
			//심각도 산정이 완료되지 않음!
			alert("심각도(등급) 설정이 완료되지 않았습니다. 해당 항목 선택하여 지정하여 주십시오.");
		} else {
			//지정이 완료됨. (Submit 타입으로 변경)
			var sdbtn = document.getElementById("fmssave");
			sdbtn.click();
		}
	}
	</script>
	
	<script>
	// sla '해당', '비해당'에 따라 사유(sla_rea) 표시하기
	function slaOption() {
		var sla = $("#fms_sla").val();
		var rea = $("#sla_rea");
		var reaTr = $("#reaTr");
		if(sla == "N") {
			// 사유 입력이 필요함!
			rea.attr("required" , true);
			reaTr.css("display","");
		} else {
			// 사유 입력이 필요 없음!
			rea.attr("required" , false);
			reaTr.css("display","none");
		}
		
	}
	
	</script>
	
	<script>
	$(document).ready(function(){
		var sla = '<%= flist.get(0).getFms_sla() %>';
		if(sla == 'Y') {
			// 만약 '해당'인 경우,
			$("#fms_sla").val("Y").prop("selected",true);
			var sla = $("#fms_sla").val();
			var rea = $("#sla_rea");
			var reaTr = $("#reaTr");
			// 사유 입력이 필요 없음!
			rea.attr("required" , false);
			reaTr.css("display","none");
		}
	});
	</script>
	
	<textarea class="textarea"  class="textarea" id="workSet" name="workSet" style="display:none;" readonly><%= workSet %></textarea>

	
</body>