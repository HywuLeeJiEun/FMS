 <%@page import="fmsrept.FmsreptDAO"%>
<%@page import="fmscar.fmscarc"%>
<%@page import="fmscar.fmscarb"%>
<%@page import="fmscar.fmscara"%>
<%@page import="java.util.ArrayList"%>
<%@page import="fmscar.FmscarDAO"%>
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
		// 테이블 FMSCARA, FMSCARB, FMSCARC 불러오기
		FmscarDAO fmscar = new FmscarDAO();
		ArrayList<fmscara> cara = fmscar.getfmscara();
		ArrayList<fmscarb> carb = fmscar.getfmscarb();
		ArrayList<fmscarc> carc = fmscar.getfmscarc();
		
		FmsreptDAO fms = new FmsreptDAO();
		
		
		// 유효 년도 가져오기 (데이터가 존재하는 년도 출력)
		ArrayList<String> recList = fms.getYearFms(4, "승인");
		
	%>
	
	<!-- 모달 영역! (날짜 선택 모달) - 출력시 활성화 -->
	<button class="btn btn-primary btn-sm" data-toggle="modal" data-target="#FmsReportModal" id="rmsData" style="display:none"> get rms_dl </button>
	<div class="modal fade" id="FmsReportModal" role="dialog">
		   <div class="modal-dialog">
		    <div class="modal-content">
		     <div class="modal-header">
		     </div>
		     <!-- FmsReportModal -->
		     	<div class="modal-body">
		     		<div class="row">
		     			<div class="col-md-12" style="visibility:hidden" >
							<a type="button" class="close"></a>
							<a type="button" class="close"></a>
						</div>
						<div class="col-md-2" style="visibility:hidden" >
						</div>
		     			<div class="col-md-8 form-outline">
							<h5 style="text-align: center;" data-toggle="tooltip" data-placement="top" title="생성할 장애리포트의 장애 인지 일자 중, 'yyyy(년)' 데이터를 선택합니다.">기준일 선택 <i class="glyphicon glyphicon-info-sign"  style="left:5px;"></i></h5>
							<table>
								<tr>
									<td>
										<select class="form-control" style="width:200px; margin-right:20px; text-align:center" id="year" onchange="">
											<option selected="selected">[선택]</option>
										<% for(int i=0; i < recList.size(); i++) { %>
												<option><%= recList.get(i) %></option>
										<% } %> 
										</select>
									</td>
									<td>
										<button type="button" class="btn btn-success pull-right form-control" style="margin-left:20px; text-align:center" onClick="AdminReportAction()" >출력</button>
									</td>
								</tr>
							</table>
							<br>
							<h6 class="col-form-label"> 선택된 년도를 기준으로 '장애리포트_year.xlsx'를 출력합니다. </h6>
							<h6 class="col-form-label"> 이때 '월 기준' 데이터가 없는 경우, 해당 월시트는 제거됩니다.</h6>
						</div>
						<div class="col-md-2" style="visibility:hidden" >
						</div>
						<div class="col-md-12" style="visibility:hidden" >
							<a type="button" class="close"></a>
							<a type="button" class="close"></a>
						</div>
						<div id="wbtn" class="modal-footer" style="display:none">
							<div class="col-md-12">
								<button type="button" class="btn btn-primary pull-right form-control" style="width:20%; margin-left:40px" onClick="wUpdate()" >저장</button>
								<button type="button" class="btn btn-success pull-right form-control" style="width:20%;" onClick="reUpdate()" >재설정</button>
							</div>
						</div>
		    		</div>
   				</div>
		   </div>
	  </div>
	</div>
	
	
	<script>
	
	function AdminReportAction() {
		var year = $("#year").val();
		
		if (year == null || year == "" || year.match("선택") != null) {
			alert("기준일이 설정되지 않았습니다. 확인하여 주시길 바랍니다.");
		} else {
			location.href='/FMS/admin/action/fmsAdminReportAction.jsp?year='+year;
			
			$('#FmsReportModal').modal('hide');
		}	
	}
	
	
	</script>
	


	
</body>