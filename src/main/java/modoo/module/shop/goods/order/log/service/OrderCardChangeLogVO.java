package modoo.module.shop.goods.order.log.service;

import java.math.BigDecimal;

public class OrderCardChangeLogVO extends OrderLogVO{

    /**카드변경로그id*/
    private BigDecimal orderCardChangeLogId;
    /**변경전카드id*/
    private String prevCardId;
    /**변경후카드id*/
    private String changeCardId;

    public BigDecimal getOrderCardChangeLogId() {
        return orderCardChangeLogId;
    }

    public void setOrderCardChangeLogId(BigDecimal orderCardChangeLogId) {
        this.orderCardChangeLogId = orderCardChangeLogId;
    }

    public String getPrevCardId() {
        return prevCardId;
    }

    public void setPrevCardId(String prevCardId) {
        this.prevCardId = prevCardId;
    }

    public String getChangeCardId() {
        return changeCardId;
    }

    public void setChangeCardId(String changeCardId) {
        this.changeCardId = changeCardId;
    }
}
