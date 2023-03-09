<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/modoo/common/commonTagLibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>FOXEDU STORE</title>
</head>
<body>
<div class="wrap">
    <div class="sub-contents">
        <%-- 이니시스 일반 결제 폼 용 --%>
        <%--<c:choose>
            <c:when test="${pgResult eq 'result'}">
                <form id="sendOrderForm" name="sendOrderForm" method="post" enctype="multipart/form-data" action="${CTX_ROOT }/shop/goods/sendOrderSingle.json">
                &lt;%&ndash; 원본 &ndash;%&gt;
                &lt;%&ndash; <form id="sendOrderForm" name="sendOrderForm" method="post" enctype="multipart/form-data" action="${CTX_ROOT }/shop/goods/sendOrder.json"> &ndash;%&gt;
            </c:when>
            <c:otherwise>
                <form id="sendOrderPgForm" name="sendOrderPgForm" method="post" enctype="multipart/form-data" action="${CTX_ROOT }/embed/shop/goods/pgcall.do">
            </c:otherwise>
        </c:choose>--%>

        <%--임시 총가격--%>

        <form id="sendOrderForm" name="sendOrderForm" method="post" enctype="multipart/form-data"
              action="${CTX_ROOT }/shop/goods/sendOrder.json">
            <input type="hidden" id="dadresNo" name="dlvyInfo.dadresNo" value=""/>
            <%--<input type="hidden" id="chdrNm" name="chdr.chdrNm" value="" />--%>
            <input type="hidden" id="islandChk" name="islandChk" value="N"/>
            <input type="hidden" id="isCoupon" name="isCoupon" value="${isCoupon}"/>
            <input type="hidden" id="isVch" name="isVch" value="${isVch}"/>
            <input type="hidden" id="isChldrnnm" name="isChldrnnm" value="${isChldrnnm}"/>
            <input type="hidden" id="payMethod" name="payMethod" value="card"/>

            <div class="sticky-cont">
                <div class="cont-area">
                    <section>
                        <div class="sub-tit-area">
                            <h3 class="sub-tit">주문자 정보</h3>
                        </div>
                        <div class="write-type full">
                            <table>
                                <caption>주문자정보 입력</caption>
                                <colgroup>
                                    <col style="width:150px"/>
                                    <col/>
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th scope="row">주문자 이름</th>
                                    <td>
                                        <input type="text" name="ordName" class="p6" placeholder="예)집, 회사"
                                               value="${USER_NAME}"/>
                                        <span class="fs-sm fc-gr block">* 보내시는 분의 이름을 변경하여 주문가능합니다.</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">휴대전화</th>
                                    <td>
                                        <div class="phone inlin-block">
                                            <c:set var="telno" value="${fn:split(ordTelno,'-')}"/>
                                            <c:forEach var="item" items="${telno}" varStatus="status">
                                                <input type="number" name="ordTelno${status.index+1}" class="p0"
                                                       <c:if test="${status.index eq 0}">maxlength="3"</c:if>
                                                       maxlength="4" value="${item}"/>
                                            </c:forEach>
                                        </div>
                                        <span class="fs-sm fc-gr block">* 해당 번호로 주문정보가 발송됩니다.</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">이메일 주소</th>
                                    <td>
                                        <div class="email">
                                            <c:set var="email" value="${fn:split(ordEmail,'@')}"/>
                                            <c:forEach var="item" items="${email}" varStatus="status">
                                                <input type="text" name="ordEmail${status.index+1}" class="p2"
                                                       value="${item}"/>
                                                <c:if test="${status.index eq 0}">
                                                    <span>@</span>
                                                </c:if>
                                            </c:forEach>
                                            <!-- <select>
                                                <option value="0">직접입력</option>
                                                <option value="">naver.com</option>
                                            </select>
