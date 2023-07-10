 <%@page import="groovyjarjarantlr.CharQueue"%>
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
<title>IMS</title>
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
		
		
		// 유효 년도 가져오기 (데이터가 존재하는 년도 출력) - fms_rec
		ArrayList<String> recList = fms.getYearFms("fms_rec", 4, "승인");
		
		// 시작일(fms_str) 기준, min 찾기
		//String min = fms.getminmaxFms("min", "fms_rec", "승인");
		
		// 완료일(fms_end) 기준, max 찾기
		//String max = fms.getminmaxFms("max", "fms_rec", "승인");
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
		     		<!-- YYYY - 년도 데이터 -->
		     		<div class="row">
		     			<div class="col-md-12" style="visibility:hidden" >
							<a type="button" class="close"></a>
							<a type="button" class="close"></a>
						</div>
						<div class="col-md-2" style="visibility:hidden" >
						</div>
		     			<div class="col-md-8 form-outline">
							<h5 style="text-align: center;" data-toggle="tooltip" data-placement="top" title="생성할 장애리포트의 기준 일자 및 'yyyy(연도)' 데이터를 선택합니다.">기준 일자 선택 <i class="glyphicon glyphicon-info-sign"  style="left:5px;"></i></h5>
							<table>
								<tr>
									<td>
										<select required class="form-control" style="width:150px; text-align:center" id="fms_day" name="fms_day">
											<option value="fms_rec">장애 인지 일자</option>
											<option value="fms_str">장애 발생 일자</option>
											<option value="fms_end">조치 완료 일자</option>
										</select>
									</td>
									<td> <input style="visibility: hidden; width:50px"> </td>
									<td>
										<select required class="form-control" style="width:100px; text-align:center" id="year" onchange="SelectYear()">
											<option value="">[선택]</option>
										<% for(int i=0; i < recList.size(); i++) { %>
												<option value="<%= recList.get(i) %>"><%= recList.get(i) %></option>
										<% } %> 
										</select>
									</td>
								</tr>
							</table>
							<br>
							<h6 class="col-form-label"> '승인'된 장애보고 이력이 있는 년도를 표시합니다. </h6>
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
						<div id="wbtn" class="modal-footer" style="display:none">
							<div class="col-md-12">
								<button type="button" class="btn btn-primary pull-right form-control" style="width:20%; margin-left:40px" onClick="wUpdate()" >저장</button>
								<button type="button" class="btn btn-success pull-right form-control" style="width:20%;" onClick="reUpdate()" >재설정</button>
							</div>
						</div>
		    		</div>
		    		
		    		<!-- MM - 월 데이터 -->
		    		<div class="row">
		     			<div class="col-md-12" style="visibility:hidden" >
							<a type="button" class="close"></a>
							<a type="button" class="close"></a>
						</div>
						<div class="col-md-2" style="visibility:hidden" >
						</div>
		     			<div class="col-md-8 form-outline">
							<h5 style="text-align: center;" data-toggle="tooltip" data-placement="top" title="지정한 연도 범위 내에서 기간을 설정합니다.">기간 범위 <i class="glyphicon glyphicon-info-sign"  style="left:5px;"></i></h5>
							<table>
								<tr align="center">
									<td>
										<input required id="str_day" name="str_day" type="date" value="" style="margin-right:10px"></input> 
										~
										<input required id="end_day" name="end_day" type="date" value="" style="margin-right:20px; margin-left:10px"></input> 
									</td>
									<td>
										<button type="button" class="btn btn-success pull-right form-control" style="margin-left:20px; text-align:center" onClick="AdminReportAction()" >출력</button>
									</td>
								</tr>
							</table>
							<br>
							<h6 class="col-form-label">  </h6>
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
		var year = $("#year option:selected").val();
		var fms_day = $("#fms_day option:selected").val();
		var str_day = $("#str_day").val();
		var end_day = $("#end_day").val();
		if (year == null || year == "" || year.match("선택") != null) {
			alert("기준일이 설정되지 않았습니다. 확인하여 주시길 바랍니다.");
		} 
		else {
			location.href='/FMS/admin/action/fmsAdminReportAction.jsp?year='+year+'&str_day='+str_day+'&end_day='+end_day+'&fms_day='+fms_day;
			$('#FmsReportModal').modal('hide');
		}	
	}
	
	function SelectYear() {
		//년도가 선택되면, 날짜 선택에 자동으로 기준일 기입
		var year = $("#year option:selected").val();
		if(year != null && year != "") {
			var str = year+"-01-01";
			var end = year+"-12-31";
			$("#str_day").attr('value',str);
			$("#end_day").attr('value',end);
			
			//min, max 정하기 (해당년도)
			$("#str_day, #end_day").prop("min",str);
			$("#str_day, #end_day").prop("max",end);
			
		} else {
			$("#str_day").attr('value',"");
			$("#end_day").attr('value',"");
		}
	}
	
	
	
	
	</script>
	


	
</body>