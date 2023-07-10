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
<title>IMS</title>
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
		
		
		// 테이블 FMSCARA, FMSCARB, FMSCARC 불러오기
		FmscarDAO fmscar = new FmscarDAO();
		ArrayList<fmscara> cara = fmscar.getfmscara();
		ArrayList<fmscarb> carb = fmscar.getfmscarb();
		ArrayList<fmscarc> carc = fmscar.getfmscarc();
				
		String fmsr_cd = request.getParameter("fmsr_cd");
		if(fmsr_cd == null || fmsr_cd.isEmpty()) {
			//비어 있는 경우, 데이터가 없거나 사라짐
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 보고서입니다. 코드번호 및 게시글 정보를 확인해주시길 바랍니다.')");
			script.println("location.href='/FMS/user/fbbs.jsp'");
			script.println("</script");
		}
		
		//데이터 가져오기
		ArrayList<fmsrept> flist = fms.getfmsOne(fmsr_cd, id);
		
		//현재날짜 구하기
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		LocalDate nowdate = LocalDate.parse(flist.get(0).getFms_doc());
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
		<form method="post" action="/FMS/user/action/fmsUpdateAction.jsp" id="main" name="main">
			<table class="table" id="fmsTable" style="text-align: center; border: 1px solid #dddddd; border-collapse: collapse;" >
				<thead>
					<tr>
						<th colspan="6" style="background-color: #eeeeee; text-align: center;">장애 보고서 수정</th>
					</tr>
				</thead>
				<tbody id="tbody">
							<tr class="ui-state-default ui-state-disabled">
								<th colspan="6" style="text-align: center; border: 1px solid #dddddd; background-color: #A4A4A4;">장애 개요
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd;">보고자</th>
								<th style="text-align: center; border: 1px solid #dddddd; display:none"><textarea class="textarea con"  id="user_id" name="user_id"><%= id %></textarea></th>
								<th style="text-align: center; border: 1px solid #dddddd;"><%= name %> <%= rank %></th>
								<th style="text-align: center; border: 1px solid #dddddd;">작성일</th>
								<th style="text-align: center; border: 1px solid #dddddd; display:none"><textarea class="textarea con"  id="fms_doc" name="fms_doc"><%= formatNow %></textarea></th>
								<th style="text-align: center; border: 1px solid #dddddd;" data-toggle="tooltip" data-placement="bottom" title="작성일을 기준으로 자동 입력됩니다."><%= formatNow %> (<%= day %>)</th>
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd;">장애 내용</th>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><textarea maxlength="1000" class="textarea con"  class="textarea" id="fms_con" name="fms_con" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_con() %></textarea></th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; border: 1px solid #dddddd;">장애 발생 일자</th>
								<th style="text-align:center"><input id="fms_str" type="datetime-local" name="fms_str" required value="<%= flist.get(0).getFms_str() %>"></th>
								<th style="text-align: center; border: 1px solid #dddddd;">조치 완료 일자</th>
								<th style="text-align:center"><input id="fms_end" class="req" type="datetime-local" name="fms_end" required value="<%= flist.get(0).getFms_end() %>"></th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; border: 1px solid #dddddd;">장애 인지 일자</th>
								<th style="text-align:center"><input id="fms_rec" type="datetime-local" name="fms_rec" required value="<%= flist.get(0).getFms_rec() %>"></th>
								<th style="text-align: center; border: 1px solid #dddddd;">장애시간 / 복구 목표시간</th>
								<th style="text-align:center"><input id="fms_fov" name="fms_fov" style="width:30%; border:none; text-align:right" readonly data-toggle="tooltip" data-html="true" data-placement="bottom" title="장애 인지 일자, 조치 완료 일자 선택 시 자동으로 계산됩니다." value="<%= flist.get(0).getFms_fov() %>"></input>/190분</th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; border: 1px solid #dddddd;" onClick="dataSEV()">심각도(등급)</th>
								<th style="text-align:center" onClick="dataSEV()"><input id="fms_sev" name="fms_sev" style="width:10%; border:none" readonly data-toggle="tooltip" data-html="true" data-placement="bottom" title="A / B / C 등급 선택으로 산정됩니다." value="<%= flist.get(0).getFms_sev() %>"></input>등급 &nbsp; 총<input id="fms_sco" name="fms_sco" style="width:30px; border:none; text-align:right" value="<%= flist.get(0).getFms_sco() %>">점 &nbsp; <button id="sev" type="button">재설정</button></th>
								<th style="text-align: center; border: 1px solid #dddddd;">장애 인지 경로</th>
								<th style="text-align:center">
									<select name="fms_rte" id="fms_rte" style="width:120px; text-align-last:center;" onchange="rteFunction()">
									<% 
										int optionRes = 0;
										ArrayList<String> rte =  new ArrayList<String>(Arrays.asList("메신저(Flow)","메일","전화","기타")); 
										for (int i=0; i < rte.size(); i++) {
									%>
										<option <%= flist.get(0).getFms_rte().equals(rte.get(i))?"selected":"" %> value="<%= rte.get(i) %>"><%= rte.get(i) %></option>	 
									<%
											if(flist.get(0).getFms_rte().equals(rte.get(i))) {
												// 만약 selected가 되었다면,
												optionRes = 1;
											}
										}
										
										if(optionRes != 1) { 
											// 선택된 조건이 없다면
 									%>
										<option selected value="<%= flist.get(0).getFms_rte() %>"><%= flist.get(0).getFms_rte() %></option>
									<%
										}
									%>
									</select>
									<div><input id="etc_val" placeholder="인지 경로 작성" style="display:none; margin-top:10px; width:120px; height:40px; text-align-last:center;"></input></div>
								</th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; border: 1px solid #dddddd;">장애 분야</th>
								<th style="text-align:center">
									<select name="fms_dif" id="fms_dif" style="width:120px; text-align-last:center;">
											 <option selected> 어플리케이션 </option>
									</select>
								</th>
								<th style="text-align: center; border: 1px solid #dddddd;">중복장애 여부</th>
								<th style="text-align:center">
									<select name="fms_dcd" id="fms_dcd" style="width:120px; text-align-last:center;">
											<% 
												ArrayList<String> dcd =  new ArrayList<String>(Arrays.asList("FD02","FD01")); 
												for (int i=0; i < dcd.size(); i++) {
													String fcode = "N";
													if(!dcd.get(i).equals("FD02")) {
														fcode = "Y";
													}
											%>
												<option <%= flist.get(0).getFms_dcd().equals(dcd.get(i))?"selected":"" %> value="<%= dcd.get(i) %>"><%= fcode %></option>	 
											<%
												}
											%>
									</select>
								</th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; border: 1px solid #dddddd;">장애 처리자</th>
								<th style="text-align:center"><%= name %> <%= rank %></th>
								<th style="text-align: center; border: 1px solid #dddddd;">장애 시스템</th>
								<th style="text-align:center">
									 <select name="fms_sys" id="fms_sys" style="height:45px; width:120px; text-align-last:center;" onchange="sysFunction()"> 
											 <%
											 for(int count=0; count < works.size(); count++) {
												 String nwo = works.get(count).replaceAll("/", "");
											 %>
											 	<option <%= userDAO.getManager(flist.get(0).getFms_sys()).equals(nwo.trim())?"Selected":"" %>> <%= nwo.trim() %> </option>
											 <%
											 }
											 if(!works.contains(flist.get(0).getFms_sys()) && !flist.get(0).getFms_sys().equals(userDAO.getManager("00"))) { // 시스템 목록에 없는 경우, - 기타 선택 후 작성한 경우임!
											 %>
											 <option  Selected value="<%= flist.get(0).getFms_sys() %>"><%= flist.get(0).getFms_sys() %></option>
											<% } %>
											<option  <%= flist.get(0).getFms_sys().equals(userDAO.getManager("00"))?"Selected":"" %> value="<%= userDAO.getManager("00") %>"><%= userDAO.getManager("00") %></option>
									</select>
									<div><input id="sys_val" placeholder="장애시스템 작성" style="display:none; margin-top:10px; width:120px; height:40px; text-align-last:center;"></input></div>
								</th>
							</tr>
							
							
							<!-- 세부 장애 내용 -->
							<tr class="ui-state-default ui-state-disabled">
								<th colspan="6" style="text-align: center; border: 1px solid #dddddd; background-color: #A4A4A4;">세부 장애 내용
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd;">장애 증상</th>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><textarea maxlength="800" class="textarea req"  class="textarea" id="fms_sym" name="fms_sym" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_sym() %></textarea></th>
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd;">조치 내용<br>(긴급)</th>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><textarea maxlength="800" class="textarea req"  class="textarea" id="fms_emr" name="fms_emr" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_emr() %></textarea></th>
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd;">조치 사항<br>(후속)</th>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><textarea maxlength="800" class="textarea req"  class="textarea" id="fms_dfu" name="fms_dfu" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_dfu() %></textarea></th>
							</tr>	
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd;">업무 영향</th>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><textarea maxlength="800" class="textarea req"  class="textarea" id="fms_eff" name="fms_eff" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_eff() %></textarea></th>
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd;">장애 원인</th>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><textarea maxlength="800" class="textarea req"  class="textarea" id="fms_cau" name="fms_cau" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_cau() %></textarea></th>
							</tr>
							<tr class="ui-state-default" style="display:none">
								<th><textarea id="fms_res" name="fms_res"><%= flist.get(0).getFms_res() %></textarea></th>
								<th><textarea id="fms_sla" name="fms_sla"><%= flist.get(0).getFms_sla() %></textarea></th>
								<th><textarea id="fms_acd" name="fms_acd"><%= flist.get(0).getFms_acd() %></textarea></th>
								<th><textarea id="fms_bcd" name="fms_bcd"><%= flist.get(0).getFms_bcd() %></textarea></th>
								<th><textarea id="fms_ccd" name="fms_ccd"><%= flist.get(0).getFms_ccd() %></textarea></th>		
								<th><textarea id="fmsr_cd" name="fmsr_cd"><%= flist.get(0).getFmsr_cd() %></textarea></th>
								<th><textarea id="fms_sig" name="fms_sig"><%= flist.get(0).getFms_sig() %></textarea></th>
							</tr>
							
							<!-- 향후 대책 -->
							<tr class="ui-state-default ui-state-disabled">
								<th colspan="6" style="text-align: center; border: 1px solid #dddddd; background-color: #A4A4A4;">향후 대책
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th colspan="6" style="text-align: center; border: 1px solid #dddddd;"><textarea class="textarea req" maxlength="800" class="textarea" id="fms_dre" name="fms_dre" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_dre() %></textarea>
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="2">실행계획</th>
								<th style="text-align: center; border: 1px solid #dddddd;">담당자</th>
								<th style="text-align: center; border: 1px solid #dddddd;">완료 예정일</th>
							</tr>
							<tr>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="2"><textarea maxlength="500" class="textarea req"  class="textarea" id="fms_drp" name="fms_drp" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_drp() %></textarea></th>
								<th style="text-align: center; border: 1px solid #dddddd;"><%= name %></th>
								<% if(flist.get(0).getFms_end() != null && !flist.get(0).getFms_end().isEmpty() && flist.get(0).getFms_end() != "") { %>
								<th style="text-align: center; border: 1px solid #dddddd;"><input id="fms_endc" style="border:none; text-align:center" required data-toggle="tooltip" data-placement="bottom" title="조치 완료 일자를 기준으로 작성됩니다." readonly value="<%= flist.get(0).getFms_end().substring(0,10) %>"></input></th>
								<% } else { %>
								<th style="text-align: center; border: 1px solid #dddddd;"><input id="fms_endc" style="border:none; text-align:center" required data-toggle="tooltip" data-placement="bottom" title="조치 완료 일자를 기준으로 작성됩니다." readonly value=""></input></th>
								<% } %>
							</tr>
							</tbody>
						</table>
						<div id="wrapper" style="width:100%; text-align: center;">
							<!-- 저장 버튼 생성 -->
							<a type="button" href="/FMS/user/fbbs.jsp" style="margin-bottom:50px; margin-left:20px" class="btn btn-primary pull-right"> 목록 </a>
							<%
								if(id.equals(flist.get(0).getUser_id())) {
									if(flist.get(0).getFms_sig().equals("저장")) {
							%>
							
							<a type="button"  onClick="SaveData()"  style="margin-bottom:50px; margin-left:20px" class="btn btn-success pull-right" data-toggle="tooltip" data-html="true" data-placement="bottom" title="관리자가 해당 보고를 확인할 수 있도록 합니다.">제출</a>		
							<a type="button" href="/FMS/user/action/fmsDeleteAction.jsp?fmsr_cd=<%= flist.get(0).getFmsr_cd() %>" onClick="return confirm('장애 보고를 제거하시겠습니까?')" style="margin-bottom:50px; margin-left:20px" class="btn btn-danger pull-right" data-toggle="tooltip" data-html="true" data-placement="bottom" title="해당 장애 보고를 제거합니다.">삭제</a>	
							<button type="button" onClick="UpdateData()" style="margin-bottom:50px" class="btn btn-info pull-right" data-toggle="tooltip" data-placement="bottom" title="변경된 내용을 저장합니다."> 수정 </button>	
							<button type="Submit" id="fmssave" style="display:none"></button>								
							<%
									} else if (flist.get(0).getFms_sig().equals("제출")) {
							%>
							<a type="button" href="/FMS/user/action/fmsSignAction.jsp?fmsr_cd=<%= flist.get(0).getFmsr_cd() %>&fms_sig=저장" onClick="return confirm('저장 상태로 되돌립니다. 수정 및 삭제가 가능해지며, 관리자의 승인 이후에는 변경이 불가합니다.')" style="margin-bottom:50px; margin-left:20px" class="btn btn-danger pull-right" data-toggle="tooltip" data-html="true" data-placement="bottom" title="제출을 취소하여 수정/삭제가 가능하도록 합니다.">변경</a>		
							<% } if(flist.get(0).getFms_sig().equals("승인") || flist.get(0).getFms_sig().equals("제출")) { %>
								<a type="button" href="/FMS/user/action/csvPrintAction.jsp?fmsr_cd=<%= flist.get(0).getFmsr_cd() %>" style="margin-bottom:50px; margin-left:20px" class="btn btn-success pull-right" data-toggle="tooltip" data-html="true" data-placement="bottom" title=".csv 파일로 출력합니다.">출력</a>	
										
							<% 		}
								}
							%>
						</div>
					</form>
				</div>	


	<!-- 현재 날짜에 대한 데이터 -->
	<textarea class="textarea con"  class="textarea" id="now" style="display:none " name="now"><%= now %></textarea>
	
	<!-- 부트스트랩 참조 영역 -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="https://code.jquery.com/ui/1.12.0/jquery-ui.min.js"></script>
	<!-- auto size를 위한 라이브러리 -->
	<script src="https://rawgit.com/jackmoore/autosize/master/dist/autosize.min.js"></script>
	<script src="../css/js/bootstrap.js"></script>
	<script src="../modalFunction.js"></script>
	
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
  			//alert("변경 : " +$("#fms_rte").val());
        }); 
        
     	// 기타 옵션 선택 후, 작성시 (장애 시스템)
        $('#sys_val').on("input", function(event) {
        	var text = $("#sys_val").val();
      	  	var a = $("#fms_sys").val();
      	  	var b = $("#fms_sys option[value='"+a+"']").val(text);
      	  	//alert($("#fms_sys").val());
        }); 
      });
    </script>
	
	<script>
	var sdbtn = document.getElementById("fmssave");
	
	function SaveData() {
		if($("#fms_sev").val() == '-') {
			//심각도 산정이 완료되지 않음!
			alert("심각도(등급) 설정이 완료되지 않았습니다. 해당 항목 선택하여 지정하여 주십시오.");
		} else {
			//지정이 완료됨. (Submit 타입으로 변경)
			if(confirm('제출하시겠습니까?\n제출 시, 수정/삭제가 불가하며 관리자에게 보고 됩니다.')) {
				// sign을 '제출'로 변경합니다.
				$("#fms_sig").val("제출");
				sdbtn.click();
			}
		}
	}
	</script>
	
	<script>
	function UpdateData() {
		if(confirm("변경된 내용으로 저장됩니다. 수정하시겠습니까?")) {
			
			//Submit 제거
			var ranges = document.querySelectorAll('.req');
			ranges.forEach((range) => {
					range.required = false;
				});	
			
			var form = document.getElementById("main");
			sdbtn.click();
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
	
	// 기타 옵션 선택시, 작성할 수 있도록 함! (장애 시스템)
	function sysFunction() { 
		const sys_val = document.getElementById("sys_val");
		if($("#fms_sys").val().indexOf("기타") == -1) {
			sys_val.style.display = 'none';
			sys_val.required = false;
		} else { 
			//alert("기타 선택");
			sys_val.style.display = '';
			sys_val.required = true;
		}
	}
	</script>
	
	<textarea class="textarea con"  class="textarea" id="workSet" name="workSet" style="display:none;" readonly><%= workSet %></textarea>

	
</body>