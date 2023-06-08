<%@page import="net.sf.jasperreports.engine.util.FileBufferedWriter"%>
<%@page import="java.io.OutputStreamWriter"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.time.LocalTime"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="javax.xml.crypto.Data"%>
<%@page import="java.time.Duration"%>
<%@page import="fmsuser.FmsuserDAO"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.LinkedHashSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.time.Month"%>
<%@page import="org.apache.poi.ss.usermodel.Cell"%>
<%@page import="fmsrept.fmsrept"%>
<%@page import="fmscar.fmscarc"%>
<%@page import="fmscar.fmscarb"%>
<%@page import="fmscar.fmscara"%>
<%@page import="java.util.ArrayList"%>
<%@page import="fmscar.FmscarDAO"%>
<%@page import="org.apache.poi.ss.usermodel.Row"%>
<%@page import="org.apache.poi.ss.usermodel.Sheet"%>
<%@page import="org.apache.poi.ss.usermodel.WorkbookFactory"%>
<%@page import="org.apache.poi.ss.usermodel.Workbook"%>
<%@page import="org.apache.poi.xwpf.usermodel.XWPFTable"%>
<%@page import="org.apache.poi.xwpf.usermodel.XWPFDocument"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="fmsrept.FmsreptDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>   
<!DOCTYPE html>
<html>
<head>
<meta http-equiv='Content-Type' content='application/vnd.ms-excel; charset=utf-8'/>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<% 
	String year = "2023";

	FmsreptDAO fms = new FmsreptDAO();
	FmsuserDAO userDAO = new FmsuserDAO();
	
	String fileName = "test_excel.csv";
	
	String csvName = "D:\\workspace\\FMS\\src\\main\\webapp\\WEB-INF\\fault_reports\\FMSFile\\"+fileName;
	//String csvName = "D:\\Program Files\\MySQL Workbench 8.0 CE\\uploads\\"+fileName;
	String excelName = "D:/workspace/FMS/src/main/webapp/WEB-INF/fault_reports/FMSFile/"+fileName;
	
	int result = fms.PrintExcel("20230525koujuice03", excelName);
	
	
	if(result == -1) {
		// 생성 실패
		System.out.println("생성 실패. 데이터베이스 에러");
	} else {
		
		// 파일 저장하기
		File dFile = new File(csvName);
		FileInputStream in = new FileInputStream(csvName);
		
		String filename = fileName;
		filename = new String(filename.getBytes("euc-kr"), "8859_1");  
		System.out.println("euc-kr 인코딩");
		
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
	
	
	
	
	


%>
</body>
</html>