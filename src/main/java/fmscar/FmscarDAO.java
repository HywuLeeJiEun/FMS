package fmscar;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import fmsrept.fmsrept;

public class FmscarDAO {
	private Connection conn; //자바와 데이터베이스를 연결
	private ResultSet rs; //결과값 저장
	
	
	//기본 생성자
	//1. 메소드마다 반복되는 코드를 이곳에 넣으면 코드가 간소화된다.
	//2. DB 접근을 자바가 직접하는 것이 아닌, DAO가 담당하도록 하여 호출 문제를 해결함.
	public FmscarDAO() {
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
	
	
	//FMSCARA (A코드) - fmscara 데이터를 조회하여 사용함. //fmsWrite.jsp (모달창)
	public ArrayList<fmscara> getfmscara() {
		ArrayList<fmscara> list = new ArrayList<fmscara>();
		String SQL = "select * from fmscara";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery(); //select
			while(rs.next()) {
				fmscara fms = new fmscara();
				fms.setFms_acd(rs.getString(1));
				fms.setAcd_con(rs.getString(2));
				fms.setAcd_wgt(rs.getInt(3));
				list.add(fms);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return list;
	}
	
	//FMSCARB (B코드) - fmscarb 데이터를 조회하여 사용함. //fmsWrite.jsp (모달창)
	public ArrayList<fmscarb> getfmscarb() {
		ArrayList<fmscarb> list = new ArrayList<fmscarb>();
		String SQL = "select * from fmscarb";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery(); //select
			while(rs.next()) {
				fmscarb fms = new fmscarb();
				fms.setFms_bcd(rs.getString(1));
				fms.setBcd_con(rs.getString(2));
				fms.setBcd_wgt(rs.getInt(3));
				list.add(fms);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return list;
	}
	
	//FMSCARA (A코드) - fmscara 데이터를 조회하여 사용함. //fmsWrite.jsp (모달창)
	public ArrayList<fmscarc> getfmscarc() {
		ArrayList<fmscarc> list = new ArrayList<fmscarc>();
		String SQL = "select * from fmscarc";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery(); //select
			while(rs.next()) {
				fmscarc fms = new fmscarc();
				fms.setFms_ccd(rs.getString(1));
				fms.setCcd_con(rs.getString(2));
				fms.setCcd_wgt(rs.getInt(3));
				list.add(fms);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return list;
	}
		
	// fmsrept 기준, fmsr_cd로 검색하여 조건 찾기
	//FMSCARA (A코드) - fmscara 데이터를 조회하여 사용함. //fmsAdminModal.jsp
	public ArrayList<fmscara> getfmsSEVA(String fmsr_cd) {
		ArrayList<fmscara> list = new ArrayList<fmscara>();
		String SQL = "select * from fmscara "
				+ "where fms_acd = (select fms_acd from fmsrept where fmsr_cd='"+fmsr_cd+"')";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery(); //select
			while(rs.next()) {
				fmscara fms = new fmscara();
				fms.setFms_acd(rs.getString(1));
				fms.setAcd_con(rs.getString(2));
				fms.setAcd_wgt(rs.getInt(3));
				list.add(fms);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return list;
	}
	
	//FMSCARB (B코드) - fmscarb 데이터를 조회하여 사용함. //fmsAdminModal.jsp
	public ArrayList<fmscarb> getfmsSEVB(String fmsr_cd) {
		ArrayList<fmscarb> list = new ArrayList<fmscarb>();
		String SQL = "select * from fmscarb "
				+ "where fms_bcd = (select fms_bcd from fmsrept where fmsr_cd='"+fmsr_cd+"')";		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery(); //select
			while(rs.next()) {
				fmscarb fms = new fmscarb();
				fms.setFms_bcd(rs.getString(1));
				fms.setBcd_con(rs.getString(2));
				fms.setBcd_wgt(rs.getInt(3));
				list.add(fms);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return list;
	}
	
	//FMSCARA (A코드) - fmscara 데이터를 조회하여 사용함. //fmsAdminModal.jsp
	public ArrayList<fmscarc> getfmsSEVC(String fmsr_cd) {
		ArrayList<fmscarc> list = new ArrayList<fmscarc>();
		String SQL = "select * from fmscarc "
				+ "where fms_ccd = (select fms_ccd from fmsrept where fmsr_cd='"+fmsr_cd+"')";	
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery(); //select
			while(rs.next()) {
				fmscarc fms = new fmscarc();
				fms.setFms_ccd(rs.getString(1));
				fms.setCcd_con(rs.getString(2));
				fms.setCcd_wgt(rs.getInt(3));
				list.add(fms);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return list;
	}
}