-->                                               </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                            <p class="fs-sm">* 주문자 정보로 결제관련 정보가 제공됩니다. 정확한 정보기입이 필요합니다. </p>
                        </div>
                    </section>

                    <c:if test="${isCoupon eq false}">
                        <section>
                            <div class="sub-tit-area">
                                <h3 class="sub-tit">배송정보</h3>
                            </div>
                            <div>
                                <div class="tabs-normal">
                                    <fieldset>
                                        <c:choose>
                                            <c:when test="${not empty dlvyList.bassDlvy}">
                                                <input type="hidden" id="dlvyNo" name="dlvyInfo.dadresNo"
                                                       value="${dlvyList.bassDlvy.dadresNo}"/>
                                                <input type="hidden" name="dlvyInfo.dlvyAdresNm"
                                                       value="${dlvyList.bassDlvy.dlvyAdresNm}"/>
                                                <input type="hidden" name="dlvyInfo.dlvyUserNm"
                                                       value="${dlvyList.bassDlvy.dlvyUserNm}"/>
                                                <c:set var="telno" value="${fn:split(dlvyList.bassDlvy.telno,'-')}"/>
                                                <c:forEach var="item" items="${telno}" varStatus="status">
                                                    <input type="hidden" name="dlvyInfo.telno${status.index+1}"
                                                           value="${item}"/>
                                                </c:forEach>
                                                <input type="hidden" name="dlvyInfo.dlvyZip"
                                                       value="${dlvyList.bassDlvy.dlvyZip }"/>
                                                <input type="hidden" name="dlvyInfo.dlvyAdres"
                                                       value="${dlvyList.bassDlvy.dlvyAdres }"/>
                                                <input type="hidden" name="dlvyInfo.dlvyAdresDetail"
                                                       value="${dlvyList.bassDlvy.dlvyAdresDetail }"/>
                                                <input type="hidden" name="dlvyInfo.bassDlvyAt"/>
                                            </c:when>
                                            <c:otherwise>
                                                <input type="hidden" id="dlvyNo" name="dlvyInfo.dadresNo"/>
                                                <input type="hidden" name="dlvyInfo.dlvyAdresNm"/>
                                                <input type="hidden" name="dlvyInfo.dlvyUserNm"/>
                                                <input type="hidden" name="dlvyInfo.telno1"/>
                                                <input type="hidden" name="dlvyInfo.telno2"/>
                                                <input type="hidden" name="dlvyInfo.telno3"/>
                                                <input type="hidden" name="dlvyInfo.dlvyZip"/>
                                                <input type="hidden" name="dlvyInfo.dlvyAdres"/>
                                                <input type="hidden" name="dlvyInfo.dlvyAdresDetail"/>
                                                <input type="hidden" name="dlvyInfo.bassDlvyAt"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </fieldset>
                                    <ul class="tabs-nav">
                                        <li class="is-active"><a href="#delivery1" class="deliveryTab">택배배송</a></li>
                                        <li class=" <c:if test="${isDpstryGoods eq 'false'}">is-disabled</c:if>"><a
                                                href="#delivery2" class="deliveryTab">센터픽업</a></li>
                                    </ul>
                                    <div id="delivery1" class="tabs-cont" style="display: block;">
                                        <div class="write-type border-none">
                                            <table>
                                                <caption>배송지 정보</caption>
                                                <colgroup>
                                                    <col style="width:150px">
                                                    <col>
                                                </colgroup>
                                                <tbody>
                                                <tr>
                                                    <th scope="row">배송지</th>
                                                    <td id="dlvyInfo-area">
                                                        <c:if test="${not empty dlvyList.bassDlvy}">
                                                            ${dlvyList.bassDlvy.dlvyUserNm}  (${dlvyList.bassDlvy.dlvyAdresNm})<br>
                                                            (${dlvyList.bassDlvy.dlvyZip}) ${dlvyList.bassDlvy.dlvyAdres} , ${dlvyList.bassDlvy.dlvyAdresDetail}
                                                            <br>
                                                            ${dlvyList.bassDlvy.telno}<br>
                                                        </c:if>
                                                        <button type="button" class="btn mt10" id="changeAddress"
                                                                onclick="initAddressPop();">배송지 변경
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th scope="row">배송메세지</th>
                                                    <td>
                                                        <select title="배송메세지 선택" class="dlvyMssage p10">
                                                            <option>배송 전에 미리 연락바랍니다.​</option>
                                                            <option>문 앞에 놔주세요.</option>
                                                            <option>부재시 전화나 문자 남겨주세요.</option>
                                                            <option value="0">요청사항을 직접 입력합니다.</option>
                                                        </select>
                                                        <textarea name="dlvyInfo.dlvyMssage" rows="3"
                                                                  style="display:none" ;
                                                                  value="배송 전에 미리 연락바랍니다."></textarea>
                                                    </td>
                                                </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <div id="delivery2" class="tabs-cont">
                                        <ul class="check-list">
                                            <c:if test="${isDpstryGoods eq 'true' and not empty cartList[0].dpstryList}">
                                                <c:forEach items="${cartList[0].dpstryList}" var="dpstry"
                                                           varStatus="status">
                                                    <li id="dpstryInfo${dpstry.dpstryNo}">
                                                        <input type="hidden" id="dpstryNm" value="${dpstry.dpstryNm}"/>
                                                        <input type="hidden" id="dpstryAdres"
                                                               value="${dpstry.dpstryAdres}"/>
                                                        <input type="hidden" id="dpstryZip"
                                                               value="${dpstry.dpstryZip}"/>
                                                        <c:set var="telno" value="${fn:split(dpstry.telno,'-')}"/>
                                                        <c:forEach var="item" items="${telno}" varStatus="status">
                                                            <input type="hidden" id="dpstryTelno${status.index+1}"
                                                                   value="${item}"/>
                                                        </c:forEach>
                                                        <label><input type="radio" name="r1" class="dpstry-select"
                                                                      data-sn="${dpstry.dpstryNo}"/></label>
                                                        <div class="txt-area">
                                                            <strong>${dpstry.dpstryNm}</strong>
                                                            <p>(${dpstry.dpstryZip}) ${dpstry.dpstryAdres}</p>
                                                        </div>
                                                    </li>
                                                </c:forEach>
                                            </c:if>
                                        </ul>
                                    </div>
                                </div>
                        </section>
                    </c:if>

                    <c:set var="tempTotalPrice" value="0"/>
                    <c:set var="itemIndex" value="0"/>
                    <c:set var="cartIndex" value="0"/>
                    <section>
                        <div class="sub-tit-area">
                            <h3 class="sub-tit">주문정보</h3>
                        </div>
                        <div class="table-type">
                            <div class="thead">
                                <cite>상품정보</cite>
                                <cite>주문정보</cite>
                                <cite class="col-w200">결제금액</cite>
                            </div>
                            <c:forEach var="cartGroup" items="${cartList }" varStatus="status">
                                <c:set var="tempSubPrice" value="0"/>
                                <div class="tbody">
                                    <input type="hidden" class="tempGoodsId" value="${cartGroup.goodsId}"/>
                                    <input type="hidden" class="tempDoptnType" value="${cartGroup.dOptnType}"/>
                                    <div class="al m-col-block">
                                        <div class="thumb-area lg">
                                            <figure><img src="${cartGroup.goodsTitleImagePath }"
                                                         alt="${cartGroup.goodsNm}"/></figure>
                                            <div class="txt-area">
                                                <cite class="goods-nm${status.count} goods-cartGroup"><c:out value="${cartGroup.goodsNm }"/></cite>
                                                <h2 class="tit"><c:out value="${cartGroup.goodsIntrcn }"/></h2>
                                                <div class="price">
                                                    <c:set var="exprnPc" value="0"/>
                                                    <c:if test="${cartGroup.exprnUseAt eq 'Y'}">
                                                        <c:set var="exprnPc" value="${cartGroup.exprnPc}"/>
                                                    </c:if>
                                                    <strong><span><fmt:formatNumber type="number" pattern="#,###" value="${cartGroup.goodsPc+exprnPc}"/></span>원</strong>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="al m-col-block">

                                        <c:if test="${not empty cartGroup.cartList }">
                                            <ul class="option-info-list">
                                                <c:forEach var="cart" items="${cartGroup.cartList}" varStatus="cartStatus">
                                                    <c:set var="tempDscntPc" value="0"/>
                                                    <li>
                                                        <input type="hidden"
                                                               name="orderList[${cartIndex }].dOptnType"
                                                               value="${cart.dOptnType }"/>
                                                        <input type="hidden"
                                                               name="orderList[${cartIndex }].cartNo"
                                                               value="${cart.cartNo }"/>
                                                        <input type="hidden"
                                                               name="orderList[${cartIndex }].goodsId"
                                                               value="${cart.goodsId }"/>
                                                        <input type="hidden"
                                                               name="orderList[${cartIndex }].goods.chldrnnmUseAt"
                                                               value="${cart.goods.chldrnnmUseAt}"/>
                                                        <c:set var="goodsKndCode" value="${cart.goodsKndCode }"/>
                                                        <c:if test="${cart.exprnUseAt ne 'Y' || empty cart.exprnUseAt}">
                                                            <input type="hidden"
                                                                   name="orderList[${cartIndex }].orderKndCode"
                                                                   value="${cart.goodsKndCode }"/>
                                                        </c:if>
                                                        <c:if test="${cart.exprnUseAt eq 'Y'}">
                                                            <input type="hidden"
                                                                   name="orderList[${cartIndex }].orderKndCode"
                                                                   value="GNR"/>
                                                        </c:if>
                                                        <input type="hidden"
                                                               name="orderList[${cartIndex }].sbscrptCycleSeCode"
                                                               value="${cart.sbscrptCycleSeCode }"/>
                                                        <input type="hidden"
                                                               name="orderList[${cartIndex }].sbscrptWeekCycle"
                                                               value="${cart.sbscrptWeekCycle }"/>
                                                        <input type="hidden"
                                                               name="orderList[${cartIndex }].sbscrptDlvyWd"
                                                               value="${cart.sbscrptDlvyWd }"/>
                                                        <input type="hidden"
                                                               name="orderList[${cartIndex }].sbscrptUseWeek"
                                                               value="${cart.sbscrptUseWeek}"/>
                                                        <input type="hidden"
                                                               name="orderList[${cartIndex }].sbscrptMtCycle"
                                                               value="${cart.sbscrptMtCycle }"/>
                                                        <input type="hidden"
                                                               name="orderList[${cartIndex }].sbscrptUseMt"
                                                               value="${cart.sbscrptUseMt }"/>
                                                        <input type="hidden"
                                                               name="orderList[${cartIndex }].sbscrptDlvyDay"
                                                               value="${cart.sbscrptDlvyDay }"/>
                                                        <input type="hidden"
                                                               name="orderList[${cartIndex }].orderCo"
                                                               value="${cart.orderCo }"/>
                                                        <input type="hidden"
                                                               name="orderList[${cartIndex }].exprnAmount"
                                                               value="${cart.goods.exprnPc}"/>
                                                        <input type="hidden"
                                                               name="orderList[${cartIndex }].exprnUseAt"
                                                               value="${cart.exprnUseAt}"/>
                                                        <input type="hidden"
                                                               name="orderList[${cartIndex }].compnoDscntUseAt"
                                                               value="${cart.compnoDscntUseAt}"/>
                                                        <input type="hidden" class="islandDlvyPc"
                                                               name="orderList[${cartIndex }].islandDlvyAmount"
                                                               value="${cartGroup.islandDlvyPc}"/>
                                                        <input type="hidden" class="jejuDlvyPc"
                                                               name="orderList[${cartIndex }].jejuDlvyAmount"
                                                               value="${cartGroup.jejuDlvyPc}"/>
                                                        <div class="txt-area">
                                                            <p>

                                                                <c:if test="${cart.goodsKndCode eq 'SBS'}">
                                                                    <c:if test="${empty cart.cartItemList}">
                                                                        <c:set var="tempSubPrice"
                                                                               value="${cart.goodsPc * cart.orderCo }"/>
                                                                    </c:if>
                                                                    <c:set var="tempSubPrice"
                                                                           value="${tempSubPrice + (cart.goodsPc * cartItem.gitemCo) }"/>
                                                                    <c:choose>
                                                                        <c:when test="${cart.sbscrptCycleSeCode eq 'WEEK' }">
                                                                            구독주기 : <c:out
                                                                                value="${cart.sbscrptWeekCycle }"/>주
                                                                        </c:when>
                                                                        <c:when test="${cart.sbscrptCycleSeCode eq 'MONTH' }">
                                                                            구독주기 :<c:out
                                                                                value="${cart.sbscrptMtCycle }"/>월
                                                                        </c:when>
                                                                        <c:otherwise> ERROR </c:otherwise>
                                                                    </c:choose>
                                                                    <c:choose>
                                                                        <c:when test="${cart.sbscrptCycleSeCode eq 'WEEK' }">
                                                                            정기결제일:
                                                                            <c:choose>
                                                                                <c:when test="${cart.sbscrptWeekCycle eq '1' }">일요일</c:when>
                                                                                <c:when test="${cart.sbscrptWeekCycle eq '2' }">월요일</c:when>
                                                                                <c:when test="${cart.sbscrptWeekCycle eq '3' }">화요일</c:when>
                                                                                <c:when test="${cart.sbscrptWeekCycle eq '4' }">수요일</c:when>
                                                                                <c:when test="${cart.sbscrptWeekCycle eq '5' }">목요일</c:when>
                                                                                <c:when test="${cart.sbscrptWeekCycle eq '6' }">금요일</c:when>
                                                                                <c:when test="${cart.sbscrptWeekCycle eq '7' }">토요일</c:when>
                                                                            </c:choose>
                                                                        </c:when>
                                                                        <c:when test="${cart.sbscrptCycleSeCode eq 'MONTH' }">
                                                                            <strong>정기결제일:</strong>
                                                                            <span> <c:out
                                                                                    value="${cart.sbscrptDlvyDay }"/> 일</span>
                                                                        </c:when>
                                                                        <c:otherwise>ERROR </c:otherwise>
                                                                    </c:choose>

                                                                </c:if>

                                                                <c:choose>
                                                                    <c:when test="${not empty cart.cartItemList}">
                                                                        <c:forEach items="${cart.cartItemList}" var="cartItem">
                                                                            <c:choose>
                                                                                <c:when test="${cartItem.gitemSeCode eq 'D'}">
                                                                                    <input type="hidden" class="tempGitemId" name="orderList[${cartIndex }].orderItemList[${itemIndex }].gitemId" value="${cartItem.gitemId }"/>
                                                                                    <input type="hidden" class="tempGitemSeCode" value="${cartItem.gitemSeCode }"/>
                                                                                    <input type="hidden" class="tempGitemCo" value="${cartItem.gitemCo }"/>
                                                                                    <br/>
                                                                                    기본옵션 : ${cartItem.gitemNm}
                                                                                    <c:choose>
                                                                                        <c:when test="${cart.dOptnType eq 'A'}">
                                                                                            <c:set var="tempSubPrice" value="${tempSubPrice + (cart.goodsPc * cartItem.gitemCo) }"/>
                                                                                            / ${cartItem.gitemCo}개 /
                                                                                            <strong>${cart.goodsPc * cartItem.gitemCo}원</strong>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <c:set var="tempSubPrice" value="${tempSubPrice + (cartItem.gitemPc * cartItem.gitemCo) }"/>
                                                                                            / ${cartItem.gitemCo}개 /
                                                                                            <strong>${cartItem.gitemCo * cartItem.gitemPc}원</strong>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                    <c:if test="${not empty cart.chldrnNm}">
                                                                                        <br/>
                                                                                        자녀 : ${cart.chldrnNm}
                                                                                    </c:if>
                                                                                    <c:set var="itemIndex"
                                                                                           value="${itemIndex + 1 }"/>
                                                                                </c:when>

                                                                                <c:when test="${cartItem.gitemSeCode eq 'Q'}">
                                                                                    <input type="hidden"
                                                                                           name="orderList[${cartIndex }].orderItemList[${itemIndex }].gitemAnswer"
                                                                                           value="${cartItem.gitemAnswer }"/>
                                                                                    <br/>
                                                                                    요청옵션 : ${cartItem.gitemAnswer}
                                                                                    <c:set var="itemIndex"
                                                                                           value="${itemIndex + 1 }"/>
                                                                                </c:when>

                                                                                <c:when test="${cartItem.gitemSeCode eq 'S'}">
                                                                                    <input type="hidden" class="tempGitemId" name="orderList[${cartIndex }].orderItemList[${itemIndex }].gitemId" value="${cartItem.gitemId }"/>
                                                                                    <input type="hidden" class="tempGitemCo" value="${cartItem.gitemCo }"/>
                                                                                    <input type="hidden" class="tempGitemSeCode" value="${cartItem.gitemSeCode }"/>

                                                                                    <br/>
                                                                                    추가상품 : ${cartItem.gitemNm} / ${cartItem.gitemCo}개 /
                                                                                    <strong>${cartItem.gitemCo * cartItem.gitemPc}원</strong>
                                                                                    <c:set var="tempSubPrice"
                                                                                           value="${tempSubPrice + (cartItem.gitemPc * cartItem.gitemCo) }"/>
                                                                                    <c:set var="itemIndex"
                                                                                           value="${itemIndex + 1 }"/>
                                                                                </c:when>

                                                                                <c:when test="${cartItem.gitemSeCode eq 'F'}"> <%--첫구독 --%>
                                                                                    <input type="hidden"
                                                                                           name="orderList[${cartIndex }].orderItemList[${itemIndex }].gitemId"
                                                                                           value="${cartItem.gitemId }"/>
                                                                                    <br/>
                                                                                    첫구독옵션 :${cartItem.gitemNm } /
                                                                                    <strong>${cart.goodsPc+cartItem.gitemPc}원</strong>
                                                                                    <c:set var="itemIndex"
                                                                                           value="${itemIndex + 1 }"/>
                                                                                </c:when>
                                                                            </c:choose>
                                                                            <c:if test="${cart.compnoDscntUseAt eq 'Y' and cartItem.gitemSeCode eq 'D' }">
                                                                                <br/>복수구매할인:
                                                                                <strong>${cart.compnoDscntPc*cartItem.gitemCo}원</strong>
                                                                                <c:set var="tempDscntPc" value="${tempDscntPc + (cart.compnoDscntPc*cartItem.gitemCo)}"/>
                                                                            </c:if>
                                                                        </c:forEach>
                                                                    </c:when>
                                                                    <c:when test="${cart.goodsKndCode eq 'GNR' and empty cart.cartItemList}">
                                                                        <c:set var="tempSubPrice" value="${tempSubPrice + (cart.goodsPc * cart.orderCo) }"/>
                                                                        <c:set var="tempDscntPc" value="${tempDscntPc + (cart.compnoDscntPc*cart.orderCo)}"/>
                                                                        수량 ${cart.orderCo}개 / <strong>${cart.goodsPc * cart.orderCo}원</strong>
                                                                    </c:when>
                                                                </c:choose>
                                                            </p>
                                                        </div>

                                                    </li>

                                                    <c:set var="cartIndex" value="${cartIndex + 1}"/>
                                                </c:forEach>
                                            </ul>
                                        </c:if>
                                    </div>

                                    <div class="col-w200 m-col-block">
                                        <div class="price">
                                            <strong><span><fmt:formatNumber type="number" pattern="#,###" value="${tempSubPrice + tempDscntPc}"/></span>원</strong>
                                            <c:choose>
                                                <c:when test="${(tempSubPrice + tempDscntPc) ge cartGroup.freeDlvyPc && cartGroup.freeDlvyPc ne '0'}">
                                                    <p class="fc-gr"><fmt:formatNumber type="number" pattern="#,###" value="${cartGroup.freeDlvyPc}"/>원
                                                        이상 주문 <br/> 배송비무료</p>
                                                </c:when>
                                                <c:when test="${cartGroup.dlvyPc gt '0'}">
                                                    <p class="fc-gr">배송비 (+<fmt:formatNumber type="number" pattern="#,###" value="${cartGroup.dlvyPc}"/>)</p>
                                                </c:when>
                                                <c:otherwise>
                                                </c:otherwise>
                                            </c:choose>
                                            <c:if test="${cartGroup.goodsKndCode eq 'SBS' && not empty cartGroup.sbscrptCycleSeCode}">
                                                (1회차)
                                                <p class="fc-gr fs-sm">다음 회차 정기 결제예정액 <strong>: <fmt:formatNumber type="number" pattern="#,###" value="${tempSubPrice}"/>원</strong></p>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                                <c:set var="tempTotalPrice" value="${tempTotalPrice + tempSubPrice + tempDscntPc}"/>
                            </c:forEach>
                        </div>
                    </section>


                    <section>
                        <c:set var="cartPc" value="0"/>
                        <c:set var="dlvyPc" value="0"/>
                        <c:set var="dscntPc" value="0"/>
                        <%-- 							<c:set var="dscntPc" value="0"/> --%>
                        <c:forEach var="cartGroup" items="${cartList }">
                            <c:set var="tempCartPc" value="0"/>
                            <c:set var="tempDlvyPc" value="0"/>
                            <c:set var="tempDscntPc" value="0"/>
                            <c:forEach var="cart" items="${cartGroup.cartList}" varStatus="cartStatus">

                                <c:choose>
                                    <c:when test="${not empty cart.cartItemList}">
                                        <c:forEach var="cartItem" items="${cart.cartItemList}" varStatus="cartStatus">
                                            <c:choose>
                                                <c:when test="${cartGroup.exprnUseAt eq 'Y'}">
                                                    <c:choose>
                                                        <c:when test="${cartItem.gitemSeCode eq 'D' and cartGroup.dOptnType eq 'A' }">
                                                            <c:set var="tempCartPc" value="${tempCartPc + ((cartGroup.goodsPc+cartGroup.exprnPc) * cartItem.gitemCo)}"/>
                                                        </c:when>
                                                        <c:when test="${cartItem.gitemSeCode eq 'D' and cartGroup.dOptnType eq 'B' }">
                                                            <c:set var="tempCartPc" value="${tempCartPc +  ((cartGroup.exprnPc+cartItem.gitemPc) * cartItem.gitemCo)}"/>
                                                        </c:when>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:choose>
                                                        <c:when test="${cartItem.gitemSeCode eq 'D' and cartGroup.dOptnType eq 'A' }">
                                                            <c:set var="tempCartPc" value="${tempCartPc + (cartGroup.goodsPc * cartItem.gitemCo)}"/>
                                                        </c:when>
                                                        <c:when test="${cartItem.gitemSeCode eq 'D' and cartGroup.dOptnType eq 'B' }">
                                                            <c:set var="tempCartPc" value="${tempCartPc +(cartItem.gitemPc * cartItem.gitemCo)}"/>
                                                        </c:when>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>

                                            <c:if test="${cartGroup.compnoDscntUseAt eq 'Y' }">
                                                <c:choose>
                                                    <c:when test="${cartItem.gitemSeCode eq 'D' and cartGroup.dOptnType eq 'A' }">
                                                        <c:set var="tempDscntPc" value="${tempDscntPc + (cartGroup.compnoDscntPc * cart.goodsCo)}"/>
                                                    </c:when>
                                                    <c:when test="${cartItem.gitemSeCode eq 'D' and cartGroup.dOptnType eq 'B' }">
                                                        <c:set var="tempDscntPc" value="${tempDscntPc + (cartGroup.compnoDscntPc * cartItem.goodsCo)}"/>
                                                    </c:when>
                                                </c:choose>
                                            </c:if>


                                            <c:choose>
                                                <c:when test="${cartItem.gitemSeCode eq 'F' and cartItem.goodsPc > 0}">
                                                    <c:set var="tempCartPc" value="${tempCartPc + cartItem.goodsPc}"/>
                                                </c:when>
                                                <c:when test="${cartItem.gitemSeCode eq 'F' and cartItem.goodsPc < 0}">
                                                    <c:set var="tempDscntPc" value="${tempDscntPc + cartItem.goodsPc}"/>
                                                </c:when>
                                            </c:choose>

                                            <c:if test="${cartItem.gitemSeCode eq 'S' }">
                                                <c:set var="tempCartPc" value="${tempCartPc + (cartItem.gitemPc * cartItem.gitemCo)}"/>
                                            </c:if>
                                        </c:forEach>
                                    </c:when>

                                    <c:when test="${cart.goodsKndCode eq 'GNR' and empty cart.cartItemList}">
                                        <c:set var="tempCartPc" value="${tempCartPc + (cartGroup.goodsPc * cart.orderCo) }"/>
                                    </c:when>

                                    <c:otherwise>
                                        <c:set var="tempCartPc" value="${tempCartPc + (cartGroup.goodsPc * cart.orderCo)}"/>
                                        <c:set var="tempDscntPc" value="0"/>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            <c:set var="cartPc" value="${cartPc + tempCartPc}"/>
                            <c:set var="dscntPc" value="${dscntPc + tempDscntPc}"/>
                            <%--TODO : 배송비용 계산 정책에 따라 계산해야 함 --%>
                            <c:choose>
                                <c:when test="${not empty cart.freeDlvyPc}">
                                    <c:choose>
                                        <c:when test="${cartPc+dscntPc ge cartGroup.freeDlvyPc && cartGroup.freeDlvyPc gt 0}">
                                            <c:set var="dlvyPc" value="${dlvyPc + 0}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="dlvyPc" value="${dlvyPc + cartGroup.dlvyPc }"/>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="dlvyPc" value="${dlvyPc + cartGroup.dlvyPc}"/>
                                </c:otherwise>
                            </c:choose>

                        </c:forEach>


                        <c:set var="totAmount" value="${dlvyPc+cartPc}"/> <%-- 포인트 할인 계산 해야함 --%>

                        <div class="sub-tit-area">
                            <h3 class="sub-tit">결제수단</h3>
                            <div class="fnc-area">
                                <!-- <button type="button" class="btn-gr">카드사 혜택보기</button> -->
                                <a href="#none" id="cardWrite" class="btn-gr">카드 등록</a>
                            </div>
                        </div>
                        <div class="write-type full">
                            <table>
                                <caption>복지 포인트 선결제</caption>
                                <colgroup>
                                    <col style="width:200px"/>
                                    <col/>
                                </colgroup>
                                <tbody>
                                <%--<c:if test="${!empty ezwelPoint}">
                                    <tr>
                                        <th scope="row">복지 포인트 결제</th>
                                        <td>
                                            <div class="input-st-area">
                                                <c:choose>
                                                    <c:when test="${ezwelPoint ge totAmount}">
                                                    <div class="input-st ar"><strong class="price pointPayPc" >${totAmount}</strong>원</div>
                                                        <c:set var="leftPoint" value="${ezwelPoint-totAmount}"/>
                                                        <span id="leftPoint" data-leftpoint="${leftPoint}">잔여 포인트 <em><fmt:formatNumber type="number" pattern="#,###" value="${leftPoint}"/></em>원</span>
                                                    </c:when>
                                                    <c:when test="${ezwelPoint lt totAmount}">
                                                        <c:set var="leftPoint" value="${totAmount-ezwelPoint}"/>
                                                        <c:if test="${ezwelPoint eq 0 }">
                                                            <c:set var="leftPoint" value="0"/>
                                                        </c:if>
                                                        <div class="input-st ar"><strong class="price pointPayPc">${ezwelPoint}</strong>원</div>
                                                        <span id="leftPoint" data-leftpoint="${leftPoint}">잔여 포인트 <em><c:if test="${ezwelPoint-totAmount lt 0}">0</c:if><c:if test="${ezwelPoint-totAmount gt 0}">${ezwelPoint}</c:if></em>원</span>
                                                    </c:when>
                                                </c:choose>
                                            </div>
                                            <label><input type="checkbox" name="pointUseAt"  checked="checked"/>복지 포인트 선결제</label>
                                            <p class="msg">
                                            ※ 복지 포인트 선결제 선택 시, 보유포인트 한도내에서 우선 차감 결제되며, <strong>임의 금액으로 포인트 결제는 불가합니다.</strong><br class="m-none" />
                                            ※ 복지 포인트 부족시 '잔여포인트+등록카드’로 복합결제가 진행되며  정기 결제일에 맞추어 동일한 방식으로 정기결제가 이루어 집니다.<br class="m-none" />
                                            ※ 복지 적립금 등 기타 포인트로는 결제가 불가합니다.
                                            </p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">카드 결제금액</th>
                                        <td>
                                        <c:choose>
                                            <c:when test="${ezwelPoint ge totAmount}">
                                                <div class="input-st ar"><strong class="price cardPayPc">0</strong> 원</div>
                                            </c:when>
                                            <c:when test="${ezwelPoint lt totAmount}">
                                                <c:set var="leftPoint" value="${totAmount-ezwelPoint+dscntPc}"/>
                                                <div class="input-st ar"><strong class="price cardPayPc" ><fmt:formatNumber type="number" pattern="#,###" value="${leftPoint}"/></strong> 원</div>
                                            </c:when>
                                        </c:choose>
                                        </td>
                                    </tr>
                                </c:if>--%>
                                <c:if test="${empty ezwelPoint}">
                                    <tr>
                                        <th scope="row">카드 결제금액</th>
                                        <td>
                                            <div class="input-st ar"><strong class="price cardPayPc"><fmt:formatNumber type="number" pattern="#,###"  value="${totAmount+dscntPc}"/></strong> 원
                                            </div>
                                        </td>
                                    </tr>
                                </c:if>
                                <%-- 이니시스 승인 받을 동안 사용 --%>
                                <tr>
                                    <th scope="row">결제방법</th>
                                    <td class="cardPayArea">
                                        <div class="border-box">
                                            <c:set var="cardDisplay" value=""/>
                                            <c:if test="${orderKnd eq 'SBS'}">
                                                <c:set var="cardDisplay" value=""/>
                                            </c:if>
                                            <label><input type="radio" name="payment" id="cardBill" value="cardBill"
                                                          class="payment" checked="checked"/>정기결제 기본카드</label>
                                            <div class="payment-area payment-swiper" id="payment1"
                                                 style="${cardDisplay}">
                                                <select id="payCard" name="creditCard.cardId" title="카드선택" class="p6">
                                                    <!--<option>카드를 선택해주세요.</option>-->
                                                    <c:if test="${!empty bassUseCard}">
                                                        <option value="${bassUseCard.cardId}">${bassUseCard.cardNm}(${bassUseCard.lastCardNo})</option>
                                                    </c:if>
                                                    <c:if test="${empty bassUseCard && empty cardList}">
                                                        <option value="0">기본설정된 카드가 없습니다. 카드를 등록해주세요.</option>
                                                    </c:if>
                                                    <c:forEach var="card" items="${cardList}">
                                                        <option value="${card.cardId}">${card.cardNm}(${card.lastCardNo})</option>
                                                    </c:forEach>
                                                </select>
                                                <p class="msg">(카드 등록 및 변경은 카드 등록/관리에서 가능합니다.)</p>
                                            </div>
                                        </div>
                                        <c:if test="${orderKnd eq 'GNR'}">
                                            <%--<select id="payCard" name="creditCard.cardId" title="카드선택" class="p3">
                                                <option>신용카드</option>
                                            </select>--%>
                                            <div class="border-box">
                                                <label><input type="radio" name="payment" id="cardPayment"
                                                              class="payment" value="cardPayment"/>일반결제</label>
                                                <div class="payment-area" id="payment2" style="display: none;">
                                                    <input type="hidden" name="goPayMethod" value=""/>
                                                    <fieldset class="radio-type">
                                                        <legend>결제수단 선택</legend>
                                                        <label><input type="radio" class="goPayMethod"
                                                                      name="selPayMethod" value="Card"/>신용카드</label>
                                                        <label><input type="radio" class="goPayMethod"
                                                                      name="selPayMethod"
                                                                      value="DirectBank"/>실시간계좌이체</label>
                                                            <%-- 휴대폰 결제 붙으면
                                                            <c:if test="${fn:length(cartList) eq 1}">
                                                                <label><input type="radio" class="goPayMethod" name="selPayMethod" value="HPP"/>휴대폰결제</label>
                                                            </c:if>
                                                            --%>
                                                        <!-- <label><input type="radio" name="goPayMethod" value="3"/>가상계좌발급</label> -->
                                                            <%--<label><input type="radio" class="goPayMethod" name="selPayMethod" value="HPP"/>휴대폰결제</label>--%>
                                                        <!--<label><input type="radio" name="goPayMethod" value="Culture"/>문화상품권</label>
                                                        <label><input type="radio" name="goPayMethod" value="DGCL"/>스마트문상</label>
                                                        <label><input type="radio" name="goPayMethod" value="Bcsh"/>도서문화상품권</label>
                                                        <label><input type="radio" name="goPayMethod" value="HPMN"/>해피머니상품권</label> -->
                                                        <!-- <label><input type="radio" name="goPayMethod" value="4"/>휴대폰결제</label> -->
                                                    </fieldset>
                                                </div>
                                                <div class="payment-area" id="payment3" style="display: none;">
                                                    <fieldset class="radio-type">
                                                        <legend>결제수단 선택</legend>
                                                        <label><input type="radio" class="goPayMethod"
                                                                      name="selPayMethod" value="CARD"/>신용카드</label>
                                                            <%--<label><input type="radio" class="goPayMethod" name="selPayMethod" value="BANK"/>실시간계좌이체</label>--%>
                                                            <%-- 휴대폰 결제 붙으면
                                                            <c:if test="${fn:length(cartList) eq 1}">
                                                                <label><input type="radio" class="goPayMethod" name="selPayMethod" value="MOBILE"/>휴대폰결제</label>
                                                            </c:if>
                                                            --%>
                                                        <!-- <label><input type="radio" name="goPayMethod" value="VBANK"/>가상계좌발급</label> -->
                                                            <%--<label><input type="radio"  class="goPayMethod" name="selPayMethod" value="MOBILE"/>휴대폰결제</label>--%>
                                                        <!--<label><input type="radio" name="goPayMethod" value="https://mobile.inicis.com/smart/culture/"/>문화상품권</label>
                                                        <label><input type="radio" name="goPayMethod" value="https://mobile.inicis.com/smart/dgcl/"/>스마트문상</label>
                                                        <label><input type="radio" name="goPayMethod" value="https://mobile.inicis.com/smart/hpmn/"/>해피머니상품권</label> -->
                                                        <!-- <label><input type="radio" name="goPayMethod" value="4"/>휴대폰결제</label> -->
                                                    </fieldset>
                                                </div>
                                            </div>
                                        </c:if>
                                    </td>
                                </tr>

                                </tbody>
                            </table>
                        </div>
                    </section>
                </div>
                <div class="sticky-area total-buy-area">
                    <div class="sticky-toggle-area">
                        <div class="sticky-header">총 결제금액</div>
                        <div class="sticky-body">
                            <ul class="price-info-list">
                                <li>
                                    <cite>상품금액</cite>
                                    <div><fmt:formatNumber type="number" pattern="#,###" value="${cartPc}"/>원</div>
                                </li>
                                <c:if test="${dscntPc ne '0'}">
                                    <li>
                                        <cite>할인금액</cite>
                                        <div><fmt:formatNumber type="number" pattern="#,###" value="${-dscntPc}"/>원
                                        </div>
                                    </li>
                                </c:if>
                                <c:if test="${!empty ezwelPoint }">
                                    <li>
                                        <cite>카드 결제 금액</cite>
                                        <c:choose>
                                            <c:when test="${ezwelPoint ge totAmount}">
                                                <div><span class="price cardPayPc">0</span>원</div>
                                            </c:when>
                                            <c:when test="${ezwelPoint lt totAmount}">
                                                <div><span class="price cardPayPc"><fmt:formatNumber type="number" pattern="#,###" value="${totAmount-ezwelPoint}"/></span>원
                                                </div>
                                            </c:when>
                                        </c:choose>
                                    </li>
                                    <li>
                                        <cite>복지 포인트사용</cite>
                                        <c:choose>
                                            <c:when test="${ezwelPoint ge totAmount}">
                                                <div><span class="point pointPayPc" id="leftPoint"><fmt:formatNumber
                                                        type="number" pattern="#,###"
                                                        value="${totAmount+dscntPc}"/></span>원
                                                </div>
                                            </c:when>
                                            <c:when test="${ezwelPoint lt totAmount}">
                                                <div><span class="point pointPayPc" id="leftPoint"><fmt:formatNumber
                                                        type="number" pattern="#,###"
                                                        value="${ezwelPoint+dscntPc}"/></span>원
                                                </div>
                                            </c:when>
                                        </c:choose>
                                    </li>
                                </c:if>
                                <c:if test="${goodsKndCode ne 'CPN' || isCoupon == false}">
                                    <li>
                                        <cite>배송비</cite>
                                        <div>
                                            <c:choose>
                                                <c:when test="${dlvyPc eq 0}">
                                                    <span class="dlvyAmount">무료</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="dlvyAmount"><fmt:formatNumber type="number"
                                                                                               pattern="#,###"
                                                                                               value="${dlvyPc}"/></span>원
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </li>
                                </c:if>
                            </ul>
                            <div class="total-area">
                                <cite>총 <em>${fn:length(cartList) }</em>건</cite>
                                <div class="price">
                                    <strong><span class="totAmount" data-totpc="${totAmount+dscntPc}"><fmt:formatNumber
                                            type="number" pattern="#,###" value="${totAmount+dscntPc}"/></span>
                                        원</strong>
                                </div>
                            </div>
                            <div class="agree-area">
                                <ul class="bullet-none">
                                    <li>
                                        <label><input type="checkbox" name="indvdlinfoAgreAt" value="Y"/> 개인정보 제 3자 제공
                                            동의</label>
                                        <button type="button" onclick="popOpen('termsThird')" class="fc-gr fs-sm">보기 <i
                                                class="ico-arr-r sm back gr"></i></button>
                                    </li>
                                    <li>
                                        <label><input type="checkbox" name="purchsCndAgreAt" value="Y"/> 구매조건 확인 및 결제대행
                                            서비스 약관 동의</label>
                                        <button type="button" onclick="popOpen('termsCard')" class="fc-gr fs-sm">보기 <i
                                                class="ico-arr-r sm back gr"></i></button>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="btn-table-area">
                        <!-- <a href="#none" class="btn-lg spot">주문하기</a> -->
                        <button type="submit" class="btn-lg spot">주문하기</button>
                    </div>
                </div>
            </div>
        </form>
        <%--------------------------- form end --%>
    </div>
