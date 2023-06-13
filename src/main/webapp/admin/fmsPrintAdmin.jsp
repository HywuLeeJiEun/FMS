<%@page import="java.time.LocalDateTime"%>
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
		
		String st = request.getParameter("st");
		
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
		
		String str = flist.get(0).getFms_str().replaceAll("T"," ");
		String end = flist.get(0).getFms_end().replaceAll("T", " ");
		String rec = flist.get(0).getFms_rec().replaceAll("T", " ");
	
		//일자 데이터 형식 수정  yyyy.mm.dd(e) hh:mm
		 // 입력된 형식
          DateTimeFormatter inputFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
          // 출력할 형식
          DateTimeFormatter outputFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd(E) HH:mm");

         // LocalDateTime으로 변환
         LocalDateTime dateTime1 = LocalDateTime.parse(str, inputFormat);
         LocalDateTime dateTime2 = LocalDateTime.parse(end, inputFormat);
         LocalDateTime dateTime3 = LocalDateTime.parse(rec, inputFormat);
         
         // 형식을 변경하여 출력
         str = dateTime1.format(outputFormat);
		 end = dateTime2.format(outputFormat);
		 rec = dateTime3.format(outputFormat);
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
						<th colspan="5" style=" text-align: center; color:blue "></th>
					</tr>
				</thead>
			</table>
		</div>
		
		<div class="container">
		<form method="post" action="/FMS/admin/action/fmsPrintAction.jsp" id="main" name="main">
			<table class="table" id="fmsTable" style="text-align: center; border: 1px solid #dddddd; border-collapse: collapse;" >
				<thead>
					<tr>
						<th colspan="6" style="background-color: #eeeeee; text-align: center;">장애 보고서<br><h6>확인 및 SLA 대상여부에 따라 출력이 가능합니다.</h6></th>
					</tr>
				</thead>
				<tbody id="tbody">
							<tr class="ui-state-default ui-state-disabled">
								<th colspan="6" style="text-align: center; border: 1px solid #dddddd; background-color: #A4A4A4;">장애 개요
							</tr>
							<tr class="ui-state-default">
								<th style="display:none;"><input name="fmsr_cd" value="<%= fmsr_cd %>"></input></th>
								<th style="display:none;"><input name="fms_acd" value="<%= flist.get(0).getFms_acd() %>"></input></th>
								<th style="display:none;"><input name="fms_bcd" value="<%= flist.get(0).getFms_bcd() %>"></input></th>
								<th style="display:none;"><input name="fms_ccd" value="<%= flist.get(0).getFms_ccd() %>"></input></th>
								<th style="text-align: center; border: 1px solid #dddddd;">보고자</th>
								<th style="text-align: left; border: 1px solid #dddddd;"><input name="user_id" style="border:none; text-align:left" readonly value="<%= userDAO.getName(user_id) %> <%= userDAO.getRank(user_id) %>"></input></th>
								<th style="text-align: center; border: 1px solid #dddddd;">작성일</th>
								<th style="text-align: left; border: 1px solid #dddddd;" data-toggle="tooltip" data-placement="bottom" title="작성일을 기준으로 자동 입력됩니다."><input name="fms_doc" style="border:none; text-align:left;" readonly value="<%= formatNow %> (<%= day %>)"></input></th>
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd;">장애 내용</th>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><textarea readonly class="textarea"  class="textarea" name="fms_con" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_con() %></textarea></th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; border: 1px solid #dddddd;">장애발생 일자</th>
								<th style="text-align:left"><input name="fms_str" readonly style="border:none; text-align:left;" value="<%= str %>"></input></th>
								<th style="text-align: center; border: 1px solid #dddddd;">조치 완료 일자</th>
								<th style="text-align:left"><input name="fms_end" readonly style="border:none; text-align:left;" value="<%= end %>"></input></th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; border: 1px solid #dddddd;">장애인지 일자</th>
								<th style="text-align:left"><input name="fms_rec" style="border:none; text-align:left" readonly value="<%= rec %>"></input></th>
								<th style="text-align: center; border: 1px solid #dddddd;">장애시간 / 복구 목표시간</th>
								<th style="text-align:left"><input name="fms_fov" style="width:30%; border:none; text-align:left" readonly value="<%= flist.get(0).getFms_fov() + "/190분" %>"></input></th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; border: 1px solid #dddddd;" onClick="dataSEV()">심각도(등급)</th>
								<th style="text-align:left" onClick="dataSEV()"><input name="fms_sev" style="width:45px; border:none; text-align:left" readonly value="<%= flist.get(0).getFms_sev() + "등급"%>"></input><button id="sev" type="button">확인</button></th>
								<th style="text-align: center; border: 1px solid #dddddd;">장애 인지 경로</th>
								<th style="text-align:center"><textarea name="fms_rte" class="textarea"  class="textarea" style="width:100%; border:none; resize:none" readonly><%= flist.get(0).getFms_rte() %></textarea></th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; border: 1px solid #dddddd;">장애 분야</th>
								<th style="text-align:center"><textarea name="fms_dif"  class="textarea"  class="textarea" style="width:100%; border:none; resize:none" readonly><%= flist.get(0).getFms_dif() %></textarea></th>
								<th style="text-align: center; border: 1px solid #dddddd;">중복장애 여부</th>
								<% String dcd = "N"; if(flist.get(0).getFms_dcd().equals("FD01")){ dcd = "Y"; } %>
								<th style="text-align:center"><textarea name="fms_dcd" class="textarea" style="width:100%; border:none; resize:none" required readonly><%= dcd %></textarea></th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; border: 1px solid #dddddd;">장애 처리자</th>
								<th style="text-align:left"><%= userDAO.getName(user_id) %> <%= userDAO.getRank(user_id) %></th>
								<th style="text-align: center; border: 1px solid #dddddd;">장애 시스템</th>
								<th style="text-align:center"><textarea name="fms_sys" class="textarea" style="width:100%; border:none; resize:none" required readonly><%= flist.get(0).getFms_sys() %></textarea></th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; border: 1px solid #dddddd;">장애 책임</th>
								<th style="text-align:center" colspan="3"><textarea name="fms_res" class="textarea"  class="textarea" style="width:100%; border:none; resize:none" required readonly><%= flist.get(0).getFms_res() %></textarea></th>
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th style="text-align: center; border: 1px solid #dddddd;">SLA 대상여부</th>
								<th style="text-align:left" colspan="3">
								<%
									String slares = "비해당";
									if(flist.get(0).getFms_sla().equals("Y")){
										slares = "해당";
									} 
								%>
								<input id="fms_sla" name="fms_sla" style="border:none; text-align:left" readonly value="<%= slares %>"></input>
								</th>
							</tr>
							<!--  SLA 대상 여부가 비해당인 경우, 사유 입력 -->
							<tr id="reaTr" class="ui-state-default ui-state-disabled">
								<th style="text-align: center; border: 1px solid #dddddd;">사유</th>
								<th style="text-align:center" colspan="3"><textarea id="sla_rea" name="sla_rea" class="textarea" readonly  class="textarea" style="width:100%; border:none; resize:none" required><%= flist.get(0).getSla_rea() %></textarea></th>
							</tr>
							
							<!-- 세부 장애 내용 -->
							<tr class="ui-state-default ui-state-disabled">
								<th colspan="6" style="text-align: center; border: 1px solid #dddddd; background-color: #A4A4A4;">세부 장애 내용
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd;">장애 증상</th>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><textarea readonly class="textarea"  class="textarea" name="fms_sym" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_sym() %></textarea></th>
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd;">조치 내용<br>(긴급)</th>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><textarea readonly class="textarea"  class="textarea" name="fms_emr" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_emr() %></textarea></th>
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd;">조치 사항<br>(후속)</th>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><textarea readonly class="textarea"  class="textarea" name="fms_dfu" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_dfu() %></textarea></th>
							</tr>	
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd;">업무 영향</th>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><textarea readonly class="textarea"  class="textarea" name="fms_eff" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_eff() %></textarea></th>
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd;">장애 원인</th>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><textarea readonly class="textarea"  class="textarea" name="fms_cau" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_cau() %></textarea></th>
							</tr>

							
							<!-- 향후 대책 -->
							<tr class="ui-state-default ui-state-disabled">
								<th colspan="6" style="text-align: center; border: 1px solid #dddddd; background-color: #A4A4A4;">향후 대책
							</tr>
							<tr class="ui-state-default ui-state-disabled">
								<th colspan="6" style="text-align: center; border: 1px solid #dddddd;"><textarea class="textarea" readonly class="textarea" name="fms_dre" style="width:100%; border:none; resize:none" required><%= flist.get(0).getFms_dre() %></textarea>
							</tr>
							<tr class="ui-state-default">
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="2">실행계획</th>
								<th style="text-align: center; border: 1px solid #dddddd;">담당자</th>
								<th style="text-align: center; border: 1px solid #dddddd;">완료 예정일</th>
							</tr>
							<tr>
								<th style="text-align: center; border: 1px solid #dddddd;" colspan="2"><textarea class="textarea" readonly class="textarea" name="fms_drp" style="width:100%; border:none; resize:none; text-align:center;" required><%= flist.get(0).getFms_drp() %></textarea></th>
								<th style="text-align: center; border: 1px solid #dddddd;"><input name="user_name" style="border:none; text-align:center" readonly value="<%= userDAO.getName(user_id) %>"></input></th>
								<th style="text-align: center; border: 1px solid #dddddd;"><input name="fms_endc" style="border:none; text-glign: center" readonly required data-toggle="tooltip" data-placement="bottom" title="조치 완료 일자를 기준으로 작성됩니다." readonly value="<%= flist.get(0).getFms_end().substring(0,10) %>"></input></th>
							</tr>
							</tbody>
						</table>
						<div id="wrapper" style="width:100%; text-align: center;">
							<!-- 저장 버튼 생성 -->
							<a type="button" href="/FMS/admin/fbbsAdminSla.jsp" style="margin-bottom:50px; margin-left:20px" class="btn btn-primary pull-right"> 목록 </a>
							<% 
								if (flist.get(0).getFms_sla().equals("Y")){
							%>
							<button type="Submit" onClick="return confirm('보고서를 출력하시겠습니까?')" style="margin-bottom:50px; margin-left:20px" class="btn btn-success pull-right" data-toggle="tooltip" data-html="true" data-placement="bottom" title="SLA 대상에 해당되는 주간보고를 보고서로 출력할 수 있습니다.">출력</button>		
							<%
								}

							%>
							<a type="button" href="/FMS/user/action/fmsSignAction.jsp?fmsr_cd=<%= flist.get(0).getFmsr_cd() %>&fms_sig=제출&admin=y&user_id=<%= flist.get(0).getUser_id() %>" onClick="return confirm('제출 상태로 되돌립니다. 장애보고 > 조회 및 승인에서 확인이 가능합니다. 변경하시겠습니까?')" style="margin-bottom:50px; margin-left:20px" class="btn btn-danger pull-right" data-toggle="tooltip" data-html="true" data-placement="bottom" title="승인을 취소하여 해당 보고를 수정합니다.">변경</a>		
						</div>
					</form>
				</div>	

	<!-- 부트스트랩 참조 영역 -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="https://code.jquery.com/ui/1.12.0/jquery-ui.min.js"></script>
	<!-- auto size를 위한 라이브러리 -->
	<script src="https://rawgit.com/jackmoore/autosize/master/dist/autosize.min.js"></script>
	<script src="../css/js/bootstrap.js"></script>
	<script src="../modalFunction.js"></script>
	
	
	<script>
	
	 $( document ).ready( function() {
		// sla '해당', '비해당'에 따라 사유(sla_rea) 표시하기
		var sla = $("#fms_sla").val();
		var rea = $("#sla_rea");
		var reaTr = $("#reaTr");
		if(sla == "N" || sla == "비해당") {
			// 사유 입력이 필요함!
			rea.attr("required" , true);
			reaTr.css("display","");
		} else {
			// 사유 입력이 필요 없음!
			rea.attr("required" , false);
			reaTr.css("display","none");
		}
	 });
	
	</script>
	
	
</body>