<%@page import="fmscar.FmscarDAO"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.apache.xmlbeans.impl.repackage.Repackage"%>
<%@page import="fmsrept.FmsreptDAO"%>
<%@page import="fmsuser.FmsuserDAO"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>

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
		FmscarDAO fmscar = new FmscarDAO(); //A,B,C 코드
	
		// 현재 세션 상태를 체크한다
		String id = null;
		
		if(session.getAttribute("id") != null){
			id = (String)session.getAttribute("id");
		}
		// 로그인을 한 사람만 글을 쓸 수 있도록 코드를 수정한다
		if(id == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 되어 있지 않습니다. 로그인 후 사용해주시길 바랍니다.')");
			script.println("location.href='../../login.jsp'");
			script.println("</script>");
		} else {  
			String fmsr_cd = request.getParameter("fmsr_cd"); //장애보고 구분 코드 
			String user_id = request.getParameter("user_id"); //사용자 아이디
			
			String fms_con = request.getParameter("fms_con"); //장애보고 요약 내용
			String fms_str = request.getParameter("fms_str"); //장애발생 일자
			String fms_end = request.getParameter("fms_end"); //조치 완료 일자
			String fms_rec = request.getParameter("fms_rec"); //장애 인지 일자
			String fms_fov = request.getParameter("fms_fov"); //장애 시간 (장애 조치 시간)
			String fms_acd = request.getParameter("fms_acd"); //장애 보고 A 구분코드
			String fms_bcd = request.getParameter("fms_bcd"); //장애 보고 B 구분코드
			String fms_ccd = request.getParameter("fms_ccd"); //장애 보고 C 구분코드
			int fms_sev = Integer.parseInt(request.getParameter("fms_sev")); //구분 등급 표시 (심각도(등급))
			String fms_rte = request.getParameter("fms_rte"); //장애 인지 경로
			String fms_dif = request.getParameter("fms_dif"); //장애 분야
			String fms_dcd = request.getParameter("fms_dcd"); //중복 장애 여부(공통 테이블)
			String fms_sys = request.getParameter("fms_sys"); //장애 시스템(장애 발생 업무) => 코드로 삽입
			String fms_dre = request.getParameter("fms_dre"); //향후 대책 총 내용
			String fms_drp = request.getParameter("fms_drp"); //향후 대책 중 실행 계획
			String fms_sym = request.getParameter("fms_sym"); //장애 증상             
			String fms_emr = request.getParameter("fms_emr"); //조치 내용(긴급)
			String fms_dfu = request.getParameter("fms_dfu"); //조치 사항(후속)
			String fms_eff = request.getParameter("fms_eff"); //업무 영향
			String fms_cau = request.getParameter("fms_cau"); //장애 원인
			String fms_res = request.getParameter("fms_res"); //장애 책임
			String fms_sla = request.getParameter("fms_sla"); // 기본 설정
			String sla_rea = request.getParameter("sla_rea"); // sla 대상 사유
			if(fms_sla.equals("Y") || sla_rea == null || sla_rea.isEmpty()) {
				// 대상인 경우 (사유가 존재할 필요 없음), 데이터가 비어있는 경우
				sla_rea = "";
			}
			String fms_sig = request.getParameter("fms_sig"); // sign
			java.sql.Timestamp fms_upa = fms.getDateNow(); //작성일 / 수정일 
			
			//에러없이 진행됨!
			int result = fms.updateFms(fmsr_cd, user_id, fms_con, fms_str, fms_end, fms_rec, fms_fov , fms_acd, fms_bcd, fms_ccd, fms_sev, fms_rte, fms_dif, fms_dcd, fms_sys, fms_dre, fms_drp, fms_sym, fms_emr, fms_dfu, fms_eff, fms_cau, fms_res,  fms_sla, sla_rea, fms_sig, fms_upa);
		
			String route = "";
			
			
			if(result != -1) {
				//입력 성공!
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('수정이 완료되었습니다.')");
				if(fms_sig.equals("승인")) {
					// admin의 경우 이어지는 경로 '승인'
					script.println("location.href='/FMS/admin/fmsUpdateAdmin.jsp?fmsr_cd="+fmsr_cd+"&user_id="+user_id+"'");
				} else {
					// 기본 개발자의 '제출', '저장'의 경우
					script.println("location.href='../fmsUpdate.jsp?fmsr_cd="+fmsr_cd+"'");
				}
				script.println("</script>");
			} else {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('update 에러가 발생하였습니다. 확인하여 주시길 바랍니다.')");
				script.println("history.back()");
				script.println("</script>");
			}			
		} 
		
	%>
	
	
	<%-- <textarea>mainaction 페이지</textarea>
	<br>
	<textarea><%= fmsr_cd %></textarea><br>
	<textarea><%= user_id %></textarea><br>

	<textarea><%= fms_con %></textarea><br>
	<textarea><%= fms_str %></textarea><br>
	<textarea><%= fms_end %></textarea><br>
	<textarea><%= fms_rec %></textarea><br>
	<textarea><%= fms_fov %></textarea><br>
	<textarea><%= fms_acd %></textarea><br>
	<textarea><%= fms_bcd %></textarea><br>
	<textarea><%= fms_ccd %></textarea><br>
	<textarea><%= fms_sev %></textarea><br>
	<textarea><%= fms_rte %></textarea><br>
	<textarea><%= fms_dif %></textarea><br>
	<textarea><%= fms_dcd %></textarea><br>
	<textarea><%= fms_sys %></textarea><br>
	<textarea><%= fms_dre %></textarea><br>
	<textarea><%= fms_drp %></textarea><br>
	<textarea><%= fms_sym %></textarea><br>
	<textarea><%= fms_emr %></textarea><br>
	<textarea><%= fms_dfu %></textarea><br>
	<textarea><%= fms_eff %></textarea><br>
	<textarea><%= fms_cau %></textarea><br>
	<textarea><%= fms_res %></textarea><br>
	<textarea><%= fms_sla %></textarea><br>
	<textarea><%= fms_sig %></textarea><br>
	<textarea><%= fms_upa %></textarea><br>  --%>
	
</body>
</html>