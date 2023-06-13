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
		String valfmsr_cd = request.getParameter("fmsr_cd");
		String valfms_sco = request.getParameter("fms_sco");
	
		// 테이블 FMSCARA, FMSCARB, FMSCARC 불러오기
		FmscarDAO fmscar = new FmscarDAO();
		ArrayList<fmscara> cara = fmscar.getfmsSEVA(valfmsr_cd);
		ArrayList<fmscarb> carb = fmscar.getfmsSEVB(valfmsr_cd);
		ArrayList<fmscarc> carc = fmscar.getfmsSEVC(valfmsr_cd);
		
		int a = cara.get(0).getAcd_wgt();
		int b = carb.get(0).getBcd_wgt();
		int c = carc.get(0).getCcd_wgt();
		
	
	%>

	<!-- 모달 영역! (날짜 선택 모달) - 출력시 활성화 -->
	<button class="btn btn-primary btn-sm" data-toggle="modal" data-target="#RmsdlModal" id="rmsData" style="display:none"> get rms_dl </button>
	<div class="modal fade" id="FmsModal" role="dialog">
		   <div class="modal-dialog">
		    <div class="modal-content">
		     <div class="modal-header">
		     	<button class="btn pull-right" onClick="closeModal()">X</button>
		     </div>
		     <!-- FmsModal, A B C 등급도 선택 -->
		     	<div class="modal-body">
		     		<div class="row">
		     			<h6 id="FmsDesc" class="col-form-label" style="text-align: center;"> 등급 산정 근거를 확인하실 수 있습니다. <br><br></h6>
		     			<table class="table" id="ATable" style="text-align: center; border: 1px solid #dddddd; border-collapse: collapse;" >
							<thead>
								<tr>
									<th colspan="6" style="text-align: center; background-color:#EFEFEF">1. 업무 중요도</th>
								</tr>
							</thead>
							<tbody id="Abody">
								<!-- A.업무 중요도 및 영향도 -->
								<tr class="ui-state-default">
									<th style="text-align: center; border: 1px solid #dddddd;">중요도</th>
									<th style="text-align: center; border: 1px solid #dddddd;" colspan="3">내용</th>
									<th style="text-align: center; border: 1px solid #dddddd;">가중치</th>
								</tr>
								<tr class="box" style="cusor:pointer">
									<th style="text-align: center; border: 1px solid #dddddd;"><%= cara.get(0).getFms_acd().substring(1) %></th>
									<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><%= cara.get(0).getAcd_con() %></th>
									<th style="text-align: center; border: 1px solid #dddddd;"><input readonly style="width:50%; height:50%; text-align:center; border:none" value="<%= a %>"></input></th>
								</tr>
								<tr style="visibility:hidden"><th><button></button></th></tr>
								
								<!-- B. 영향 범위 -->
								<tr>
									<th colspan="6" style="text-align: center; background-color:#EFEFEF">2. 영향 범위</th>
								</tr>
								<tr class="ui-state-default">
									<th style="text-align: center; border: 1px solid #dddddd;">중요도</th>
									<th style="text-align: center; border: 1px solid #dddddd;" colspan="3">내용</th>
									<th style="text-align: center; border: 1px solid #dddddd;">가중치</th>
								</tr>
								<tr class="box" style="cusor:pointer">
									<th style="text-align: center; border: 1px solid #dddddd;"><%= carb.get(0).getFms_bcd().substring(1) %></th>
									<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><%= carb.get(0).getBcd_con() %></th>
									<th style="text-align: center; border: 1px solid #dddddd;"><input readonly style="width:50%; height:50%; text-align:center; border:none" value="<%= b %>"></input></th>
								</tr>
								<tr style="visibility:hidden"><th><button></button></th></tr>
								
								<!-- C. 장애 성격 -->
								<tr>
									<th colspan="6" style="text-align: center; background-color:#EFEFEF">3. 장애 성격</th>
								</tr>
								<tr class="ui-state-default">
									<th style="text-align: center; border: 1px solid #dddddd;">중요도</th>
									<th style="text-align: center; border: 1px solid #dddddd;" colspan="3">내용</th>
									<th style="text-align: center; border: 1px solid #dddddd;">가중치</th>
								</tr>
								<tr class="box" style="cusor:pointer">
									<th style="text-align: center; border: 1px solid #dddddd;"><%= carc.get(0).getFms_ccd().substring(1) %></th>
									<th style="text-align: center; border: 1px solid #dddddd;" colspan="3"><%= carc.get(0).getCcd_con() %></th>
									<th style="text-align: center; border: 1px solid #dddddd;"><input readonly style="width:50%; height:50%; text-align:center; border:none" value="<%= c %>"></input></th>
								</tr>
								<tr style="visibility:hidden"><th><button></button></th></tr>
								
								<!-- 총 합산 -->
								<tr>
									<th colspan="6" style="text-align: center; background-color:#EFEFEF">장애 등급 산정</th>
								</tr>
								<tr class="ui-state-default">
									<th style="text-align: center; border: 1px solid #dddddd;">업무<br>중요도(A)</th>
									<th style="text-align: center; border: 1px solid #dddddd;">영향 범위(B)</th>
									<th style="text-align: center; border: 1px solid #dddddd;">장애 성격(C)</th>
									<th style="text-align: center; border: 1px solid #dddddd;">A * B * C</th>
									<th style="text-align: center; border: 1px solid #dddddd;">심각도<br>(등급)</th>
								</tr>
								<tr class="box">
									<th rowspan="4" style="text-align: center; border: 1px solid #dddddd;">1~4<br>(5~2점)</th>
									<th rowspan="4" style="text-align: center; border: 1px solid #dddddd;">1~4<br>(5~2점)</th>
									<th rowspan="4" style="text-align: center; border: 1px solid #dddddd;">1~4<br>(5~2점)</th>
									<td style="text-align: center; border: 1px solid #dddddd;">100 이상</td>
									<td style="text-align: center; border: 1px solid #dddddd;" id="rk1">1</td>
								</tr>
								<tr>
									<td style="text-align: center; border: 1px solid #dddddd;">64 ~ 80</td>
									<td style="text-align: center; border: 1px solid #dddddd;" id="rk2">2</td>
									
								</tr>
								<tr>
									<td style="text-align: center; border: 1px solid #dddddd;">27 ~ 60</td>
									<td style="text-align: center; border: 1px solid #dddddd;" id="rk3">3</td>
								</tr>
								<tr>
									<td style="text-align: center; border: 1px solid #dddddd;">25 이하</td>
									<td style="text-align: center; border: 1px solid #dddddd;" id="rk4">4</td>
								</tr>
								<tr>
									<td style="text-align: center; border: 1px solid #dddddd;">총합</td>
									<td colspan="4" style="text-align: center; border: 1px solid #dddddd;"><%= a %> * <%= b %> * <%= c %> = <%= valfms_sco %> (점)</td>
								</tr>
								</tbody>
						</table>
						
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
	function dataSEV() {
		//심각도(등급)을 구하기 위해, ABC 구분코드 선택하는 창 띄우기
		$("#FmsModal").modal();
		
		var sco = <%= valfms_sco %>;
		if(sco >= 100) {
			$("#rk1").css('backgroundColor','#DCDCDC');
		} else if(sco >= 64 && sco <= 80) {
			$("#rk2").css('backgroundColor','#DCDCDC');
		} else if(sco >= 27 && sco <= 60) {
			$("#rk3").css('backgroundColor','#DCDCDC');
		} else if(sco <= 25) {
			$("#rk4").css('backgroundColor','#DCDCDC');
		}
	}
	
	function closeModal() {
		//alert("close 선택");
		$("#FmsModal").modal("hide");
	}
	</script>
	
	
	


	
</body>