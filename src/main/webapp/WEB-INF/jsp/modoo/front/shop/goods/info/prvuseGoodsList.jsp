<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/modoo/common/commonTagLibs.jsp"%>

<c:if test="${not empty prvuseGoodsList}">
		<div class="mn-tit-area">
				<h2 class="mn-tit"><em class="spot">${USER_NAME}</em>님의 전용 상품</h2>
		</div>


		<c:set var="col" value="col4"/>
			<ul class="custom-list ">
			<c:forEach var="result" items="${prvuseGoodsList }" varStatus="status">
				<li>
	                <a href="${CTX_ROOT }/shop/goods/goodsView.do?goodsId=${result.goodsId}">
	                    <div class="img-area">
	                        <img src="<c:out value="${result.goodsLrgeImagePath }"/>" alt="${result.goodsNm }" />
						</div>
							<div class="txt-area">
	                        <c:choose>
								<c:when test="${result.goodsKndCode eq 'SBS' }">
								<h3>[구독상품] <c:out value="${result.goodsNm }"/></h3>
								</c:when>
								<c:when test="${result.goodsKndCode eq 'GNR' }">
								<h3>[일반상품] <c:out value="${result.goodsNm }"/></h3>
								</c:when>
							</c:choose>
							<div class="price">
								<c:choose>
									<c:when test="${empty USER_ID && not empty result.mrktPc}">
										<strong><span><c:if test="${result.sbscrptCycleSeCode eq 'MONTH' }">월</c:if> <fmt:formatNumber type="number" pattern="#,###" value="${result.mrktPc}"/></span>원</strong>
									</c:when>
									<c:otherwise>
										<strong><span><c:if test="${result.sbscrptCycleSeCode eq 'MONTH' }">월</c:if> <fmt:formatNumber type="number" pattern="#,###" value="${result.goodsPc}"/></span>원</strong>
									</c:otherwise>
								</c:choose>
							</div>
	                    </div>
	                </a>
	            </li>
			</c:forEach>
        </ul>
	</c:if>