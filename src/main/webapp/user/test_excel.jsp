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
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<% 
	String year = "2023";

	FmsreptDAO fms = new FmsreptDAO();
	FmsuserDAO userDAO = new FmsuserDAO();
	
	//테이블 FMSCARA, FMSCARB, FMSCARC 불러오기
	FmscarDAO fmscar = new FmscarDAO();
	ArrayList<fmscara> cara = fmscar.getfmscara();
	ArrayList<fmscarb> carb = fmscar.getfmscarb();
	ArrayList<fmscarc> carc = fmscar.getfmscarc();

	// 삭제할 시트를 구해둡니다.
	ArrayList<Integer> slist = new ArrayList<>();
	
	// year - 인지일자(FMS_REC)을 기준으로 데이터를 조회합니다.
	ArrayList<fmsrept> list = fms.getExcelfms(year);
	
	
	//LinkedHashSet을 통해 중복을 제거한 순서 있는 fms_recm 데이터를 수집합니다.
	HashSet<Integer> rec = new HashSet<Integer>();
	rec.add(1);
	rec.add(2);
	rec.add(3);
	rec.add(4);
	rec.add(5);
	rec.add(6);
	rec.add(7);
	rec.add(8);
	rec.add(9);
	rec.add(10);
	rec.add(11);
	rec.add(12);
	// fms_rec을 수정해, 포함된 월을 계산합니다. (데이터가 있는 '월'은 rec에서 제거합니다.)
	for(int i=0; i < list.size(); i++) {
		int fms_recm = Integer.parseInt(list.get(i).getFms_rec().split("-")[1]); // ex> 5;
		rec.remove(fms_recm);
	}

	// 총 장애시간을 구하기 위한 변수 선언
	long fovAll;
	
	
	//원본 파일 로드
	String excel = "D:\\workspace\\FMS\\src\\main\\webapp\\WEB-INF\\fault_reports\\FMSFile\\2023test.xlsx";
	
	FileInputStream file = new FileInputStream(excel);
	
	//.xlsx 파일열기
	Workbook wb = WorkbookFactory.create(file);
	
	// 시트 개수 구하기
	int sheetNum = wb.getNumberOfSheets();
	//System.out.println("시트 개수 : " + sheetNum);
	
	// 필요 없는 시트라면, 모두 제거 (데이터가 없는 시트는 모두 제거한다.)
	for(int recn : rec) {
		int a = wb.getSheetIndex(recn+"월");
		if(a != -1) {
			wb.removeSheetAt(a);
		}
	}
	

	// 데이터 삽입이 필요한 시트 처리
	for(int i=0; i < wb.getNumberOfSheets(); i++) {
		Sheet sheet = wb.getSheetAt(i);
		String sn = sheet.getSheetName(); // Sheet이름 가져오기
		//System.out.println(sn + wb.getNumberOfSheets());
		// 가져온 시트 중, '예시'를 제외하여 작업 
		if(sn.contains("월")) {
			
			// 월까지 계산된 데이터를 찾아옵니다.
			String mm = String.format("%02d", Integer.parseInt(sn.replaceAll("월","")));
			//System.out.println(mm);
			
			// year-mm - 인지일자(FMS_REC)을 기준으로 데이터를 조회합니다.
			ArrayList<fmsrept> flist = fms.getExcelfms(year+"-"+mm);
			fovAll = 0;
			
			int fovAllRow = 10;
			
			// column이 부족한 경우, 추가작업
			if(flist.size() > 7) { // 7개가 최대 (Row는 10번째))
				//column 추가하기
				//shiftRows(시작 row값, end row값, )
				sheet.shiftRows(9, 9+flist.size()-7, flist.size()-7, true, false);
				fovAllRow += flist.size()-7;
			}
			
			
			//Row 선정 - 데이터 하나별
			for(int r=0; r < flist.size(); r ++) {
				Row row = sheet.getRow(4+r);
				
				if(row.getRowNum() > 3) {
					
					// 번호 0 / 시스템 1 / 인지일시 2 / 발생일시 3 / 종료일시 4 / 장애시간 5 / 장애내용 6 / 장애원인 7 / 장애구분 8 / 장애등급 9 / 후속조치 10 / 기타 11
					// Cell 선정 - 데이터 입력할 곳 (총 14개의 항목)
					for(int j=0; j < row.getLastCellNum(); j++) {
						Cell cell = row.getCell(j);
						//System.out.println(flist.size());
						//System.out.println(row.getLastCellNum()); 0~13 (14개)
						if(j == 0) {
							// 번호
							cell.setCellValue(j+1);
						} else if (j == 1) {
							// 시스템
							cell.setCellValue(userDAO.getTask(flist.get(r).getFms_sys()));
						} else if (j == 2) {
							// 인지일시
							cell.setCellValue(flist.get(r).getFms_rec());
						} else if (j == 3) {
							// 발생일시
							cell.setCellValue(flist.get(r).getFms_str());
						} else if (j == 4) {
							// 종료일시
							cell.setCellValue(flist.get(r).getFms_end());
						} else if (j == 5) {
							// 장애 시간
							long minutes = Long.parseLong(flist.get(r).getFms_fov());
							
							long day = minutes / (60 * 24);
							long hour = (minutes % (60 * 24)) / 60 ;
							long min = minutes % 60;
							
							String fov = String.format("%02d일 %02d:%02d", day, hour, min);
							cell.setCellValue(fov);
						
							// 총 장애시간에 합산
							fovAll += minutes;
							
						} else if (j == 6) {
							// 장애내용
							cell.setCellValue(flist.get(r).getFms_con());
						} else if (j == 7) {
							// 장애원인
							cell.setCellValue(flist.get(r).getFms_cau());
						} else if (j == 8) {
							// 장애구분
							
						}  else if (j == 9) {
							// 장애등급
							cell.setCellValue(flist.get(r).getFms_sev());
						}  else if (j == 10) {
							// 장애조치 (조치내용(긴급))
							cell.setCellValue(flist.get(r).getFms_emr());
						} else if (j == 11) {
							// 후속조치 (조치사항(후속))
							cell.setCellValue(flist.get(r).getFms_dfu());
						}  else if (j == 12) {
							// 기타
						}
					
					}
				}
			}
			//끝나기 전에 fovAll 처리
			//System.out.println("cell 1 : "+sheet.getRow(fovAllRow).getCell(5));
			Cell fovCell = sheet.getRow(fovAllRow).getCell(5);
			// 총시간
			long day = fovAll / (60 * 24);
			long hour = (fovAll % (60 * 24)) / 60 ;
			long min = fovAll % 60;
			
			String fov = String.format("%02d일 %02d:%02d", day, hour, min);
			fovCell.setCellValue(fov);
		}
		
	}  
	
	// 수정된 내용을 .docx 파일에 저장
	String fileName = "D:\\workspace\\FMS\\src\\main\\webapp\\WEB-INF\\fault_reports\\FMSFile\\장애리포트_"+year+".docx";
	
	FileOutputStream output = new FileOutputStream(new File(fileName));
	
	wb.write(output);
	
	// 리소스 해제
	file.close();
	output.close();
	wb.close();
	
	// 파일 저장하기
	File dFile = new File(fileName);
	FileInputStream in = new FileInputStream(fileName);
	
	String filename = "장애리포트_"+year+".docx";
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
	


%>
</body>
</html>