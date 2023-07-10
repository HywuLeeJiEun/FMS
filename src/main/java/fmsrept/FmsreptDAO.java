package fmsrept;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;


public class FmsreptDAO {
	private Connection conn; //자바와 데이터베이스를 연결
	private ResultSet rs; //결과값 저장
	
	
	//기본 생성자
	//1. 메소드마다 반복되는 코드를 이곳에 넣으면 코드가 간소화된다.
	//2. DB 접근을 자바가 직접하는 것이 아닌, DAO가 담당하도록 하여 호출 문제를 해결함.
	public FmsreptDAO() {
		try {
			String dbURL = "jdbc:mariadb://localhost:3306/fms"; //연결할 DB
			String dbID = "root"; //DB 접속 ID
			String dbPassword = "7471350"; //DB 접속 password
			Class.forName("org.mariadb.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	/*********** 기능 구현(메소드 구현) 영역 ***********/
	//작성일자(시간 추출) 메소드 - main, update
	public java.sql.Timestamp getDateNow() {
		String sql = "select now()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getTimestamp(1);
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return null; //데이터베이스 오류
	}
	
	
	
	//FMSREPT - 사용자(User_id) 기준으로 조회하기 (+ pageNumber) // fbbs.jsp
	public ArrayList<fmsrept> getfms(String user_id, int pageNumber) {
		ArrayList<fmsrept> list = new ArrayList<fmsrept>();
		String SQL = "select fmsr_cd ,user_id, fms_con, fms_doc, fms_sco, fms_sev, fms_sys, fms_sig, fms_upa from fmsrept where user_id=? order by fms_doc desc limit ?,10";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user_id);
			pstmt.setInt(2, (pageNumber-1) * 10);
			rs = pstmt.executeQuery(); //select
			while(rs.next()) {
				fmsrept fms = new fmsrept();
				fms.setFmsr_cd(rs.getString(1));  // 구분 코드
				fms.setUser_id(rs.getString(2));  // 사용자 정보
				fms.setFms_con(rs.getString(3));  // 작성 내용
				fms.setFms_doc(rs.getString(4));  // 작성일
				fms.setFms_sco(rs.getInt(5));     // 심각도 산정값
				fms.setFms_sev(rs.getInt(6));     // 심각도
				fms.setFms_sys(rs.getString(7));  // 장애 발생 업무, 장애 발생 시스템
				fms.setFms_sig(rs.getString(8));  // 승인 및 상태 확인
				fms.setFms_upa(rs.getString(9));  // 수정일
				list.add(fms);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return list;
	}
	
	
	//FMSREPT - 사용자(User_id) 기준으로 조회하기 / 조건을 추가하여 검색 (+ pageNumber) // searchfbbs.jsp
	public ArrayList<fmsrept> getSearchfms(String user_id, String searchField, String searchText, int pageNumber) {
		ArrayList<fmsrept> list = new ArrayList<fmsrept>();
		String SQL = "select fmsr_cd ,user_id, fms_con, fms_doc, fms_sco, fms_sev, fms_sys, fms_sig, fms_upa from"
				+ "(select * from fmsrept where user_id=?) r"
				+ " where " + searchField.trim();
		try {
			if(searchText != null && !searchText.equals("")) {
				SQL += " LIKE '%"+searchText.trim()+"%' order by fms_doc desc limit ?,10";
			} else {
				return list;
			}
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user_id);
			pstmt.setInt(2, (pageNumber-1) * 10);
			rs = pstmt.executeQuery(); //select
			while(rs.next()) {
				fmsrept fms = new fmsrept();
				fms.setFmsr_cd(rs.getString(1));  // 구분 코드
				fms.setUser_id(rs.getString(2));  // 사용자 정보
				fms.setFms_con(rs.getString(3));  // 작성 내용
				fms.setFms_doc(rs.getString(4));  // 작성일
				fms.setFms_sco(rs.getInt(5));     // 심각도 산정 값
				fms.setFms_sev(rs.getInt(6));     // 심각도
				fms.setFms_sys(rs.getString(7));  // 장애 발생 업무, 장애 발생 시스템
				fms.setFms_sig(rs.getString(8));  // 승인 및 상태 확인
				fms.setFms_upa(rs.getString(9));  // 수정일
				list.add(fms);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return list;
	}
	
	
	
	//FMSREPT - (관리자) fms_sig = '제출'인 경우 또는 '승인'인 모든 경우 조회하기 (+ pageNumber) // fbbsAdmin.jsp('제출'), fbbsAdminSla.jsp('승인')
	public ArrayList<fmsrept> getAdminfms(String fms_sig, int pageNumber) {
		ArrayList<fmsrept> list = new ArrayList<fmsrept>();
		String SQL = "select fmsr_cd ,user_id, fms_con, fms_rec, fms_sco, fms_sev, fms_sys, fms_sla, fms_sig, fms_upa from fmsrept where fms_sig=? order by fms_rec desc limit ?,10";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, fms_sig);
			pstmt.setInt(2, (pageNumber-1) * 10);
			rs = pstmt.executeQuery(); //select
			while(rs.next()) {
				fmsrept fms = new fmsrept();
				fms.setFmsr_cd(rs.getString(1));  // 구분 코드
				fms.setUser_id(rs.getString(2));  // 사용자 정보
				fms.setFms_con(rs.getString(3));  // 작성 내용
				fms.setFms_rec(rs.getString(4));  // 인지일자
				fms.setFms_sco(rs.getInt(5));     // 심각도 산정 값
				fms.setFms_sev(rs.getInt(6));     // 심각도
				fms.setFms_sys(rs.getString(7));  // 장애 발생 업무, 장애 발생 시스템
				fms.setFms_sla(rs.getString(8));  // SLA 대상여부
				fms.setFms_sig(rs.getString(9));  // 승인 및 상태 확인
				fms.setFms_upa(rs.getString(10));  // 수정일
				list.add(fms);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return list;
	}
		
	
	//FMSREPT - 사용자(User_id) 기준으로 조회하기 / 조건을 추가하여 검색 (+ pageNumber) // searchfbbsAdminSla.jsp
	public ArrayList<fmsrept> getSearchfmsAdmin(String fms_sig, String searchField, String searchText, int pageNumber, String str_day, String end_day, String dayField) {
		ArrayList<fmsrept> list = new ArrayList<fmsrept>();
		String SQL = "select fmsr_cd ,user_id, fms_doc, fms_con, fms_str, fms_end, fms_rec, fms_sco, fms_sev, fms_sys, fms_sla, fms_sig, fms_upa from"
				+ "(select * from fmsrept where fms_sig=?) r ";
				
		try {
			if(searchText != null && !searchText.equals("")) {
				SQL += " where " + searchField.trim();
				SQL += " LIKE '%"+searchText.trim()+"%' ";
				if(str_day != null || end_day !=  null) {
					SQL += " and ";
				}
			} else { //검색 텍스트가 비어있다면,
				// 텍스트 검색에 대한 조건은 입력하지 않는다.
				if(str_day != null || end_day !=  null) {
					SQL += " where "; // 조건이 없기에 조건 작성
				}
			}
			
			if(str_day != null && !str_day.equals("")) {
				// 시작 기준일이 비어있지 않다면
				if(end_day != null && !end_day.equals("")) {
					// 끝 기준일이 비어있지 않다면 
					//SQL += "(fms_rec between '"+str_day.trim()+"' and '"+end_day.trim()+"') "; // OK
				} else {
					// 끝 기준일이 비어있다면, (str만 비교)
					end_day = "9999-12-31";
				}
			} else {
				// 시작 기준일이 없는 경우,
				if(end_day != null && !end_day.equals("")) {
					str_day = "1900-01-01";
				} else if(searchText != null && !searchText.equals("")) { // 데이터가 하나도 없는 경우!

				}
			}
			//System.out.println(SQL);
			
			if(SQL.contains("between") || str_day.contains("1900-01-01") || str_day.equals(end_day)) {
				SQL += " ("+dayField+" LIKE '"+end_day.trim()+"%')"; //end_day까지 포함하기
			} else {
				SQL += "("+dayField+" between '"+str_day.trim()+"' and '"+end_day.trim()+"') "; //" (fms_rec <= '"+end_day.trim()+"') ";
			}
			SQL += " order by "+dayField+" desc limit ?,10";
			//System.out.println(SQL);
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, fms_sig);
			pstmt.setInt(2, (pageNumber-1) * 10);
			rs = pstmt.executeQuery(); //select
			while(rs.next()) {
				fmsrept fms = new fmsrept();
				fms.setFmsr_cd(rs.getString(1));  // 구분 코드
				fms.setUser_id(rs.getString(2));  // 사용자 정보
				fms.setFms_doc(rs.getString(3));  // 장애 보고 작성 날짜
				fms.setFms_con(rs.getString(4));  // 작성 내용
				fms.setFms_str(rs.getString(5));  // 장애 발생 일자
				fms.setFms_end(rs.getString(6));  // 장애 조치 일자
				fms.setFms_rec(rs.getString(7));  // 장애 인지 일자
				fms.setFms_sco(rs.getInt(8));     // 심각도 산정 값
				fms.setFms_sev(rs.getInt(9));     // 심각도
				fms.setFms_sys(rs.getString(10));  // 장애 발생 업무, 장애 발생 시스템
				fms.setFms_sla(rs.getString(11));  // SLA
				fms.setFms_sig(rs.getString(12));  // 승인 및 상태 확인
				fms.setFms_upa(rs.getString(13));  // 수정일
				list.add(fms);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		//System.out.println(SQL);
		return list;
	}
	
	
	//FMSREPT - fmsr_cd 기준으로 데이터 조회하기 // fmsUpdate.jsp
	public ArrayList<fmsrept> getfmsOne(String fmsr_cd, String user_id) {
		ArrayList<fmsrept> list = new ArrayList<fmsrept>();
		String SQL = "select * from fmsrept where fmsr_cd = ? and user_id = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, fmsr_cd);
			pstmt.setString(2, user_id);
			rs = pstmt.executeQuery(); //select
			while(rs.next()) {
				fmsrept fms = new fmsrept();
				fms.setFmsr_cd(rs.getString(1));  // 구분 코드
				fms.setUser_id(rs.getString(2));  // 사용자 정보
				fms.setFms_doc(rs.getString(3));  // 작성일
				fms.setFms_con(rs.getString(4));  // 작성 내용
				fms.setFms_str(rs.getString(5));  // 장애발생 일자
				fms.setFms_end(rs.getString(6));  // 조치 완료 일자
				fms.setFms_rec(rs.getString(7));  // 장애 인지 일자
				fms.setFms_fov(rs.getString(8));  // 장애 시간
				fms.setFms_acd(rs.getString(9));  // A코드
				fms.setFms_bcd(rs.getString(10)); // B코드
				fms.setFms_ccd(rs.getString(11)); // C코드
				fms.setFms_sco(rs.getInt(12));    // 등급 표시 값
				fms.setFms_sev(rs.getInt(13));    // 등급 표시
				fms.setFms_rte(rs.getString(14)); // 장애 인지 경로
				fms.setFms_dif(rs.getString(15)); // 장애 분야
				fms.setFms_dcd(rs.getString(16)); // 중복 장애 여부
				fms.setFms_sys(rs.getString(17)); // 장애 시스템(장애 발생 업무)
				fms.setFms_dre(rs.getString(18)); // 향후 대책 총 내용
				fms.setFms_drp(rs.getString(19)); // 향후 대책 중, 실행 계획
				fms.setFms_sym(rs.getString(20)); // 장애 증상
				fms.setFms_emr(rs.getString(21)); // 조치 내용 (긴급)
				fms.setFms_dfu(rs.getString(22)); // 조치 사항 (후속)
				fms.setFms_eff(rs.getString(23)); // 업무 영향
				fms.setFms_cau(rs.getString(24)); // 장애 원인
				fms.setFms_res(rs.getString(25)); // 장애 책임
				fms.setFms_sla(rs.getString(26)); // SLA 대상여부
				fms.setSla_rea(rs.getString(27)); // SLA 대상여부 '비해당'시, 사유
				fms.setFms_sig(rs.getString(28)); // 승인 및 상태 확인
				fms.setFms_upa(rs.getString(29)); // 수정일
				list.add(fms);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return list;
	}

	
	//FMSREPT - fmsrept 저장하기(추가하기) // fmsAction.jsp
	public int writeFms(String fmsr_cd, String user_id, String fms_doc, String fms_con, String fms_str, String fms_end, String fms_rec, String fms_fov, String fms_acd, String fms_bcd, String fms_ccd, int fms_sco, int fms_sev, String fms_rte, String fms_dif, String fms_dcd, String fms_sys, String fms_dre, String fms_drp, String fms_sym, String fms_emr, String fms_dfu, String fms_eff, String fms_cau, String fms_res, String fms_sla, String sla_rea, String fms_sig, java.sql.Timestamp fms_upa) {
		String sql = "insert into fmsrept values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, fmsr_cd);
			pstmt.setString(2, user_id);
			pstmt.setString(3, fms_doc);
			pstmt.setString(4, fms_con);
			pstmt.setString(5, fms_str);
			pstmt.setString(6, fms_end);
			pstmt.setString(7, fms_rec);
			pstmt.setString(8, fms_fov);
			pstmt.setString(9, fms_acd);
			pstmt.setString(10, fms_bcd);
			pstmt.setString(11, fms_ccd);
			pstmt.setInt(12, fms_sco);
			pstmt.setInt(13, fms_sev);
			pstmt.setString(14, fms_rte);
			pstmt.setString(15, fms_dif);
			pstmt.setString(16, fms_dcd);
			pstmt.setString(17, fms_sys);
			pstmt.setString(18, fms_dre);
			pstmt.setString(19, fms_drp);
			pstmt.setString(20, fms_sym);
			pstmt.setString(21, fms_emr);
			pstmt.setString(22, fms_dfu);
			pstmt.setString(23, fms_eff);
			pstmt.setString(24, fms_cau);
			pstmt.setString(25, fms_res);
			pstmt.setString(26, fms_sla);
			pstmt.setString(27, sla_rea);
			pstmt.setString(28, fms_sig);
			pstmt.setTimestamp(29, fms_upa);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return -1;
	}

	
	
	//FMSREPT - fmsrept 저장하기(추가하기) // fmsAction.jsp
	public String countFms(String user_id, String fms_doc) {
		String fmsr_cd = fms_doc.replaceAll("[-]", "");
		fmsr_cd = fmsr_cd.replaceAll("[.]", "");
		String sql = "select fmsr_cd from fmsrept where fmsr_cd LIKE '"+fmsr_cd+user_id+"%' order by fmsr_cd desc";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			// 이때, 생성된 자료가 없다면 01, 있다면 count 개수 + 1
			if(rs.next()) {
				return rs.getString(1); //fmsr_cd
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return "";
	}
		
		
		
	//FMSREPT - fmsrept 수정하기(update) // fmsUpdateAction.jsp
	public int updateFms(String fmsr_cd, String user_id, String fms_con, String fms_str, String fms_end, String fms_rec, String fms_fov, String fms_acd, String fms_bcd, String fms_ccd, int fms_sco, int fms_sev, String fms_rte, String fms_dif, String fms_dcd, String fms_sys, String fms_dre, String fms_drp, String fms_sym, String fms_emr, String fms_dfu, String fms_eff, String fms_cau, String fms_res, String fms_sla, String sla_rea, String fms_sig, java.sql.Timestamp fms_upa) {
		String sql = "update fmsrept set fms_con = ?, fms_str = ?, fms_end = ?, fms_rec = ?, fms_fov = ?, fms_acd = ?, fms_bcd = ?, fms_ccd = ?, fms_sco = ?, fms_sev = ?, fms_rte = ?, fms_dif = ?, fms_dcd = ?, fms_sys = ?, fms_dre = ?, fms_drp = ?, fms_sym = ?, fms_emr = ?, fms_dfu = ?, fms_eff = ?, fms_cau = ?, fms_res = ?, fms_sla = ?, sla_rea = ?, fms_sig = ?, fms_upa = ? where fmsr_cd = ? and user_id = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, fms_con);
			pstmt.setString(2, fms_str);
			pstmt.setString(3, fms_end);
			pstmt.setString(4, fms_rec);
			pstmt.setString(5, fms_fov);
			pstmt.setString(6, fms_acd);
			pstmt.setString(7, fms_bcd);
			pstmt.setString(8, fms_ccd);
			pstmt.setInt(9, fms_sco);
			pstmt.setInt(10, fms_sev);
			pstmt.setString(11, fms_rte);
			pstmt.setString(12, fms_dif);
			pstmt.setString(13, fms_dcd);
			pstmt.setString(14, fms_sys);
			pstmt.setString(15, fms_dre);
			pstmt.setString(16, fms_drp);
			pstmt.setString(17, fms_sym);
			pstmt.setString(18, fms_emr);
			pstmt.setString(19, fms_dfu);
			pstmt.setString(20, fms_eff);
			pstmt.setString(21, fms_cau);
			pstmt.setString(22, fms_res);
			pstmt.setString(23, fms_sla);
			pstmt.setString(24, sla_rea);
			pstmt.setString(25, fms_sig);
			pstmt.setTimestamp(26, fms_upa);
			pstmt.setString(27, fmsr_cd);
			pstmt.setString(28, user_id);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return -1;
	}
	
	
	//FMSREPT - fmsrept 제출 및 승인하기(sign) // fmsSignAction.jsp
	public int updateSignFms(String fmsr_cd, String user_id, String fms_sig) {
		String sql = "update fmsrept set fms_sig = ? where fmsr_cd = ? and user_id = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, fms_sig);
			pstmt.setString(2, fmsr_cd);
			pstmt.setString(3, user_id);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return -1;
	}
	
	
	//FMSREPT - fmsrept 제거하기(delete) // fmsDeleteAction.jsp
	public int deleteFms(String fmsr_cd, String user_id) {
		String sql = "delete from fmsrept where fmsr_cd = ? and user_id = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, fmsr_cd);
			pstmt.setString(2, user_id);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return -1;
	}
	
	
	//FMSREPT - <Excel출력> 인지일자(fms_rec)를 기준으로 '년도-월-일' 기준 데이터 찾기  // fmsExcelAction.jsp
	public ArrayList<fmsrept> getExcelfms(String fms_day, String str_day, String end_day) {
		ArrayList<fmsrept> list = new ArrayList<fmsrept>();
		String SQL = "select * from fmsrept where "+fms_day;
		if(str_day != null && ! str_day.equals("") && end_day != null && ! end_day.equals("")) {
			   SQL += " between '"+str_day+"' and '"+end_day+"' and fms_sig='승인' order by "+fms_day+" desc";
		} else {
			//System.out.println(SQL);
			return list;
		}
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery(); //select
			while(rs.next()) {
				fmsrept fms = new fmsrept();
				fms.setFmsr_cd(rs.getString(1));  // 구분 코드
				fms.setUser_id(rs.getString(2));  // 사용자 정보
				fms.setFms_doc(rs.getString(3));  // 작성일
				fms.setFms_con(rs.getString(4));  // 작성 내용
				fms.setFms_str(rs.getString(5));  // 장애발생 일자
				fms.setFms_end(rs.getString(6));  // 조치 완료 일자
				fms.setFms_rec(rs.getString(7));  // 장애 인지 일자
				fms.setFms_fov(rs.getString(8));  // 장애 시간
				fms.setFms_acd(rs.getString(9));  // A코드
				fms.setFms_bcd(rs.getString(10)); // B코드
				fms.setFms_ccd(rs.getString(11)); // C코드
				fms.setFms_sco(rs.getInt(12));    // 등급 표시 값
				fms.setFms_sev(rs.getInt(13));    // 등급 표시
				fms.setFms_rte(rs.getString(14)); // 장애 인지 경로
				fms.setFms_dif(rs.getString(15)); // 장애 분야
				fms.setFms_dcd(rs.getString(16)); // 중복 장애 여부
				fms.setFms_sys(rs.getString(17)); // 장애 시스템(장애 발생 업무)
				fms.setFms_dre(rs.getString(18)); // 향후 대책 총 내용
				fms.setFms_drp(rs.getString(19)); // 향후 대책 중, 실행 계획
				fms.setFms_sym(rs.getString(20)); // 장애 증상
				fms.setFms_emr(rs.getString(21)); // 조치 내용 (긴급)
				fms.setFms_dfu(rs.getString(22)); // 조치 사항 (후속)
				fms.setFms_eff(rs.getString(23)); // 업무 영향
				fms.setFms_cau(rs.getString(24)); // 장애 원인
				fms.setFms_res(rs.getString(25)); // 장애 책임
				fms.setFms_sla(rs.getString(26)); // SLA 대상여부
				fms.setSla_rea(rs.getString(27)); // SLA 대상여부 '비해당'시, 사유
				fms.setFms_sig(rs.getString(28)); // 승인 및 상태 확인
				fms.setFms_upa(rs.getString(29)); // 수정일
				list.add(fms);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		//System.out.println(SQL);
		return list;
	}
	
	
	//FMSREPT - <Excel출력> 인지일자(fms_rec)를 기준으로 '년도-월' 기준 데이터 찾기  // fmsExcelAction.jsp
		public ArrayList<fmsrept> getExcelMMfms(String fms_day, String year) {
			ArrayList<fmsrept> list = new ArrayList<fmsrept>();
			String SQL = "select * from fmsrept where "+fms_day ;
			if(year != null && ! year.equals("")) {
				   SQL += " LIKE '"+year+"%' and fms_sig='승인' order by "+fms_day+" desc";
			} else {
				return list;
			}
			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				rs = pstmt.executeQuery(); //select
				while(rs.next()) {
					fmsrept fms = new fmsrept();
					fms.setFmsr_cd(rs.getString(1));  // 구분 코드
					fms.setUser_id(rs.getString(2));  // 사용자 정보
					fms.setFms_doc(rs.getString(3));  // 작성일
					fms.setFms_con(rs.getString(4));  // 작성 내용
					fms.setFms_str(rs.getString(5));  // 장애발생 일자
					fms.setFms_end(rs.getString(6));  // 조치 완료 일자
					fms.setFms_rec(rs.getString(7));  // 장애 인지 일자
					fms.setFms_fov(rs.getString(8));  // 장애 시간
					fms.setFms_acd(rs.getString(9));  // A코드
					fms.setFms_bcd(rs.getString(10)); // B코드
					fms.setFms_ccd(rs.getString(11)); // C코드
					fms.setFms_sco(rs.getInt(12));    // 등급 표시 값
					fms.setFms_sev(rs.getInt(13));    // 등급 표시
					fms.setFms_rte(rs.getString(14)); // 장애 인지 경로
					fms.setFms_dif(rs.getString(15)); // 장애 분야
					fms.setFms_dcd(rs.getString(16)); // 중복 장애 여부
					fms.setFms_sys(rs.getString(17)); // 장애 시스템(장애 발생 업무)
					fms.setFms_dre(rs.getString(18)); // 향후 대책 총 내용
					fms.setFms_drp(rs.getString(19)); // 향후 대책 중, 실행 계획
					fms.setFms_sym(rs.getString(20)); // 장애 증상
					fms.setFms_emr(rs.getString(21)); // 조치 내용 (긴급)
					fms.setFms_dfu(rs.getString(22)); // 조치 사항 (후속)
					fms.setFms_eff(rs.getString(23)); // 업무 영향
					fms.setFms_cau(rs.getString(24)); // 장애 원인
					fms.setFms_res(rs.getString(25)); // 장애 책임
					fms.setFms_sla(rs.getString(26)); // SLA 대상여부
					fms.setSla_rea(rs.getString(27)); // SLA 대상여부 '비해당'시, 사유
					fms.setFms_sig(rs.getString(28)); // 승인 및 상태 확인
					fms.setFms_upa(rs.getString(29)); // 수정일
					list.add(fms);
				}
			} catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
			}
			return list;
		}
	
	
	//FMSREPT - fmsrept의 일자 기준 년도 데이터 확인하기 // fbbsAdminReport.jsp
	public ArrayList<String> getYearFms(String fms_day, int num, String fms_sig) {
		ArrayList<String> list = new ArrayList<String>();
		String SQL = "select distinct(left("+fms_day.trim()+", ?)) from fmsrept where fms_sig=?"; 
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, num);
			pstmt.setString(2, fms_sig);
			rs = pstmt.executeQuery(); //select
			while(rs.next()) {
				list.add(rs.getString(1));
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return list;
	}
	
	
	//FMSREPT - fmsrept의 일자 기준 최소(min), 최대(max) 구하기 // fbbsAdminReport.jsp
		public String getminmaxFms(String minmax, String fms_day, String fms_sig) {
			String SQL = "select "+minmax+"("+fms_day+") from fmsrept where fms_sig=?"; 
			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, fms_sig);
				rs = pstmt.executeQuery(); //select
				if(rs.next()) {
					return rs.getString(1); 
				}
			} catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
			}
			return "";
		}
	
	
	//FMSREPT - fmsrept table excel 출력하기
	public int PrintExcel(String fmsr_cd, String csvName) {
		String sql = "select '시스템','인지일시','발생일시', '종료일시', '장애소요시간(분)','장애내용','장애원인','장애등급','장애조치','후속조치' union "
				+ "select r.fms_sys, r.fms_rec, r.fms_str, r.fms_end, r.fms_fov, r.fms_con, fms_cau, fms_sev, fms_emr, fms_dfu "
				+ "from fmsrept r "
				+ "where r.fmsr_cd = ? "
				+ "INTO OUTFILE '"+csvName+"' "
				+ "character set euckr "
				+ "fields terminated by ',' "
				+ "enclosed by '\"' "
				+ "escaped by '\\\\' "
				+ "lines terminated by '\\n'";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, fmsr_cd);
			pstmt.execute();
			return 1;
		} catch (Exception e) {
			// TODO: handle exception
			//System.out.println(fmsr_cd);
			//System.out.println(csvName);
			//System.out.println(sql);
			e.printStackTrace();
		}
		return -1;
	}
	
	//FMSREPT - fmsrept의 fms_sys를 distinct로 중복을 제거하여 목록 출력 // fbbsAdminSla.jsp, ...
	public ArrayList<String> getDistSys(String user_id) {
		ArrayList<String> list = new ArrayList<String>();
		String SQL = "select distinct(fms_sys) from fmsrept"; 
		if(user_id != null && !user_id.equals("")) {
			SQL += " where user_id='"+user_id+"' order by 1";
		}
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery(); //select
			while(rs.next()) {
				list.add(rs.getString(1));
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return list;
	}
	
	
	//FMSREPT - fmsrept의 요약내용 불러오기 // migration/migration_excel.jsp
	public ArrayList<String> getFmscon(String user_id) {
		ArrayList<String> list = new ArrayList<String>();
		String SQL = "select fms_con from fmsrept where user_id = ?"; 
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user_id);
			rs = pstmt.executeQuery(); //select
			while(rs.next()) {
				list.add(rs.getString(1));
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return list;
	}
}