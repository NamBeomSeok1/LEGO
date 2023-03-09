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
				<h2 class="sub-tit">구독 상세보기</h2>
				<section>

					<div class="sub-tit-area">
						<h3 class="txt-hide">구독상세</h3>
						<p>주문번호 : <em>${orderInfo.orderGroupNo}</em></p>
						<p>주문날짜 : <em><fmt:formatDate value="${orderInfo.orderPnttm}" pattern="yyyy-MM-dd" /></em></p>
					</div>
					<div class="table-type">
						<%--<div class="thead">
							<cite class="col-w200">상품주문번호</cite>
							<cite>상품정보</cite>
							<cite>주문정보</cite>
							<cite class="col-w200">결제금액</cite>
						</div>--%>
						<div class="thead">
							<cite>상품정보</cite>
							<cite>주문정보</cite>
							<%--<cite>상품금액</cite>--%>
						</div>

							<div class="tbody">
								<div class="al m-col-block">
									<a href="#none">
										<div class="thumb-area">
											<figure><img src="${goodsInfo.goodsTitleImagePath}" alt="${goodsInfo.goodsNm}" /></figure>
											<div class="txt-area">
												<h2 class="tit">${goodsInfo.goodsNm}</h2>
												<p class="fc-gr">${orderInfo.dlvySttusCodeNm}</p>
												<c:if test="${orderInfo.orderKndCode eq 'SBS'}">
													<%-- <p class="fc-gr">${orderInfo.nowOdr-1}회차 / ${dlvySttusCodeNm}</p> --%>
													<c:if test="${orderInfo.orderSttusCode ne 'ST04' && orderInfo.orderSttusCode ne 'ST99'}">
														<p class="fc-gr">${orderInfo.nowOdr}회차 예정</p>
													</c:if>
													<c:if test="${orderInfo.orderSttusCode eq 'ST04' || orderInfo.orderSttusCode eq 'ST99'}">
														<p class="fc-gr">${orderInfo.nowOdr}회차 취소 </p>
													</c:if>
													<c:if test="${minUse gt '0'}">
														<p class="fs-sm fc-gr">최소이용주기 : ${minUse}회</p>
													</c:if>
												</c:if>
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
													<cite>상품주문번호: ${orderInfo.orderNo}</cite>
													<c:if test="${orderInfo.orderKndCode eq 'SBS'}">
														구독주기 :
														${sbscrptCycle}/
														정기결제일 :
														${sbscrptDlvyDate}/
													</c:if>
													<c:if test="${not empty orderInfo.orderInfo}">
														${orderInfo.orderInfo }/
													</c:if>
													<c:if test="${orderInfo.dOptnType ne 'B'}">
														${orderInfo.orderCo}개
													</c:if>
													<strong><fmt:formatNumber pattern="#,###" value="${orderInfo.totAmount}"/>원</strong>
												</p>
											</div>
											<%--<div class="col-w150 m-col-block">
                                                <div class="price">
                                                    <strong>
                                                        <span><fmt:formatNumber value="${order.totAmount}" pattern="#,###" /></span>원
                                                    </strong>
                                                </div>
                                            </div>--%>
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
				<%-----------------------------수정전 버전 (2022-08-01)-----------------------------------------------------%>
					<%--	<div class="tbody">
							<div class="col-w200">
								${orderInfo.orderNo}
							</div>
							<div class="al m-col-block">
								<a href="${CTX_ROOT}/shop/goods/goodsView.do?goodsId=${goodsInfo.goodsId}">
									<div class="thumb-area lg">
										<figure><img src="${goodsInfo.goodsTitleImagePath}" alt="${goodsInfo.goodsNm}" /></figure>
										<div class="txt-area">
											&lt;%&ndash; <cite>[${orderStatusNm}] ${goodsInfo.goodsNm}</cite> &ndash;%&gt;
											 <h2 class="tit">${goodsInfo.goodsNm}</h2>
											 <c:if test="${orderInfo.orderKndCode eq 'SBS'}">
											 	&lt;%&ndash; <p class="fc-gr">${orderInfo.nowOdr-1}회차 / ${dlvySttusCodeNm}</p> &ndash;%&gt;
												 	<c:if test="${orderInfo.orderSttusCode ne 'ST04' && orderInfo.orderSttusCode ne 'ST99'}">
												 		<p class="fc-gr">${orderInfo.nowOdr}회차 예정</p>
												 	</c:if>
												 	<c:if test="${orderInfo.orderSttusCode eq 'ST04' || orderInfo.orderSttusCode eq 'ST99'}">
												 		<p class="fc-gr">${orderInfo.nowOdr}회차 취소 </p>
												 	</c:if>
													<c:if test="${minUse gt '0'}">
														<p class="fs-sm fc-gr">최소이용주기 : ${minUse}회</p>
													</c:if>
											</c:if>
										</div>
									</div>
								</a>
							</div>
							<div class="al m-col-block">
								<c:if test="${orderInfo.orderKndCode eq 'SBS'}">
								<ul class="option-info">
									   <li>
										<strong>구독주기 :</strong>
										<span>${sbscrptCycle}</span>
									</li>
									<li>
										<strong>정기결제일 :</strong>
										<span>${sbscrptDlvyDate}</span>
									</li>
								</ul>
								</c:if>
								<ul class="option-info">
									<li>
										<cite>수량 :</cite>
										<span>${orderInfo.orderCo}개</span>
									</li>
								</ul>
								<ul class="option-info">
									<c:choose>
										<c:when test="${orderItemList.size() > 0}">
											<c:set var="totalAmount" value="0"/>
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
												<li>
													<cite>${orderItem.gistemSeCodeNm} :</cite>
													<span>${orderItem.gitemNm}${pc}</span>
												</li>
												</c:if>
												<c:if test="${orderItem.gitemPc ge 0}">
													<c:set var= "totalAmount" value="${totalAmount+orderItem.gitemPc}"/>
												</c:if>
											</c:forEach>
										</c:when>
										<c:otherwise>
											&lt;%&ndash;
											<li>
												<p class="none-txt">옵션이 없습니다.</p>
											</li>
											&ndash;%&gt;
										</c:otherwise>
									</c:choose>
									&lt;%&ndash; <c:if test="${orderInfo.exprnUseAt eq 'Y'}">
										<li>
										<c:if test="${orderInfo.exprnAmount ge 0}">
												<c:set var="exprnPc" value="+${orderInfo.exprnAmount}원"/>
										</c:if>
										<c:if test="${orderInfo.exprnAmount lt 0}">
												<c:set var="exprnPc" value="${orderInfo.exprnAmount}원"/>
										</c:if>
											<cite>1회 체험 가격 : </cite>
											<span>${exprnPc}</span>
										</li>
									</c:if> &ndash;%&gt;
									<c:if test="${orderInfo.compnoDscntUseAt eq 'Y'}">
									<li>
										<cite>복수구매할인: </cite>
										<span>${goodsInfo.compnoDscntPc*orderInfo.orderCo}원</span>
									</li>
									</c:if>
								</ul>
								<c:if test="${not empty goodsItemList}">
									<ul class="option-info">
										<li>
											<cite>업체요청사항</cite>
											<span>
											<c:choose>
												<c:when test="${goodsItemList.size() > 0}">
													<c:forEach var="goodsItem" items="${goodsItemList}" varStatus="status">
														${status.count}.${goodsItem.gitemSeCode}${goodsItem.gitemNm}: 없음
													</c:forEach>
												</c:when>
												<c:otherwise>
													&lt;%&ndash; : 없음 &ndash;%&gt;
												</c:otherwise>
											</c:choose>
											</span>
										</li>
									</ul>
								</c:if>
							</div>
							<div class="col-w200 m-col-block">
								<div class="price">
								<c:set var="dlvyAmount" value="${orderInfo.dlvyAmount+orderInfo.islandDlvyAmount}"/>
									 <strong><span><fmt:formatNumber value="${((orderInfo.goodsAmount + totalAmount )*orderInfo.orderCo) + dlvyAmount+orderInfo.exprnAmount+orderInfo.dscntAmount}" pattern="#,###" />원</span></strong>
								</div>
							</div>
						</div>--%>
					</div>
					<c:if test="${orderInfo.orderSttusCode eq 'ST02'}">
						<div class="mt20 ar">
							<button type="button" class="btn-sm spot2" onclick="modOrder('${orderInfo.orderNo}');"  data-popup-open="optionEdit">주문정보변경</button>
						</div>
					</c:if>
				</section>
				<section>
					<div class="sub-tit-area">
						<h3 class="sub-tit">결제정보</h3>
						<input type="hidden" id="payCardInfo" value="${payCardInfo}">
						<input type="hidden" id="payCardId" value="${payCardId}">
					</div>
					<ul class="info-table-type">
						<li>
							<cite>상품금액</cite>
							<c:set var="exprnAmount" value="0"/>
							<c:if test="${orderInfo.exprnUseAt eq 'Y'}">
								<c:set var="exprnAmount" value="${goodsInfo.exprnPc*orderInfo.orderCo}"/>
							</c:if>
							<div>
								<c:set var="bTypeOtpnTotPrice" value="0"/>
								<c:set var="aTypeOtpnTotPrice" value="0"/>
								<c:forEach var="orderItem" items="${orderItemList}" varStatus="status">
									<c:set var="bTypeOtpnTotPrice" value="${bTypeOtpnTotPrice + (orderItem.gitemPc*orderItem.gitemCo)}"/>
									<c:set var="aTypeOtpnTotPrice"  value="${ aTypeOtpnTotPrice + (orderInfo.goodsAmount * orderInfo.orderCo)}"/>
								</c:forEach>
								<c:choose>
									<c:when test="${orderInfo.dOptnType eq 'B'}">
										<fmt:formatNumber value="${bTypeOtpnTotPrice + dlvyAmount+ orderInfo.exprnAmount + orderInfo.dscntAmount}" pattern="#,###" />
									</c:when>
									<c:when test="${orderInfo.dOptnType eq 'A'}">
										<fmt:formatNumber value="${aTypeOtpnTotPrice + dlvyAmount+ orderInfo.exprnAmount + orderInfo.dscntAmount}" pattern="#,###" />
									</c:when>
									<c:otherwise>
										<fmt:formatNumber value="${((orderInfo.goodsAmount) *orderInfo.orderCo) + dlvyAmount+orderInfo.exprnAmount+orderInfo.dscntAmount}" pattern="#,###" />
									</c:otherwise>
								</c:choose>
								원
							</div>
						</li>
						<li class="col-w400">
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
												${orderItem.gistemSeCodeNm}옵션 : ${orderItem.gitemNm}${pc}<br/>
											</c:if>
								   			<%-- <c:if test="${orderItem.gistemSeCode eq 'Q'}">
												업체 요청 사항 ${status.index+1}. ${orderItem.gitemNm}:${orderItem.gitemAnswer}<br/>
											</c:if> --%>
									 	</c:forEach>
							   		</c:when>
							   		<c:otherwise>
									   	<span>옵션이 없습니다.<br/></span>
							   		</c:otherwise>
								</c:choose>
							 <%--  <c:if test="${orderInfo.exprnUseAt eq 'Y'}">
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
								</c:if>--%>
								<c:if test="${orderInfo.compnoDscntUseAt eq 'Y'}">
									복수구매할인:${goodsInfo.compnoDscntPc*orderInfo.orderCo}원
								</c:if>
							</div>
						</li>
						 <li>
							<i class="ico-plus"></i>
							<cite>배송비</cite>
							<c:set var="dlvyAmount" value="${orderInfo.dlvyAmount+orderInfo.islandDlvyAmount}"/>
							<div>${dlvyAmount}원</div>
						</li>
						<li class="tfooter">
							<i class="ico-equal"></i>
							<cite>결제금액</cite>
							<div class="price">
								<em><strong><span class="fs-lg">
									<c:choose>
										<c:when test="${orderInfo.dOptnType eq 'B'}">
											<fmt:formatNumber value="${bTypeOtpnTotPrice + dlvyAmount+ orderInfo.exprnAmount + orderInfo.dscntAmount}" pattern="#,###" />
										</c:when>
										<c:when test="${orderInfo.dOptnType eq 'A'}">
											<fmt:formatNumber value="${aTypeOtpnTotPrice + dlvyAmount+ orderInfo.exprnAmount + orderInfo.dscntAmount}" pattern="#,###" />
										</c:when>
										<c:otherwise>
											<fmt:formatNumber value="${((orderInfo.goodsAmount + totalAmount) *orderInfo.orderCo) + dlvyAmount+orderInfo.exprnAmount+orderInfo.dscntAmount}" pattern="#,###" />
										</c:otherwise>
									</c:choose>
								</span> 원</strong></em>
							</div>
						</li>
					</ul>
					<c:if test="${orderInfo.orderSttusCode eq 'ST02'}">
						<div class="mt20 ar">
							<button type="button" onclick="changeCardOpen();" class="btn-sm spot2">결제카드 변경</button>
						</div>
					</c:if>
				</section>
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
				<c:if test="${orderInfo.orderKndCode eq 'SBS'}">
				<section>
					<div class="sub-tit-area">
						<h3 class="sub-tit">구독현황</h3>
						<div class="fnc-area">
							 <button type="button" class="btn spot2" onclick="showDlvyHistory('${orderInfo.orderNo}')">
							  		  회차별 상세보기
							 </button>
						</div>
					 </div>
					<div class="list-type">
						<table>
							<caption>구독현황 리스트</caption>
							<tbody>
							   <c:choose>
									<c:when test="${orderDlvyList.size() > 0}">
										<input type="hidden" id="orderNo" value="${orderInfo.orderNo}"/>
										<input type="hidden" id="orderSttusCode" value="${orderInfo.orderSttusCode}"/>

										<c:forEach var="dlvyItem" items="${orderDlvyList}" varStatus="status">
											<input type="hidden" class="listCnt"/>
											<input type="hidden" id="dlvySttusCode${status.index}" value="${dlvyItem.dlvySttusCode}" />
											<input type="hidden" id="dlvySetleSttusCode${status.index}" value="${dlvyItem.searchSetleSttusCode}" />
											<tr>
											<td><span class="block">
												<c:if test="${not empty dlvyItem.searchSetlePnttm}">
													${dlvyItem.searchSetlePnttm}</br>
												</c:if>
													${dlvyItem.orderOdr}회차</span></td>

											<td><!-- 상태 표시 area -->
												<c:choose>
													<c:when test="${orderInfo.orderSttusCode eq 'ST01'}"><!-- 해지 접수 -->
														<em>주문취소 접수</em>
													</c:when>
													<c:when test="${orderInfo.orderSttusCode eq 'ST02'}"><!-- 구독중 -->
														<c:choose>
															<c:when test="${dlvyItem.searchSetleSttusCode eq 'T'}"><em>주문취소</em></c:when>
															<c:when test="${dlvyItem.searchSetleSttusCode eq 'F'}"><em>결제 실패</em></c:when>
															<c:when test="${dlvyItem.searchSetleSttusCode eq 'R'}"><em>결제 대기</em></c:when>
															<c:when test="${dlvyItem.searchSetleSttusCode eq 'P'}"><em>이번 회차 건너뛰기</em></c:when>
															<c:when test="${dlvyItem.searchSetleSttusCode eq 'S'}"><!-- 결제 완료 -->
																<c:choose>
																	<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY00' && fn:length(orderInfo.orderCouponList) == 0 }"><em>상품준비중</em></c:when>
																	<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY01' && fn:length(orderInfo.orderCouponList) == 0 }"><em>배송준비중</em></c:when>
																	<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY02' && fn:length(orderInfo.orderCouponList) == 0}"><em>배송중</em></c:when>
																	<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY03' && fn:length(orderInfo.orderCouponList) == 0}"><em>배송완료</em></c:when>
																	<c:otherwise><em>쿠폰발급완료</em></c:otherwise>
																</c:choose>
															</c:when>
															<c:when test="${dlvyItem.searchSetleSttusCode eq 'C'}">
															</c:when>
															<c:otherwise>

															</c:otherwise>
														</c:choose>
													</c:when>
													<c:when test="${orderInfo.orderSttusCode eq 'ST03'}">
													</c:when>
													<c:when test="${orderInfo.orderSttusCode eq 'ST04'}"><!-- 구독해지 -->
														<em>주문취소</em>
													</c:when>
													<c:when test="${orderInfo.orderSttusCode eq 'ST99'}"><!-- 구독취소해지 -->
														<em>주문취소</em>
													</c:when>
													<c:otherwise></c:otherwise>
												</c:choose>
											</td>
											<td><!-- 버튼 표시 area -->
												<c:choose>
													<c:when test="${orderInfo.orderSttusCode eq 'ST01'}"><!-- 해지 접수 -->
														<!-- 해지버튼 숨김 -->
													</c:when>
													<c:when test="${orderInfo.orderSttusCode eq 'ST02'}"><!-- 구독중 -->
														<c:choose>
															<c:when test="${dlvyItem.searchSetleSttusCode eq 'T'}"></c:when>
															<c:when test="${dlvyItem.searchSetleSttusCode eq 'F'}"></c:when>
															<c:when test="${dlvyItem.searchSetleSttusCode eq 'R'}"><!-- 결제 대기 -->
																<a href="#none" class="btn spot2 sbsModBtn" data-kind="pause" data-dlvyno="${dlvyItem.orderDlvyNo}">건너뛰기</a>
																<!-- 해지버튼 표시 -->
															</c:when>
															<c:when test="${dlvyItem.searchSetleSttusCode eq 'P'}"><!-- 건너뛰기 -->
																<a href="#none" class="btn spot2 sbsModBtn" data-kind="pauseStop" data-dlvyno="${dlvyItem.orderDlvyNo}">건너뛰기해제</a>
																<!-- 해지버튼 표시 -->
															</c:when>
															<c:when test="${dlvyItem.searchSetleSttusCode eq 'S'}"><!-- 결제완료-->
																<c:choose>
																	<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY00' && fn:length(orderInfo.orderCouponList) == 0 }"> <!-- 상품 준비중 -->
																		<a href="#none" class="btn spot2 pauseBtn" onclick="cancelOrderDirect('${orderInfo.orderNo}', ${orderInfo.orderGroupNo}, ${dlvyItem.orderDlvyNo},'${orderInfo.orderKndCode}')">주문취소</a>
																	</c:when>
																	<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY01' && fn:length(orderInfo.orderCouponList) == 0 }"> <!-- 배송준비중 -->
																		<a href="#none" class="btn spot2 pauseBtn" onclick="cancelOrder('${orderInfo.orderNo}','${orderInfo.orderKndCode}')">주문취소</a>
																	</c:when>
																	<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY02' && fn:length(orderInfo.orderCouponList) == 0}"> <!-- 배송중 -->
																		<a href="#none" onclick="showDlvyStatus('${dlvyItem.hdryId}', ${dlvyItem.invcNo})" class="btn spot2">배송추적</a>
																	</c:when>
																	<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY03' && fn:length(orderInfo.orderCouponList) == 0}"> <!-- 배송완료 -->
																		<a href="#none" onclick="initExchangeOrRecallPop('${orderInfo.orderNo}')" class="btn spot2">교환/반품</a>
																	</c:when>
																	<c:otherwise><a href="#none" class="btn spot2 pauseBtn" onclick="cancelOrder('${orderInfo.orderNo}','CPN')">주문취소</a></c:otherwise>
																</c:choose>
															</c:when>
															<c:otherwise>

															</c:otherwise>
														</c:choose>
													</c:when>
													<c:when test="${orderInfo.orderSttusCode eq 'ST03'}">
													</c:when>
													<c:when test="${orderInfo.orderSttusCode eq 'ST04'}">
