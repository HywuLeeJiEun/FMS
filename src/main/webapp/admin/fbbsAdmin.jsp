<%@page import="fmsrept.fmsrept"%>
<%@page import="fmsuser.fmsuser"%>
<%@page import="fmsrept.FmsreptDAO"%>
<%@page import="fmsuser.FmsuserDAO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.ArrayList" %>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<!-- // 폰트어썸 이미지 사용하기 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet" href="../css/index.css">
<meta charset="UTF-8">
<!-- 화면 최적화 -->
<!-- <meta name="viewport" content="width-device-width", initial-scale="1"> -->
<!-- 루트 폴더에 부트스트랩을 참조하는 링크 -->
<title>IMS</title>
</head>

<body>
	<%
		FmsuserDAO userDAO = new FmsuserDAO(); //사용자 정보
		FmsreptDAO fms = new FmsreptDAO(); //주간보고 목록
		
		// 메인 페이지로 이동했을 때 세션에 값이 담겨있는지 체크
		String id = null;
		if(session.getAttribute("id") != null){
			id = (String)session.getAttribute("id");
		}
		int pageNumber = 1; //기본은 1 페이지를 할당
		// 만약 파라미터로 넘어온 오브젝트 타입 'pageNumber'가 존재한다면
		// 'int'타입으로 캐스팅을 해주고 그 값을 'pageNumber'변수에 저장한다
		if(request.getParameter("pageNumber") != null){
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
		if(id == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 필요한 서비스입니다.')");
			script.println("location.href='../login.jsp'");
			script.println("</script>");
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
		
		//관리자의 권한을 가진 경우, admin으로 넘김
		if(!au.equals("관리자")) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href='/FMS/user/fbbs.jsp'");
			script.println("</script>");
		}
		
		
		
		// fms_sig = "제출"인 장애 보고 목록을 조회
		//기존 데이터 불러오기 (가장 최근에 작성된 fms 조회)
		ArrayList<fmsrept> list = fms.getAdminfms("제출", pageNumber);
		
		// 다음 페이지가 있는지 확인!
		ArrayList<fmsrept> aflist = fms.getAdminfms("제출", pageNumber+1);
		
	
	%>
	    
	<!-- nav바 불러오기 -->
    <jsp:include page="../Nav.jsp"></jsp:include>
	
	
	<!-- ***********검색바 추가 ************* -->
	<div class="container">
		<div class="row">
			<table class="pull-left" style="text-align: center; cellpadding:50px; width:60%" >
			<thead>
				<tr>
					<th style=" text-align: left" data-toggle="tooltip" data-html="true" data-placement="bottom" title=""> 
					<br><i class="glyphicon glyphicon-triangle-right" id="icon"  style="left:5px;"></i> 장애보고 목록 (관리자)
					<br><h6>: '제출'된 장애 보고를 확인 / 수정 및 승인할 수 있습니다.</h6>
				</th>
				</tr>
			</thead>
			</table>
		</div>
	</div>
	<br>


	<!-- 게시판 메인 페이지 영역 시작 -->
	<div class="container">
		<div class="row">
			<table id="FmsTable" class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<!-- <th style="background-color: #eeeeee; text-align: center;">번호</th> -->
						<th style="background-color: #eeeeee; text-align: center; cursor:pointer"onclick="sortTable(0)">시스템<input type="hidden" readonly id="0" style="border:none; width:18px; background-color:transparent;" value=""></input></th>
						<th style=" width:50%; background-color: #eeeeee; text-align: center; cursor:pointer" onclick="sortTable(1)">장애 내용<input type="hidden" readonly id="1" style="border:none; width:18px; background-color:transparent;" value=""></input></th>
						<th style="background-color: #eeeeee; text-align: center; cursor:pointer"onclick="sortTable(2)">작성자<input type="hidden" readonly id="2" style="border:none; width:18px; background-color:transparent;" value=""></input></th>
						<th style="background-color: #eeeeee; text-align: center; cursor:pointer"onclick="sortTable(3)">심각도<input type="hidden" readonly id="3" style="border:none; width:18px; background-color:transparent;" value=""></input></th>
						<th style="background-color: #eeeeee; text-align: center; cursor:pointer"onclick="sortTable(4)">점수<input type="hidden" readonly id="4" style="border:none; width:18px; background-color:transparent;" value=""></input></th>
						<th style="background-color: #eeeeee; text-align: center; cursor:pointer"onclick="sortTable(5)">장애 인지 일자<input id="5" readonly style="border:none; width:18px; background-color:transparent;" value="▽"></input> </th>
					</tr>
				</thead>
				<%
				if(list.size() != 0) {
				%>
				<tbody>
					<%
						for(int i = 0; i < list.size(); i++){
					%>
						<!-- 게시글 제목을 누르면 해당 글을 볼 수 있도록 링크를 걸어둔다 -->
					<tr>
						<!--  (1) 시스템 -->
						<td><%= list.get(i).getFms_sys() %></td>
						<!-- (2) 장애 내용 -->
						<td style="text-align:left">
						<a href="/FMS/admin/fmsUpdateAdmin.jsp?fmsr_cd=<%= list.get(i).getFmsr_cd() %>&user_id=<%= list.get(i).getUser_id() %>">
							<%= list.get(i).getFms_con() %></a></td>
						<!-- (3) 작성자 -->	
						<td><%= userDAO.getName(list.get(i).getUser_id()) %></td>
						<!--  (4) 심각도 -->
						<td><%= list.get(i).getFms_sev() %>등급</td>
						<!--  (5) 심각도 -->
						<td><%= list.get(i).getFms_sco() %>점</td>
						<!-- (6) 장애 인지 일자-->
						<td><%= list.get(i).getFms_rec() %></td>
					</tr>
					<%
						}
					%>
				</tbody>
				<% } else { %>
					<tbody><tr><th colspan="7" style="text-align: center; border: 1px solid #dddddd;">미승인된 장애 보고가 없습니다.<br><br>승인된 목록은 <a href="/FMS/admin/fbbsAdminSla.jsp">[SLA]</a> 조회에서 확인 가능합니다.</th></tr></tbody>
				<% } %>
			</table>
			
			<!-- 페이징 처리 영역 -->
			<%
				if(pageNumber != 1){
			%>
					<a href="/FMS/user/fbbs.jsp?pageNumber=<%=pageNumber - 1 %>"
					class="btn btn-success btn-arraw-left">이전</a>
			<%
				}if(aflist.size() != 0){
			%>
					<a href="/FMS/user/fbbs.jsp?pageNumber=<%=pageNumber + 1 %>"
					class="btn btn-success btn-arraw-left" id="next">다음</a>
			<%
				}
			%>
		</div>
	</div>
	
	
	
	<!-- 게시판 메인 페이지 영역 끝 -->
	
	<!-- 부트스트랩 참조 영역 -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="../css/js/bootstrap.js"></script>
	<script src="../modalFunction.js"></script>
	

	
	<script>
		function ChangeValue() {
			var value_str = document.getElementById('searchField');
			
		}
	</script>
	
    <!-- 보고 개수에 따라 버튼 노출 (list.size()) -->
	<script>
	var trCnt = $('#bbsTable tr').length; 
	
	if(trCnt < 11) {
		$('#next').hide();
	}
	</script>
	
</body>
</html>