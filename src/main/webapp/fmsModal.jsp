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
	%>

	<!-- 모달 영역! (날짜 선택 모달) - 출력시 활성화 -->
	<button class="btn btn-primary btn-sm" data-toggle="modal" data-target="#RmsdlModal" id="rmsData" style="display:none"> get rms_dl </button>
	<div class="modal fade" id="FmsModal" role="dialog">
		   <div class="modal-dialog">
		    <div class="modal-content">
		     <div class="modal-header">
		     </div>
		     <!-- FmsModal, A B C 등급도 선택 -->
		     	<div class="modal-body">
		     		<div class="row">
		     			<h6 id="FmsDesc" class="col-form-label" style="text-align: center;"> 선택하여 등급과 가중치를 지정할 수 있습니다. <br><br></h6>
		     			<table class="table" id="ATable" style="text-align: center; border: 1px solid #dddddd; border-collapse: collapse;" >
							<thead>
								<tr>
									<th colspan="6" style="text-align: center;">A. 업무 중요도 구분 선택</th>
								</tr>
							</thead>
							<tbody id="Abody">
								<!-- A.업무 중요도 및 영향도 -->
								<tr class="ui-state-default">
									<th style="text-align: center; border: 1px solid #dddddd;">구분</th>
									<th style="text-align: center; border: 1px solid #dddddd;" colspan="2">내용</th>
									<th style="text-align: center; border: 1px solid #dddddd;">가중치</th>
								</tr>
								<% for(int i=0; i < cara.size(); i++) { %>
								<tr class="box" style="cusor:pointer" onClick="fmscaraClick(<%= i+1 %>, '<%= cara.get(i).getFms_acd() %>', <%= cara.get(i).getAcd_wgt() %>)">
									<th style="text-align: center; border: 1px solid #dddddd;"><%= i + 1 %></th>
									<th style="text-align: center; border: 1px solid #dddddd;" colspan="2"><%= cara.get(i).getAcd_con() %></th>
									<th style="text-align: center; border: 1px solid #dddddd;"><input readonly style="width:50%; height:50%; text-align:center" value="<%= cara.get(i).getAcd_wgt() %>"></input></th>
								</tr>
								<% } %>
								<tr style="visibility:hidden"></tr>
								<tr style="visibility:hidden"></tr>
								</tbody>
						</table>
						<table class="table" id="BTable" style="text-align: center; border: 1px solid #dddddd; border-collapse: collapse; display:none" >
							<thead>
								<tr>
									<th colspan="6" style="text-align: center;">B. 영향 범위</th>
								</tr>
							</thead>
							<tbody id="Bbody">
								<!-- B. 영향 범위 -->
								<tr class="ui-state-default">
									<th style="text-align: center; border: 1px solid #dddddd;">구분</th>
									<th style="text-align: center; border: 1px solid #dddddd;" colspan="2">내용</th>
									<th style="text-align: center; border: 1px solid #dddddd;">가중치</th>
								</tr>
								<% for(int i=0; i < carb.size(); i++) { %>
								<tr class="box" onClick="fmscarbClick(<%= i+1 %>, '<%= carb.get(i).getFms_bcd() %>', <%= carb.get(i).getBcd_wgt() %>)">
									<th style="text-align: center; border: 1px solid #dddddd;"><%= i + 1 %></th>
									<th style="text-align: center; border: 1px solid #dddddd;" colspan="2"><%= carb.get(i).getBcd_con() %></th>
									<th style="text-align: center; border: 1px solid #dddddd;"><input readonly style="width:30%; height:30%; text-align:center" value="<%= carb.get(i).getBcd_wgt() %>"></input></th>
								</tr>
								<% } %>
								</tbody>
						</table>
						<table class="table" id="CTable" style="text-align: center; border: 1px solid #dddddd; border-collapse: collapse; display:none" >
							<thead>
								<tr>
									<th colspan="6" style="text-align: center;">C. 인시던트 성격</th>
								</tr>
							</thead>
							<tbody id="Cbody">
								<!-- C. 인시던트 성격 -->
								<tr class="ui-state-default">
									<th style="text-align: center; border: 1px solid #dddddd;">구분</th>
									<th style="text-align: center; border: 1px solid #dddddd;" colspan="2">내용</th>
									<th style="text-align: center; border: 1px solid #dddddd;">가중치</th>
								</tr>
								<% for(int i=0; i < carc.size(); i++) { %>
								<tr class="box" onClick="fmscarcClick(<%= i+1 %>, '<%= carc.get(i).getFms_ccd() %>', <%= carc.get(i).getCcd_wgt() %>)">
									<th style="text-align: center; border: 1px solid #dddddd;"><%= i + 1 %></th>
									<th style="text-align: center; border: 1px solid #dddddd;" colspan="2"><%= carc.get(i).getCcd_con() %></th>
									<th style="text-align: center; border: 1px solid #dddddd;"><input readonly style="width:40%; height:40%; text-align:center" value="<%= carc.get(i).getCcd_wgt() %>"></input></th>
								</tr>
								<% } %>
								</tbody>
						</table>
						<table class="table" id="WTable" style="text-align: center; border: 1px solid #dddddd; border-collapse: collapse; display:none" >
							<thead>
								<tr>
									<th colspan="6" style="text-align: center;">W 가중치 환산</th>
								</tr>
							</thead>
							<tbody id="Wbody">
								<!-- B. 영향 범위 -->
								<tr class="ui-state-default">
									<th style="text-align: center; border: 1px solid #dddddd;">A * B * C</th>
									<th style="text-align: center; border: 1px solid #dddddd;">심각도 등급</th>
								</tr>
								<tr>
									<th style="text-align: center; border: 1px solid #dddddd;">100 이상</th>
									<th style="text-align: center; border: 1px solid #dddddd;">1</th>
								</tr>
								<tr>
									<th style="text-align: center; border: 1px solid #dddddd;">64~80</th>
									<th style="text-align: center; border: 1px solid #dddddd;">2</th>
								</tr>
								<tr>
									<th style="text-align: center; border: 1px solid #dddddd;">27~60</th>
									<th style="text-align: center; border: 1px solid #dddddd;">3</th>
								</tr>
								<tr>
									<th style="text-align: center; border: 1px solid #dddddd;">25이하</th>
									<th style="text-align: center; border: 1px solid #dddddd;">4</th>
								</tr>
								<tr style="visibility:hidden"><th> </th></tr>
								<tr>
									<th style="text-align: center;" colspan="5"><textarea readonly id="wth" style="border:none; resize:none"></textarea></th>
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
	}
	
	var aw = 0;
	var bw = 0;
	var cw = 0;
	var rank = "-";
	
	
	var ranges = document.querySelectorAll('.box');
	ranges.forEach((range) => {
		range.addEventListener('mouseover', () => {
			range.style.backgroundColor = "#eeeeee";
			range.style.cursor = 'pointer';
			// 내부 요소의 색상도 변경
			var elements = range.querySelectorAll("*");
			elements.forEach(function(element){
				element.style.backgroundColor = '#eeeeee';
			});
		});
		range.addEventListener('mouseout', () => {
			range.style.backgroundColor = "";
			range.style.cursor = '';
			// 내부 요소의 색상도 변경
			var elements = range.querySelectorAll("*");
			elements.forEach(function(element){
				element.style.backgroundColor = '';
			});
		});
	});

	
	// A 선택
	function fmscaraClick(i, fms_acd, w) {
		//alert(fms_acd + w);
		if(confirm("구분 "+i+" 선택, [업무 중요도]에 대한 가중치를 "+w+"로 설정하시겠습니까?")) {
			//alert(fms_acd);
			//A를 선택한 등급(fms_acd)/가중치를 설정하고 B를 선택할 수 있도록 수정함.
			aw = w;
			$("#fms_acd").val(fms_acd);
			
			 const atable = document.getElementById('ATable');
			 atable.style.display = 'none';
			 const btable = document.getElementById('BTable');
			 btable.style.display = '';
			//alert("B.영향 범위 선택으로 이동합니다.");
		} 
	}
	
	// B 선택
	function fmscarbClick(i, fms_bcd, w) {
		//alert(fms_acd + w);
		if(confirm("구분 "+i+" 선택, [영향 범위]에 대한 가중치를 "+w+"로 설정하시겠습니까?")) {
			//alert(fms_acd);
			//A를 선택한 등급(fms_acd)/가중치를 설정하고 B를 선택할 수 있도록 수정함.
			bw = w;
			$("#fms_bcd").val(fms_bcd);
			
			 const atable = document.getElementById('BTable');
			 atable.style.display = 'none';
			 const btable = document.getElementById('CTable');
			 btable.style.display = '';
			//alert("C.인시던트 성격으로 이동합니다.");
		} 
	}
	
	
	// C 선택
	function fmscarcClick(i, fms_ccd, w) {
		//alert(fms_acd + w);
		if(confirm("구분 "+i+" 선택, [장애 영역]에 대한 가중치가 "+w+"로 설정하시겠습니까?")) {
			//alert(fms_acd);
			//A를 선택한 등급(fms_acd)/가중치를 설정하고 B를 선택할 수 있도록 수정함.
			cw = w;
			$("#fms_ccd").val(fms_ccd);
			
			 const atable = document.getElementById('CTable');
			 atable.style.display = 'none';
			 const btable = document.getElementById('WTable');
			 btable.style.display = '';
			 const wbtn = document.getElementById('wbtn');
			 wbtn.style.display = '';
			 const fd = document.getElementById('FmsDesc');
			 fd.style.display = 'none';
					 
			 var wv = aw * bw * cw;

			 if(wv <= 25) {
				 rank = "4";
			 } else if(wv >= 27 && wv <= 60) {
				 rank = "3";
			 } else if(wv >= 64 && wv <= 80) {
				 rank = "2";
			 } else {
				 // 100 이상
				 rank = "1";
			 }
			 $("#fms_sev").val(rank);
			 $("#wth").val('W는 '+aw+' * '+bw+' * '+cw+' = '+wv+'(점)으로 '+rank+'(등급)입니다.');		
			
		} 
	}
	
	function wUpdate() {
		if(confirm("산정된 등급으로 심각도(등급)가 표시됩니다.")) {
			//등급 기록
			$('#fms_sev').val(rank);
			$('#sev').text("재설정");
			//모달 창 끄기
			$("#FmsModal").modal('hide');
		}
	}
	
	function reUpdate() {
		if(confirm("재설정 시, 계산된 등급이 초기화됩니다. 다시 설정하시겠습니까?")) {
			$('#fms_sev').val("-");
			
			 const atable = document.getElementById('ATable');
			 atable.style.display = '';
			 const btable = document.getElementById('WTable');
			 btable.style.display = 'none';
			 const wbtn = document.getElementById('wbtn');
			 wbtn.style.display = 'none';
			 const fd = document.getElementById('FmsDesc');
			 fd.style.display = '';
		}
	}
	</script>
	


	
</body>