<!-- 														<em>구독 해지</em>	 -->
													</c:when>
													<c:when test="${orderInfo.orderSttusCode eq 'ST99'}">
<!-- 														<em>구독 해지</em>	 -->
													</c:when>
													<c:otherwise></c:otherwise>
												</c:choose>
											</td>
										</c:forEach>

									</c:when>
									<c:otherwise>
										<tr colspan="3">
											<p class="none-txt">구독현황이 없습니다.</p>
										</tr>
									</c:otherwise>
								</c:choose>
								</tbody>
							</table>
					</div>
				</section>
			   </c:if>
				<c:if test="${(orderInfo.orderKndCode eq 'GNR' && dlvyItem.size() gt 0) || (orderInfo.orderKndCode eq 'CPN' && dlvyItem.size() gt 0)}">
					<section>
						<div class="sub-tit-area">
							<h3 class="sub-tit">배송현황</h3>
						 </div>
						<div class="list-type">
							<table>
								<caption>배송 현황</caption>
								<tbody>
									<input type="hidden" id="orderNo" value="${orderInfo.orderNo}"/>
									<input type="hidden" id="orderSttusCode" value="${orderInfo.orderSttusCode}"/>
									<input type="hidden" class="listCnt"/>
									<input type="hidden" id="dlvySttusCode" value="${dlvyItem.dlvySttusCode}" />
									<input type="hidden" id="dlvySetleSttusCode" value="${dlvyItem.searchSetleSttusCode}" />
										<tr>
										<td><!-- 상태 표시 area -->
											<c:choose>
												<c:when test="${orderInfo.orderSttusCode eq 'ST02'}"><!-- 구독중 -->
													<c:choose>
														<c:when test="${dlvyItem.searchSetleSttusCode eq 'S'}"><!-- 결제 완료 -->
															<c:choose>
																<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY00'}"><em>상품준비중</em></c:when>
																<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY01'}"><em>배송준비중</em></c:when>
																<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY02'}"><em>배송중</em></c:when>
																<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY03'}"><em>배송완료</em></c:when>
																<c:otherwise></c:otherwise>
															</c:choose>
														</c:when>
														<c:when test="${dlvyItem.searchSetleSttusCode eq 'C'}">
														</c:when>
														<c:otherwise>

														</c:otherwise>
													</c:choose>
												</c:when>
												<c:when test="${orderInfo.orderSttusCode eq 'ST03'}">
												</c:when>
												<c:otherwise></c:otherwise>
											</c:choose>
										</td>
										<td><!-- 버튼 표시 area -->
											<c:choose>
												<c:when test="${orderInfo.orderSttusCode eq 'ST02'}"><!-- 구독중 -->
													<c:choose>
														<c:when test="${dlvyItem.searchSetleSttusCode eq 'S'}"><!-- 결제완료-->
															<c:choose>
															<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY00' && orderInfo.orderKndCode ne 'CPN'}"> <!-- 상품 준비중 -->
																<%-- 																	<c:if test="${sbsCnt gt minUse}"> --%>
																<a href="#none" class="btn spot2 pauseBtn" onclick="cancelOrderDirect('${orderInfo.orderNo}', ${orderInfo.orderGroupNo}, ${dlvyItem.orderDlvyNo},'${orderInfo.orderKndCode}')">주문취소</a>
																<%-- 																	</c:if> --%>
															</c:when>
																<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY01' && orderInfo.orderKndCode ne 'CPN'}"> <!-- 배송준비중 -->
