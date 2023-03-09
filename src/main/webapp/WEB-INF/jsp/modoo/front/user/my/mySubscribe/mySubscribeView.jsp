<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/modoo/common/commonTagLibs.jsp"%>
<c:set var="title" value="상세보기"/>
<c:set var= "totalAmount" value="0"/>
<title>${title}</title>

	<div class="wrap">
		<input type="hidden" name="siteId" value="${SITE_ID}">
			<c:import url="/user/my/subMenu.do" charEncoding="utf-8">
			</c:import>
			<div class="sub-contents">
					<c:import url="/user/my/myLocation.do" charEncoding="utf-8">
						<c:param name="menuId" value="sbs"/>
					</c:import>
				<c:set var="orderInfo" value="${orderGroupOrderList[0]}"/>
				<h2 class="sub-tit">주문 상세보기</h2>
				<section>
					<div class="sub-tit-area">
						<p>주문번호 : <em>${orderGroupOrderList[0].orderGroupNo}</em></p>
						<p>주문날짜 : <em>${orderGroupOrderList[0].orderPnttm}</em></p>
					</div>
					<div class="table-type">
						<div class="thead">
							<cite>상품정보</cite>
							<cite>주문정보</cite>
							<%--<cite>상품금액</cite>--%>
						</div>
						<c:forEach var="order"  items="${orderGroupOrderList}" varStatus="status">
								<div class="tbody">
									<div class="al m-col-block">
										<a href="#none">
											<div class="thumb-area">
												<figure><img src="${order.goodsImageThumbPath}" alt="${order.goodsNm}" /></figure>
												<div class="txt-area">
													<h2 class="tit">${order.goodsNm}</h2>
													<p class="fc-gr">${order.dlvySttusCodeNm}</p>
													<!--<p class="fs-sm fc-gr">최소이용주기 : 4주</p>-->
												</div>
											</div>
										</a>
									</div>
									<div class="al m-col-block">
										<ul class="option-info-list">
											<li>
												<div class="txt-area">
													<p>
														<cite>상품주문번호: ${order.orderNo}</cite>
														<c:if test="${not empty order.orderInfo}">
															${order.orderInfo }
														</c:if>
														<c:if test="${order.dOptnType != 'B' && not empty order.orderCo}">
															/ ${order.orderCo}개
														</c:if>
														 <strong><fmt:formatNumber value="${order.setleTotAmount}" pattern="#,###"/> 원</strong>
													</p>
												</div>
												<%--<div class="col-w150 m-col-block">
													<div class="price">
														<strong>
															<span><fmt:formatNumber value="${order.totAmount}" pattern="#,###" /></span>원
														</strong>
													</div>
												</div>--%>
												<div class="btn-area">
													<c:choose>
														<c:when test="${order.orderSttusCode eq 'ST02'}">
															<c:choose>
																<c:when test="${order.dlvySttusCode eq 'DLVY00'}"><%--상품 준비중--%>
																	<a href="#" class="btn-sm" onclick="cancelOrderDirect('${order.orderNo}','${order.orderGroupNo}','${dlvyItem.orderDlvyNo}','${order.orderKndCode}')">주문취소</a>
																</c:when>
																<c:when test="${order.dlvySttusCode eq 'DLVY01'}"><%--배송 준비중--%>
																	<a href="#" class="btn-sm" onclick="cancelOrder('${order.orderNo}','${order.orderKndCode}')">주문취소</a>
																</c:when>
																<c:when test="${order.dlvySttusCode eq 'DLVY02'}"><%--배송중--%>
																	<a href="#" class="btn-sm" onclick="showDlvyStatus('${order.hdryId}', ${order.invcNo})">배송조회</a>
																</c:when>
																<c:when test="${order.dlvySttusCode eq 'DLVY03'}"><%--배송 완료--%>
																	<a href="#" class="btn-sm" onclick="cancelOrder('${order.orderNo}','${order.orderKndCode}')">주문취소</a>
																	<%--<a href="#" class="btn-sm" onclick="initExchangeOrRecallPop('${order.orderNo}')">교환/환불</a>--%>
																</c:when>
															</c:choose>
														</c:when>
														<c:otherwise>
															<span class="fc-red">${order.orderSttusCodeNm}</span>
															<span class="fc-gr">${order.cancelPnttm}</span>
														</c:otherwise>
													</c:choose>
													<c:if test="${empty order.commentId and order.orderSttusCode eq 'ST02'}">
														<a href="#" class="btn-sm" onclick="initCommentPopupMyPage('add','${order.goodsId}','${order.orderNo}');">리뷰쓰기</a>
													</c:if>
												</div>
											</li>
										</ul>
									</div>
									<!--<div class="col-w100 m-col-block">
										<div class="btn-area">
											<a href="#noen" class="btn-sm">구독변경</a>
											<a href="#noen" class="btn-sm spot2">상품평쓰기</a>
											<a href="#noen" class="btn-sm spot2">취소/교환/반품</a>
										</div>
									</div>-->
								</div>
						</c:forEach>
				</section>
				<section>
					<div class="sub-tit-area">
						<h3 class="sub-tit">결제정보</h3>
					</div>
					<p class="mb20">결제방법 : <strong>${orderGroupOrderList[0].setleTyCodeNm}</strong></p>
					<ul class="info-table-type">
						<li>
							<cite>상품금액</cite>
							<div><fmt:formatNumber value="${orderPriceMap.totOrderPrice}" pattern="#,###"/>원</div>
						</li>
						<%--<li class="col-w400">
							<i class="ico-plus"></i>
							<cite>주문정보</cite>
							<div>
								<c:choose>
							   		<c:when test="${orderItemList.size() > 0}">
										<span>수량:${orderInfo.orderCo}개<br/></span>
										<c:forEach var="orderItem" items="${orderItemList}" varStatus="status">
											<c:if test="${orderItem.gitemPc gt 0}">
												<c:set var="pc" value="(+${orderItem.gitemPc}원)"/>
											</c:if>
											<c:if test="${orderItem.gitemPc lt 0}">
												<c:set var="pc" value="(${orderItem.gitemPc}원)"/>
											</c:if>
											<c:if test="${orderItem.gitemPc eq 0}">
												<c:set var="pc" value=""/>
											</c:if>
											<c:if test="${orderItem.gistemSeCode eq 'A' or orderItem.gistemSeCode eq 'D' or orderItem.gistemSeCode eq 'F' }">
												${orderItem.gistemSeCodeNm} ${orderItem.gitemNm}${pc}<br/>
											</c:if>
								   			&lt;%&ndash; <c:if test="${orderItem.gistemSeCode eq 'Q'}">
												업체 요청 사항 ${status.index+1}. ${orderItem.gitemNm}:${orderItem.gitemAnswer}<br/>
											</c:if> &ndash;%&gt;
									 	</c:forEach>
							   		</c:when>
							   		<c:otherwise>
									   	<span>옵션이 없습니다.<br/></span>
							   		</c:otherwise>
								</c:choose>
							 &lt;%&ndash;  <c:if test="${orderInfo.exprnUseAt eq 'Y'}">
									<c:if test="${orderInfo.exprnAmount gt 0}">
											<c:set var="exprnPc" value="+${orderInfo.exprnAmount}원"/>
									</c:if>
									<c:if test="${orderInfo.exprnAmount lt 0}">
											<c:set var="exprnPc" value="${orderInfo.exprnAmount}원"/>
									</c:if>
									<c:if test="${orderInfo.exprnAmount eq 0}">
										<c:set var="exprnPc" value=""/>
									</c:if>
										<span>1회 체험 가격 : ${exprnPc}<br/>
								</c:if>&ndash;%&gt;
							</div>
						</li>--%>
						 <li>
							<i class="ico-plus"></i>
							<cite>배송비</cite>
							<div><fmt:formatNumber value="${orderPriceMap.totOrderDlvyPrice}" pattern="#,###"/>원</div>
						</li>
						<li class="tfooter">
							<i class="ico-equal"></i>
							<cite>결제금액</cite>
							<div class="price">
								<em><strong><span class="fs-lg"><fmt:formatNumber value="${orderPriceMap.totOrderPrice + orderPriceMap.totOrderDlvyPrice}" pattern="#,###"/></span> 원</strong></em>
							</div>
						</li>
					</ul>
				</section>
				<c:if test="${not empty orderPriceMap.totOrderCancelPrice}">
				<section>
					<div class="sub-tit-area">
						<h3 class="sub-tit">환불정보</h3>
					</div>
					<ul class="info-table-type">
						<li>
							<cite>상품금액</cite>
							<div><fmt:formatNumber value="${orderPriceMap.totOrderCancelPrice}" pattern="#,###"/>원</div>
						</li>
						<%--<li class="col-w400">
							<i class="ico-plus"></i>
							<cite>주문정보</cite>
							<div>
								<c:choose>
							   		<c:when test="${orderItemList.size() > 0}">
										<span>수량:${orderInfo.orderCo}개<br/></span>
										<c:forEach var="orderItem" items="${orderItemList}" varStatus="status">
											<c:if test="${orderItem.gitemPc gt 0}">
												<c:set var="pc" value="(+${orderItem.gitemPc}원)"/>
											</c:if>
											<c:if test="${orderItem.gitemPc lt 0}">
												<c:set var="pc" value="(${orderItem.gitemPc}원)"/>
											</c:if>
											<c:if test="${orderItem.gitemPc eq 0}">
												<c:set var="pc" value=""/>
											</c:if>
											<c:if test="${orderItem.gistemSeCode eq 'A' or orderItem.gistemSeCode eq 'D' or orderItem.gistemSeCode eq 'F' }">
												${orderItem.gistemSeCodeNm} ${orderItem.gitemNm}${pc}<br/>
											</c:if>
								   			&lt;%&ndash; <c:if test="${orderItem.gistemSeCode eq 'Q'}">
												업체 요청 사항 ${status.index+1}. ${orderItem.gitemNm}:${orderItem.gitemAnswer}<br/>
											</c:if> &ndash;%&gt;
									 	</c:forEach>
							   		</c:when>
							   		<c:otherwise>
									   	<span>옵션이 없습니다.<br/></span>
							   		</c:otherwise>
								</c:choose>
							 &lt;%&ndash;  <c:if test="${orderInfo.exprnUseAt eq 'Y'}">
									<c:if test="${orderInfo.exprnAmount gt 0}">
											<c:set var="exprnPc" value="+${orderInfo.exprnAmount}원"/>
									</c:if>
									<c:if test="${orderInfo.exprnAmount lt 0}">
											<c:set var="exprnPc" value="${orderInfo.exprnAmount}원"/>
									</c:if>
									<c:if test="${orderInfo.exprnAmount eq 0}">
										<c:set var="exprnPc" value=""/>
									</c:if>
										<span>1회 체험 가격 : ${exprnPc}<br/>
								</c:if>&ndash;%&gt;
							</div>
						</li>--%>
						<li>
							<i class="ico-plus"></i>
							<cite>배송비</cite>
							<div><fmt:formatNumber value="${empty orderPriceMap.totOrderCancelDlvyPrice ? '0' : orderPriceMap.totOrderCancelDlvyPrice}" pattern="#,###"/>원</div>
						</li>
						<li class="tfooter">
							<i class="ico-equal"></i>
							<cite>총 환불금액</cite>
							<div class="price">
								<em><strong><span class="fs-lg"><fmt:formatNumber value="${orderPriceMap.totOrderCancelPrice + orderPriceMap.totOrderCancelDlvyPrice}" pattern="#,###"/></span> 원</strong></em>
							</div>
						</li>
					</ul>
				</section>
				</c:if>
				<c:if test="${param.menuNm eq 'refund'}">
					<section>
						<div class="sub-tit-area">
							<h3 class="sub-tit">교환정보</h3>
						</div>
						<div class="list-type">
							<table>
								<caption>교환정보</caption>
								<thead>
									<tr>
										<th scope="col">교환처리</th>
										<th scope="col">교환사유</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td class="ac">${orderStatusNm}</td>
										<td class="ac">${qaInfo.qestnCn}</td>
									</tr>
								</tbody>
							</table>
						</div>
					</section>
				</c:if>
				<c:if test="${param.menuNm ne 'refund' && not empty orderInfo.dlvyZip }">
				<section>
					<div class="sub-tit-area">
						<h3 class="sub-tit">배송정보</h3>
					</div>
					<div class="write-type">
						<table>
							<caption>배송지 정보</caption>
							<colgroup>
								<col style="width:150px" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">배송지명</th>
									<td>${orderInfo.dlvyAdresNm}</td>
								</tr>
								<tr>
									<th scope="row">수령인</th>
									<td>${orderInfo.dlvyUserNm}</td>
								</tr>
								<tr>
									<th scope="row">연락처</th>
									<td>${orderInfo.recptrTelno}</td>
								</tr>
								<tr>
									<th scope="row">배송주소</th>
									<td>(${orderInfo.dlvyZip}) ${orderInfo.dlvyAdres}, ${orderInfo.dlvyAdresDetail}</td>
								</tr>
								<tr>
									<th scope="row">배송메세지</th>
									<td>${orderInfo.dlvyMssage}</td>
								</tr>
							</tbody>
						</table>
					</div>
				</section>
				</c:if>
				<!--쿠폰상품-->
				<c:if test="${empty dlvyItem}">
					<c:set var="dlvyItem" value="${orderDlvyList[0]}"></c:set>
				</c:if>
				<c:if test="${fn:length(orderInfo.orderCouponList) > 0 && param.menuId ne 'sbs_mySubscribeCancel' && orderInfo.orderSttusCode eq 'ST02' && dlvyItem.reqTyCode ne 'E01'&& dlvyItem.reqTyCode ne 'R01'}">
					<section>
						<div class="sub-tit-area">
							<h3 class="sub-tit">수강권 정보</h3>
						</div>
						<div class="border-top">
							<ul class="ticket-list">
								<c:forEach var="item" items="${orderInfo.orderCouponList}" varStatus="status">
									<li>
										<i class="bg-ticket"></i>
										<div class="ticket-txt-area">
											<cite>${item.couponNm}</cite>
											<em>${item.couponNo}</em>
										</div>
									</li>
								</c:forEach>
							</ul>
						</div>
					</section>
				</c:if>
		</div>
	<!-- 구독상품이 아닌 상품 주문취소 -->
