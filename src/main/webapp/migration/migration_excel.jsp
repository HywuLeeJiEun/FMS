<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="fmscar.FmscarDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="fmsuser.FmsuserDAO"%>
<%@page import="fmsrept.FmsreptDAO"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.io.File"%>
<%@page import="java.io.IOException"%>
<%@page import="org.apache.poi.ss.usermodel.CellType"%>
<%@page import="org.apache.poi.ss.usermodel.Cell"%>
<%@page import="org.apache.poi.ss.usermodel.Row"%>
<%@page import="org.apache.poi.ss.usermodel.Sheet"%>
<%@page import="org.apache.poi.ss.usermodel.WorkbookFactory"%>
<%@page import="org.apache.poi.ss.usermodel.Workbook"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.InputStream"%>
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

	FmsreptDAO fms = new FmsreptDAO();
	FmsuserDAO userDAO = new FmsuserDAO();
	FmscarDAO fmscarDAO = new FmscarDAO();

	ArrayList<String> conlist = new ArrayList<String>();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	
	//excel 파일 불러오기
	String fileName = "ITSM_데이터조회.xls";
	String filePath = "C:\\Users\\S-OIL\\git\\FMS\\src\\main\\webapp\\WEB-INF\\fault_reports\\FMSFile\\migration\\"+fileName;
	File file = new File(filePath);
	
	// 파일 확장자가 다른 경우가 있을 수 있음! (ex> .xls로 되어 있으나, 실제 파일은 HTML인 경우 ...)
	/* if(file.exists()) {
		File newFile = new File(filePath);
		if(file.renameTo(newFile)) {
			System.out.println("파일 형식 변경 완료.");
		}
	} */
	
	
	//System.out.println(file.getName());

	try (InputStream inputStream = new FileInputStream(filePath)) {
	    Workbook workbook = WorkbookFactory.create(inputStream);
	    
	    // 시트는 단일 시트.
	    Sheet sheet = workbook.getSheetAt(0); // 첫 번째 시트 가져오기
	
	    // 사용될 값을 미리 지정합니다.
	    String fmsr_cd = ""; // fms_doc (- 제거) + user_id + 일련번호  
	    String user_id = ""; // 사용자 아이디 (이름으로 값이 들어 있기 때문에, 동명이인에 유의하며 값이 없는 경우 작성 생략)
	    String fms_doc = ""; // 장애보고 작성일 (O)
	    String fms_con = ""; // 장애보고 요약 내용 (O)
	    String fms_str = ""; // 장애 발생 일자 (O)
	    String fms_end = ""; // 조치 완료 일자 (O)  => FMS_SIG(컬럼의 상태명)에 따라 표시 
	    String fms_rec = ""; // 장애 인지 일자, 자동 입력으로 발생한 데이터는 fms_rec = fms_str로 생성 (장애 발생 일자와 동일하도록) 
			
	    // 심각도 관련 건수
	    // 심각도의 경우, SEV(등급)이 주어지는 대로 a,b,c 코드를 맞춤.  또한 Null값인 경우, '4등급' 배정
		String fms_fov = "";  
	    String fms_acd = "";
	    String fms_bcd = "";
	    String fms_ccd = "";
	    int fms_sco = 0;
	    int fms_sev = 0;
	    
	    String fms_rte = "기타"; // 장애 인지 경로 = > 기본값 '기타'
	    String fms_dif = "어플리케이션"; // 장애 분야 = > 기본값 '어플리케이션'
	    String fms_dcd = "FD02"; // 중복 장애 여부 = > 기본값 'FD02'
	    String fms_sys = "기타"; // 장애 시스템이 표시되지 않습니다. '기타'로 기본 설정
	    
	    // 장애 보고 상세 내용
	    // 장애보고 내용이 작성되어 있지 않기 떄문에, 기본 설정 Text로 대체 (이떄, '제출' 상태가 아니라면 비워둠.)
	    // '장애 처리 완료 후, 작성된 데이터입니다. [ITSM]'
	    String fms_dre = ""; // 향후 대책 총 내용
	    String fms_drp = ""; // 향후 대책 중, 실행 계획
	    String fms_sym = ""; // 장애 증상
	    String fms_emr = ""; // 조치 내용 (긴급)
	    String fms_dfu = ""; // 조치 사항 (후속)
	    String fms_eff = ""; // 업무 영향
	    String fms_cau = ""; // 장애 원인
	    String fms_res = ""; // 장애 책임
	    String fms_sla = "N"; // SLA 대상 여부 => 기본값 'N'
	    String sla_rea = "";
	    
	    // 장애보고 상태에 따라 설정됨
	    String fms_sig = "";   // 결제대기 - '저장', 종료 - '제출'
	   	java.sql.Timestamp fms_upa = fms.getDateNow();
	    
	    
	    
	    
	    // 첫째 row를 기준으로 하여, 유효값을 비교합니다.
		Row rowGet = sheet.getRow(0);
	    //System.out.println(row.toString());
	   
	    
	    int getColId = 0;
	    int getColDoc = 0;
	    int getColStr = 0;
	    int getColSev = 0;
	    int getColCon = 0;
	    int getColEnd = 0;
	    int getColSig = 0;
	    
	    
	    // 첫째 row에 해당하는 cell값을 가져와 확인합니다.
	    for(Cell cell : rowGet) {
	    	// 사용되어야 할 데이터인 경우, 값을 받아옵니다. 
	    	//System.out.println(cell);
	    	
	    	if(cell.toString().equals("처리자명")) {
	    		//(1) 사용자 정보
	    		getColId = cell.getColumnIndex(); // '처리자명'의 column 인덱스가 몇번인지 구함. (16 (0~16))
	    		//System.out.println(cell.getColumnIndex());
	    	} else if(cell.toString().equals("등록일시")) {
	    		//(2) FMS 생성 날짜
	    		getColDoc = cell.getColumnIndex();
	    	} else if(cell.toString().equals("장애발생일시")) {
	    		//(3) 장애 발생 일자
	    		getColStr = cell.getColumnIndex();
	    	} else if(cell.toString().equals("장애등급")) {
	    		//(4) 장애등급
	    		getColSev = cell.getColumnIndex();
	    	} else if(cell.toString().equals("장애제목")) {
	    		//(5) 장애요약본
	    		getColCon = cell.getColumnIndex();
	    	} else if(cell.toString().equals("처리완료일")) {
	    		//(6) 처리 완료일
	    		getColEnd = cell.getColumnIndex();
	    	} else if(cell.toString().equals("상태명")) {
	    		//(7) 장애 처리 상태
	    		getColSig = cell.getColumnIndex();
	    	}
	    	
	    }
	    
	   // ArrayList<Integer> getRow = new ArrayList<Integer>();
	    
	    // row를 돌려 아이디 값이 유효한지 확인한다. 
	    // 해당 로직을 통해 필요 없는 row는 제거한다. 
	    for(Row row : sheet) {
	    	Cell getIdcell = row.getCell(getColId);
	    	
	    	String getId = userDAO.getId(getIdcell.toString());
	    	user_id = getId;
	    	//System.out.println(user_id);
	    	
	        Cell getSigcell = row.getCell(getColSig);
	        String sigState = getSigcell.toString();
	    	
	    	int forNum = -1; // -1인 경우, 해당 row는 저장할 수 없음!
	    	
	    	if(getId != null && !getId.isEmpty()) {
	    		//해당 Row만 탐색하면 됨!
	    		// 데이터 생성 시작 (장애보고 마이그레이션)
	    		// 지정된 cell을 확인하면 됨!	    		
	    		for(Cell cell : row) {
	    			if(cell.getColumnIndex() == getColDoc) {
	    				if(!cell.toString().contains("null")) {
		    				// 데이터를 올바르게 가져오기 위해 Date 함수 사용
		    				Date docDate = cell.getDateCellValue();
		    				fms_doc = sdf.format(docDate).substring(0,10);
	    				} else {
	    					fms_doc = "";
	    				}
	    			} else if(cell.getColumnIndex() == getColEnd) {
	    				if(!cell.toString().contains("null")) {
	    					// 데이터를 올바르게 가져오기 위해 Date 함수 사용
		    				Date endDate = cell.getDateCellValue();
	    					fms_end = sdf.format(endDate);
	    					
	    					//fms_end가 있는 경우, 승인 상태는 ('제출')
	    					if(sigState.contains("종료")) {
	    						fms_sig = "제출";
	    					} else {
	    						fms_sig = "저장";
	    					}
	    				} else {
	    					//null 인 경우,
	    					fms_end = "";
	    					fms_sig = "저장";
	    				}
	    			} else if(cell.getColumnIndex() == getColCon) {
	    				fms_con = cell.toString();
	    				
	    				conlist = fms.getFmscon(user_id);
	    				//System.out.println(conlist.toString());
	    				
	    				boolean result = false;
	    				// 정확도 대신, 길이가 더 긴 문자열 기준으로 포함 여부 확인하기
	    				for(String con : conlist) {
	    					if(fms_con.length() > con.length()) {
	    						result = fms_con.contains(con); 
	    					} else {
	    						result = con.contains(fms_con); // con이 fms_con을 포함하고 있습니까?
	    					}
	    	
		    				if(result) { //true라면, (즉, 포함되어 있다면!)
		    					forNum = -1;
		    					break;
		    				}
	    				}	
	    				
	    				if(result) {
	    					conlist.clear();
	    					//System.out.println(result);
	    					//System.out.println("정확도 달성 건 (미입력건): "+fms_con);
	    					continue; // 해당 row 스킵
	    				} else {
	    					forNum = 1;
	    					//System.out.println(result);
	    					//System.out.println("입력 건: "+fms_con);
	    				}
	    				
	    			}  else if(cell.getColumnIndex() == getColSev) {
	    				// 심각도(등급)
	    				if(cell.toString() == null || cell.toString().isEmpty() || cell.toString().contains("null")) {
	    					fms_sev = 4;
	    					fms_acd = "A04";
	    					fms_bcd = "B04";
	    					fms_ccd = "C04";
	    				} else if(!cell.toString().contains("null")){ // "null"을 텍스트로 가지고 있는 경우,
	    					fms_sev = Integer.parseInt(cell.toString().substring(0, 1)); // 등급 제외, 숫자만 표시
	    					fms_acd = "A0"+fms_sev;
	    					fms_bcd = "B0"+fms_sev;
	    					fms_ccd = "C0"+fms_sev;
	    				}
	    			} else if(cell.getColumnIndex() == getColStr) {
	    				if(!cell.toString().contains("null")) {
		    				// 데이터를 올바르게 가져오기 위해 Date 함수 사용
		    				Date strDate = cell.getDateCellValue();
		    				fms_str = sdf.format(strDate);
	    				} else {
	    					fms_str = "";
	    				}
	    			}
	    		}
	    		
	    		fms_rec = fms_str;
	    		
	    		// 일련번호
	    		String fmsr_cdNum = "";
	    		// 나머지 데이터들도 확인된 데이터를 통해 채움. 
	    		String rs = fms.countFms(user_id, fms_doc);
	    		if(rs == "" || rs.isEmpty() || rs == null) {
	    			fmsr_cdNum = "01";
	    		} else {
	    			rs = rs.replaceAll(fms_doc.replaceAll("[.,-]", ""), "");
	    			rs = rs.replace(user_id, "");
	    			fmsr_cdNum = String.format("%02d", Integer.parseInt(rs) + 1);
	    		}
	    		
	    		fmsr_cd = fms_doc.replaceAll("[.,-]", "") + user_id + fmsr_cdNum;
	    		
	    		// 심각도 세부 산정
	    		//System.out.println("A코드 : "+fms_acd+"  B코드 : "+fms_bcd+"  C코드 : "+fms_ccd);
	    		fms_sco = fmscarDAO.getWgt(fms_acd, fms_bcd, fms_ccd);
	    		
	    		if(fms_sig.equals("제출")) {
		    		fms_dre = "장애 처리 완료 후, 작성된 데이터입니다. [ITSM]";
		    		fms_drp = fms_dre;
		    		fms_sym = fms_dre;
		    		fms_emr = fms_dre;
		    		fms_dfu = fms_dre;
		    		fms_eff = fms_dre;
		    		fms_cau = fms_dre;
		    		fms_res = fms_dre;
	    		}
	    		
	    		//fms_fov - 장애 시간 (완료 시간 - 인지 시간)
	    		if(fms_end != null && !fms_end.equals("")) {
	    			Date rec = sdf.parse(fms_rec);
	    			Date end = sdf.parse(fms_end);
	    			
	    			long milliseconds = Math.abs(rec.getTime() - end.getTime());
	    			long min = milliseconds / (60 * 1000);
	    			
	    			fms_end = Long.toString(min);
	    		} else {
	    			fms_end = "";
	    		}
	    	
	    		
	    		// 데이터 저장
	    		if(forNum != -1) {
		    		fms.writeFms(fmsr_cd, user_id, fms_doc, fms_con, fms_str, fms_end, fms_rec, fms_fov, fms_acd, fms_bcd, fms_ccd, fms_sco, fms_sev, fms_rte, fms_dif, fms_dcd, fms_sys, fms_dre, fms_drp, fms_sym, fms_emr, fms_dfu, fms_eff, fms_cau, fms_res, fms_sla, sla_rea, fms_sig, fms_upa);	
	    		}
	    	}
	    	
	    }
	
	    workbook.close();
	} catch (IOException e) {
	    e.printStackTrace();
	}


%>
</body>
</html>