<%-- 																	<c:if test="${sbsCnt gt minUse}"> --%>
																		<a href="#none" class="btn spot2 pauseBtn" onclick="cancelOrder('${orderInfo.orderNo}','${orderInfo.orderKndCode}')">주문취소</a>
<%-- 																	</c:if> --%>
																</c:when>
																<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY02' && not empty dlvyItem.invcNo}"> <!-- 배송중 -->
																	<a href="#none" onclick="showDlvyStatus('${dlvyItem.hdryId}', ${dlvyItem.invcNo})" class="btn spot2">배송추적</a>
																</c:when>
																<%-- <c:when test="${dlvyItem.dlvySttusCode eq 'DLVY02' && empty dlvyItem.invcNo}"> <!-- 배송중 -->
																	<span>직접배송 상품입니다. (배송문의: <c:out value="${goodsInfo.cnsltTelno}"/>)</span>
																</c:when> --%>
																<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY03'}"> <!-- 배송중 -->
																	<a href="#none" onclick="initExchangeOrRecallPop('${orderInfo.orderNo}')" class="btn spot2">교환/반품</a>
																</c:when>
																<c:otherwise></c:otherwise>
															</c:choose>
														</c:when>
														<c:when test="${dlvyItem.searchSetleSttusCode eq 'F'}">
														</c:when>
														<c:otherwise></c:otherwise>
													</c:choose>
													</c:when>
													<c:when test="${orderInfo.orderSttusCode eq 'ST01'}">
													</c:when>
												<c:otherwise></c:otherwise>
											</c:choose>
												</td>
										</tbody>
									</table>
								</div>
							</section>
					   </c:if>
			   <!-- 구독해지 버튼 -->
			   <c:if test="${orderInfo.orderKndCode eq 'SBS'}">
				   <div class="btn-area stopSubscribe">
					   <c:choose>
						   <c:when test="${orderInfo.orderSttusCode eq 'ST01'}"><!-- 해지 접수 --></c:when>
						   <c:when test="${orderInfo.orderSttusCode eq 'ST02'}"><!-- 구독중 -->
							   <c:choose>
								   <c:when test="${orderDlvyList[1].searchSetleSttusCode eq 'T'}">
								   </c:when>
								   <c:when test="${orderDlvyList[1].searchSetleSttusCode eq 'F'}">
									   <button type="button" id="stopSubscribe" onclick="popOpen('popSubscribeStop1');" class="btn-lg width">구독 해지</button>
								   </c:when>
								   <c:when test="${orderDlvyList[1].searchSetleSttusCode eq 'R'}"><!-- 결제 대기 -->
									   <button type="button" id="stopSubscribe" onclick="popOpen('popSubscribeStop1');" class="btn-lg width">구독 해지</button>
								   </c:when>
								   <c:when test="${orderDlvyList[1].searchSetleSttusCode eq 'P'}">
									   <button type="button" id="stopSubscribe" onclick="popOpen('popSubscribeStop1');" class="btn-lg width">구독 해지</button>
								   </c:when>
								   <c:when test="${orderDlvyList[1].searchSetleSttusCode eq 'S'}"><!-- 결제완료-->
									   <c:choose>
										   <c:when test="${orderDlvyList[1].dlvySttusCode eq 'DLVY00'}"> <!-- 상품 준비중 -->
											   <button type="button" class="btn-lg width pauseBtn" onclick="cancelOrderDirect('${orderInfo.orderNo}', ${orderInfo.orderGroupNo}, ${dlvyItem.orderDlvyNo},'${orderInfo.orderKndCode}');">구독해지</button>
										   </c:when>
										   <c:when test="${orderDlvyList[1].dlvySttusCode eq 'DLVY01'}"> <!-- 배송준비중 -->
											   <button type="button" id="stopSubscribe" onclick="popOpen('popSubscribeCancel1')" class="btn-lg width">구독 해지</button>
										   </c:when>
										   <c:when test="${orderDlvyList[1].dlvySttusCode eq 'DLVY02'}"> <!-- 배송중 -->
											   <button type="button" id="stopSubscribe" class="btn-lg width" onclick="popOpen('popSubscribeStop1');">구독해지</button>
										   </c:when>
										   <c:when test="${orderDlvyList[1].dlvySttusCode eq 'DLVY03'}"> <!-- 배송완료 -->
											   <button type="button" id="stopSubscribe" class="btn-lg width" onclick="popOpen('popSubscribeStop1');">구독해지</button>
										   </c:when>
										   <c:otherwise></c:otherwise>
									   </c:choose>
								   </c:when>
								   <c:otherwise>

								   </c:otherwise>
							   </c:choose>
						   </c:when>
						   <c:otherwise></c:otherwise>
					   </c:choose>
				   </div>
			 <%--  <div class="btn-area ar stopSubscribe">
				<c:if test="${sbsCnt gt minUse}">
					<c:choose>
						<c:when test="${orderInfo.orderSttusCode eq 'ST01'}"><!-- 해지 접수 -->
						</c:when>
						<c:when test="${orderInfo.orderSttusCode eq 'ST02'}"><!-- 구독중 -->
							<c:choose>
								<c:when test="${dlvyItem.searchSetleSttusCode eq 'T'}">
								</c:when>
								<c:when test="${dlvyItem.searchSetleSttusCode eq 'F'}">
									<button type="button" id="stopSubscribe" onclick="stopSubscribe('${orderNo}')"class="btn spot2">구독 해지</button>
								</c:when>
								<c:when test="${dlvyItem.searchSetleSttusCode eq 'R'}"><!-- 결제 대기 -->
									<button type="button" id="stopSubscribe" onclick="stopSubscribe('${orderNo}')"class="btn spot2">구독 해지</button>
								</c:when>
								<c:when test="${dlvyItem.searchSetleSttusCode eq 'P'}">
									<button type="button" id="stopSubscribe" onclick="stopSubscribe('${orderNo}')"class="btn spot2">구독 해지</button>
								</c:when>
								<c:when test="${dlvyItem.searchSetleSttusCode eq 'S'}"><!-- 결제완료-->

									<c:choose>
										<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY00'}"> <!-- 상품 준비중 -->
										</c:when>
										<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY01'}"> <!-- 배송준비중 -->
										</c:when>
										<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY02'}"> <!-- 배송중 -->
										</c:when>
										<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY03'}"> <!-- 배송완료 -->
											<button type="button" id="stopSubscribe" onclick="stopSubscribe('${orderNo}')"class="btn spot2">구독 해지</button>
										</c:when>
										<c:otherwise></c:otherwise>
									</c:choose>
								</c:when>
								<c:otherwise>

								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise></c:otherwise>
					</c:choose>
				</c:if>
			   </div>--%>
		   </c:if>
			<!-- 구독해지 버튼 (한번만사보기상품) -->
		<%--	<c:if test="${orderInfo.orderKndCode eq 'GNR'}">
				<div class="btn-area stopSubscribe">
						&lt;%&ndash;						<c:if test="${sbsCnt gt minUse}"> &ndash;%&gt;
					<c:choose>
						<c:when test="${orderInfo.orderSttusCode eq 'ST01'}"><!-- 해지 접수 -->

						</c:when>
						<c:when test="${orderInfo.orderSttusCode eq 'ST02'}"><!-- 구독중 -->
							<c:choose>
								<c:when test="${dlvyItem.searchSetleSttusCode eq 'T'}">
								</c:when>
								<c:when test="${dlvyItem.searchSetleSttusCode eq 'F'}">
									<button type="button" id="stopSubscribe" onclick="stopSubscribe('${orderInfo.orderNo}')"class="btn spot2">주문 취소</button>
								</c:when>
								<c:when test="${dlvyItem.searchSetleSttusCode eq 'R'}"><!-- 결제 대기 -->
									<button type="button" id="stopSubscribe" onclick="stopSubscribe('${orderInfo.orderNo}')"class="btn spot2">주문 취소</button>
								</c:when>
								<c:when test="${dlvyItem.searchSetleSttusCode eq 'P'}">
									<button type="button" id="stopSubscribe" onclick="stopSubscribe('${orderInfo.orderNo}')"class="btn spot2">주문 취소</button>
								</c:when>
								<c:when test="${dlvyItem.searchSetleSttusCode eq 'S'}"><!-- 결제완료-->
									<c:choose>
										<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY00'}"> <!-- 상품 준비중 -->
											<button type="button" class="btn-lg width pauseBtn" onclick="cancelOrderDirect('${orderInfo.orderNo}', ${orderInfo.orderGroupNo}, ${dlvyItem.orderDlvyNo},'${orderInfo.orderKndCode}');">주문 취소</button>
											&lt;%&ndash;											<a href="#none" class="btn spot2 pauseBtn" onclick="cancelOrderDirect('${orderInfo.orderNo}', ${orderInfo.orderGroupNo}, ${dlvyItem.orderDlvyNo},'${orderInfo.orderKndCode}')">주문취소</a>&ndash;%&gt;
										</c:when>
										<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY01'}"> <!-- 배송준비중 -->
											<button type="button" class="btn-lg width pauseBtn" onclick="popOpen('popSubscribeCancel1');">주문 취소</button>
											&lt;%&ndash;											<a href="#none" class="btn spot2 pauseBtn" onclick="cancelOrder('${orderInfo.orderNo}','${orderInfo.orderKndCode}')">주문취소</a>&ndash;%&gt;
										</c:when>
										<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY02'}"> <!-- 배송중 -->
											<button type="button" class="btn-lg width pauseBtn" onclick="cancelOrder('${orderInfo.orderNo}','${orderInfo.orderKndCode}');">주문 취소</button>
										</c:when>
										<c:when test="${dlvyItem.dlvySttusCode eq 'DLVY03'}"> <!-- 배송완료 -->
											&lt;%&ndash;											<button type="button" id="stopSubscribe" class="btn-lg width" onclick="stopSubscribe('${orderInfo.orderNo}')">주문 취소</button>&ndash;%&gt;
											&lt;%&ndash;											<button type="button" id="stopSubscribe" onclick="stopSubscribe('${orderNo}')"class="btn spot2">구독 해지</button>&ndash;%&gt;
										</c:when>
										<c:otherwise></c:otherwise>
									</c:choose>
								</c:when>
								<c:otherwise>

								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise></c:otherwise>
					</c:choose>
						&lt;%&ndash; 					</c:if> &ndash;%&gt;
				</div>
			</c:if>--%>
			<c:if test="${orderInfo.orderKndCode eq 'CPN' && fn:length(orderInfo.orderCouponList) > 0 && param.menuId ne 'sbs_mySubscribeCancel' && orderInfo.orderSttusCode eq 'ST02'}">
				<div class="btn-area">
				  		<a onclick="cancelOrder('${orderInfo.orderNo}','CPN')" class="btn-lg width">주문취소</a>
				</div>
			</c:if>
		</div>
	<!-- 구독상품이 아닌 상품 주문취소 -->
	<div class="btn-area">
		<c:if test="${orderInfo.orderKndCode eq 'CPN' && fn:length(orderInfo.orderCouponList) > 0 && orderInfo.orderSttusCode eq 'ST02'}">
			<a onclick="cancelOrder('${orderInfo.orderNo}','CPN')" class="btn-lg width">주문취소</a>
		</c:if>
		</div>
	</div>
