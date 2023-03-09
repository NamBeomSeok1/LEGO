package modoo.module.shop.goods.label.service;

import org.springframework.web.multipart.MultipartFile;

import java.io.File;

public class GoodsLabelVO {

    /**상품 고유 아이디*/
    private String goodsId;
    /**라벨 순서 */
    private Integer labelSn;
    /**라벨 내용*/
    private String labelCn;
    /**라벨 내용2*/
    private String labelCn2;
    /**메인라벨체크*/
    private String labelMainChk;
    /**라벨타입*/
    private String labelTy;
    /**라벨 컬러*/
    private String labelColor;
    /**라벨이미지경로*/
    private String labelImgPath;
    /**라벨이미지파일*/
    private MultipartFile labelImgFile;

    public String getGoodsId() {
        return goodsId;
    }

    public void setGoodsId(String goodsId) {
        this.goodsId = goodsId;
    }

    public Integer getLabelSn() {
        return labelSn;
    }

    public void setLabelSn(Integer labelSn) {
        this.labelSn = labelSn;
    }

    public String getLabelCn() {
        return labelCn;
    }

    public void setLabelCn(String labelCn) {
        this.labelCn = labelCn;
    }

    public String getLabelCn2() {
        return labelCn2;
    }

    public void setLabelCn2(String labelCn2) {
        this.labelCn2 = labelCn2;
    }

    public String getLabelMainChk() {
        return labelMainChk;
    }

    public void setLabelMainChk(String labelMainChk) {
        this.labelMainChk = labelMainChk;
    }

    public String getLabelTy() {
        return labelTy;
    }

    public void setLabelTy(String labelTy) {
        this.labelTy = labelTy;
    }

    public String getLabelImgPath() {
        return labelImgPath;
    }

    public void setLabelImgPath(String labelImgPath) {
        this.labelImgPath = labelImgPath;
    }

    public String getLabelColor() {
        return labelColor;
    }

    public void setLabelColor(String labelColor) {
        this.labelColor = labelColor;
    }

    public MultipartFile getLabelImgFile() {
        return labelImgFile;
    }

    public void setLabelImgFile(MultipartFile labelImgFile) {
        this.labelImgFile = labelImgFile;
    }

    @Override
    public String toString() {
        return "GoodsLabelVO{" +
                "goodsId='" + goodsId + '\'' +
                ", labelSn=" + labelSn +
                ", labelCn='" + labelCn + '\'' +
                ", labelCn2='" + labelCn2 + '\'' +
                ", labelMainChk='" + labelMainChk + '\'' +
                ", labelTy='" + labelTy + '\'' +
                ", labelColor='" + labelColor + '\'' +
                ", labelImgPath='" + labelImgPath + '\'' +
                ", labelImgFile=" + labelImgFile +
                '}';
    }
}
