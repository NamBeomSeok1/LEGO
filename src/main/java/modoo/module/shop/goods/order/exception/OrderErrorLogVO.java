package modoo.module.shop.goods.order.exception;

import java.util.Date;


public class OrderErrorLogVO {

    private Integer orderErrorLogNo;

    private String orderNo;

    private String ordrrId;

    private String errorCode;

    private String errorMsg;

    private Date creatDt;

    public Integer getOrderErrorLogNo() {
        return orderErrorLogNo;
    }

    public void setOrderErrorLogNo(Integer orderErrorLogNo) {
        this.orderErrorLogNo = orderErrorLogNo;
    }

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public String getOrdrrId() {
        return ordrrId;
    }

    public void setOrdrrId(String ordrrId) {
        this.ordrrId = ordrrId;
    }

    public String getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(String errorCode) {
        this.errorCode = errorCode;
    }

    public String getErrorMsg() {
        return errorMsg;
    }

    public void setErrorMsg(String errorMsg) {
        this.errorMsg = errorMsg;
    }

    public Date getCreatDt() {
        return creatDt;
    }

    public void setCreatDt(Date creatDt) {
        this.creatDt = creatDt;
    }

    /* public OrderErrorLogVO(Builder builder) {
        this.orderNo = builder.orderNo;
        this.ordrrId = builder.ordrrId;
        this.errorCode = builder.errorCode;
        this.errorMsg = builder.errorMsg;
    }


    public static class Builder{

        private Integer orderErrorLogNo;

        private String orderNo;

        private String ordrrId;

        private String errorCode;

        private String errorMsg;

        public Builder setOrderNo(String orderNo){
            this.orderNo = orderNo;
            return this;
        }

        public Builder setOrdrrId(String ordrrId){
            this.ordrrId= ordrrId;
            return this;
        }

        public Builder setErrorCode(String errorCode){
            this.errorCode= errorCode;
            return this;
        }

        public Builder setErrorMsg(String errorMsg){
            this.errorMsg= errorMsg;
            return this;
        }

        public OrderErrorLogVO build(){
            return new OrderErrorLogVO(this);
        }
    }*/

    @Override
    public String toString() {
        return "OrderErrorLogVO{" +
                "orderErrorLogNo=" + orderErrorLogNo +
                ", orderNo='" + orderNo + '\'' +
                ", ordrrId='" + ordrrId + '\'' +
                ", errorCode='" + errorCode + '\'' +
                ", errorMsg='" + errorMsg + '\'' +
                ", creatDt=" + creatDt +
                '}';
    }
}
