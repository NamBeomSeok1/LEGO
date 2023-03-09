package modoo.module.sale.service.impl;

public class SaleVO {
	/** 노출순서 **/
	private java.math.BigDecimal expsrOrdr;
	/** 상품코드 **/
	private String goodsId;
	/** 제휴사코드 **/
	private String prtnrId;
	/** 상태 **/
	private String actvtyAt;
	/** 타입(특가 : SALE, 신상품 : NEW) **/
	private String typeCode;
	/** 라벨유형코드 **/
	private String labelTyCode;
	/** 라벨문구 **/
	private String labelText;
	/** 라벨색상 **/
	private String labelColor;
	/** 라벨글자색상 **/
	private String labelTextColor;
	/** 노출시작일 **/
	private java.util.Date expsrBeginDe;
	/** 노출종료일 **/
	private java.util.Date expsrEndDe;
	/**검색 : 상품노출유형*/
	private String searchGoodsExpsrCode;

	public String getSearchGoodsExpsrCode() {
		return searchGoodsExpsrCode;
	}

	public void setSearchGoodsExpsrCode(String searchGoodsExpsrCode) {
		this.searchGoodsExpsrCode = searchGoodsExpsrCode;
	}

	public java.math.BigDecimal getExpsrOrdr() {
		return expsrOrdr;
	}
	public void setExpsrOrdr(java.math.BigDecimal expsrOrdr) {
		this.expsrOrdr = expsrOrdr;
	}
	public String getGoodsId() {
		return goodsId;
	}
	public void setGoodsId(String goodsId) {
		this.goodsId = goodsId;
	}
	public String getPrtnrId() {
		return prtnrId;
	}
	public void setPrtnrId(String prtnrId) {
		this.prtnrId = prtnrId;
	}
	public String getActvtyAt() {
		return actvtyAt;
	}

	public String getTypeCode() {
		return typeCode;
	}

	public void setTypeCode(String typeCode) {
		this.typeCode = typeCode;
	}

	public void setActvtyAt(String actvtyAt) {
		this.actvtyAt = actvtyAt;
	}
	public String getLabelTyCode() {
		return labelTyCode;
	}
	public void setLabelTyCode(String labelTyCode) {
		this.labelTyCode = labelTyCode;
	}
	public String getLabelText() {
		return labelText;
	}
	public void setLabelText(String labelText) {
		this.labelText = labelText;
	}
	public String getLabelColor() {
		return labelColor;
	}
	public void setLabelColor(String labelColor) {
		this.labelColor = labelColor;
	}
	public String getLabelTextColor() {
		return labelTextColor;
	}
	public void setLabelTextColor(String labelTextColor) {
		this.labelTextColor = labelTextColor;
	}
	public java.util.Date getExpsrBeginDe() {
		return expsrBeginDe;
	}
	public void setExpsrBeginDe(java.util.Date expsrBeginDe) {
		this.expsrBeginDe = expsrBeginDe;
	}
	public java.util.Date getExpsrEndDe() {
		return expsrEndDe;
	}
	public void setExpsrEndDe(java.util.Date expsrEndDe) {
		this.expsrEndDe = expsrEndDe;
	}

}
