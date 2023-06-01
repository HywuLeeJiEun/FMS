
<%@page import="fmsuser.fmsuser"%>
<%@page import="fmsuser.FmsuserDAO"%>
<%@page import="fmsrept.FmsreptDAO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FMS</title>
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
	
	// ********** 담당자를 가져오기 위한 메소드 *********** 
	String workSet;
	ArrayList<String> code = userDAO.getCode(id); //코드 리스트 출력(FMSmgrs에 접근하여, task_num을 가져옴.)
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
	

%>

<!-- fmsModal 불러오기 (심각도(등급)을 구하기 위함) -->
	<jsp:include page="fbbsAdminReport.jsp"></jsp:include>

   <!-- ************ 상단 네비게이션바 영역 ************* -->
	<nav class="navbar navbar-default"> 
		<div class="navbar-header"> 
			<!-- 네비게이션 상단 박스 영역 -->
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<!-- 이 삼줄 버튼은 화면이 좁아지면 우측에 나타난다 -->
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="/FMS/user/fbbs.jsp">Fault Management System</a>
		</div>
		
		<!-- 게시판 제목 이름 옆에 나타나는 메뉴 영역 -->
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
				<ul class="nav navbar-nav navbar-left">
					<li class="dropdown">
						<a href="#" class="dropdown-toggle"
							data-toggle="dropdown" role="button" aria-haspopup="true"
							aria-expanded="false">장애보고<span class="caret"></span></a>
						<!-- 드랍다운 아이템 영역 -->	
					<% if(au.equals("관리자")) { %>
						<ul class="dropdown-menu">
							<li><a href="/FMS/admin/fbbsAdmin.jsp">조회 및 승인</a></li>
						</ul>
					<% }else { %>
						<!-- 일반 사용자 view -->
						<ul class="dropdown-menu">
							<li><a href="/FMS/user/fbbs.jsp">조회</a></li>
							<li><a href="/FMS/user/fmsWrite.jsp">작성</a></li>
						</ul>
					<% } %>
					</li>
						
						<%
							if(au.equals("관리자")) {
						%>
							<li class="dropdown">
							<a href="#" class="dropdown-toggle"
								data-toggle="dropdown" role="button" aria-haspopup="true"
								aria-expanded="false">SLA<span class="caret"></span></a>
							<!-- 드랍다운 아이템 영역 -->	
							<ul class="dropdown-menu">
								<li><h5 style="background-color: #e7e7e7; height:40px; margin-top:-20px" class="dropdwon-header"><br>&nbsp;&nbsp; SLA 대상여부</h5></li>
								<li><a href="/FMS/admin/fbbsAdminSla.jsp">조회 및 출력</a></li>
								<li><h5 style="background-color: #e7e7e7; height:40px;" class="dropdwon-header"><br>&nbsp;&nbsp; 연간 장애리포트</h5></li>
								<li><a onClick="reportModal()">장애리포트 생성</a></li>
							</ul>
							</li>
						<%
							}
						%>
				</ul>
			
		
			
			<!-- 헤더 우측에 나타나는 드랍다운 영역 -->
			<ul class="nav navbar-nav navbar-right">
				<li><a data-toggle="modal" href="#UserUpdateModal" style="color:#2E2E2E"><%= name %>(님)</a></li>
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">관리<span class="caret"></span></a>
					<!-- 드랍다운 아이템 영역 -->	
					<ul class="dropdown-menu">
					<%
					if(au.equals("관리자")||au.equals("PL")) {
					%>
						<li><a data-toggle="modal" href="#UserUpdateModal">개인정보 수정</a></li>
						<li><a href="/FMS/admin/work/workChange.jsp">담당업무 변경</a></li>
						<li><a href="/FMS/logoutAction.jsp">로그아웃</a></li>
					<%
					} else {
					%>
						<li><a data-toggle="modal" href="#UserUpdateModal">개인정보 수정</a>
						
						</li>
						<li><a href="/FMS/logoutAction.jsp">로그아웃</a></li>
					<%
					}
					%>
					</ul>
				</li>
			</ul>
		</div>
	</nav>
	<!-- 네비게이션 영역 끝 -->

	<!-- 모달 불러오기 -->
	<div id="modalCall">
		<textarea style="display:none" id="ui"><%= id %></textarea>
		<textarea style="display:none" id="pw"><%= password %></textarea>
		<textarea style="display:none" id="nm"><%= name %></textarea>
		<textarea style="display:none" id="rn"><%= rank %></textarea>
		<textarea style="display:none" id="em"><%= email[0] %></textarea>
		<textarea style="display:none" id="ws"><%= workSet %></textarea>
		<jsp:include page="./modal.html" flush="false" />
	</div>
	

<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script>
	var url = window.location.pathname;
	//url 가공하기 (특정 url의 표시 설정)
		//1. fbbs.jsp (장애보고 > 조회 중, 검색)
		if(url.includes("fbbs.jsp") || url.includes("searchfbbs.jsp")) {
			url = "/FMS/user/fbbs.jsp";
		}
	
		//2. fmsWrite.jsp (장애보고 > 작성)
		if(url.includes("fmsWrite.jsp")) {
			url = "/FMS/user/fmsWrite.jsp";
		}
		
		//3. (관리자) fbbsAdmin.jsp, 장애보고 조회 및 승인
		if(url.includes("fbbsAdmin.jsp")) {
			url = "/FMS/admin/fbbsAdmin.jsp";
		}
		
		//4. (관리자) fbbsAdminSla.jsp, '승인'된 장애보고 조회 및 출력
		if(url.includes("fbbsAdminSla.jsp")) {
			url = "/FMS/admin/fbbsAdminSla.jsp";
		}

		//5. workChangesearch.jsp (work 변경 중, 검색시)
		if(url.includes("workChangesearch.jsp")) {
			url = "/FMS/admin/work/workChange.jsp";
		}

	$(".navbar").find('a').each(function() {
		//$(this).toggleClass('active', $(this).attr('href') == url);
		if($(this).attr('href') == url) {
			$(this).closest("li").addClass('active');
		}
		
	});
</script>

	<script>
	// fbbsAdminReport.jsp의 모달 실행
	function reportModal() {
		//심각도(등급)을 구하기 위해, ABC 구분코드 선택하는 창 띄우기
		$("#FmsReportModal").modal();
	}
	</script>

</body>
</html>