</div><!-- //site-body -->
	<c:import url="${CTX_ROOT}/user/my/subscribeHistory.do" charEncoding="utf-8"/>

	<!-- 배송준비중 -> 구독해지 확인 팝업 -->
	<div class="popup-alert" data-popup="popSubscribeCancel1" style="display: none;">
		<div class="pop-body">
			<p class="tit"><span class="fc-spot">배송 준비중인 상품</span>은 판매자 확인 후 구독해지가 완료됩니다.</p>
			<p class="mt10">구독을 해지하시겠습니까?</p>
		</div>
		<div class="pop-footer">
			<button type="button" onclick="popClose('popSubscribeCancel1');">취소</button>
			<button type="button" class="spot2" onclick="cancelOrderSbs('${orderInfo.orderNo}','${orderInfo.orderKndCode}');">확인</button>
		</div>
	</div>

	<!-- 배송중 -> 구독해지 확인 팝업 -->
	<div class="popup-alert" data-popup="popSubscribeStop1" style="display: none;">
		<div class="pop-body">
			<p class="tit"><span class="fc-spot">다음 회차부터</span> 구독해지가 완료됩니다.</p>
			<p class="mt10">구독을 해지하시겠습니까?</p>
		</div>
		<div class="pop-footer">
			<button type="button" onclick="popClose('popSubscribeStop1');">취소</button>
			<%--<button type="button" class="spot2" onclick="stopSubscribe('${orderInfo.orderDlvyNo}', '${orderInfo.orderNo}', '${orderInfo.orderGroupNo}');">확인</button>--%>
			<button type="button" class="spot2" onclick="stopSubscribe('${orderInfo.orderNo}');">확인</button>
		</div>
	</div>

	<!-- 배송준비중 -> 구독해지 팝업 -->
	<div class="popup-alert" data-popup="popSubscribeCancel" style="display: none; margin-left: -166px; margin-top: -164px; opacity: 1; transform: matrix(1, 0, 0, 1, 0, 0);">
		<div class="pop-body">
			<p class="tit">배송준비중인 상품은<br>판매자 확인 후 구독해지 가능합니다.</p>
			<p class="al mt10">자세한 문의는 소비자 상담전화로 문의바랍니다.</p>
			<p class="al mt10">
				판매자: ${goodsInfo.cmpnyNm}<br>
				소비자상담전화: <a href="tel:${goodsInfo.cnsltTelno}"><em>${goodsInfo.cnsltTelno}</em></a>
			</p>
			<p class="al fc-gr mt20 fs-sm">* 상품의 특성이나 배송상태에 따라서 이번 회차 환불이 불가능할 수 있습니다.</p>
		</div>
		<div class="pop-footer">
			<button type="button" class="spot2" onclick="closeSbsCancelPopup();">확인</button>
		</div>
	</div>

	<!-- 배송중 -> 구독해지 팝업 -->
	<div class="popup-alert" data-popup="popSubscribeStop" style="display: none; margin-left: -166px; margin-top: -164px; opacity: 1; transform: matrix(1, 0, 0, 1, 0, 0);">
		<div class="pop-body">
			<p class="tit">다음 회차부터 해지가 완료됩니다.</p>
			<p class="al mt10">자세한 문의는 소비자 상담전화로 문의바랍니다.</p>
			<p class="al mt10">
				판매자: ${goodsInfo.cmpnyNm}<br>
				소비자상담전화: <a href="tel:${goodsInfo.cnsltTelno}"><em>${goodsInfo.cnsltTelno}</em></a>
			</p>
			<p class="al fc-gr mt20 fs-sm">* 상품의 특성이나 배송상태에 따라서 이번 회차 환불이 불가능할 수 있습니다.</p>
		</div>
		<div class="pop-footer">
			<button type="button" class="spot2" onclick="closeSbsStopPopup();">확인</button>
		</div>
	</div>

	<c:import url="${CTX_ROOT}/shop/goods/review/reviewWrite.do" charEncoding="utf-9"/>
	<c:import url="${CTX_ROOT}/shop/goods/review/reviewView.do" charEncoding="utf-9"/>
	<c:import url="${CTX_ROOT}/user/my/refundWrite.do" charEncoding="utf-8"/>
	<javascript>
		<script src="${CTX_ROOT}/resources/front/my/mySubscribe/mySubscribeView.js?v=20220517"></script>
	</javascript>
</body>
</html>