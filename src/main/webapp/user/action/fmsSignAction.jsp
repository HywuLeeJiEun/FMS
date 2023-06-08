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
			String fmsr_cd = request.getParameter("fmsr_cd");
			String user_id = id; //사용자 아이디
			String fms_sig = request.getParameter("fms_sig"); // sign    저장 -> 제출 (수정 삭제가 불가하고 관리자가 승인 가능한 상태로 변경)

			int result = fms.updateSignFms(fmsr_cd, user_id, fms_sig);
			
			if(result != -1) {
				//입력 성공!
				if(fms_sig.contains("제출")) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('제출이 완료되었습니다. 이후 관리자 확인 후 승인 됩니다.')");
					script.println("location.href='../fmsUpdate.jsp?fmsr_cd="+fmsr_cd+"'");
					script.println("</script>");
				} else {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('저장 상태로 변경 되었습니다. 수정 및 삭제가 가능합니다.')");
					script.println("location.href='../fmsUpdate.jsp?fmsr_cd="+fmsr_cd+"'");
					script.println("</script>");
				}
			} else {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('update(sign) 에러가 발생하였습니다. 확인하여 주시길 바랍니다.')");
				script.println("history.back()");
				script.println("</script>");
			}			
		}
		
	%>
	
	
	<%-- <a><%= fms.countFms(user_id, fms_doc, fms_sys) %></a>
	
	<textarea>mainaction 페이지</textarea>
	<br>
	<textarea><%= fmsr_cd %></textarea><br>
	<textarea><%= user_id %></textarea><br>
	<textarea><%= fms_doc %></textarea><br>
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
	<textarea><%= fms_upa %></textarea><br> --%>
	
</body>
</html>