</div>


<%--<!-- 배송지api  -->
 <div class="popup" data-popup="adress">
		<div class="pop-header">
			<h1>주소 찾기</h1>
			<button type="button" class="btn-pop-close" data-popup-close="adress">닫기</button>
		</div>
		<div class="pop-body">
			<form name="form" id="form" method="post">
			<input type="hidden" name="currentPage" value="1"/>
			<input type="hidden" name="countPerPage" value="5"/>
			<input type="hidden" name="resultType" value="json"/>
			<input type="hidden" name="confmKey" value="U01TX0FVVEgyMDIxMDExNDEwMTM1MDExMDY4ODQ="/>
			<div class="sch-area lg">
				<input type="text" name="keyword" value="" onkeydown="enterSearch(this);" placeholder="주소를 입력해주세요." />
				<button type="submit" class="btn-sch"></button>
			</div>
			<p style="display:none;" id="addTotalCnt" class="mb10">총 <em></em>건</p>
			<p style="display:none;" id="message" class="mb10">주소를 상세히 입력해 주시기 바랍니다.</p>
			<p  class="mb10">검색어 예 : 도로명(반포대로 58), 건물명(독립기념관), 지번(삼성동 25)</p>
			<ul class="border-list">
			</ul>
			<ul class="paging">
			</ul>
		</div>
	</div>--%>
