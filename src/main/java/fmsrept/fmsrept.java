package fmsrept;

public class fmsrept {
	private String fmsr_cd;    //장애보고 구분코드
	private String user_id;    //사용자 아이
	private String fms_doc;    //장애보고 작성일 
	private String fms_con;    //장애보고 요약 내용
	private String fms_str;    //장애 발생 일자
	private String fms_end;    //조치 완료 일자
	private String fms_rec;    //장애 인지 일자
	private String fms_fov;    //장애 시간
	private String fms_acd;    //해당 장애 보고에 대한 A 구분코드
	private String fms_bcd;    //해당 장애 보고에 대한 B 구분코드
	private String fms_ccd;    //해당 장애 보고에 대한 C 구분코드
	private int fms_sco; 	   //가중치 A * B * C 값
	private int fms_sev; 	   //가중치 A * B * C 값의 등급 표시
	private String fms_rte;    //장애 인지 경로
	private String fms_dif;    //장애 분야
	private String fms_dcd;    //중복 장애 여부(공통코드 테이블)
	private String fms_sys;    //장애 시스템(장애 발생 업무)
	private String fms_dre;    //향후 대책 총 내용(Disaster Recovery)
	private String fms_drp;    //향후 대책 중, 실행 계획(Disaster Recovery Plan)
	private String fms_sym;    //장애 증상
	private String fms_emr;    //조치 내용(긴급, Emergency)
	private String fms_dfu;    //조치 사항 (후속, Disability follow-up)
	private String fms_eff;    //업무 영향(effect)
	private String fms_cau;    //장애 원인(Cause)
	private String fms_res;    //장애 책임(Responsibility)
	private String fms_sla;    //SLA 대상여부(보고서 출력이 필요한 대상인지)
	private String sla_rea;	   //SLA 대상여부 '비해당'시, 사유
	private String fms_sig;    //승인 및 상태 확인(Sign)
	private String fms_upa;    //수정일
	public String getFmsr_cd() {
		return fmsr_cd;
	}
	public void setFmsr_cd(String fmsr_cd) {
		this.fmsr_cd = fmsr_cd;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getFms_doc() {
		return fms_doc;
	}
	public void setFms_doc(String fms_doc) {
		this.fms_doc = fms_doc;
	}
	public String getFms_con() {
		return fms_con;
	}
	public void setFms_con(String fms_con) {
		this.fms_con = fms_con;
	}
	public String getFms_str() {
		return fms_str;
	}
	public void setFms_str(String fms_str) {
		this.fms_str = fms_str;
	}
	public String getFms_end() {
		return fms_end;
	}
	public void setFms_end(String fms_end) {
		this.fms_end = fms_end;
	}
	public String getFms_rec() {
		return fms_rec;
	}
	public void setFms_rec(String fms_rec) {
		this.fms_rec = fms_rec;
	}
	public String getFms_fov() {
		return fms_fov;
	}
	public void setFms_fov(String fms_fov) {
		this.fms_fov = fms_fov;
	}
	public String getFms_acd() {
		return fms_acd;
	}
	public void setFms_acd(String fms_acd) {
		this.fms_acd = fms_acd;
	}
	public String getFms_bcd() {
		return fms_bcd;
	}
	public void setFms_bcd(String fms_bcd) {
		this.fms_bcd = fms_bcd;
	}
	public String getFms_ccd() {
		return fms_ccd;
	}
	public void setFms_ccd(String fms_ccd) {
		this.fms_ccd = fms_ccd;
	}
	public int getFms_sco() {
		return fms_sco;
	}
	public void setFms_sco(int fms_sco) {
		this.fms_sco = fms_sco;
	}
	public int getFms_sev() {
		return fms_sev;
	}
	public void setFms_sev(int fms_sev) {
		this.fms_sev = fms_sev;
	}
	public String getFms_rte() {
		return fms_rte;
	}
	public void setFms_rte(String fms_rte) {
		this.fms_rte = fms_rte;
	}
	public String getFms_dif() {
		return fms_dif;
	}
	public void setFms_dif(String fms_dif) {
		this.fms_dif = fms_dif;
	}
	public String getFms_dcd() {
		return fms_dcd;
	}
	public void setFms_dcd(String fms_dcd) {
		this.fms_dcd = fms_dcd;
	}
	public String getFms_sys() {
		return fms_sys;
	}
	public void setFms_sys(String fms_sys) {
		this.fms_sys = fms_sys;
	}
	public String getFms_dre() {
		return fms_dre;
	}
	public void setFms_dre(String fms_dre) {
		this.fms_dre = fms_dre;
	}
	public String getFms_drp() {
		return fms_drp;
	}
	public void setFms_drp(String fms_drp) {
		this.fms_drp = fms_drp;
	}
	public String getFms_sym() {
		return fms_sym;
	}
	public void setFms_sym(String fms_sym) {
		this.fms_sym = fms_sym;
	}
	public String getFms_emr() {
		return fms_emr;
	}
	public void setFms_emr(String fms_emr) {
		this.fms_emr = fms_emr;
	}
	public String getFms_dfu() {
		return fms_dfu;
	}
	public void setFms_dfu(String fms_dfu) {
		this.fms_dfu = fms_dfu;
	}
	public String getFms_eff() {
		return fms_eff;
	}
	public void setFms_eff(String fms_eff) {
		this.fms_eff = fms_eff;
	}
	public String getFms_cau() {
		return fms_cau;
	}
	public void setFms_cau(String fms_cau) {
		this.fms_cau = fms_cau;
	}
	public String getFms_res() {
		return fms_res;
	}
	public void setFms_res(String fms_res) {
		this.fms_res = fms_res;
	}
	public String getFms_sla() {
		return fms_sla;
	}
	public void setFms_sla(String fms_sla) {
		this.fms_sla = fms_sla;
	}
	public String getSla_rea() {
		return sla_rea;
	}
	public void setSla_rea(String sla_rea) {
		this.sla_rea = sla_rea;
	}
	public String getFms_sig() {
		return fms_sig;
	}
	public void setFms_sig(String fms_sig) {
		this.fms_sig = fms_sig;
	}
	public String getFms_upa() {
		return fms_upa;
	}
	public void setFms_upa(String fms_upa) {
		this.fms_upa = fms_upa;
	}
	
	
	
}
