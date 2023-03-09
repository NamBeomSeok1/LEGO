package modoo.module.shop.cmpny.service;

import java.util.Date;
import java.util.List;

public class CmpnyDpstryVO {

    private Integer dpstryNo;

    private String cmpnyId;

    private String dpstryNm;

    private String dpstryAdres;

    private String dpstryZip;

    private String telno;

    private Date registPnttm;

    /** 보관소 번호 리스트 */
    private List<String> searchDpstryNoList;

    public Integer getDpstryNo() {
        return dpstryNo;
    }

    public void setDpstryNo(Integer dpstryNo) {
        this.dpstryNo = dpstryNo;
    }

    public String getCmpnyId() {
        return cmpnyId;
    }

    public void setCmpnyId(String cmpnyId) {
        this.cmpnyId = cmpnyId;
    }

    public String getDpstryNm() {
        return dpstryNm;
    }

    public void setDpstryNm(String dpstryNm) {
        this.dpstryNm = dpstryNm;
    }

    public String getDpstryAdres() {
        return dpstryAdres;
    }

    public void setDpstryAdres(String dpstryAdres) {
        this.dpstryAdres = dpstryAdres;
    }

    public String getDpstryZip() {
        return dpstryZip;
    }

    public void setDpstryZip(String dpstryZip) {
        this.dpstryZip = dpstryZip;
    }

    public String getTelno() {
        return telno;
    }

    public void setTelno(String telno) {
        this.telno = telno;
    }

    public Date getRegistPnttm() {
        return registPnttm;
    }

    public void setRegistPnttm(Date registPnttm) {
        this.registPnttm = registPnttm;
    }

    public List<String> getSearchDpstryNoList() {
        return searchDpstryNoList;
    }

    public void setSearchDpstryNoList(List<String> searchDpstryNoList) {
        this.searchDpstryNoList = searchDpstryNoList;
    }
}
