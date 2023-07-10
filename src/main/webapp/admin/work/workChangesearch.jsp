<%@page import="fmsuser.fmsuser"%>
<%@page import="fmsuser.FmsuserDAO"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<!-- // 폰트어썸 이미지 사용하기 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<meta charset="UTF-8">
<!-- 화면 최적화 -->
<!-- <meta name="viewport" content="width-device-width", initial-scale="1"> -->
<!-- 루트 폴더에 부트스트랩을 참조하는 링크 -->
<link rel="stylesheet" href="../../css/css/bootstrap.css">
<link rel="stylesheet" href="../../css/index.css">

<title>IMS</title>
</head>



<body>
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
			script.println("location.href='../../login.jsp'");
			script.println("</script>");
		}
		
		// ********** 유저를 가져오기 위한 메소드 *********** 
		//String workset;
		//works 리스트에 저장됨!
		//user_id => 현재 탐색중인 사원의 이름
		String user_id = request.getParameter("user_id");
		
		if(user_id == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('대상자가 없습니다. 사원의 이름을 확인해주십시오.')");
			script.println("location.href='/FMS/admin/work/workChange.jsp'");
			script.println("</script>");
		}
		//str이 user 목록에 있는지 확인.
		if(userDAO.getUser(user_id) == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('대상자가 없습니다. 사원의 이름을 확인해주십시오.')");
			script.println("location.href='/FMS/admin/work/workChange.jsp'");
			script.println("</script>");
		} 
	
		ArrayList<String> getcode = userDAO.getCode(user_id); //코드 리스트 출력
		List<String> getworks = new ArrayList<String>();
		String str=" ";
		String workset ="";
		
		if(getcode == null) {
			str = "";
			workset ="";
		} else {
			for(int i=0; i < getcode.size(); i++) {
				// code 번호에 맞는 manager 작업을 가져와 저장해야함!
				String manager = userDAO.getManager(getcode.get(i));
				getworks.add(manager); //즉, work 리스트에 모두 담겨 저장됨
			}
			
			workset = String.join("/",getworks);
		}
		
		
		// ********** 담당자를 가져오기 위한 메소드 *********** 
		String workSet;
		ArrayList<String> code = userDAO.getCode(id); //코드 리스트 출력(rmsmgrs에 접근하여, task_num을 가져옴.)
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
		
		//모든 사용자 아이디 가져오기!
		ArrayList<String> fuser = userDAO.getidfull();
		//중복값 제거
		for(int i=0; i < fuser.size(); i++) {
			if(fuser.get(i) != null && fuser.get(i).equals("user_id")) {
				fuser.remove(i);
			} else if(fuser.get(i) == null || fuser.get(i).equals("미정")) {
				fuser.remove(i);
			}
		}
	%>
	<!-- 모달 영역! -->
	   <div class="modal fade" id="UserUpdateModal" role="dialog">
		   <div class="modal-dialog">
		    <div class="modal-content">
		     <div class="modal-header">
		      <button type="button" class="close" data-dismiss="modal">×</button>
		      <h3 class="modal-title" align="center">개인정보 수정</h3>
		     </div>
		     <!-- 모달에 포함될 내용 -->
		     <form method="post" action="../../ModalUpdateAction.jsp" id="modalform">
		     <div class="modal-body">
		     		<div class="row">
		     			<div class="col-md-12" style="visibility:hidden">
		     				<a type="button" class="close" >취소</a>
		     				<a type="button" class="close" >취소</a>
		     			</div>
		     			<div class="col-md-3" style="visibility:hidden">
		     			</div>
		     			<div class="col-md-6 form-outline">
		     				<label class="col-form-label">ID </label>
		     				<input type="text" maxlength="20" class="form-control" readonly style="width:100%" id="updateid" name="updateid"  value="<%= id %>">
		     			</div>
		     			<div class="col-md-3">
		     				<label class="col-form-label"> &nbsp; </label>
		     				<!-- <button type="submit" class="btn btn-primary pull-left form-control" >확인</button> -->
						</div>
						<div class="col-md-12" style="visibility:hidden">
		     				<a type="button" class="close" >취소</a>
		     				<a type="button" class="close" >취소</a>
		     			</div>
		     			
		     			
		     			<div class="col-md-3" style="visibility:hidden">
		     			</div>
		     			<div class="col-md-6 form-outline">
		     				<label class="col-form-label"> Password </label>
		     				<input type="password" maxlength="20" required class="form-control" style="width:100%" id="password" name="password" value="<%= password %>">
		     			</div>
		     			<div class="col-md-3">
		     				<label class="col-form-label"> &nbsp; </label>
		     				<i class="glyphicon glyphicon-eye-open" id="icon" style="right:20%; top:35px;" ></i>
						</div>
		     			<div class="col-md-12" style="visibility:hidden">
		     				<a type="button" class="close" >취소</a>
		     				<a type="button" class="close" >취소</a>
		     			</div>
		     			
		     			
		     			<div class="col-md-3" style="visibility:hidden">
		     			</div>
		     			<div class="col-md-6 form-outline">
		     				<label class="col-form-label">name </label>
		     				<input type="text" maxlength="20" required class="form-control" style="width:100%" id="name" name="name"  value="<%= name %>">
		     			</div>
		     			<div class="col-md-3">
		     				<label class="col-form-label"> &nbsp; </label>
		     				<!-- <button type="submit" class="btn btn-primary pull-left form-control" >확인</button> -->
						</div>
		     			<div class="col-md-12" style="visibility:hidden">
		     				<a type="button" class="close" >취소</a>
		     				<a type="button" class="close" >취소</a>
		     			</div>
		     			
		     			
		     			<div class="col-md-3" style="visibility:hidden">
		     			</div>
		     			<div class="col-md-6 form-outline">
		     				<label class="col-form-label">rank </label>
		     				<input type="text" required class="form-control" data-toggle="tooltip" data-placement="bottom" title="직급 변경은 관리자 권한이 필요합니다." readonly style="width:100%" id="rank" name="rank"  value="<%= rank %>">
		     			</div>
		     			<div class="col-md-3">
		     				<label class="col-form-label"> &nbsp; </label>
		     				<!-- <button type="submit" class="btn btn-primary pull-left form-control" >확인</button> -->
						</div>
		     			<div class="col-md-12" style="visibility:hidden">
		     				<a type="button" class="close" >취소</a>
		     				<a type="button" class="close" >취소</a>
		     			</div>
		     			
		     			
		     			<div class="col-md-3" style="visibility:hidden">
		     			</div>
		     			<div class="col-md-4 form-outline">
		     				<label class="col-form-label">email </label>
		     				<input type="text" maxlength="30" required class="form-control" style="width:100%" id="email" name="email"  value="<%= email[0] %>"> 
		     			</div>
		     			<div class="col-md-3" align="left" style="top:5px; right:20px">
		     				<label class="col-form-label" > &nbsp; </label>
		     				<div><i>@ s-oil.com</i></div>
						</div>
		     			<div class="col-md-12" style="visibility:hidden">
		     				<a type="button" class="close" >취소</a>
		     				<a type="button" class="close" >취소</a>
		     			</div>
		     			
		     			
		     			<div class="col-md-3" style="visibility:hidden">
		     			</div>
		     			<div class="col-md-6 form-outline">
		     				<label class="col-form-label">duty </label>
		     				<input type="text" required class="form-control" readonly data-toggle="tooltip" data-placement="bottom" title="업무 변경은 관리자 권한이 필요합니다." style="width:100%" id="duty" name="duty" value="<%= workSet %>">
		     			</div>
		     			<div class="col-md-3">
		     				<label class="col-form-label"> &nbsp; </label>
		     				<!-- <button type="submit" class="btn btn-primary pull-left form-control" >확인</button> -->
						</div>
		     			<div class="col-md-12" style="visibility:hidden">
		     				<a type="button" class="close" >취소</a>
		     				<a type="button" class="close" >취소</a>
		     			</div>
		     		</div>	
		     </div>
		     <div class="modal-footer">
			     <div class="col-md-3" style="visibility:hidden">
     			</div>
     			<div class="col-md-6">
			     	<button type="submit" class="btn btn-primary pull-left form-control" id="modalbtn" >수정</button>
		     	</div>
		     	 <div class="col-md-3" style="visibility:hidden">
	   			</div>	
		    </div>
		    </form>
		   </div>
	  </div>
	</div>
	
    <!-- nav바 불러오기 -->
    <jsp:include page="../../Nav.jsp"></jsp:include>
	
	<%		
		
		// 모든 업무 목록을 불러옴. ( ERP,HR, 의 형태로)
		ArrayList<String> jobs = userDAO.getManagerAll();
	%>

	

	<!-- 게시판 메인 페이지 영역 시작 -->
	<div class="container">
		<div class="row">
			<form method="post" name="search" action="/FMS/admin/work/workChangesearch.jsp">
				<table class="pull-left">
					<tr>
					<td><i class="glyphicon glyphicon-triangle-right" id="icon"  style="left:5px;"></i>&nbsp; <b>담당자</b> &nbsp;</td>
						<td><select class="form-control" name="searchField" id="searchField" onchange="if(this.value) location.href=(this.value);">
							<option><%= userDAO.getName(user_id) %></option>
							<% for(int i=0; i < fuser.size(); i++) {%>
								<option value="/FMS/admin/work/workChangesearch.jsp?user_id=<%= fuser.get(i) %>"><%= userDAO.getName(fuser.get(i)) %></option>
							<% } %>
							</select></td>
					</tr>

				</table>
			</form>
		</div>
	</div>
	
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
		<div class="row">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
			<tr>
				<th colspan="5" style="text-align: center;"> 담당자 업무 변경 </th>
			</tr>
			<tr>
				<th colspan="5" style="text-align: center;">현재 [ <%= userDAO.getName(user_id) %> ](님)의 담당 업무를 변경중입니다.</th>
			</tr>
			</table>
			
		</div>
	</div>
			
			
	<div class="container d-flex align-items-start" style="text-align:center;">
			<div class="flex-grow-1" style="display:inline-block; width:45%;">
				<table class="table" style="text-align: center; border: 1px solid #dddddd">
					<tr>
						<th colspan="2" style="text-align:center">담당업무</th>
					</tr>
					<%
						if(workset.equals("")) {
					%>
						<tr>
							<td colspan="1" style="text-align:center"><input type=text style="border:0; width:50%; text-align:center" readonly value="담당 업무 해당이 없습니다."></td>
						</tr>
					<% 
						} else {
						// 직업의 개수 만큼 for문을 돌림.
							for(int i=0; i< getworks.size(); i++ ) {
					%>
					<tr>
						<td colspan="1" style="text-align:center"><input type=text name="<%= i %>" style="border:0; width:50%; text-align:center" readonly value="<%= getworks.get(i) %>"></td>
						<td colspan="1"><a type="submit" style="margin-right:50%" class="btn btn-danger pull-left" href="workDeleteActionSh.jsp?work=<%= getworks.get(i) %>&user_id=<%= user_id %>" >삭제</a></td>
					</tr>
					<%
							} if (getworks.size() == 10) {
					%>
						<tr>
							<td colspan="2" style="text-align:center"><input type=text style="border:0; width:100%; text-align:center; color:blue" readonly value="업무 지정은 최대 10개까지만 가능합니다."></td>
						</tr>
					<%
							}
						}
					%>
				</table>
			</div>
			
			<div class="align-self-start" style="display:inline-block; width:5%">
				<table class="table" style="text-align: center; border: 1px solid #dddddd">
				</table>
			</div>
			
			<div class="align-slef-start" style="display:inline-block; width:45%;">
				<form method="post" action="workActionSh.jsp?user_id=<%= user_id %>">
					<table class="table" style="text-align: center; border: 1px solid #dddddd">
						<tr>
							<th colspan="2" style="text-align:center"><input type=text name="user" style="border:0; width:15%; text-align:right" readonly value="<%= userDAO.getName(user_id) %>">(님) 업무관리</th>
						</tr>
						<tr style="border:none">
							<td style="border-bottom:none">
								<select id="workValue" class="form-control pull-right" name="workValue" onchange="selectValue()" style="margin-left:30px; width:70%; text-align-last:center;">
										<%
											for(int i=0; i<jobs.size(); i++) {
										%>
										<option value="<%= jobs.get(i) %>"><%= jobs.get(i) %></option> 
										<%
											}
										%>
								</select>
							</td>
								<td><button type="submit" class="btn btn-primary pull-left" style="margin-light:50%;"  >추가</button></td>
						</tr>
						<% 
						for(int i=0; i<works.size()-1; i++) {
						%>
							<tr style="border:none">
								<td colspan="1" style="border:none"><button style="margin-right:30%; visibility:hidden; border-top:none; border:none" class="btn btn-danger" formaction=""> 가나다  </button></td>
							</tr>	
						<%
							} if (works.size() == 10) {
						%>
							<tr style="border:none">
								<td colspan="1" style="border:none"><button style="margin-right:30%;border:none; visibility:hidden" class="btn btn-danger" formaction=""> 가나다  </button></td>
							</tr>
						<%
								}
						%>
					</table>
				</form>
			</div>
	</div>
	
	
	
	<!-- 부트스트랩 참조 영역 -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="../../css/js/bootstrap.js"></script>
	
	<!-- modal 내, password 보이기(안보이기) 기능 -->
		<script>
		$(document).ready(function(){
		    $('#icon').on('click',function(){
		    	console.log("hello");
		        $('#password').toggleClass('active');
		        if($('#password').hasClass('active')){
		            $(this).attr('class',"glyphicon glyphicon-eye-close")
		            $('#password').attr('type',"text");
		        }else{
		            $(this).attr('class',"glyphicon glyphicon-eye-open")
		            $('#password').attr('type','password');
		        }
		    });
		});
	</script>
	
	<!-- 모달 툴팁 -->
	<script>
		$(document).ready(function(){
			$('[data-toggle="tooltip"]').tooltip();
		});
	</script>
	
	
	<!-- 모달 submit -->
	<script>
	$('#modalbtn').click(function(){
		$('#modalform').text();
	})
	</script>
	
	<!-- 모달 update를 위한 history 감지 -->
	<script>
	window.onpageshow = function(event){
		if(event.persisted || (window.performance && window.performance.navigation.type == 2)){ //history.back 감지
			location.reload();
		}
	}
	</script>
</body>