</div><!-- //site-body -->
	<c:import url="${CTX_ROOT}/user/my/refundWrite.do" charEncoding="utf-8"/>
	<c:import url="${CTX_ROOT}/user/my/subscribeHistory.do" charEncoding="utf-8"/>


	<%--주문옵션변경(구독변경)팝업--%>
	<div class="popup" data-popup="optionEdit">

	</div>

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

	<!--카드 목록 팝업-->
	<div class="popup w1200" data-popup="cardSubscribeEdit">
		<div class="pop-header">
			<h1>정기결제 카드변경​</h1>
			<button type="button" class="btn-pop-close" data-popup-close="cardSubscribeEdit">닫기</button>
		</div>
		<div class="pop-body">
			<p class="mb20"><strong>결제카드:</strong><span class="payedCard"></span></p>
			<div class="pop-tit-area">
				<h3 class="pop-tit">정기결제 카드 변경</h3>
				<div class="fnc-area">
					<button type="button" id="cardWrite" class="btn">카드 등록하기</button>
				</div>
			</div>
			<div class="list-type">
				<table>
					<caption>정기결제 카드 변경</caption>
					<thead>
					<tr>
						<th scope="col">카드(카드번호)</th>
						<th scope="col">카드 이름</th>
						<th scope="col">관리</th>
					</tr>
					</thead>
					<tbody class="cardlist">
					</tbody>
				</table>
			</div>
		</div>
	</div>

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
							<input type="number" class="cardNo" name="cardNo1" maxlength="4" autocomplete="one-time-code" placeholder="0000" title="카드번호 첫번째 입력" />
							<input type="number" class="cardNo" name="cardNo2" maxlength="4" autocomplete="one-time-code" placeholder="0000" title="카드번호 두번째 입력" />
							<input type="password" class="cardNo" name="cardNo3" class="pw" maxlength="4" placeholder="0000" autocomplete="new-password" title="카드번호 세번째 입력" />
							<input type="password" class="cardNo" name="cardNo4" class="pw" maxlength="4" placeholder="0000" autocomplete="new-password" title="카드번호 네번째 입력" />
						</div>
					</dd>
					<dd class="table-area">
						<div>
							<cite class="write-tit">유효기간</cite>
							<div class="focus-auto border-input-area">
								<input type="password" name="cardUsgpd1"  autocomplete="new-password" class="pw ac cardUsgpd" maxlength="2"  placeholder="MM" title="월입력(MM)" />
								/
								<input type="password" name="cardUsgpd2"  autocomplete="new-password" class="pw ac cardUsgpd" maxlength="2"  placeholder="YY" title="연입력(YY)" />
							</div>
						</div>
						<div>
							<cite class="write-tit">카드비밀번호</cite>
							<input type="password" name="cardPassword" autocomplete="new-password" class="pw p10 al" maxlength="2"  placeholder="비밀번호 앞 2자리 숫자" title="비밀번호 앞 2자리 숫자" />
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
						<label><input type="radio" checked="checked" name="kind" data-kind="first" />개인카드</label>
						<label><input type="radio"  name="kind" data-kind="second"/>법인카드</label>
					</dd>
					<dt id="brthdy">생년월일</dt>
					<dd>
						<input type="number" name="brthdy" maxlength="6" class="p10 al" placeholder="6자리 입력" title="6자리 입력" />
					</dd>
					<dt style="display:none;" id="bizrno">사업자등록번호</dt>
					<dd style="display:none;">
					</dd>
					<dt>카드이름</dt>
					<dd>
						<input type="text" name="cardNm"  class="p10 al" placeholder="카드 이름" title="카드 이름" />
					</dd>
				</dl>
				<div class="agree-area">
					<label><input type="checkbox" name="bassUseAt"/>기본 카드로 설정</label>
				</div>

				<!-- <div class="agree-area">
				<p class="msg"><a href="#none" onclick="popOpen2('cardList')" class="fc-gr fs-sm">등록 가능한 카드사 보기<i class="ico-arr-r sm back gr "></i></a></p>
				</div> -->
				<div class="agree-all-area">
					<label><input type="checkbox" id="allStplat" value="Y" /><strong>전체 약관 동의</strong></label>
					<ul class="bg-box bullet-none">
						<li>
							<label><input type="checkbox" class="stplat" id="indvdlStplat"/>FOXEDU STORE 개인(신용)정보 수집 및 이용 동의</label>
							<a href="#none" onclick="popOpen2('termsPrivacy')" class="fc-gr fs-sm">보기 <i class="ico-arr-r sm back gr "></i></a>
						</li>
						<li>
							<label><input type="checkbox" class="stplat" id="cardStplat" />FOXEDU STORE · 카드사 간 개인(신용)정보 제공 동의</label>
							<a href="#none"  onclick="popOpen2('termsCard')" class="fc-gr fs-sm">보기 <i class="ico-arr-r sm back gr "></i></a>
						</li>
					</ul>
				</div>
				<div class="btn-table-area">
					<button type="button" onclick="cardSubmit();" id="cardReg" class="btn-lg spot width">완료</button>
				</div>
			</form>
		</div>
	</div>
	<javascript>
		<script src="${CTX_ROOT}/resources/front/my/mySubscribe/mySubscribeView.js?v=20220517"></script>
		<script src="${CTX_ROOT}/resources/front/my/mySubscribe/mySubscribeModify.js?v=20220914"></script>
	</javascript>
</body>
</html>