<!--카드 팝업 -->
<!-- 카드 등록폼 -->
<div class="popup" data-popup="cardWrite">
    <div class="pop-header">
        <h1>카드정보</h1>
        <button type="button" class="btn-pop-close" data-popup-close="cardWrite">닫기</button>
    </div>
    <div class="pop-body">
        <form id="cardForm" name="cardForm" method="post" action="/card/cardReg.json">
            <dl class="write-area">
                <dt>카드번호</dt>
                <dd>
                    <div class="card-num-area focus-auto border-input-area">
                        <input type="number" class="cardNo" name="cardNo1" maxlength="4" autocomplete="one-time-code"
                               placeholder="0000" title="카드번호 첫번째 입력"/>
                        <input type="number" class="cardNo" name="cardNo2" maxlength="4" autocomplete="one-time-code"
                               placeholder="0000" title="카드번호 두번째 입력"/>
                        <input type="password" class="cardNo" name="cardNo3" class="pw" maxlength="4" placeholder="0000"
                               autocomplete="new-password" title="카드번호 세번째 입력"/>
                        <input type="password" class="cardNo" name="cardNo4" class="pw" maxlength="4" placeholder="0000"
                               autocomplete="new-password" title="카드번호 네번째 입력"/>
                    </div>
                </dd>
                <dd class="table-area">
                    <div>
                        <cite class="write-tit">유효기간</cite>
                        <div class="focus-auto border-input-area">
                            <input type="password" name="cardUsgpd1" autocomplete="new-password" class="pw ac cardUsgpd"
                                   maxlength="2" placeholder="MM" title="월입력(MM)"/>
                            /
                            <input type="password" name="cardUsgpd2" autocomplete="new-password" class="pw ac cardUsgpd"
                                   maxlength="2" placeholder="YY" title="연입력(YY)"/>
                        </div>
                    </div>
                    <div>
                        <cite class="write-tit">카드비밀번호</cite>
                        <input type="password" name="cardPassword" autocomplete="new-password" class="pw p10 al"
                               maxlength="2" placeholder="비밀번호 앞 2자리 숫자" title="비밀번호 앞 2자리 숫자"/>
                    </div>
                </dd>
                <%--<dt class="txt-hide">간편비밀번호</dt>
                <dd class="table-area">
                    <div>
                        <cite class="write-tit">간편비밀번호</cite>
                        <input type="password" id="password1" class="p10" autocomplete="new-password" placeholder="6자리" maxlength="6" />
                    </div>
                    <div>
                        <cite class="write-tit">간편비밀번호 확인</cite>
                        <input type="password" id="password2" name="password" class="p10" autocomplete="new-password" placeholder="6자리" maxlength="6" />
                    </div>
                </dd>--%>
                <dt>카드구분</dt>
                <dd>
                    <label><input type="radio" checked="checked" name="kind" data-kind="first"/>개인카드</label>
                    <label><input type="radio" name="kind" data-kind="second"/>법인카드</label>
                </dd>
                <dt id="brthdy">생년월일</dt>
                <dd>
                    <input type="number" name="brthdy" maxlength="6" class="p10 al" placeholder="6자리 입력"
                           title="6자리 입력"/>
                </dd>
                <dt style="display:none;" id="bizrno">사업자등록번호</dt>
                <dd style="display:none;">
                </dd>
                <dt>카드이름</dt>
                <dd>
                    <input type="text" name="cardNm" class="p10 al" placeholder="카드 이름" title="카드 이름"/>
                </dd>
            </dl>
            <div class="agree-area">
                <label><input type="checkbox" name="bassUseAt"/>기본 카드로 설정</label>
            </div>

            <div class="agree-area">
                <p class="msg"><a href="#none" onclick="popOpen2('cardList')" class="fc-gr fs-sm">등록 가능한 카드사 보기<i
                        class="ico-arr-r sm back gr "></i></a></p>
            </div>
            <div class="agree-all-area">
                <label><input type="checkbox" id="allStplat" value="Y"/><strong>전체 약관 동의</strong></label>
                <ul class="bg-box bullet-none">
                    <li>
                        <label><input type="checkbox" class="stplat" id="indvdlStplat"/>FOXEDU STORE 개인(신용)정보 수집 및 이용 동의</label>
                        <a href="#none" onclick="popOpen2('termsPrivacy')" class="fc-gr fs-sm">보기 <i
                                class="ico-arr-r sm back gr "></i></a>
                    </li>
                    <li>
                        <label><input type="checkbox" class="stplat" id="cardStplat"/>FOXEDU STORE · 카드사 간 개인(신용)정보 제공
                            동의</label>
                        <a href="#none" onclick="popOpen2('termsCard')" class="fc-gr fs-sm">보기 <i
                                class="ico-arr-r sm back gr "></i></a>
                    </li>
                </ul>
            </div>
            <div class="btn-table-area">
                <button type="button" onclick="cardSubmit();" id="cardReg" class="btn-lg spot width">완료</button>
            </div>
        </form>
    </div>
