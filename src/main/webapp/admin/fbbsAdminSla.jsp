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
		ArrayList<fmsrept> list = fms.getAdminfms("승인", pageNumber);
		
		// 다음 페이지가 있는지 확인!
		ArrayList<fmsrept> aflist = fms.getAdminfms("승인", pageNumber+1);
		
	
	%>
	    
	<!-- nav바 불러오기 -->
    <jsp:include page="../Nav.jsp"></jsp:include>
	
	
	<!-- ***********검색바 추가 ************* -->
	<div class="container">
		<div class="row" style="display:flex; flex-direction:column;">
			<table class="pull-left" style="text-align: center; cellpadding:50px; width:100%" >
			<thead>
				<tr>
					<th style=" text-align: left" data-toggle="tooltip" data-html="true" data-placement="bottom" title=""> 
					<br><i class="glyphicon glyphicon-triangle-right" id="icon"  style="left:5px;"></i> 승인된 장애보고 목록 (관리자)
					<br><h6>: '승인'된 장애 보고를 확인 및 출력(SLA 여부에 따라 개별 출력)할 수 있습니다.</h6>
				</th>
				</tr>
			</thead>
			</table>
			<form method="post" name="search" action="/FMS/admin/searchfbbsAdminSla.jsp">
			<div style="width:50%; display:flex; flex-direction:column; float:right">
				<table>
					<tr>
						<td colspan="5"><h5>조건 검색을 통해 [장애리포트]를 출력할 수 있습니다.</h5></td>
					</tr>
					<!-- 기준일자 선택 (시작일 - 기준 끝일) -->
					<tr>
						<td style="margin-right:10px">
							<select style="width:95%" class="form-control" name="dayField" id="dayField" onchange="ChangeValueOfDay()">
								<option value="fms_rec">장애 인지 일자</option>
								<option value="fms_doc">보고 작성 일자</option>
								<option value="fms_str">장애 발생 일자</option>
								<option value="fms_end">조치 완료 일자</option>
							</select>
						</td>
						<td><input type="date" class="form-control" name="str_day" style="margin-right:10px" ></td>
						<td> ~ </td> 
						<td><input type="date" class="form-control" name="end_day" style="margin-left:10px;" ></td>
					</tr>
				</table>
				
				<table>
					<!-- 검색어 입력 -->
					<tr>
						<td>
							<select style="width:90%" class="form-control" name="searchField" id="searchField" onchange="ChangeValue()">
								<option value="fms_sla">SLA 여부</option>
								<option value="fms_con">장애 내용</option>
								<option value="fms_sys">시스템</option>
								<option value="user_id">작성자</option>
							</select>
						</td>
						<td><input type="hidden" class="form-control" style="margin-right:10px"
							placeholder="검색어 입력" name="searchText" id="searchText" maxlength="100" value="All">
							<select class="form-control" name="searchSys" id="searchSys" style="margin-right:10px; display:none;" onchange="ChangeSys()">
								<!-- 시스템 목록 출력 -->
									<option>All</option>
								<%
									ArrayList<String> syslist = fms.getDistSys(null);
								
									for(int i=0; i < syslist.size(); i++) {
								%>
									<option><%= syslist.get(i) %></option>
								<% } %>
							</select>
							<select class="form-control" name="searchSla" id="searchSla" style="margin-right:10px; display:block;" onchange="ChangeSla()">
								<!--  SLA 여부 -->
								<option>All</option>
								<option>Y</option>
								<option>N</option>
							</select>
						</td>
						<td><button type="submit" style="margin:5px" class="btn btn-success" style="margin-left:10px">검색</button></td>		
					</tr>
				</table>
				</div>
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
						<th style="background-color: #eeeeee; text-align: center; cursor:pointer"onclick="sortTable(0)">시스템<br><input id="0" type="hidden" readonly  style="border:none; width:18px; background-color:transparent;" value=""></input></th>
						<th style=" width:50%; background-color: #eeeeee; text-align: center; cursor:pointer" onclick="sortTable(1)">장애 내용<br><input id="1" type="hidden" readonly  style="border:none; width:18px; background-color:transparent;" value=""></input></th>
						<th style="background-color: #eeeeee; text-align: center; cursor:pointer"onclick="sortTable(2)">작성자<br><input id="2" type="hidden" readonly  style="border:none; width:18px; background-color:transparent;" value=""></input></th>
						<th style="background-color: #eeeeee; text-align: center; cursor:pointer"onclick="sortTable(3)">심각도<br><input id="3" type="hidden" readonly  style="border:none; width:18px; background-color:transparent;" value=""></input></th>
						<th style="background-color: #eeeeee; text-align: center; cursor:pointer"onclick="sortTable(4)">점수<br><input id="4" type="hidden" readonly  style="border:none; width:18px; background-color:transparent;" value=""></input></th>
						<th style="background-color: #eeeeee; text-align: center; cursor:pointer"onclick="sortTable(5)">장애 인지 일자<br><input id="5" readonly style="border:none; width:18px; background-color:transparent;" value="▽"></input> </th>
						<th style="background-color: #eeeeee; text-align: center; cursor:pointer"onclick="sortTable(6)">SLA 여부<br><input id="6" type="hidden" readonly  style="border:none; width:18px; background-color:transparent;" value=""></input> </th>
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
						<td style="text-align: center">
						<a href="/FMS/admin/fmsPrintAdmin.jsp?fmsr_cd=<%= list.get(i).getFmsr_cd() %>&user_id=<%= list.get(i).getUser_id() %>">
							<%= list.get(i).getFms_con() %></a></td>
						<!-- (3) 작성자 -->	
						<td><%= userDAO.getName(list.get(i).getUser_id()) %></td>
						<!--  (4) 심각도 -->
						<td><%= list.get(i).getFms_sev() %>등급</td>
						<!--  (5) 심각도 -->
						<td><%= list.get(i).getFms_sco() %>점</td>
						<!-- (6) 장애 인지 일자 -->
						<td><%= list.get(i).getFms_rec() %></td>
						<!-- (7) SLA 대상여부 -->
						<td><%= list.get(i).getFms_sla() %></td>
					</tr>
					<%
						}
					%>
				</tbody>
				<% } else { %>
					<tbody><tr><th colspan="7" style="text-align: center; border: 1px solid #dddddd;">승인된 장애 보고가 없습니다.<br></th></tr></tbody>
				<% } %>
			</table>
			
			<!-- 페이징 처리 영역 -->
			<%
				if(pageNumber != 1){
			%>
					<a href="/FMS/admin/searchfbbsAdminSla.jsp?pageNumber=<%=pageNumber - 1 %>"
					class="btn btn-success btn-arraw-left">이전</a>
			<%
				}if(aflist.size() != 0){
			%>
					<a href="/FMS/admin/searchfbbsAdminSla.jsp?pageNumber=<%=pageNumber + 1 %>"
					class="btn btn-success btn-arraw-left" id="next">다음</a>
			<%
				}
			%>
			<!-- 출력 버튼 생성 -->
			<a href="/RMS/user/bbsUpdate.jsp" class="btn btn-info pull-right" data-toggle="tooltip" data-html="true" data-placement="bottom" title="주간보고 작성">작성</a>
			<button class="btn btn-success pull-right" onclick="rmsModalAction()" style="margin-right:20px" data-toggle="tooltip" data-html="true" data-placement="bottom" title="설정된 기준에 따라, [장애리포트]를 출력합니다.">출력</button>
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
			
			if(value_str.value == "fms_sys") {
				$("#searchText").attr('type','hidden'); //텍스트 필드가 보이지 않도록 수정합니다.
				$("#searchSla").css('display', 'none'); 
				$("#searchSys").css('display', 'block'); //선택 상자 출력
				
				// 값 변경
				$("#searchText").attr('value',$("#searchSys").val());
	
				
			} else if(value_str.value == "fms_sla") { 
				$("#searchText").attr('type','hidden'); //텍스트 필드가 보이지 않도록 수정합니다.
				$("#searchSys").css('display', 'none'); 
				$("#searchSla").css('display', 'block'); //선택 상자 출력
				
				// 값 변경
				$("#searchText").attr('value',$("#searchSla").val());	
			}else {
				$("#searchText").attr('type','text'); 
				$("#searchSla").css('display', 'none'); 
				$("#searchSys").css('display', 'none');
				
				// 값 변경
				$("#searchText").attr('value', "");
			}
			
		}
		function ChangeValueOfDay() {
			var value_str = document.getElementById('dayField');
		}
		
		function ChangeSys() {
			var value_str = document.getElementById('searchSys');
			// 값 변경
			$("#searchText").attr('value',value_str.value);
		}
		
		function ChangeSla() {
			var value_str = document.getElementById('searchSla');
			// 값 변경
			$("#searchText").attr('value',value_str.value);
		}
	</script>
	
    <!-- 보고 개수에 따라 버튼 노출 (list.size()) -->
	<script>
	var trCnt = $('#FmsTable tr').length; 
	
	if(trCnt < 11) {
		$('#next').hide();
	}
	</script>
	
	
</body>
</html>