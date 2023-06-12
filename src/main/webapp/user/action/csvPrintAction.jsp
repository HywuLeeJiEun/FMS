<%@page import="java.io.OutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
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
			if(fmsr_cd == null || fmsr_cd.isEmpty()) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('유효하지 않은 장애보고입니다. 확인 후 다시 시도해주시길 바랍니다.')");
				script.println("history.back();");
				script.println("</script>");
			} else {
				
				String year = fmsr_cd.substring(0,4);
				
				String fileName = id + "_"+ fmsr_cd.substring(0, 8) +".csv";
				
				String csvName = "C:\\Users\\S-OIL\\git\\FMS\\src\\main\\webapp\\WEB-INF\\fault_reports\\FMSFile\\"+fileName;
				//String csvName = "D:\\Program Files\\MySQL Workbench 8.0 CE\\uploads\\"+fileName;
				String excelName = "C:/Users/S-OIL/git/FMS/src/main/webapp/WEB-INF/fault_reports/FMSFile/"+fileName;
				
				int result = fms.PrintExcel(fmsr_cd, excelName);

				if(result == -1) {
					// 생성 실패
					System.out.println("생성 실패. 데이터베이스 에러");
				} else {
					
					// 파일 저장하기
					File dFile = new File(csvName);
					FileInputStream in = new FileInputStream(csvName);
					
					String filename = fileName;
					filename = new String(filename.getBytes("euc-kr"), "8859_1");  
					
					response.setContentType("application/octet-stream");	
					response.setHeader("Content-Disposition", "attachment; filename=" + filename ); 
					
					out.clear();
					out = pageContext.pushBody();
					
					OutputStream os = response.getOutputStream();
					
					int length;
					byte[] b = new byte[(int)fileName.length()];
					
					while ((length = in.read(b)) > 0) {
						os.write(b, 0, length);
					}
					
					os.flush();
					os.close();
					in.close();
					
					
					// 완료후 파일 삭제
					dFile.delete();
				}
			}
		}
		
	%>

</body>
</html>