</div>
<!--비밀번호 확인-->
<div class="popup" data-popup="passwordChk">
    <div class="pop-header">
        <h1>간편 비밀번호</h1>
        <button type="button" class="btn-pop-close" data-popup-close="passwordChk">닫기</button>
    </div>
    <div class="pop-body">
        <input type="hidden" name="cardId" id="cardId" value=""/>
        <dl class="write-area">
            <dt>비밀번호</dt>
            <p class="msg">결제할 카드의 간편 비밀번호 숫자 6자리를 입력해주세요.</p>
            <dd>
                <input id="passwordChk" type="password" class="p10" maxlength="6"/>
            </dd>
        </dl>
        <div class="btn-table-area">
            <button type="button" class="btn-lg spot" id="passwordChkBtn" data-popup-close="passwordChk">확인</button>
        </div>
    </div>
</div>

<!--등록 가능한 카드사-->
<div class="popup" data-popup="cardList">
    <div class="pop-header">
        <h1>등록 가능한 카드사</h1>
        <button type="button" class="btn-pop-close" data-popup-close="cardList">닫기</button>
    </div>
    <div class="pop-body">
        <ul class="card-list">
            <li><img src="${CTX_ROOT }/resources/front/site/${SITE_ID }/image/sub/card_logo_samsung.jpg"/></li>
            <c:if test="${!fn:contains(USER_ID,'100')}">
                <li><img src="${CTX_ROOT }/resources/front/site/${SITE_ID }/image/sub/card_logo_shinhan.jpg"/></li>
            </c:if>
            <li><img src="${CTX_ROOT }/resources/front/site/${SITE_ID }/image/sub/card_logo_hyundai.jpg"/></li>
            <li><img src="${CTX_ROOT }/resources/front/site/${SITE_ID }/image/sub/card_logo_bc.jpg"/></li>
            <li><img src="${CTX_ROOT }/resources/front/site/${SITE_ID }/image/sub/card_logo_kb.jpg"/></li>
            <li><img src="${CTX_ROOT }/resources/front/site/${SITE_ID }/image/sub/card_logo_hana.jpg"/></li>
            <li><img src="${CTX_ROOT }/resources/front/site/${SITE_ID }/image/sub/card_logo_nh.jpg"/></li>
            <li><img src="${CTX_ROOT }/resources/front/site/${SITE_ID }/image/sub/card_logo_lotte.jpg"/></li>
            <%-- <li><img src="${CTX_ROOT }/resources/front/site/${SITE_ID }/image/sub/card_logo_citi.jpg" /></li> --%>
            <li><img src="${CTX_ROOT }/resources/front/site/${SITE_ID }/image/sub/card_logo_kakao.jpg"/></li>
        </ul>
    </div>
</div>

<template>
    <c:import url="/embed/termsPopup.do" charEncoding="utf-8">
    </c:import>
    <c:import url="/user/my/deliveryEdit.do" charEncoding="utf-8">
        <c:param name="menuId" value="myInfo"/>
    </c:import>
</template>

<javascript>
    <script src="<%=egovframework.com.cmm.service.Globals.INICIS_JS %>"></script>
    <script src="${CTX_ROOT }/resources/front/shop/goods/info/js/goodsOrder.js?v=5"></script>
    <script src="${CTX_ROOT }/resources/front/shop/goods/info/js/goodsOrderDlvy.js?v=1"></script>

    <!-- 이니시스 표준결제 js -->
    <!-- 가맹점 URL이 http일 경우 http처리, 실제 오픈시 가맹점 MID로 stdpay로 처리 -->
    <%--<c:if test="${pgResult eq 'result'}">
        <script>
            $(document).ready(function(){
                $("#sendOrderForm").submit();
            });
        </script>
    </c:if>--%>
    <c:if test="${not empty resultMsg}">
        <script>
            modooAlert('${resultMsg}', '결제오류');
        </script>
    </c:if>
</javascript>
</body>
</html>