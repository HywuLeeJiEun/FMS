<%@page import="org.openxmlformats.schemas.wordprocessingml.x2006.main.CTShd"%>
<%@page import="fmscar.fmscarc"%>
<%@page import="fmscar.fmscarb"%>
<%@page import="fmscar.fmscara"%>
<%@page import="java.util.ArrayList"%>
<%@page import="fmscar.FmscarDAO"%>
<%@page import="org.apache.poi.xwpf.usermodel.ParagraphAlignment"%>
<%@page import="org.apache.poi.xwpf.usermodel.XWPFRun"%>
<%@page import="org.apache.poi.xwpf.usermodel.XWPFParagraph"%>
<%@page import="org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTcPr"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="org.apache.poi.xwpf.usermodel.XWPFTableCell"%>
<%@page import="org.apache.poi.xwpf.usermodel.XWPFTableRow"%>
<%@page import="org.apache.poi.xwpf.usermodel.XWPFTable"%>
<%@page import="org.apache.poi.xwpf.usermodel.XWPFDocument"%>
<%@page import="java.io.FileInputStream"%>
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
<%	

	//메인 페이지로 이동했을 때 세션에 값이 담겨있는지 체크
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
	} else {

	//테이블 FMSCARA, FMSCARB, FMSCARC 불러오기
	FmscarDAO fmscar = new FmscarDAO();
	ArrayList<fmscara> cara = fmscar.getfmscara();
	ArrayList<fmscarb> carb = fmscar.getfmscarb();
	ArrayList<fmscarc> carc = fmscar.getfmscarc();

	// 출력 버튼 여부
	String st = request.getParameter("st");
	
	// 데이터 받아오기
	String fmsr_cd = request.getParameter("fmsr_cd"); // fmsr_cd
	String acd = request.getParameter("fms_acd");
	String bcd = request.getParameter("fms_bcd");
	String ccd = request.getParameter("fms_ccd");
	
	String user_id = request.getParameter("user_id"); // 보고자, 장애 처리자
	String fms_doc = request.getParameter("fms_doc"); // 작성일
	String fms_con = request.getParameter("fms_con"); // 장애 요약 내용
	String fms_str = request.getParameter("fms_str"); // 장애발생 일자
	String fms_end = request.getParameter("fms_end"); // 조치 완료 일자
	String fms_rec = request.getParameter("fms_rec"); // 장애인지 일자
	String fms_fov = request.getParameter("fms_fov"); // 장애시간 / 복구시간
	String fms_sev = request.getParameter("fms_sev"); // 심각도(등급)
	String fms_rte = request.getParameter("fms_rte"); // 장애인지경로
	String fms_dif = request.getParameter("fms_dif"); // 장애 분야
	String fms_dcd = request.getParameter("fms_dcd"); // 중복 장애 여부
	String fms_sys = request.getParameter("fms_sys"); // 중복장애 여부
	String fms_res = request.getParameter("fms_res"); // 장애 적임
	String fms_sla = request.getParameter("fms_sla"); // SLA 대상여부
	String sla_rea = request.getParameter("sla_rea"); // SLA 대상여부 '비해당' 즉, "N"인 경우 출력 (추가 생성)
	String fms_sym = request.getParameter("fms_sym"); // 장애 증상
	String fms_emr = request.getParameter("fms_emr"); // 조치 내용 긴급
	String fms_dfu = request.getParameter("fms_dfu"); // 조치 사항 (후속)
	String fms_eff = request.getParameter("fms_eff"); // 업무 영향
	String fms_cau = request.getParameter("fms_cau"); // 장애 원인
	String fms_dre = request.getParameter("fms_dre"); // 향후 대책
	String fms_drp = request.getParameter("fms_drp"); // 실행 계획
	String user_name = request.getParameter("user_name"); // 담당자
	String fms_endc = request.getParameter("fms_endc"); // 완료예정일
	
	

	// 원본 파일 로드
	String docx = "D:\\workspace\\FMS\\src\\main\\webapp\\WEB-INF\\fault_reports\\FMSFile\\SOIL_Application.docx";
	
	FileInputStream file = new FileInputStream(docx);
	
	//.docx 파일열기
	XWPFDocument doc = new XWPFDocument(file);
	
	
	XWPFTable table = doc.getTables().get(0);
	
	//가져온 table을 기준으로 row(행) 순회하기 
	for(int i=0; i < table.getRows().size(); i ++) {
		XWPFTableRow row = table.getRows().get(i);
		
		for(int j=0; j < row.getTableCells().size(); j++) {
			XWPFTableCell cell = row.getTableCells().get(j);
			
			if(cell.getText().equals("user_id")) { 
				// 보고자명
				cell.removeParagraph(0); // 데이터 초기화
				//스타일 적용하기
				XWPFParagraph paragraph = cell.addParagraph();
				XWPFRun run = paragraph.createRun();
				run.setFontFamily("맑은 고딕");
				run.setText(user_id);
				
			} else if(cell.getText().equals("fms_doc")) {	
				// 작성일
				cell.removeParagraph(0); // 데이터 초기화
				//스타일 적용하기
				XWPFParagraph paragraph = cell.addParagraph();
				XWPFRun run = paragraph.createRun();
				run.setFontFamily("맑은 고딕");
				run.setText(fms_doc);
				
			} else if(cell.getText().equals("fms_con")) {
				// 장애요약내용
				cell.removeParagraph(0); // 데이터 초기화
				//스타일 적용하기
				XWPFParagraph paragraph = cell.addParagraph();
				XWPFRun run = paragraph.createRun();
				run.setFontFamily("맑은 고딕");
				run.setText(fms_con);
			} else if(cell.getText().equals("fms_str")) {
				// 장애 발생 일자
				cell.removeParagraph(0); // 데이터 초기화
				//스타일 적용하기
				XWPFParagraph paragraph = cell.addParagraph();
				XWPFRun run = paragraph.createRun();
				run.setFontFamily("맑은 고딕");
				run.setText(fms_str);
				
			} else if(cell.getText().equals("fms_end")) {
				// 조치 완료 일자
				cell.removeParagraph(0); // 데이터 초기화
				//스타일 적용하기
				XWPFParagraph paragraph = cell.addParagraph();
				XWPFRun run = paragraph.createRun();
				run.setFontFamily("맑은 고딕");
				run.setText(fms_end);
				
			} else if(cell.getText().equals("fms_rec")) {
				// 장애 인지 일자
				cell.removeParagraph(0); // 데이터 초기화
				//스타일 적용하기
				XWPFParagraph paragraph = cell.addParagraph();
				XWPFRun run = paragraph.createRun();
				run.setFontFamily("맑은 고딕");
				run.setText(fms_rec);
				
			} else if(cell.getText().equals("fms_fov")) {
				// 장애 시간 (장애 조치까지 소요 시간)
				cell.removeParagraph(0); // 데이터 초기화
				//스타일 적용하기
				XWPFParagraph paragraph = cell.addParagraph();
				XWPFRun run = paragraph.createRun();
				run.setFontFamily("맑은 고딕");
				run.setText(fms_fov);
				
			} else if(cell.getText().equals("fms_sev")) {
				// 심각도(등급)
				cell.removeParagraph(0); // 데이터 초기화
				//스타일 적용하기
				XWPFParagraph paragraph = cell.addParagraph();
				XWPFRun run = paragraph.createRun();
				run.setFontFamily("맑은 고딕");
				run.setText(fms_sev);
					
			} else if(cell.getText().equals("fms_rte")) {
				// 장애 인지 경로
				cell.removeParagraph(0); // 데이터 초기화
				//스타일 적용하기
				XWPFParagraph paragraph = cell.addParagraph();
				XWPFRun run = paragraph.createRun();
				run.setFontFamily("맑은 고딕");
				run.setText(fms_rte);
				
			} else if(cell.getText().equals("fms_dif")) {
				// 장애 분야 
				cell.removeParagraph(0); // 데이터 초기화
				//스타일 적용하기
				XWPFParagraph paragraph = cell.addParagraph();
				XWPFRun run = paragraph.createRun();
				run.setFontFamily("맑은 고딕");
				run.setText(fms_dif);
				
			} else if(cell.getText().equals("fms_dcd")) {
				// 중복 장애 여부
				cell.removeParagraph(0); // 데이터 초기화
				//스타일 적용하기
				XWPFParagraph paragraph = cell.addParagraph();
				XWPFRun run = paragraph.createRun();
				run.setFontFamily("맑은 고딕");
				run.setText(fms_dcd);
				
			} else if(cell.getText().equals("fms_sys")) {
				// 장애 시스템
				cell.removeParagraph(0); // 데이터 초기화
				//스타일 적용하기
				XWPFParagraph paragraph = cell.addParagraph();
				XWPFRun run = paragraph.createRun();
				run.setFontFamily("맑은 고딕");
				run.setText(fms_sys);
				
			} else if(cell.getText().equals("fms_dre")) {
				// 향후 대책 총 내용 (Disaster Recovery)
				cell.removeParagraph(0); // 데이터 초기화
				//스타일 적용하기
				XWPFParagraph paragraph = cell.addParagraph();
				XWPFRun run = paragraph.createRun();
				run.setFontFamily("맑은 고딕");
				run.setText(fms_dre);
				
			} else if(cell.getText().equals("fms_drp")) {
				// 향후 대책 중, 실행 계획
				cell.removeParagraph(0); // 데이터 초기화
				//스타일 적용하기
				XWPFParagraph paragraph = cell.addParagraph();
				XWPFRun run = paragraph.createRun();
				paragraph.setAlignment(ParagraphAlignment.CENTER);
				run.setFontFamily("맑은 고딕");
				run.setText(fms_drp);
					
			} else if(cell.getText().equals("fms_sym")) {
				// 장애 증상
				cell.removeParagraph(0); // 데이터 초기화
				//스타일 적용하기
				XWPFParagraph paragraph = cell.addParagraph();
				XWPFRun run = paragraph.createRun();
				run.setFontFamily("맑은 고딕");
				run.setText(fms_sym);
				
			} else if(cell.getText().equals("fms_emr")) {
				// 조치 내용 (긴급)
				cell.removeParagraph(0); // 데이터 초기화
				//스타일 적용하기
				XWPFParagraph paragraph = cell.addParagraph();
				XWPFRun run = paragraph.createRun();
				run.setFontFamily("맑은 고딕");
				run.setText(fms_emr);
				
			} else if(cell.getText().equals("fms_dfu")) {
				// 조치 사항 (후속)
				cell.removeParagraph(0); // 데이터 초기화
				//스타일 적용하기
				XWPFParagraph paragraph = cell.addParagraph();
				XWPFRun run = paragraph.createRun();
				run.setFontFamily("맑은 고딕");
				run.setText(fms_dfu);
					
			} else if(cell.getText().equals("fms_eff")) {
				// 업무 영향
				cell.removeParagraph(0); // 데이터 초기화
				//스타일 적용하기
				XWPFParagraph paragraph = cell.addParagraph();
				XWPFRun run = paragraph.createRun();
				run.setFontFamily("맑은 고딕");
				run.setText(fms_eff);
				
			} else if(cell.getText().equals("fms_cau")) {
				// 장애 원인
				cell.removeParagraph(0); // 데이터 초기화
				//스타일 적용하기
				XWPFParagraph paragraph = cell.addParagraph();
				XWPFRun run = paragraph.createRun();
				run.setFontFamily("맑은 고딕");
				run.setText(fms_cau);
				
			} else if(cell.getText().equals("fms_res")) {
				// 장애 책임
				cell.removeParagraph(0); // 데이터 초기화
				//스타일 적용하기
				XWPFParagraph paragraph = cell.addParagraph();
				XWPFRun run = paragraph.createRun();
				run.setFontFamily("맑은 고딕");
				run.setText(fms_res);
				
			} else if(cell.getText().equals("fms_sla")) {
				// SLA 대상여부
				cell.removeParagraph(0); // 데이터 초기화
				//스타일 적용하기
				XWPFParagraph paragraph = cell.addParagraph();
				XWPFRun run = paragraph.createRun();
				run.setFontFamily("맑은 고딕");
				run.setText(fms_sla);
				
				// 이때, fms_sla가 "N"이라면 ...
				
			} else if(cell.getText().equals("user_name")) {
				// 담당자
				cell.removeParagraph(0); // 데이터 초기화
				//스타일 적용하기
				XWPFParagraph paragraph = cell.addParagraph();
				XWPFRun run = paragraph.createRun();
				run.setFontFamily("맑은 고딕");
				paragraph.setAlignment(ParagraphAlignment.CENTER);
				run.setText(user_name);
				
			} else if(cell.getText().equals("fms_endc")) {
				// 완료 예정일
				cell.removeParagraph(0); // 데이터 초기화
				//스타일 적용하기
				XWPFParagraph paragraph = cell.addParagraph();
				XWPFRun run = paragraph.createRun();
				run.setFontFamily("맑은 고딕");
				paragraph.setAlignment(ParagraphAlignment.CENTER);
				run.setText(fms_endc);
			}
		}
	}
	
	
	
	// ############ A Table 수정 #################
	table = doc.getTables().get(1);
	int aw = 2;
	//가져온 table을 기준으로 row(행) 순회하기 
	XWPFTableRow row = table.getRows().get(1); // 2번째 row
	for(int j=0; j < row.getTableCells().size(); j++) {
		XWPFTableCell cell = row.getTableCells().get(j);
		
		// ### 중요도 ###
		if(cell.getText().equals("fms_acd")) { 
			cell.removeParagraph(0);
			//스타일 적용하기
			XWPFParagraph paragraph = cell.addParagraph();
			XWPFRun run = paragraph.createRun();
			run.setFontFamily("맑은 고딕");
			paragraph.setAlignment(ParagraphAlignment.CENTER);
			if(acd.equals("A01")) {
				run.setText("1");
			} else if(acd.equals("A02")) {
				run.setText("2");
			} else if(acd.equals("A03")) {
				run.setText("3");
			} else {
				run.setText("4");
			}
		// ### 내용 ###		
		} else if(cell.getText().equals("acon")) {
			cell.removeParagraph(0);
			//스타일 적용하기
			XWPFParagraph paragraph = cell.addParagraph();
			XWPFRun run = paragraph.createRun();
			run.setFontFamily("맑은 고딕");
			for(int i=0; i < cara.size(); i++) {
				if(cara.get(i).getFms_acd().equals(acd)) {
					run.setText(cara.get(i).getAcd_con());
				}
			}
		// ### 가중치 ###
		} else if(cell.getText().equals("aw")) {
			cell.removeParagraph(0);
			//스타일 적용하기
			XWPFParagraph paragraph = cell.addParagraph();
			XWPFRun run = paragraph.createRun();
			run.setFontFamily("맑은 고딕");
			paragraph.setAlignment(ParagraphAlignment.CENTER);
			
			if(acd.equals("A01")) {
				run.setText("5");
				aw = 5;
			} else if(acd.equals("A02")) {
				run.setText("4");
				aw = 4;
			} else if(acd.equals("A03")) {
				run.setText("3");
				aw = 3;
			} else {
				run.setText("2");
			}
		} 
	}
	
	
	// ############ B Table 수정 #################
	table = doc.getTables().get(2);
	int bw = 2;
	//가져온 table을 기준으로 row(행) 순회하기 
	row = table.getRows().get(1); // 2번째 row
	for(int j=0; j < row.getTableCells().size(); j++) {
		XWPFTableCell cell = row.getTableCells().get(j);
		
		// ### 중요도 ###
		if(cell.getText().equals("fms_bcd")) { 
			cell.removeParagraph(0);
			//스타일 적용하기
			XWPFParagraph paragraph = cell.addParagraph();
			XWPFRun run = paragraph.createRun();
			run.setFontFamily("맑은 고딕");
			paragraph.setAlignment(ParagraphAlignment.CENTER);
			
			if(bcd.equals("B01")) {
				run.setText("1");
			} else if(bcd.equals("B02")) {
				run.setText("2");
			} else if(bcd.equals("B03")) {
				run.setText("3");
			} else {
				run.setText("4");
			}
		// ### 내용 ###		
		} else if(cell.getText().equals("bcon")) {
			cell.removeParagraph(0);
			//스타일 적용하기
			XWPFParagraph paragraph = cell.addParagraph();
			XWPFRun run = paragraph.createRun();
			run.setFontFamily("맑은 고딕");
			for(int i=0; i < carb.size(); i++) {
				if(carb.get(i).getFms_bcd().equals(bcd)) {
					run.setText(carb.get(i).getBcd_con());
				}
			}
		// ### 가중치 ###
		} else if(cell.getText().equals("bw")) {
			cell.removeParagraph(0);
			//스타일 적용하기
			XWPFParagraph paragraph = cell.addParagraph();
			XWPFRun run = paragraph.createRun();
			run.setFontFamily("맑은 고딕");
			paragraph.setAlignment(ParagraphAlignment.CENTER);
			
			if(bcd.equals("B01")) {
				run.setText("5");
				bw = 5;
			} else if(bcd.equals("B02")) {
				run.setText("4");
				bw = 4;
			} else if(bcd.equals("B03")) {
				run.setText("3");
				bw = 3;
			} else {
				run.setText("2");
			}
		} 
	}
	
	
	// ############ C Table 수정 #################
	table = doc.getTables().get(3);
	int cw = 2;
	//가져온 table을 기준으로 row(행) 순회하기 
	row = table.getRows().get(1); // 2번째 row
	for(int j=0; j < row.getTableCells().size(); j++) {
		XWPFTableCell cell = row.getTableCells().get(j);
		
		// ### 중요도 ###
		if(cell.getText().equals("fms_ccd")) { 
			cell.removeParagraph(0);
			//스타일 적용하기
			XWPFParagraph paragraph = cell.addParagraph();
			XWPFRun run = paragraph.createRun();
			run.setFontFamily("맑은 고딕");
			paragraph.setAlignment(ParagraphAlignment.CENTER);
			
			if(ccd.equals("C01")) {
				run.setText("1");
			} else if(ccd.equals("C02")) {
				run.setText("2");
			} else if(ccd.equals("C03")) {
				run.setText("3");
			} else {
				run.setText("4");
			}
		// ### 내용 ###		
		} else if(cell.getText().equals("ccon")) {
			cell.removeParagraph(0);
			//스타일 적용하기
			XWPFParagraph paragraph = cell.addParagraph();
			XWPFRun run = paragraph.createRun();
			run.setFontFamily("맑은 고딕");
			for(int i=0; i < carb.size(); i++) {
				if(carc.get(i).getFms_ccd().equals(ccd)) {
					run.setText(carc.get(i).getCcd_con());
				}
			}
		// ### 가중치 ###
		} else if(cell.getText().equals("cw")) {
			cell.removeParagraph(0);
			//스타일 적용하기
			XWPFParagraph paragraph = cell.addParagraph();
			XWPFRun run = paragraph.createRun();
			run.setFontFamily("맑은 고딕");
			paragraph.setAlignment(ParagraphAlignment.CENTER);
			
			if(ccd.equals("C01")) {
				run.setText("5");
				cw = 5;
			} else if(ccd.equals("C02")) {
				run.setText("4");
				cw = 4;
			} else if(ccd.equals("C03")) {
				run.setText("3");
				cw = 3;
			} else {
				run.setText("2");
			}
		} 
	}
	
	// ########### 어플리케이션 장애 심각도 설정 ##########
	table = doc.getTables().get(4);
	int w = aw * bw * cw;
	System.out.println(w);
	System.out.println(aw);
	System.out.println(bw);
	System.out.println(cw);
	if(w >= 100) {
		XWPFTableCell cell = table.getRow(1).getTableCells().get(4);
		//스타일 적용하기
		XWPFParagraph paragraph = cell.addParagraph();
		XWPFRun run = paragraph.createRun();
		CTTcPr tcPr = cell.getCTTc().addNewTcPr();
		if(tcPr == null) {
			tcPr = cell.getCTTc().addNewTcPr();
		}
		CTShd shd = tcPr.isSetShd() ? tcPr.getShd() : tcPr.addNewShd();
		shd.setFill("9F9F9F");
		//run.setColor("9F9F9F");
	} else if(w >= 64 && w <= 80) {
		XWPFTableCell cell = table.getRow(2).getTableCells().get(4);
		//스타일 적용하기
		XWPFParagraph paragraph = cell.addParagraph();
		XWPFRun run = paragraph.createRun();
		CTTcPr tcPr = cell.getCTTc().addNewTcPr();
		if(tcPr == null) {
			tcPr = cell.getCTTc().addNewTcPr();
		}
		CTShd shd = tcPr.isSetShd() ? tcPr.getShd() : tcPr.addNewShd();
		shd.setFill("9F9F9F");
		//run.setColor("9F9F9F");
	} else if(w >= 27 && w <= 60) {
		XWPFTableCell cell = table.getRow(3).getTableCells().get(4);
		//스타일 적용하기
		XWPFParagraph paragraph = cell.addParagraph();
		XWPFRun run = paragraph.createRun();
		CTTcPr tcPr = cell.getCTTc().addNewTcPr();
		if(tcPr == null) {
			tcPr = cell.getCTTc().addNewTcPr();
		}
		CTShd shd = tcPr.isSetShd() ? tcPr.getShd() : tcPr.addNewShd();
		shd.setFill("9F9F9F");
		//run.setColor("9F9F9F");
	} else if(w <= 25) {
		XWPFTableCell cell = table.getRow(4).getTableCells().get(4);
		//스타일 적용하기
		XWPFParagraph paragraph = cell.addParagraph();
		XWPFRun run = paragraph.createRun();
		CTTcPr tcPr = cell.getCTTc().addNewTcPr();
		if(tcPr == null) {
			tcPr = cell.getCTTc().addNewTcPr();
		}
		CTShd shd = tcPr.isSetShd() ? tcPr.getShd() : tcPr.addNewShd();
		shd.setFill("9F9F9F");
		//run.setColor("9F9F9F");
	}
	
	
	
	// 수정된 내용을 .docx 파일에 저장
	String fileName = "D:\\workspace\\FMS\\src\\main\\webapp\\WEB-INF\\fault_reports\\FMSFile\\"+fmsr_cd+".docx";
	
	FileOutputStream output = new FileOutputStream(new File(fileName));
	
	doc.write(output);
	
	// 리소스 해제
	file.close();
	output.close();
	doc.close();
	
	// 파일 저장하기
	File dFile = new File(fileName);
	FileInputStream in = new FileInputStream(fileName);
	
	String filename = fmsr_cd+".docx";
	filename = new String(filename.getBytes("utf-8"), "8859_1");  
	
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

<%-- <textarea><%=  user_id %></textarea><br>
<textarea><%=  fms_doc %></textarea><br>
<textarea><%=  fms_con %></textarea><br>
<textarea><%= fms_str  %></textarea><br>
<textarea><%=  fms_end  %></textarea><br>
<textarea><%= fms_rec  %></textarea><br>
<textarea><%=  fms_fov %></textarea><br>
<textarea><%=  fms_sev %></textarea><br>
<textarea><%=  fms_rte %></textarea><br>
<textarea><%=  fms_dif %></textarea><br>
<textarea><%= fms_dcd  %></textarea><br>
<textarea><%=  fms_sys %></textarea><br>
<textarea><%= fms_res  %></textarea><br>
<textarea><%=  fms_sla %></textarea><br>
<textarea><%= fms_sym  %></textarea><br>
<textarea><%= fms_emr  %></textarea><br>
<textarea><%=  fms_dfu %></textarea><br>
<textarea><%= fms_eff  %></textarea><br>
<textarea><%= fms_cau  %></textarea><br>
<textarea><%=  fms_dre %></textarea><br>
<textarea><%= fms_drp  %></textarea><br>
<textarea><%=  user_name %></textarea><br>
<textarea><%=  fms_endc %></textarea><br> --%>

</body>
</html>