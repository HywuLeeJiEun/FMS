<%@page import="net.sf.jasperreports.web.actions.SearchAction"%>
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
		
		//검색을 위한 설정
		String category = request.getParameter("searchField");
		String str = request.getParameter("searchText");
	
		// All 선택시, fbbs로 돌아갑니다. 
		if(category.equals("fms_sys") && str.equals("All")) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href='/FMS/user/fbbs.jsp'");
			script.println("</script>");
		}
		
		if(category == null || str == null || str.equals("") || str.isEmpty()) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력된 데이터가 없습니다.')");
			script.println("location.href='/FMS/user/fbbs.jsp'");
			script.println("</script>");
		}
		
	// 검색 결과 조회	
	//기존 데이터 불러오기 (가장 최근에 작성된 fms 조회)
	ArrayList<fmsrept> list = fms.getSearchfms(id, category, str, pageNumber);
	
	// 다음 페이지가 있는지 확인!
	ArrayList<fmsrept> aflist = fms.getSearchfms(id, category, str, pageNumber+1);
		
		
	
	if(list.size() == 0){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('검색 결과가 없습니다.')");
		script.println("location.href='/FMS/user/fbbs.jsp'");
		script.println("</script>");
	}
		
	
	// 시스템 출력을 위한 목록 불러오기 (유저가 작성한 장애보고 중, 시스템 목록)
	ArrayList<String> syslist = fms.getDistSys(id);
	
	String option = "All";
			
	
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
					<br><i class="glyphicon glyphicon-triangle-right" id="icon"  style="left:5px;"></i> 주간보고 목록 (개인)
				</th>
				</tr>
			</thead>
			</table>
			<form method="post" name="search" action="/FMS/user/searchfbbs.jsp">
				<table class="pull-right">
					<tr>
						<td><select class="form-control" name="searchField" id="searchField" onchange="ChangeValue()">
								<option value="fms_sys" <%= category.equals("fms_sys") ? "selected":"" %>>시스템</option>
								<option value="fms_con" <%= category.equals("fms_con") ? "selected":"" %>>장애 내용</option>
						</select></td>
						<td><input type="hidden" class="form-control" style="margin-right:10px"
							placeholder="검색어 입력" name="searchText" id="searchText" maxlength="100" value="<%=  str %>">
							<select class="form-control" name="searchSys" id="searchSys" style="margin-right:10px; display:block;" onchange="ChangeSys()">
								<!-- 시스템 목록 출력 -->
								<option>All</option>
								<%
								if(syslist.size() != 0) {
									for(int i=0; i < syslist.size(); i++) {
								%>
									<option <%= syslist.get(i).equals(str) ? "selected":"" %>><%= syslist.get(i) %></option>
								<%
									} 
								} else {
								%>
								<option>기타</option>
								<% } %>
							</select></td>
						<td><button type="submit" style="margin:5px" class="btn btn-success">검색</button></td>
					</tr>

				</table>
			</form>
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
						<th style="background-color: #eeeeee; text-align: center; cursor:pointer"onclick="sortTable(0)">작성일<input id="0" type="hidden" readonly style="border:none; width:18px; background-color:transparent;" value=""></input></th>
						<th style=" width:45%; background-color: #eeeeee; text-align: center; cursor:pointer" onclick="sortTable(1)">장애 내용<input id="1" style="border:none; width:18px; background-color:transparent;" value=""></input></th>
						<th style="background-color: #eeeeee; text-align: center; cursor:pointer"onclick="sortTable(2)">작성자<input id="2" type="hidden" readonly style="border:none; width:18px; background-color:transparent;" value=""></input></th>
						<th style="background-color: #eeeeee; text-align: center; cursor:pointer"onclick="sortTable(3)">시스템<input id="3" type="hidden" readonly style="border:none; width:18px; background-color:transparent;" value=""></input></th>
						<th style="background-color: #eeeeee; text-align: center; cursor:pointer"onclick="sortTable(4)">심각도<input id="4" type="hidden" readonly style="border:none; width:18px; background-color:transparent;" value=""></input></th>
						<th style="background-color: #eeeeee; text-align: center; cursor:pointer"onclick="sortTable(5)">수정일<input id="5" readonly style="border:none; width:18px; background-color:transparent;" value="▽"></input> </th>
						<th style="background-color: #eeeeee; text-align: center; cursor:pointer"onclick="sortTable(6)">상태<input id="6" type="hidden" readonly style="border:none; width:18px; background-color:transparent;" value=""></input> </th>
					</tr>
				</thead>
				<tbody>
					<%
						for(int i = 0; i < list.size(); i++){
					%>
						<!-- 게시글 제목을 누르면 해당 글을 볼 수 있도록 링크를 걸어둔다 -->
					<tr>
						<!-- (1) 작성일/수정일-->
						<td><%= list.get(i).getFms_doc() %></td>
						<!-- (2) 장애 내용 -->
						<td style="text-align: center">
						<a href="/FMS/user/fmsUpdate.jsp?fmsr_cd=<%= list.get(i).getFmsr_cd() %>">
							<%= list.get(i).getFms_con() %></a></td>
						<!-- (3) 작성자 -->	
						<td><%= name %></td>
						<!--  (4) 시스템 -->
						<td><%= list.get(i).getFms_sys() %></td>
						<!--  (4) 심각도 -->
						<td><%= list.get(i).getFms_sev() %> 등급</td>
						<!-- (5) 작성일/수정일-->
						<td><%= list.get(i).getFms_upa().substring(0, 11) + list.get(i).getFms_upa().substring(11, 13) + "시"
							+ list.get(i).getFms_upa().substring(14, 16) + "분" %></td>
						<!-- (6) 승인/미승인/마감 표시 -->
						<td><%= list.get(i).getFms_sig() %></td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>
			
			<!-- 페이징 처리 영역 -->
			<%
				if(pageNumber != 1){
			%>
					<a href="/FMS/user/searchfbbs.jsp?pageNumber=<%=pageNumber - 1 %>"
					class="btn btn-success btn-arraw-left">이전</a>
			<%
				}if(aflist.size() != 0){
			%>
					<a href="/FMS/user/searchfbbs.jsp?pageNumber=<%=pageNumber + 1 %>"
					class="btn btn-success btn-arraw-left" id="next">다음</a>
			<%
				}
			%>
			
			<!-- 글쓰기 버튼 생성 -->
			<a href="/FMS/user/fbbs.jsp" class="btn btn-primary pull-right" data-toggle="tooltip" data-html="true" data-placement="bottom" title="전체 목록으로 돌아갑니다.">목록</a>
		</div>
	</div>
	
	
	
	<!-- 게시판 메인 페이지 영역 끝 -->
	
	<!-- 부트스트랩 참조 영역 -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="../css/js/bootstrap.js"></script>
	<script src="../modalFunction.js"></script>
	

	
	<script>
	var category = '<%= category %>';
	var strRe = '<%= str %>';
	
	$( document ).ready( function() {
		if(category == "fms_sys") {
			$("#searchText").attr('type','hidden'); //텍스트 필드가 보이지 않도록 수정합니다.
			$("#searchSys").css('display', 'block'); //선택 상자 출력
			
			// 값 설정
			$("#searchSys").val(strRe).prop("selected",true);
		}
	});
	
	function ChangeValue() {
		var value_str = document.getElementById('searchField');
		if(value_str.value == "fms_sys") {
			$("#searchText").attr('type','hidden'); //텍스트 필드가 보이지 않도록 수정합니다.
			$("#searchSys").css('display', 'block'); //선택 상자 출력
			
			// 값 변경
			$("#searchText").attr('value',$("#searchSys").val());

		}else {
			$("#searchText").attr('type','text'); 
			$("#searchSys").css('display', 'none');
			
			// 값 변경
			$("#searchText").attr('value', "");
		}
		
	}

	function ChangeSys() {
		var value_str = document.getElementById('searchSys');
		// 값 변경
		$("#searchText").attr('value',value_str.value);
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