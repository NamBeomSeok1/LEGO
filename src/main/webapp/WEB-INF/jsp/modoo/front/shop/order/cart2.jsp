<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/modoo/common/commonTagLibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>장바구니</title>
</head>
<body>
	<div class="wrap">	
			<div class="sub-contents">
				<form id="sendOrder" name="sendOrder" action="/shop/goods/goodsOrder.do" method="post">
					<div class="sticky-cont cart">
						<input type="hidden" id="searchGoodsKndCode" name="searchGoodsKndCode" value="${searchGoodsKndCode}"/>
					<div class="cont-area">
						<h2 class="sub-tit">장바구니</h2>
						<ul class="tabs-nav">
							<li class="${searchGoodsKndCode eq 'GNR' ? 'is-active' : ''}"><a href="#none" onclick="fnCart('GNR')">일반상품</a></li>
							<li class="${searchGoodsKndCode eq 'SBS' ? 'is-active' : ''}"><a href="#none" onclick="fnCart('SBS')">구독상품</a></li>
						</ul>
						<div class="sub-fnc-area">
							<div class="fl">
								<c:if test="${searchGoodsKndCode eq 'GNR'}">
									<label><input type="checkbox" id="allSelect" /> 전체선택</label>
								</c:if>
							</div>
							<div class="fr">
								<button type="button" onclick="deleteCart();" class="btn spot2">선택삭제</button>
							</div>
						</div>
						<section>
							<div class="table-type">
								<div class="thead">
									<div class="col-w50"></div>

									<cite>상품정보</cite>
									<cite class="col-w350">주문정보</cite>
									<cite class="col-w150">결제금액</cite>
								</div>
								<c:forEach var="cartGroup" items="${cartGroupList}" varStatus="status">
									<c:set var="tempSubPrice" value="0"/>
									<c:set var="tempDscntPc" value="0"/>
									<c:set var="cartAmount" value="0"/> <%-- 포인트 할인 계산 해야함 --%>
								<div class="tbody">
									<div class="col-w50">
										<label>
											<c:choose>
												<c:when test="${searchGoodsKndCode eq 'GNR'}">
													<input type="checkbox" name="cartGroupNo" class="selCart" data-selcartno="${status.index}" value="${cartGroup.cartGroupNo}" data-cartid="${cartGroup.cartGroupNo}" data-goodsid="${cartGroup.goodsId}" />
												</c:when>
												<c:otherwise>
													<input type="radio" name="cartGroupNo" class="selCart" data-selcartno="${status.index}" value="${cartGroup.cartGroupNo}" data-cartid="${cartGroup.cartGroupNo}" data-goodsid="${cartGroup.goodsId}" />
												</c:otherwise>
											</c:choose>

										</label>
									</div>

									<div class="al m-col-block">
										<a href="${CTX_ROOT}/shop/goods/goodsView.do?goodsId=${cartGroup.goodsId}">
											<div class="thumb-area lg">
												<figure><img src="${cartGroup.goodsTitleImagePath}" alt="${cartGroup.goodsNm }" /></figure>
												<div class="txt-area">
													<%-- <cite>${cartGroup.goodsNm}</cite> --%>
													 <h2 class="tit">${cartGroup.goodsNm}
													 <c:set var="exprnPc" value="0"/>
													<%-- <c:if test="${cartGroup.exprnUseAt eq 'Y'}">
													 [체험구독]
													 <c:set var="exprnPc" value="${cartGroup.exprnPc}"/>
													 </c:if>--%>
													 </h2>
													<%--<div class="price">
														<strong><span><fmt:formatNumber type="number" pattern="#,###" value="${cartGroup.goodsPc+exprnPc}"/></span>원</strong>
													</div>--%>
													<c:if test="${cartGroup.exprnUseAt ne 'Y'}">
														<c:choose>
															<c:when test="${!empty cartGroup.sbscrptMinUseWeek}">
																<p class="fs-sm fc-gr">최소이용주기 : ${cartGroup.sbscrptMinUseWeek }주</p>
															</c:when>
															<c:when test="${!empty cartGroup.sbscrptMinUseMt}">
																<p class="fs-sm fc-gr">최소이용주기 : ${cartGroup.sbscrptMinUseMt}개월</p>
															</c:when>
															<c:otherwise>
															</c:otherwise>
														</c:choose>
													</c:if>
												</div>
											</div>
										</a>
									</div>

									<div class="col-w350 al m-col-block">
											<ul class="option-info-list">
												<c:set var="cartPc" value="0"/>
												<c:set var="dlvyPc" value="0"/>
												<c:set var="dscntPc" value="0"/>

												<c:forEach var="cart" items="${cartGroup.cartList}" varStatus="cartStatus">
													<li>


														<c:set var="cartPc" value="${cartPc + cart.cartTotPc }"/>
														<c:set var="dscntPc" value="${dscntPc + cart.dscntPc }"/>
														<c:set var="tempChldrnNm" value="${cart.chldrnNm}"/>


														<input type="hidden" name="isCart" value="Y"/>
														<input type="hidden" id="cartPc${cartStatus.index}" class="cartPc" value="${cart.cartTotPc}"/>
														<%--<c:choose>
															<c:when test="${cart.gitemSeCode eq 'S'}">
																&lt;%&ndash;<input type="hidden" id="dlvyPc${cartStatus.index}" class="dlvyPc" value="0"/>&ndash;%&gt;
																<input type="hidden" id="cartPc${cartStatus.index}" class="cartPc" value="${cart.cartTotPc}"/>
															</c:when>
															<c:when test="${cart.gitemSeCode eq 'D'}">
																<c:choose>
																	<c:when test="${cartAmount ge cart.freeDlvyPc && cart.freeDlvyPc ne '0'}">
																		&lt;%&ndash;<input type="hidden" id="dlvyPc${cartStatus.index}" class="dlvyPc" value="0"/>&ndash;%&gt;
																		<input type="hidden" id="cartPc${cartStatus.index}" class="cartPc" value="${cart.cartTotPc+cart.dscntPc}"/>
																	</c:when>
																	<c:otherwise>
																		&lt;%&ndash;<input type="hidden" id="dlvyPc${cartStatus.index}" class="dlvyPc" value="${cart.dlvyPc}"/>&ndash;%&gt;
																		<input type="hidden" id="cartPc${cartStatus.index}" class="cartPc" value="${cart.cartTotPc+cart.dlvyPc+cart.dscntPc}"/>
																	</c:otherwise>
																</c:choose>
															</c:when>
														</c:choose>--%>

														<c:set var="exprnPc" value="0"/>
														<c:choose>
															<c:when test="${cart.exprnUseAt eq 'Y'}">
																<c:set var="exprnPc" value="${cart.exprnPc*cart.orderCo}"/>
															</c:when>
															<c:otherwise>
																<c:set var="exprnPc" value="0"/>
															</c:otherwise>
														</c:choose>
														<%--<input type="hidden" id="cartPc${cartStatus.index}" value="${cart.cartTotPc}"/>--%>
														<input type="hidden" id="optPc${cartStatus.index}" class="optPc" value="${cart.optPc}"/>
														<input type="hidden" id="dscntPc${cartStatus.index}" class="dscntPc" value="${-cart.dscntPc}"/>
														<input type="hidden" id="orderCo${cartStatus.index}" class="orderCo" value="${cart.orderCo}"/>
														<input type="hidden" id="exprnPc${cartStatus.index}" class="exprnPc" value="${cart.exprnPc}"/>
														<input type="hidden" id="compnoDscntUseAt"  class="compnoDscntUseAt" value="${cart.compnoDscntUseAt}"/>
														<div class="txt-area">
															<p>
															<c:if test="${cart.goodsKndCode eq 'SBS'}">
																<c:choose>
																	<c:when test="${cart.sbscrptCycleSeCode eq 'WEEK' }">
																		구독주기 : <c:out value="${cart.sbscrptWeekCycle }"/>주
																	</c:when>
																	<c:when test="${cart.sbscrptCycleSeCode eq 'MONTH' }">
																		구독주기 :<c:out value="${cart.sbscrptMtCycle }"/>월
																	</c:when>
																	<c:otherwise> ERROR </c:otherwise>
																</c:choose>
																<c:choose>
																	<c:when test="${cart.sbscrptCycleSeCode eq 'WEEK' }">
																		정기결제요일:
																		<c:choose>
																			<c:when test="${cart.sbscrptDlvyWd eq '1' }">일요일</c:when>
																			<c:when test="${cart.sbscrptDlvyWd eq '2' }">월요일</c:when>
																			<c:when test="${cart.sbscrptDlvyWd eq '3' }">화요일</c:when>
																			<c:when test="${cart.sbscrptDlvyWd eq '4' }">수요일</c:when>
																			<c:when test="${cart.sbscrptDlvyWd eq '5' }">목요일</c:when>
																			<c:when test="${cart.sbscrptDlvyWd eq '6' }">금요일</c:when>
																			<c:when test="${cart.sbscrptDlvyWd eq '7' }">토요일</c:when>
																		</c:choose>
																	</c:when>
																	<c:when test="${cart.sbscrptCycleSeCode eq 'MONTH' }">
																		정기결제일:
																		<span> <c:out value="${cart.sbscrptDlvyDay }"/> 일</span>
																	</c:when>
																	<c:otherwise>ERROR </c:otherwise>
																</c:choose>
																<c:if test="${not empty tempChldrnNm && empty cart.dOptnType}">
																	<br/>
																	자녀 : ${tempChldrnNm}
																</c:if>
															</c:if>

															<c:set var="itemIndex" value="0"/>
																<c:choose>
																	<c:when test="${not empty cart.cartItemList}">
																		<c:forEach items="${cart.cartItemList}" var="cartItem">
																			<c:choose>
																				<c:when test="${cartItem.gitemSeCode eq 'D'}">
																					<input type="hidden" class="gitemId" name="orderList[${cartStatus.index }].orderItemList[${itemIndex }].gitemId" value="${cartItem.gitemId }"/>
																					<input type="hidden" class="gitemSeCode" value="${cartItem.gitemSeCode }"/>
																					<input type="hidden" class="gitemCo" value="${cartItem.gitemCo }"/>
																					<br/>
																					기본옵션 : ${cartItem.gitemNm}
																					<c:choose>
																						<c:when test="${cart.dOptnType eq 'B'}">
																							<c:set var="tempSubPrice" value="${tempSubPrice + (cartItem.gitemPc * cartItem.gitemCo) }"/>
																							/ ${cartItem.gitemCo}개 / <strong>${cartItem.gitemCo * (cartItem.gitemPc)}원</strong>
																						</c:when>
																						<c:otherwise>
																							<c:set var="tempSubPrice" value="${tempSubPrice + (cart.goodsPc * cartItem.gitemCo) }"/>
																							/ ${cartItem.gitemCo}개 / <strong>${cartItem.gitemCo * cart.goodsPc}원</strong>
																						</c:otherwise>
																					</c:choose>

																					<c:if test="${not empty tempChldrnNm}">
																						<br/>
																						자녀 : ${tempChldrnNm}
																					</c:if>
																					<c:set var="itemIndex" value="${itemIndex + 1 }"/>
																				</c:when>

																				<c:when test="${cartItem.gitemSeCode eq 'Q'}">
																					<input type="hidden" name="orderList[${cartStatus.index }].orderItemList[${itemIndex }].gitemId" value="${cartItem.gitemId }"/>
																					<br/>
																					요청옵션 : ${cartItem.gitemAnswer}
																					<c:set var="itemIndex" value="${itemIndex + 1 }"/>
																				</c:when>

																				<c:when test="${cartItem.gitemSeCode eq 'S'}">
																					<input type="hidden" class="gitemId" name="orderList[${cartStatus.index }].orderItemList[${itemIndex }].gitemId" value="${cartItem.gitemId }"/>
																					<input type="hidden" class="gitemSeCode" value="${cartItem.gitemSeCode }"/>
																					<input type="hidden" class="gitemCo" value="${cartItem.gitemCo }"/>
																					<br/>
																					추가상품 : ${cartItem.gitemNm} / ${cartItem.gitemCo}개 / <strong>${cartItem.gitemCo * cartItem.gitemPc}원</strong>
																					<c:set var="tempSubPrice" value="${tempSubPrice + (cartItem.gitemPc * cartItem.gitemCo) }"/>
																					<c:set var="itemIndex" value="${itemIndex + 1 }"/>
																				</c:when>

																				<c:when test="${cartItem.gitemSeCode eq 'F'}"> <%--첫구독 --%>
																					<input type="hidden" name="orderList[${cartStatus.index }].orderItemList[${itemIndex }].gitemId" value="${cartItem.gitemId }"/>
																					<br/>
																					첫구독옵션 :${cartItem.gitemNm } / <strong>${cart.goodsPc+cartItem.gitemPc}원</strong>
																					<c:set var="itemIndex" value="${itemIndex + 1 }"/>
																				</c:when>


																			</c:choose>


																			<c:if test="${cart.compnoDscntUseAt eq 'Y' and cartItem.gitemSeCode eq 'D' }">
																				<br/>복수구매할인: <strong>${cart.compnoDscntPc*cartItem.gitemCo}원</strong>
																				<c:set var="tempDscntPc" value="${tempDscntPc + (cart.compnoDscntPc*cartItem.gitemCo)}"/>
																			</c:if>
																		</c:forEach>
																	</c:when>
																	<c:when test="${cart.goodsKndCode eq 'GNR' and empty cart.cartItemList}">
																		<c:set var="tempSubPrice" value="${tempSubPrice + (cart.goodsPc * cart.orderCo) }"/>
																		수량 : ${cart.orderCo}개 / <strong>${cart.goodsPc * cart.orderCo}원</strong>
																	</c:when>
																</c:choose>

															</p>
														</div>

													</li>
													<c:set var="cartAmount" value="${cartPc + dscntPc}"/> <%-- 포인트 할인 계산 해야함 --%>
										</c:forEach>
											</ul>
										<c:if test="${cartGroup.goodsId ne 'GOODS_00000000001460'}">
											<button type="button" class="btn-option-open" onclick="modCart(${cartGroup.cartGroupNo});"  data-popup-open="optionEdit">주문정보변경 <i class="ico-arr-r gr sm back"></i></button>
										</c:if>
									</div>
									<div class="col-w150 m-col-block">
										<div class="price">
												<strong><span><fmt:formatNumber type="number" pattern="#,###" value="${cartAmount}"/></span>원</strong>
												<c:choose>
													<c:when test="${cartAmount ge cartGroup.freeDlvyPc && cartGroup.freeDlvyPc ne '0'}">
														 <p class="fc-gr"><fmt:formatNumber type="number" pattern="#,###" value="${cartGroup.freeDlvyPc}"/>원 이상 주문 <br/>배송비무료</p>
														<input type="hidden"  class="dlvyPc" value="0"/>
													</c:when>
													<c:otherwise>
														 <p class="fc-gr">배송비 (+<fmt:formatNumber type="number" pattern="#,###" value="${cartGroup.dlvyPc}"/>)</p>
														<input type="hidden"  class="dlvyPc" value="${cartGroup.dlvyPc}"/>
													</c:otherwise>
												</c:choose>
										</div>
									</div>
								</div>
								</c:forEach>

								<c:if test="${!empty cartGroupList }">
									<div class="tfooter">
										<ul class="sum-area">
											<li>기본가격 (<span class="bassPc">0</span>원)</li>
											<%--<li><i>+</i> 옵션가격 (<span class="optPc">0</span>원)</li>--%>
											<li><i>-</i> 할인예상가격 (<span class="dscntPc">0</span>원)</li>
											<li><i>+</i> 배송비(<span class="dlvyPc">0</span>원)</li>
											<li><i>=</i> <strong class="price"><em class="totPc">0</em></strong>원</li>
										</ul>
									</div>
								</c:if>
								<c:if test="${empty cartGroupList }">
									<div class="tbody">
										<p class="none-txt">장바구니 목록이 없습니다.</p>
									</div>
								</c:if>
							</div>
						</section>
					</div>
					<div class="sticky-area total-buy-area">
						<div class="sticky">
							<div class="sticky-toggle-area">
								<div class="sticky-header">결제예정금액</div>
								<div class="sticky-body">
									<ul class="price-info-list">
										<li>
											<cite>상품금액</cite>
											<div><span class="bassPc">0</span>원</div>
										</li>
										<%--<li>
											<cite>옵션가격</cite>
											<div><span class="optPc">0</span>원</div>
										</li>--%>
										<li>
											<cite>할인예상금액</cite>
											<div><span class="dscntPc">0</span>원</div>
										</li>
										<!-- <li>
											<cite>1회 체험 가격</cite>
											<div><span class="exprnPc">0</span>원</div>
										</li>  -->
										<li>
											<cite>배송비</cite>
											<div><span class="dlvyPc">0</span>원</div>
										</li>
									</ul>
									<div class="total-area">
										<cite>총 <em class="orderCo">0</em>건</cite>
										<div class="price">
											<strong><span class="totPc">0</span> 원</strong>
										</div>
									</div>
								</div>
							</div>
							<div class="btn-table-area">
								<button type="submit" class="btn-lg spot orderBtn">주문하기</button>
							</div>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>


	<div class="popup" data-popup="optionEdit">

	</div>

		<!--날짜선택 -->
		<div class="layer-datepicker">
			<button type="button"><span>1</span></button>
			<button type="button"><span>2</span></button>
			<button type="button"><span>3</span></button>
			<button type="button"><span>4</span></button>
			<button type="button"><span>5</span></button>
			<button type="button"><span>6</span></button>
			<button type="button"><span>7</span></button>
			<button type="button"><span>8</span></button>
			<button type="button"><span>9</span></button>
			<button type="button"><span>10</span></button>
			<button type="button"><span>11</span></button>
			<button type="button"><span>12</span></button>
			<button type="button"><span>13</span></button>
			<button type="button"><span>14</span></button>
			<button type="button"><span>15</span></button>
			<button type="button"><span>16</span></button>
			<button type="button"><span>17</span></button>
			<button type="button"><span>18</span></button>
			<button type="button"><span>19</span></button>
			<button type="button"><span>20</span></button>
			<button type="button"><span>21</span></button>
			<button type="button"><span>22</span></button>
			<button type="button"><span>23</span></button>
			<button type="button"><span>24</span></button>
			<button type="button"><span>25</span></button>
			<button type="button"><span>26</span></button>
			<button type="button"><span>27</span></button>
			<button type="button"><span>28</span></button>
			<button type="button"><span>29</span></button>
			<button type="button"><span>30</span></button>
			<button type="button"><span>31</span></button>
		</div>
<javascript>
	 <script src="${CTX_ROOT }/resources/front/shop/goods/info/js/goodsCart.js"></script>
</javascript>
</body>
</html>