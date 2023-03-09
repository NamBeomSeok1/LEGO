<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/modoo/common/commonTagLibs.jsp"%>
<c:set var="now" value="<%=new java.util.Date()%>" />
<c:set var="today"><fmt:formatDate value="${now}" pattern="d" /></c:set>
<!DOCTYPE html>
<html>
<head>
	<metatag>
		<meta property="og:title" content="${goods.goodsNm}"/>
		<meta property="og:description" content="${goods.goodsIntrcn}"/>
		<c:set var="imageUrl" value=""/>
		<c:forEach var="imgItem" items="${goods.goodsImageList }" varStatus="status">
			<c:if test="${status.first }">
				<c:set var="imageUrl" value="${BASE_URL}${imgItem.goodsMiddlImagePath }"/>
				<meta proerty="og:image" content="${BASE_URL}${imgItem.goodsMiddlImagePath}">
			</c:if>
		</c:forEach>
		<c:if test="${empty goods.goodsImageList }">
			<c:set var="imageUrl" value="${BASE_URL}/resources/front/site/${SITE_ID }/image/logo/modoo_logo.png"/>
			<meta property="og:image" content="${BASE_URL}/resources/front/site/${SITE_ID }/image/logo/modoo_logo.png"/>
		</c:if>
	</metatag>
	<title>폭스스토어</title>
</head>
<body>
<div class="wrap">
	<div class="sub-contents">
		<c:import url="/embed/shop/goods/goodsCtgryLocation.do" charEncoding="utf-8">
			<c:param name="goodsCtgryId" value="${goods.goodsCtgryId }"/>
		</c:import>
		<section class="product-detail-top">
			<div class="top-img-area">
				<div class="sticky">
					<c:set var="mainLabelCnt" value="0"/>
					<c:if test="${not empty goods.goodsMainLabelList}">
						<div class="label-area">
							<c:forEach var="labelItem" items="${goods.goodsMainLabelList}" varStatus="status">
								<c:set var="mainLabelCnt" value="${mainLabelCnt+1}"/>
								<c:if test="${mainLabelCnt < 3}">
									<c:choose>
										<c:when test="${labelItem.labelTy eq 'IMG'}">
											<span class="label-img-xlg"><img src="${labelItem.labelImgPath}" alt=""></span>
										</c:when>
										<c:otherwise>
													<span class="label-r-xlg" style="background-color: ${labelItem.labelColor}">
														<cite>${labelItem.labelCn}</cite>
														<strong>${labelItem.labelCn2}</strong>
													</span>
										</c:otherwise>
									</c:choose>
								</c:if>
							</c:forEach>
						</div>
					</c:if>
					<div class="swiper-container">
						<c:if test="${goodsEventInfo.eventAt eq 'Y'}">
							<span class="label-event">이벤트</span>
						</c:if>
						<ul class="swiper-wrapper">
							<c:forEach var="imgItem" items="${goods.goodsImageList }">
								<li class="swiper-slide">
									<img src="<c:out value="${imgItem.goodsLrgeImagePath }"/>" alt="이미지1 썸네일" />
									<c:if test="${goods.soldOutAt eq 'Y'}">
										<div class="soldout"><span>일시품절</span></div>
									</c:if>
								</li>
							</c:forEach>
						</ul>
					</div>
					<button type="button" class="swiper-button-next"></button>
					<button type="button" class="swiper-button-prev"></button>
					<div class="swiper-pagination"></div>
				</div>
			</div>
			<div class="product-buy-area">
				<form:form modelAttribute="goodsCart" id="goodsOrderForm" name="goodsOrderForm" method="post" action="${CTX_ROOT }/shop/goods/order.do">
					<fieldset id="inputField">
						<input type="hidden" id="goodsId" name="goodsId" value="${goods.goodsId }"/>
						<input type="hidden" id="goodsKndCode" name="goodsKndCode" value="${goods.goodsKndCode}"/>
						<input type="hidden" id="sbscrptCycleSeCode" name="sbscrptCycleSeCode" value="${goods.sbscrptCycleSeCode }"/>
						<input type="hidden" id="orderMode" name="orderMode" value="CART"/> <%--CART :장바구니, SBS: 구독 --%>
						<input type="hidden" id="dOptnType"  value="${goods.dOptnType }"/>
						<input type="hidden" id="dOptnUseAt"  value="${goods.dOptnUseAt }"/>
						<c:choose>
							<c:when test="${empty USER_ID && not empty goods.mrktPc}">
								<input type="hidden" id="goodsPrice" value="${goods.mrktPc }"/>
							</c:when>
							<c:otherwise>
								<input type="hidden" id="goodsPrice" value="${goods.goodsPc }"/>
							</c:otherwise>
						</c:choose>
						<input type="hidden" id="frstOptnEssntlAt" value="${goods.frstOptnEssntlAt }"/>
						<input type="hidden" id="exprnPc"  name="exprnPc" value="${goods.exprnPc}"/>
						<input type="hidden" id="exprnUseAt"  name="exprnUseAt" value=""/>
						<input type="hidden" id="compnoDscntPc"  name="compnoDscntPc" value="${goods.compnoDscntPc}"/>
						<input type="hidden" id="compnoDscntUseAt" value="${goods.compnoDscntUseAt}"/>
						<input type="hidden" id="chldrnnmUseAt" value="${goods.chldrnnmUseAt}"/>
						<input type="hidden" id="qGitemListSize" value="${fn:length(goods.qGitemList)}"/>
						<input type="hidden" id="goodsCo" value="${goods.goodsCo }"/>

					</fieldset>
					<div class="info-area">
						<c:if test="${not empty goods.brandId }">
							<a href="${CTX_ROOT }/shop/goods/brandGoodsList.do?searchGoodsBrandId=${goods.brandId}" class="btn-link">
								<c:out value="${goods.brandNm }"/>몰 상품보러가기</a>
						</c:if>
						<h2><c:out value="${goods.goodsNm }"/></h2>
						<div class="price">
							<c:choose>
								<c:when test="${empty USER_ID && not empty goods.mrktPc}">
									<strong><span><c:if test="${goods.sbscrptCycleSeCode eq 'MONTH' }">월</c:if> <fmt:formatNumber type="number" pattern="#,###" value="${goods.mrktPc}"/></span>원</strong>
								</c:when>
								<c:otherwise>
									<strong><span><c:if test="${goods.sbscrptCycleSeCode eq 'MONTH' }">월</c:if> <fmt:formatNumber type="number" pattern="#,###" value="${goods.goodsPc}"/></span>원</strong>
									<c:if test="${goods.mrktUseAt eq 'Y'}">
										<del><span><fmt:formatNumber type="number" pattern="#,###" value="${goods.mrktPc}"/></span>원</del>
									</c:if>
								</c:otherwise>
							</c:choose>
							</div>
								<c:if test="${user.groupId ne 'GROUP_00000000000001'}">
									<div class="info-fnc-area">
										<div class="layerpopup-sm-area share-area">
											<button type="button" class="btn-layerpopup-sm"><i class="ico-share"></i><span>공유하기</span></button>
											<div class="layerpopup-sm">
												<!--<div class="pop-header">
													<h1>공유하기</h1>
												</div>-->
												<div class="pop-body">
													<div class="share">
														<button type="button" id="kakaoShare" data-title='${goods.goodsNm}' data-description='${goods.goodsIntrcn}' data-link='${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}' data-imageurl='${imageUrl}'><i class="ico-sns-kakao-spot lg"></i><span class="txt-hide">카카오톡</span></button>
														<%--<button type="button" id="facebookShare" data-title='${goods.goodsNm}' data-link='${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}' data-imageurl='${imageUrl}'><i class="ico-sns-facebook-spot lg"></i><span class="txt-hide">페이스북</span></button>--%>
														<!-- <button type="button"><i class="ico-sns-instagram-spot lg"></i><span class="txt-hide">인스타그램</span></button> -->
														<%--<button type="button" id="twitterShare" data-title='${goods.goodsNm}' data-description='${goods.goodsIntrcn}' data-link='${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}' data-imageurl='${imageUrl}'><i class="ico-sns-twitter-spot lg"></i><span class="txt-hide">트위터</span></button>--%>
														<%--<button type="button" id="naverShare" data-title='${goods.goodsNm}' data-description='${goods.goodsIntrcn}' data-link='${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}' data-imageurl='${imageUrl}'><i class="ico-sns-naverblog-spot lg"></i><span class="txt-hide">네이버블로그</span></button>--%>
														<button type="button" id="clipBoard" onclick="urlClipCopy('${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}');"><i class="ico-sns-url-spot lg"></i><span class="txt-hide">URL</span></button>
													</div>
												</div>
												<button type="button" class="btn-close">닫기</button>
											</div>
										</div>
									</div>
								</c:if>
							</div>
							<c:if test="${goods.goodsKndCode ne 'CPN'}">
								<div class="etc-info-area">
									<c:if test="${not empty goods.goodsLabelList}">
										<div class="label-area">
											<c:forEach items="${goods.goodsLabelList}" var="labelItem">
											<c:if test="${not empty labelItem.labelCn and labelItem.labelMainChk ne 'Y'}">
												<span class="label-r spot3">${labelItem.labelCn} ${labelItem.labelCn2}</span>
											</c:if>
											</c:forEach>
										</div>
									</c:if>
									<dl class="etc-info">
										<c:choose>
											<%-- 폭스구독권(수강권) --%>
											<c:when test="${goods.goodsCtgryId eq 'GCTGRY_0000000000032' or goods.goodsCtgryId eq 'GCTGRY_0000000000037'}">
												<dt>안내사항</dt>
												<dd>
													본 상품은 실물 상품이 아닌 e-구독권입니다.<br />
													사용 관련 자세한 안내는 고객센터로 문의바랍니다.
													<c:if test="${goods.dpstryAt eq 'Y'}">
														<ul class="etc-boxinfo">
															<li><i class="ico-pickup sm"></i>센터픽업 가능</li>
														</ul>
													</c:if>
												</dd>
											</c:when>
											<c:otherwise>
												<dt>배송비</dt>
												<dd>
													<c:choose>
														<c:when test="${goods.dlvySeCode eq 'DS01' }"><b>배송비 선불</b> <fmt:formatNumber type="number" pattern="#,###" value="${goods.dlvyPc}"/>원</c:when>
														<c:when test="${goods.dlvySeCode eq 'DS02' }"><b>배송비 착불</b> <fmt:formatNumber type="number" pattern="#,###" value="${goods.dlvyPc}"/>원</c:when>
														<c:when test="${goods.dlvySeCode eq 'DS03' }"><b>무료배송</b></c:when>
													</c:choose>
													<c:if test="${not empty goods.freeDlvyPc and  goods.freeDlvyPc gt '0'}">
														<span class="msg"><fmt:formatNumber type="number" pattern="#,###" value="${goods.freeDlvyPc}"/>원 이상 구매시 무료 /</span>
													</c:if>
													<c:if test="${not empty goods.jejuDlvyPc and goods.jejuDlvyPc gt '0' }">
														<span class="msg">제주 지역  <fmt:formatNumber type="number" pattern="#,###" value="${goods.jejuDlvyPc}"/>원 /</span>
													</c:if>
													<c:if test="${not empty goods.islandDlvyPc and goods.islandDlvyPc gt '0' }">
														<span class="msg">도서산간지역 <fmt:formatNumber type="number" pattern="#,###" value="${goods.islandDlvyPc}"/>원</span>
													</c:if>
												</dd>

										<dt>배송정보</dt>
										<dd class="dlvyInfo-text">
											<c:choose>
												<c:when test="${not empty goods.dlvyPolicyCn}"><modoo:crlf content="${goods.dlvyPolicyCn}"/></c:when>
												<c:otherwise>${systemDlvyPolicyCn }</c:otherwise>
											</c:choose>
											<c:if test="${goods.dpstryAt eq 'Y'}">
												<ul class="etc-boxinfo">
													<li><i class="ico-pickup sm"></i>센터픽업 가능</li>
												</ul>
											</c:if>


											<!-- 무료배송 / 설정한 요일에 맞추어 출고가 진행되며 , 배송일정은 판매자의 사정에 따라 <strong>변경 될 수 있음을 알려드립니다.</strong> -->
										</dd>
										<!-- <dt>결제정보</dt>
										<dd>
										첫 결제는 주문 당일에 결제되며, 2회차 결제부터는 배송일 3일전에 정기결제가 이루어 집니다.
										</dd>-->

										<c:if test="${goods.goodsKndCode eq 'SBS' }">
											<dt>결제안내</dt>
											<dd class="payInfo-text">
												첫 결제는 주문 당일에 결제되며,<br/> 2회차 결제부터는 지정한 정기결제일에 결제가 이루어 집니다. <br/>
												<c:if test="${goods.sbscrptCycleSeCode eq 'MONTH'}">본 상품은 월 단위로 선택 결제가 가능하며,<br/> 마이페이지에서 결제주기,결제일 변경이 가능합니다.</c:if>
												<c:if test="${goods.sbscrptCycleSeCode eq 'WEEK'}">본 상품은 주 단위로 선택 결제가 가능하며,<br/> 마이페이지에서 결제주기,결제요일변경이 가능합니다.</c:if>
											</dd>
										</c:if>

										<c:if test="${!empty goods.sbscrptMinUseMt}">
											<dt>이용주기</dt>
											<dd>
												본 상품은 최소 ${goods.sbscrptMinUseMt}개월 구독기간을 유지해야 하는 상품으로 ${goods.sbscrptMinUseMt}개월 이용 후, 해지가 가능합니다. 구매 시 참고하여주세요.
											</dd>
										</c:if>
									</c:otherwise>
								</c:choose>
							</dl>
						</div>
					</c:if>
					<c:choose>
						<c:when test="${goods.soldOutAt eq 'Y'}">
							<div class="fnc-area">
								<div class="info-box">
									<i class="ico-soldout"></i>
									<p>일시품절 입니다.</p>
								</div>
							</div>
						</c:when>
						<c:when test="${adultCrtYn ne 'Y' && goods.adultCrtAt eq 'Y'}">
							<div class="fnc-area">
								<div class="info-box">
									<i class="ico-adult lg vt"></i>
									<p>
										본 상품은 청소년 유해매체물로서 19세 미만의 청소년이 이용할 수 없습니다.<br />
										이용을 원하시면 (청소년보호법에 따라) 나이 및 본인 여부를 확인해 주시기 바랍니다.
									</p>
								</div>
								<ul class="bullet sm">
									<li>본인인증시 입력하신 모든 정보는 항상 암호화되어 처리되며, 본인확인 외에 다른 목적으로 사용되지 않습니다.</li>
									<li>고객님께서 입력하신 정보는 NICE신용평가정보(주)에 제공됩니다.</li>
								</ul>
							</div>
							<div class="btn-area">
								<c:choose>
									<c:when test="${not empty USER_ID}">
										<button type="button" class="btn-lg spot adultCrtBtn">인증 후 구독하기 <i class="ico-arr-r sm back wh" aria-hidden="true"></i></button>
									</c:when>
									<c:otherwise>
										<button type="button"  onclick="popOpen('popupOrder')" class="btn-lg spot">인증 후 구독하기 <i class="ico-arr-r sm back wh" aria-hidden="true"></i></button>
									</c:otherwise>
								</c:choose>
							</div>
						</c:when>
						<c:otherwise>
							<div class="fnc-area">
								<c:if test="${empty USER_ID}">
									<c:set var="exprnChkCnt" value="0"/>
								</c:if>
								<div class="option-check-area">
									<c:if test="${goods.exprnUseAt eq 'Y'}">
										<div class="option-check is-active">
											<button type="button" class="btn-option-check" data-buytype="subscribe"><span class="txt-hide">정기구독 선택</span></button>
											<span class="txt">정기구독</span>
										</div>
										<div class="option-check">
											<button type="button" class="btn-option-check" name="exprnUseAt" data-buytype="experience"><span class="txt-hide">1회 체험 선택</span></button>
											<!-- <label><input type="checkbox" name="exprnUseAt" value="Y" class="optioncheck"/></label> -->
											<span class="txt">1회 체험 구매</span>
											<div class="tooltip-area">
												<button type="button" class="btn-tooltip">
													<i class="ico-info"></i>
												</button>
												<div class="popup-tooltip">
													<div class="pop-header">
														<h1>1회 체험 구매</h1>
														<button type="button" class="btn-close">닫기</button>
													</div>
													<div class="pop-body">
														<p>
															1회 체험 구매를 선택하면 한 번만 결제가 이루어지며,
															구독상품을 체험해 보실 수 있습니다.
														</p>
													</div>
												</div>
											</div>
												<%-- <div class="price">
												<c:choose>
													<c:when test="${goods.exprnPc ge '0'}">
														+<fmt:formatNumber type="number" pattern="#,###" value="${goods.exprnPc}"/>원
													</c:when>
													<c:otherwise>
														<fmt:formatNumber type="number" pattern="#,###" value="${goods.exprnPc}"/>원
													</c:otherwise>
												</c:choose>
												</div> --%>
										</div>
									</c:if>
								</div>
								<div class="option-area">
									<ul class="option-list">
										<c:if test="${goods.chldrnnmUseAt eq 'Y'}">
											<li>
												<cite>자녀</cite>
												<select class="chdr" name="chdr.chdrId">
													<option value="0">선택</option>
												</select>
												<input type="text" class="chdrNm mt10" name="chdr.chdrNm" style="display: none;"/>
													<%--&lt;%&ndash;<span class="fs-sm fc-gr block">* 폭스러닝센터 상품일 경우, 자녀의 이름을 입력해주세요.</span>&ndash;%&gt;--%>
											</li>
										</c:if>
										<c:if test="${goods.optnUseAt eq 'Y' }">
											<c:if test="${goods.qOptnUseAt eq 'Y' and fn:length(goods.qGitemList) gt 0}">
												<li class="qOptionLi">
													<cite>업체 요청사항<span class="required"></span></cite>
													<c:forEach var="opt" items="${goods.qGitemList }" varStatus="status">
														<input type="hidden" class="qopt_${status.index}" value="${opt.gitemId }"/>
														<input type="text"  class="p10 gitemAnswer" data-answerid="gitemAnswer_${status.index}" placeholder="${opt.gitemNm }" />
													</c:forEach>
												</li>
											</c:if>
										</c:if>

										<c:if test="${goods.goodsKndCode eq 'SBS'}">
											<c:if test="${goods.fOptnUseAt eq 'Y' }">
												<li>
													<cite>첫구독옵션</cite>
													<select name="cartItemList[${orderItemNo }].gitemId" id="fOptOption" class="fOpt orderOption" title="옵션선택">
														<option value="">첫 구독 옵션을 선택하세요</option>
														<c:forEach var="opt" items="${goods.fGitemList }">
															<c:if test="${opt.gitemPc gt 0}">
																<c:set var="pc" value="(+${opt.gitemPc}원)"/>
															</c:if>
															<c:if test="${opt.gitemPc lt 0}">
																<c:set var="pc" value="(${opt.gitemPc}원)"/>
															</c:if>
															<c:if test="${opt.gitemPc eq 0}">
																<c:set var="pc" value=""/>
															</c:if>
															<c:choose>
																<c:when test="${opt.gitemSttusCode eq 'F'}">
																	<option value="${opt.gitemId }" disabled="disabled">${opt.gitemNm }${pc}(품절)</option>
																</c:when>
																<c:otherwise>
																	<option value="${opt.gitemId }" data-pc="${opt.gitemPc }">${opt.gitemNm }${pc}</option>
																</c:otherwise>
															</c:choose>
														</c:forEach>
													</select>
													<p class="msg">
														첫 구독옵션은 첫 주문시에만 결제,배송되며 2회차부터는 결제,배송되지 않습니다.
													</p>
												</li>
												<c:set var="orderItemNo" value="${orderItemNo + 1 }"/>
											</c:if>
											<c:choose>
												<c:when test="${goods.sbscrptCycleSeCode eq 'WEEK'}"> <%-- 주 구독 --%>
													<li>
														<cite>구독주기</cite>
														<form:select path="sbscrptWeekCycle" class="sbscrptWeekCycle" title="주기 선택">
															<c:if test="${fn:length(goods.sbscrptWeekCycleList) gt 1 }">
																<option value="">주기를 선택하세요.</option>
															</c:if>
															<c:forEach var="week" items="${goods.sbscrptWeekCycleList }">
																<option value="${week }">${week }주</option>
															</c:forEach>
														</form:select>
													</li>
													<li>
														<cite>정기결제요일</cite> <%--오영석 차장 요청 : 구독요일을 정기결제일, 배송요일을 정기결제 요일 변경 10.28 --%>
														<form:select path="sbscrptDlvyWd" class="sbscrptDlvyWd" title="정기결제요일 선택">
															<option value="">정기결제 요일을 선택하세요.</option>
															<c:forEach var="code" items="${wdCodeList }">
																<c:forEach var="wd" items="${goods.sbscrptDlvyWdList }">
																	<c:if test="${code.code eq wd}">
																		<option value="${code.code }">${code.codeNm }</option>
																	</c:if>
																</c:forEach>
															</c:forEach>
														</form:select>
													</li>
												</c:when>
												<c:when test="${goods.sbscrptCycleSeCode eq 'MONTH' }"> <%--월 구독 --%>
													<li>
														<cite>구독주기</cite>
														<form:select path="sbscrptMtCycle" class="sbscrptMtCycle" title="구독주기 선택">
															<c:if test="${fn:length(goods.sbscrptMtCycleList) gt 1 }">
																<option value="">주기를 선택하세요.</option>
															</c:if>
															<c:forEach var="month" items="${goods.sbscrptMtCycleList }">
																<option value="${month }">${month }개월</option>
															</c:forEach>
														</form:select>
													</li>
													<li>
														<cite>정기결제일</cite>
														<div class="datepicker-area">
																<%-- <form:hidden path="sbscrptDlvyDay" value="${goods.sbscrptDlvyDay }"/>
																<input type="text" class="" disabled value="${goods.sbscrptDlvyDay} 일"/> --%>
															<c:choose>
																<c:when test="${not empty goods.sbscrptDlvyDay }">
																	<c:choose>
																		<c:when test="${goods.sbscrptDlvyDay eq '0'}"> <%-- 결제일 기준 --%>
																			<form:hidden path="sbscrptDlvyDay" class="sbscrptDlvyDay" value="${today}"/>
																			<input type="text" disabled value="${today } 일"/>
																		</c:when>
																		<c:otherwise>
																			<form:hidden path="sbscrptDlvyDay" class="sbscrptDlvyDay" value="${goods.sbscrptDlvyDay}"/>
																			<input type="text" disabled value="${goods.sbscrptDlvyDay } 일"/>
																		</c:otherwise>
																	</c:choose>
																</c:when>
																<c:otherwise>
																	<form:input path="sbscrptDlvyDay" cssClass="datepicker-input sbscrptDlvyDay" placeholder="결제일을 선택하세요" title="결제일을 선택" readonly="true" />
																	<button class="btn-datepicker-toggle" type="button"><span class="text-hide"></span></button>
																</c:otherwise>
															</c:choose>
														</div>
													</li>
												</c:when>
											</c:choose>
										</c:if>

										<%--<c:if test="${(goods.optnUseAt eq 'N' or (goods.optnUseAt eq 'Y' and goods.dOptnUseAt eq 'N')) and goods.goodsKndCode eq 'GNR'}">
											<li>
												<cite>수량</cite>
												<div>
													<div class="count tempCount">
														<button type="button" class="btn-minus tempGoodsCo"><span class="txt-hide">빼기</span></button>
														<form:input type="number" path="orderCo" class="goodsOrderCo inputNumber"  disabled="true"  min="1" max="9999"   title="수량 입력" maxlength="4"/>
														<button type="button" class="btn-plus tempGoodsCo" ><span class="txt-hide">더하기</span></button>
													</div>
													&lt;%&ndash;<c:if test="${goods.compnoDscntUseAt eq 'Y'}">
														<p class="msg mt10">2개 이상 구매시 개당 ${-goods.compnoDscntPc}원이 할인됩니다.</p>
													</c:if>&ndash;%&gt;
												</div>
											</li>
										</c:if>--%>

										<c:set var="orderItemNo" value="0"/>
										<c:if test="${goods.optnUseAt eq 'Y' }">
											<c:if test="${goods.dOptnUseAt eq 'Y' }">
												<c:set var="optnList1" value="${fn:split(goods.optnComList[0].optnValue, ',')}"/>
												<c:set var="optnList2" value="${fn:split(goods.optnComList[1].optnValue, ',')}"/>
												<li>
													<cite>기본옵션</cite>
													<select name="cartItemList[${orderItemNo }].gitemId" id="orderOption1"  class="dOpt1 orderOption" title="옵션선택">
														<option value="">${goods.optnComList[0].optnName}</option>
														<c:choose>
															<c:when test="${not empty goods.optnComList[1].optnValue}">
																<c:forEach var="opt1" items="${optnList1}">
																	<option value="${opt1}">${opt1 }</option>
																</c:forEach>
															</c:when>
															<c:otherwise>
																<c:forEach var="opt1" items="${goods.dGitemList}">
																	<option value="${opt1.gitemId}" data-gitemnm="${opt1.gitemNm}" data-price="${opt1.gitemPc}" data-count="${goods.dOptnType eq 'A' ? goods.goodsCo : opt1.gitemCo}">${opt1.gitemNm }</option>
																</c:forEach>
															</c:otherwise>
														</c:choose>
													</select>
													<c:if test="${fn:length(goods.optnComList) > 1}">
														<select name="cartItemList[${orderItemNo }].gitemId" id="orderOption2"  class="dOpt2 orderOption" title="옵션선택">
															<option value="">${goods.optnComList[1].optnName}</option>
														</select>
													</c:if>
												</li>
												<c:set var="orderItemNo" value="${orderItemNo + 1 }"/>
											</c:if>
											<c:if test="${goods.aOptnUseAt eq 'Y' }">
												<li>
													<cite>추가옵션</cite>
													<select name="cartItemList[${orderItemNo }].gitemId" class="aOpt orderOption" title="옵션선택">
														<option value="">옵션을 선택하세요</option>
														<c:forEach var="opt" items="${goods.aGitemList }">
															<c:if test="${opt.gitemPc gt 0}">
																<c:set var="pc" value="(+${opt.gitemPc}원)"/>
															</c:if>
															<c:if test="${opt.gitemPc lt 0}">
																<c:set var="pc" value="(${opt.gitemPc}원)"/>
															</c:if>
															<c:if test="${opt.gitemPc eq 0}">
																<c:set var="pc" value=""/>
															</c:if>
															<c:choose>
																<c:when test="${opt.gitemSttusCode eq 'F'}">
																	<option value="${opt.gitemId }" disabled="disabled">${opt.gitemNm }${pc}(품절)</option>
																</c:when>
																<c:otherwise>
																	<option value="${opt.gitemId }" data-pc="${opt.gitemPc }">${opt.gitemNm }${pc}</option>
																</c:otherwise>
															</c:choose>
														</c:forEach>
													</select>
												</li>
												<c:set var="orderItemNo" value="${orderItemNo + 1 }"/>
											</c:if>
										</c:if>
									</ul>
								</div>
								<c:if test="${goods.sOptnUseAt eq 'Y' and goods.optnUseAt eq 'Y'}">
									<div class="option-area">
										<ul class="option-list">
											<li>
												<cite>추가상품</cite>
												<select name="cartItemList[${orderItemNo }].gitemId" class="sOpt orderOption" title="옵션선택">
													<option value="">옵션을 선택하세요</option>
													<c:forEach var="opt" items="${goods.sGitemList }">
														<c:if test="${opt.gitemPc gt 0}">
															<c:set var="pc" value="(+${opt.gitemPc}원)"/>
														</c:if>
														<c:if test="${opt.gitemPc lt 0}">
															<c:set var="pc" value="(${opt.gitemPc}원)"/>
														</c:if>
														<c:if test="${opt.gitemPc eq 0}">
															<c:set var="pc" value=""/>
														</c:if>
														<c:choose>
															<c:when test="${opt.gitemSttusCode eq 'F'}">
																<option value="${opt.gitemId }" disabled="disabled">${opt.gitemNm }${pc}(품절)</option>
															</c:when>
															<c:otherwise>
																<option value="${opt.gitemId }" data-pc="${opt.gitemPc }">${opt.gitemNm }${pc}</option>
															</c:otherwise>
														</c:choose>
													</c:forEach>
												</select>
											</li>
										</ul>
									</div>
								</c:if>

								<div class="bg-area">
									<ul class="option-select-area">
										<c:if test="${goods.optnUseAt eq 'N' and (goods.goodsKndCode eq 'GNR' or goods.goodsKndCode eq 'CPN')}">
											<li class="goodsLi">
												<div class="count">
													<button type="button" class="btn-minus sm"><span class="txt-hide">빼기</span></button>
													<input type="number" value="1" class="orderCo inputNumber" min="1" max="" title="수량 입력" maxlength="4" readonly="">
													<button type="button" class="btn-plus sm"><span class="txt-hide">더하기</span></button>
												</div>
												<div class="price"><fmt:formatNumber type="number" pattern="#,###" value="${goods.goodsPc}"/>원</div>
											</li>
										</c:if>
									</ul>
									<div class="total-area">
										<cite>결제금액</cite>
										<div class="price">
											<strong><span class="totPrice">0</span> 원</strong>
										</div>
									</div>
								</div>
							</div>
							<div class="btn-area">
									<%-- <label class="btn-zzim"><input type="checkbox" title="찜" /></label> --%>
									<%-- <button type="button" id="clipBoard" onclick="urlClipCopy('${CTX_ROOT}/shop/goods/goodsView.do?goodsId=${goods.goodsId}');" class="btn">URL</button> --%>
								<c:choose>
									<c:when test="${fn:contains(USER_ROLE,'ROLE_SHOP') and not fn:contains(USER_ROLE, 'ROLE_EMPLOYEE')}">
										<button type="button" class="btn-lg spot2" disabled>장바구니 담기</button>
										<button type="button" class="btn-lg spot2 btnOrderText" disabled>
											<c:choose>
												<c:when test="${goods.goodsKndCode eq 'SBS'}">구독하기</c:when>
												<c:otherwise>구매하기</c:otherwise>
											</c:choose>
											<i class="ico-arr-r sm back wh" aria-hidden="true"></i></button>
									</c:when>
									<c:when test="${empty USER_ID }">
										<button type="button" class="btn-lg" data-popup-open="popupOrder" onclick="popOpen('popupOrder');">장바구니 담기</button>
										<button type="button" class="btn-lg spot btnOrderText" data-popup-open="popupOrder" onclick="popOpen('popupOrder');">
											<c:choose>
												<c:when test="${goods.goodsKndCode eq 'SBS'}">
													구독하기
												</c:when>
												<c:otherwise>
													구매하기
												</c:otherwise>
											</c:choose>
											<i class="ico-arr-r sm back wh" aria-hidden="true"></i></button>
									</c:when>
									<c:otherwise>
										<button type="button" class="btn-lg btnCart" data-order-mode="CART" onclick="popOpen('popupCart');">장바구니 담기</button>
										<button type="button" class="btn-lg spot btnOrder btnOrderText" data-order-mode="SBS">
											<c:choose>
												<c:when test="${goods.goodsKndCode eq 'SBS'}">
													구독하기
												</c:when>
												<c:otherwise>
													구매하기
												</c:otherwise>
											</c:choose>
											<i class="ico-arr-r sm back wh" aria-hidden="true"></i></button>
										</c:otherwise>
									</c:choose>
								</div>
								</c:otherwise>
							</c:choose>
							</form:form>
						</div>
					<%--<div class="top-etc-area">
						<div>
							<dl class="etc-info">
								<dt>공유하기</dt>
								<dd>
									<div class="share">
										<button type="button" id="kakaoShare" data-title='${goods.goodsNm}' data-description='${goods.goodsIntrcn}' data-link='${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}' data-imageurl='${imageUrl}'><i class="ico-sns-kakao-gr lg"></i><span class="txt-hide">카카오톡</span></button>
										<button type="button" id="facebookShare" data-title='${goods.goodsNm}' data-description='${goods.goodsIntrcn}' data-link='${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}' data-imageurl='${imageUrl}'><i class="ico-sns-facebook-gr lg"></i><span class="txt-hide">페이스북</span></button>
										<!-- <button type="button"><i class="ico-sns-instagram-spot lg"></i><span class="txt-hide">인스타그램</span></button> -->
										<button type="button" id="twitterShare" data-title='${goods.goodsNm}' data-description='${goods.goodsIntrcn}' data-link='${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}' data-imageurl='${imageUrl}'><i class="ico-sns-twitter-gr lg"></i><span class="txt-hide">트위터</span></button>
										<button type="button" id="naverShare" data-title='${goods.goodsNm}' data-description='${goods.goodsIntrcn}' data-link='${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}' data-imageurl='${imageUrl}'><i class="ico-sns-naverblog-gr lg"></i><span class="txt-hide">네이버블로그</span></button>
										<button type="button" id="clipBoard" onclick="urlClipCopy('${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}');"><i class="ico-sns-url-gr lg"></i><span class="txt-hide">URL</span></button>
									</div>
								</dd>
							</dl>
						</div>--%>
						<div>
						</div>
					</div>
				</section>
					<div class="product-detail">
					<ul class="tabs-nav">
						<li class="anchor-detail01"><a href="#detail01">상세정보</a></li>
						<li class="anchor-detail02"><a href="#detail02">리뷰 <em class="review-cnt"></em></a></li>
						<li class="anchor-detail03"><a href="#detail03">Q&amp;A <em class="qaTotalCount"></em></a></li>
						<li class="anchor-detail04"><a href="#detail04">교환/반품 안내</a></li>
					</ul>
					<div class="product-detail-area">
					<!-- 상세정보 -->
						<section id="detail01" class="detail-info">
							<c:if test="${goodsEventInfo.eventAt eq 'Y'}">
								<%--<c:choose>
									<c:when test="${user.groupId eq 'GROUP_00000000000001'}"><!-- B2B -->
										<div class="info-event-area view-content">
											<c:forEach var="evtImg" items="${goodsEventInfo.evtImageList }">
												<img src="<c:out value="${evtImg.goodsImagePath }"/>" alt="이벤트 이미지" />
											</c:forEach>
										</div>
									</c:when>
									<c:otherwise><!-- B2C -->
										<c:choose>
											<c:when test="${goods.goodsId eq 'GOODS_00000000002002'}">
												<div class="info-event-area view-content">
													<img src="<c:out value="${CTX_ROOT}/html/SITE_00000/event/210202health/images/banner_goods/GROUP_00000000000000/${goods.goodsId}/event.jpg"/>" alt="이벤트 이미지" />
												</div>
											</c:when>
											<c:otherwise>
												<c:if test="${goods.goodsId != 'GOODS_00000000001518'}">
													<div class="info-event-area view-content">
														<img src="<c:out value="${CTX_ROOT}/html/SITE_00000/event/210111open2/images/banner_goods/GROUP_00000000000000/${goods.goodsId}/event.jpg"/>" alt="이벤트 이미지" />
													</div>
												</c:if>
											</c:otherwise>
										</c:choose>

                            </c:otherwise>
                        </c:choose>--%>
						<%--<div class="info-event-area view-content">
                            <c:forEach var="evtImg" items="${goodsEventInfo.evtImageList }">
                                <img src="<c:out value="${evtImg.goodsImagePath }"/>" alt="이벤트 이미지" />
                            </c:forEach>
                        </div>--%>
						<c:forEach var="event" items="${goods.goodsEventList}">
							<div class="boxlist-area">
								<c:set var="eventUrl" value="#none"/>
								<c:if test="${not empty event.eventUrl}">
									<c:set var="eventUrl" value="${event.eventUrl}"/>
								</c:if>
								<a href="${eventUrl}" target="_blank">
									<div class="info-event-box border-box">
										<div class="img-area">
											<img src="${event.eventThumbnail}" alt="이벤트 썸네일" />
										</div>
										<div class="txt-area">
											<strong>${event.eventSj}</strong>
											<p>${event.eventCn}</p>
											<span class="time"><fmt:formatDate value="${event.eventBeginDt}" pattern="yyyy-MM-dd"></fmt:formatDate> - <fmt:formatDate value="${event.eventEndDt}" pattern="yyyy-MM-dd"></fmt:formatDate></span>
										</div>
											<%--	<c:if test="${not empty event.eventUrl}">
                                                    <a href="${event.eventUrl}" target="_blank" class="link-full">이벤트바로가기</a>
                                                </c:if>--%>
									</div>
								</a>
							</div>
						</c:forEach>
					</c:if>
					<h2 class="txt-hide">상세정보</h2>
					<div class="info-txt-area">
						<div style="margin-bottom:20px;">
							&lt;상품 필수정보고시&gt;
						</div>
						<dl>
							<c:if test="${not empty goods.orgplce }">
								<dt>원산지</dt>
								<dd><c:out value="${goods.orgplce  }"/></dd>
							</c:if>
							<c:if test="${not empty goods.modelNm }">
								<dt>모델명</dt>
								<dd><c:out value="${goods.modelNm }"/></dd>
							</c:if>
							<c:if test="${not empty goods.makr }">
								<dt>제조사</dt>
								<dd><c:out value="${goods.makr }"/></dd>
							</c:if>
							<%-- <c:if test="${not empty goods.brandNm }">
                                <dt>브랜드</dt>
                                <dd><a href="${CTX_ROOT }/shop/goods/brandGoodsList.do?searchGoodsBrandId=${goods.brandId}" style="text-decoration:underline;">
                                    <strong><c:out value="${goods.brandNm }"/>몰 상품보러가기</strong></a></dd>
                            </c:if> --%>
							<c:if test="${not empty goods.crtfcMatter }">
								<dt>인증사항</dt>
								<dd><c:out value="${goods.crtfcMatter }"/></dd>
							</c:if>
						</dl>
						<%-- <div class="txt-more">
                            <button type="button">필수표기정보 더보기 <i class="ico-arr-b sm back" aria-hidden="true"></i></button>
                            <div class="txt-area">
                                <c:out value="${goods.goodsIntrcn }"/>
                            </div>
                        </div> --%>
					</div>

					<c:if test="${not empty goods.mvpSourcCn }">
						<div class="info-video-area">
							<div class="video-box">
								<c:out value="${goods.mvpSourcCn }" escapeXml="false"/>
							</div>
						</div>
					</c:if>
					<div class="info-img-area">
						<div class="img-area">
							<div class="img-box view-content" id="detailImg">
								<c:out value="${goods.goodsCn }" escapeXml="false"/>
								<c:forEach var="imgItem" items="${goods.gdcImageList }" varStatus="status">
									<img src="<c:out value="${imgItem.goodsImagePath }"/>" alt="상세보기 이미지" />
									<c:if test="${(goods.goodsId eq'GOODS_00000000002002' || goods.goodsId  eq 'GOODS_00000000002012') && status.index eq 0}">
										<div class="video-box">
											<iframe width="560" height="315" src="https://www.youtube.com/embed/fKySZ_CRuKU?loop=1&playlist=fKySZ_CRuKU&rel=0" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
										</div>
									</c:if>
								</c:forEach>
							</div>
						</div>

						<div class="img-more">
							<a href="javascript:void(0);" class="btn-lg width spot2">상세정보 더보기 <i class="ico-arr-b sm back"></i></a>
						</div>
					</div>
				</section>
				<!--추천상품 -->
				<c:if test="${not empty goods.goodsRecomendList}">
					<section id="productRecoSwiper" class="product-recommend">
						<h3 class="sub-tit">추천상품</h3>
						<div class="product-recommend-swiper">
							<div class="swiper-container">
								<ul class="product-list-reco swiper-wrapper">
									<c:forEach var="item" items="${goods.goodsRecomendList}">
										<li class="swiper-slide">
											<a href="/shop/goods/goodsView.do?goodsId=${item.recomendGoodsId}" target="_blank">
												<div class="product-img-area">
													<img src="${item.goodsTitleImagePath}" alt="${item.goodsNm}"/>
													<%--<div class="label-info">
														<c:choose>
															<c:when test="${item.goodsKndCode eq 'SBS'}">
																<cite>구독상품</cite>
																<c:if test="${item.sbscrptCycleSeCode eq 'MONTH'}">
																	<strong>주단위</strong>
																</c:if>
																<c:if test="${item.sbscrptCycleSeCode eq 'WEEK'}">
																	<strong>월단위</strong>
																</c:if>
															</c:when>
															<c:otherwise>
															</c:otherwise>
														</c:choose>
													</div>--%>
												</div>
												<div class="product-txt-area">
													<h3>
															${item.goodsNm}
													</h3>
													<div class="price">
															<%--<strong><span><fmt:formatNumber type="number" pattern="#,###" value="${item.goodsPc}"/></span>원</strong>--%>
														<c:choose>
															<c:when test="${empty USER_ID && not empty item.mrktPc}">
																<strong><span> <fmt:formatNumber type="number" pattern="#,###" value="${item.mrktPc}"/></span>원</strong>
															</c:when>
															<c:when test="${empty USER_ID && empty item.mrktPc}">
																<strong><span> <fmt:formatNumber type="number" pattern="#,###" value="${item.goodsPc}"/></span>원</strong>
															</c:when>
															<c:otherwise>
																<strong><span> <fmt:formatNumber type="number" pattern="#,###" value="${item.goodsPc}"/></span>원</strong>
																<c:if test="${item.mrktUseAt eq 'Y'}">
																	<del><span><fmt:formatNumber type="number" pattern="#,###" value="${item.mrktPc}"/></span>원</del>
																</c:if>
															</c:otherwise>
														</c:choose>
													</div>
														<%-- <c:if test="${item.mrktUseAt eq 'Y'}">
                                                            <del><span><fmt:formatNumber type="number" pattern="#,###" value="${goods.mrktPc}"/></span>원</del>
                                                        </c:if> --%>
												</div>
											</a>
										</li>
									</c:forEach>
								</ul>
							</div>
						</div>
						<div class="swiper-prevnext">
							<div class="swiper-button-prev"><span>이전</span></div>
							<div class="swiper-button-next"><span>다음</span></div>
						</div>
					</section>
				</c:if>
				<!-- 리뷰 -->
				<section id="detail02" class="detail-review">
					<c:import url="/shop/goods/review/reviewList.do" charEncoding="utf-8"/>
				</section>

				<!-- QNA  -->
				<section id="detail03" class="detail-qa">
					<c:import url="/shop/goods/qainfo/qaInfo.do" charEncoding="utf-8">
					</c:import>
				</section>

				<!-- 교환/반품 안내 -->
				<section id="detail04" class="detail-etc">
					<%-- <c:import url="/shop/goods/goodsGuidance.do" charEncoding="utf-8">
                        <c:param name="cmpnyId" value="${goods.cmpnyId }"/>
                    </c:import> --%>
					<div class="sub-tit-area">
						<h2>교환/반품 안내</h2>
					</div>
					<ul class="border-list etc-list">
						<li>
							<cite>판매자 정보</cite>
							<div>
								업체명  : <c:out value="${cmpny.cmpnyNm }"/><br />
								<c:if test="${cmpny.cmpnyNm eq '폭스에듀'}">
									통신판매업신고번호 : 2022-성남분당C-0073<br />
								</c:if>
								<c:if test="${cmpny.cmpnyNm ne '폭스에듀'}">
									통신판매업신고번호 : <c:out value="${cmpny.bizrno }"/><br />
								</c:if>
								사업장 소재지 : <c:out value="${cmpny.bsnmAdres }"/><br />
								대표자 : <c:out value="${cmpny.rprsntvNm }"/><br />
								사업자등록번호 : <c:out value="${cmpny.bizrno }"/><br />
								소비자상담전화 : <c:out value="${goods.cnsltTelno }"/><br />
								이메일주소 : <c:out value="${cmpny.chargerEmail }"/><br />
								<c:if test="${not empty cmpny.csChnnl }">
									상담채널 : <a href="<c:out value="${cmpny.csChnnl}"/>" class="fc-spot" target="_blank">상담톡 바로가기 <i class="ico-arr-r gr sm"></i></a>
								</c:if>
								<p class="fs-sm fc-gr">* 상품정보에 오류가 있을 경우 고객센터(<c:out value="${goods.cnsltTelno }"/>)로 연락주시면 즉시 확인하도록 하겠습니다.</p>
							</div>
						</li>
						<c:choose>
							<%-- 폭스구독권(수강권) --%>
							<c:when test="${goods.goodsUpperCtgryId eq 'GCTGRY_0000000000032' || goods.goodsUpperCtgryId eq 'GCTGRY_0000000000037'}">
								<li>
									<cite>사용방법 문의 및<br /> 안내</cite>
									<div>
										<ol class="bullet">
											<li>구독권에 대해 문의 혹은 안내가 필요하실 경우,
												대표번호로 연락주시면 빠르게 도움 드리겠습니다.
											</li>
											<li>대표번호 : <c:out value="${goods.cnsltTelno }"/></li>
										</ol>
									</div>
								</li>
								<li>
									<c:choose>
										<c:when test="${goods.goodsUpperCtgryId eq 'GCTGRY_0000000000037'}">
											<cite>예약 변경 및 환불</cite>
										</c:when>
										<c:otherwise>
											<cite>해지 및 환불</cite>
										</c:otherwise>
									</c:choose>
									<div>
										<div class="info-type">
											<c:choose>
												<%-- [2월]방학 패키지 이용권(2/12~2/28) 상품 1회성 --%>
												<c:when test="${goods.goodsId eq 'GOODS_00000000001604'}">
													<p>1. 구독 해지  </p>
													<p class="fs-sm fc-gr mt10">- 구독해지 신청 시 다음 정기결제일부터 구독이 해지되며,</p>
													<p class="fs-sm fc-gr mt10">남은 구독기간동안 정상적으로 서비스를 이용할 수 있습니다.</p>
													<p>2. 구독 취소 및 환불  </p><p class="fs-sm fc-gr mt10">- 구독 해지 후 남은 이용기간에 대한 환불 요청 시 아래 기준에 따라 환불됩니다.</p>
													<table class="mt20 tbl-sm tbl-border-none">
														<caption>해지 및 환불 정보</caption>
														<thead>
														<tr>
															<th scop="col">환불신청 시점</th>
															<th scop="col">환불금액</th>
														</tr>
														</thead>
														<tbody>
														<!--<tr>
                                                            <td class="al">
                                                                <ul class="bullet">
                                                                    <li>구독권 사용일 전 혹은 사용 당일 환불 신청 시</li>
                                                                    <li>구독권 사용일 기준 구독기간 1/3 경과 전</li>
                                                                    <li>구독권 사용일 기준 구독기간 1/2 경과 전</li>
                                                                    <li>구독권 사용일 기준 구독기간 1/2 경과 후</li>
                                                                </ul>
                                                            </td>
                                                            <td class="al">
                                                                <ul class="bullet">
                                                                    <li>결제금액 전액</li>
                                                                    <li>결제금액의 2/3에 해당하는 금액</li>
                                                                    <li>결제금액의 1/2에 해당하는 금액</li>
                                                                    <li>반환하지 아니함</li>
                                                                </ul>
                                                            </td>
                                                        </tr>-->
														<tr>
															<td class="al">
																<ul class="bullet">
																	<li>구독권 사용일 전 혹은 사용 당일 환불 신청 시</li>
																</ul>
															</td>
															<td class="al">
																<ul class="bullet">
																	<li>결제금액 전액</li>
																</ul>
															</td>
														</tr>
														<tr>
															<td class="al">
																<ul class="bullet">
																	<li>구독권 사용일 기준 구독기간 1/3 경과 전</li>
																</ul>
															</td>
															<td class="al">
																<ul class="bullet">
																	<li>결제금액의 2/3에 해당하는 금액</li>
																</ul>
															</td>
														</tr>
														<tr>
															<td class="al">
																<ul class="bullet">
																	<li>구독권 사용일 기준 구독기간 1/2 경과 전</li>
																</ul>
															</td>
															<td class="al">
																<ul class="bullet">
																	<li>결제금액의 1/2에 해당하는 금액</li>
																</ul>
															</td>
														</tr>
														<tr>
															<td class="al">
																<ul class="bullet">
																	<li>구독권 사용일 기준 구독기간 1/2 경과 후</li>
																</ul>
															</td>
															<td class="al">
																<ul class="bullet">
																	<li>반환하지 아니함</li>
																</ul>
															</td>
														</tr>
														</tbody>
													</table>
													<p class="fs-sm fc-gr mt10">* 구독권 사용일은 폭스러닝센터 '오프라인 수업 첫 시작일'을 기준으로 합니다.</p>
													<p class="fs-sm fc-gr mt10">* 구독권 결제 후 2개월 이내에 센터를 통해 사용신청 해야 하며, 2개월 이상 미사용 시 환불됩니다.</p>
													<p class="fs-sm fc-gr">* 결제할 때 제공된 사은품 및 할인 혜택의 경우 금액으로 환산하여 환불금액에서 공제합니다.</p>
												</c:when>
												<c:when test="${goods.goodsUpperCtgryId eq 'GCTGRY_0000000000037'}">
													<ol class="bullet-demical">
														<li>
															예약 변경
															<ul class="bullet">
																<li>
																	예약 전날 19시 이전까지 변경 가능
																</li>
																<li>
																	예약 당일 일정 변경 불가
																</li>
															</ul>
														</li>
														<li class="mt20">
															예약 변경 방법
															<ul class="bullet">
																<li>
																	예약 전날까지 대표전화로 미리 연락주시면 일정 변경 도움 드리겠습니다.
																</li>
																<li>
																	대표번호 : 1433-2700
																</li>
															</ul>
														</li>
														<li class="mt20">
															환불 신청 방법
															<ul class="bullet">
																<li>
																	대표전화로 연락주시면 환불 신청일 기준으로 환불정책에 따라 처리됩니다.
																</li>
																<li>
																	대표번호 : 1433-2700
																</li>
															</ul>
														</li>
														<li class="mt20">
															환불 정책
															<ul class="bullet">
																<li>
																	예약 전날 19시 이후에는 환불 불가
																</li>
																<li>
																	당일 취소 및 사전 연락 없이 불참 시 환불 불가
																</li>
																<li>
																	다회 이용권 이용 개시 후  환불 신청 시, 환불 신청일 기준으로 이용한 횟수에 따라 회당비용을 차감하여 환불해드립니다.
																</li>
																<li>
																	다회 이용권(할인 상품) 부분 환불 신청 시, 회당 금액은 할인되지 않은 정가로 산정하여 차액을 환불해드립니다.</br>
																	ex) 10회권(10% 할인가 : 900,000원) 중 3회(정가 기준 : 300,000) 사용 후 환불 요청 시 →  총 600,000원 환불 가능
																</li>
															</ul>
														</li>
													</ol>

															</c:when>
					                                    	<c:otherwise>
																<p>1. 구독 해지  </p>
																<p class="fs-sm fc-gr mt10">- 구독해지 신청 시 다음 정기결제일부터 구독이 해지되며,</p>
																<p class="fs-sm fc-gr mt10">남은 구독기간동안 정상적으로 서비스를 이용할 수 있습니다.</p>
																<p>2. 구독 취소 및 환불  </p><p class="fs-sm fc-gr mt10">- 구독 해지 후 남은 이용기간에 대한 환불 요청 시 아래 기준에 따라 환불됩니다.</p>
																<table class="mt20 tbl-sm tbl-border-none">
																	<caption>해지 및 환불 정보</caption>
																	<thead>
																	<tr>
																		<th scop="col">환불신청 시점</th>
																		<th scop="col">환불금액</th>
																	</tr>
																	</thead>
																	<tbody>
																	<!--<tr>
                                                                        <td class="al">
                                                                            <ul class="bullet">
                                                                                <li>구독권 사용일 전 혹은 사용 당일 환불 신청 시</li>
                                                                                <li>구독권 사용일 기준 구독기간 1/3 경과 전</li>
                                                                                <li>구독권 사용일 기준 구독기간 1/2 경과 전</li>
                                                                                <li>구독권 사용일 기준 구독기간 1/2 경과 후</li>
                                                                            </ul>
                                                                        </td>
                                                                        <td class="al">
                                                                            <ul class="bullet">
                                                                                <li>결제금액 전액</li>
                                                                                <li>결제금액의 2/3에 해당하는 금액</li>
                                                                                <li>결제금액의 1/2에 해당하는 금액</li>
                                                                                <li>반환하지 아니함</li>
                                                                            </ul>
                                                                        </td>
                                                                    </tr>-->
																	<tr>
																		<td class="al">
																			<ul class="bullet">
																				<li>구독권 사용일 전 혹은 사용 당일 환불 신청 시</li>
																			</ul>
																		</td>
																		<td class="al">
																			<ul class="bullet">
																				<li>결제금액 전액</li>
																			</ul>
																		</td>
																	</tr>
																	<tr>
																		<td class="al">
																			<ul class="bullet">
																				<li>구독권 사용일 기준 구독기간 1/3 경과 전</li>
																			</ul>
																		</td>
																		<td class="al">
																			<ul class="bullet">
																				<li>결제금액의 2/3에 해당하는 금액</li>
																			</ul>
																		</td>
																	</tr>
																	<tr>
																		<td class="al">
																			<ul class="bullet">
																				<li>구독권 사용일 기준 구독기간 1/2 경과 전</li>
																			</ul>
																		</td>
																		<td class="al">
																			<ul class="bullet">
																				<li>결제금액의 1/2에 해당하는 금액</li>
																			</ul>
																		</td>
																	</tr>
																	<tr>
																		<td class="al">
																			<ul class="bullet">
																				<li>구독권 사용일 기준 구독기간 1/2 경과 후</li>
																			</ul>
																		</td>
																		<td class="al">
																			<ul class="bullet">
																				<li>반환하지 아니함</li>
																			</ul>
																		</td>
																	</tr>
																	</tbody>
																</table>
																<p class="fs-sm fc-gr mt10">* 구독권 사용일은 폭스러닝센터 '오프라인 수업 첫 시작일'을 기준으로 합니다.</p>
																<p class="fs-sm fc-gr mt10">* 구독권 결제 후 2개월 이내에 센터를 통해 사용신청 해야 하며, 2개월 이상 미사용 시 환불됩니다.</p>
																<p class="fs-sm fc-gr">* 결제할 때 제공된 사은품 및 할인 혜택의 경우 금액으로 환산하여 환불금액에서 공제합니다.</p>
					                                    	</c:otherwise>
					                                    </c:choose>
					                                </div>
					                            </div>
			                                </li>
										</c:when>
										<c:otherwise>
											<li>
												<cite>교환/반품 접수 안내</cite>
												<div>
													<ol class="bullet-demical">
														<li>마이페이지 &gt; 주문관리 &gt; 주문확인 으로 이동</li>
														<li>해당 주문건에서 [취소/교환/반품] 선택하여 접수 진행</li>
													</ol>
													<a href="${CTX_ROOT }/user/my/mySubscribeNow.do" class="fc-gr">접수하러 바로가기 <i class="ico-arr-r gr sm"></i></a>
												</div>
											</li>
											<li>
												<cite><span><c:out value="${cmpny.cmpnyNm }"/></span> 교환/반품 안내</cite>
												<div>
													<ol class="bullet-demical">
														<li>교환/반품에 관한 일반적인 사항은 판매자 제시사항보다 관계법령을 우선시합니다.</li>
														<li>교환/반품 관련 문의사항은 판매자 연락처 및 상품 상세 페이지의 Q&amp;A를 통하여 문의하여 주시기 바랍니다.													
															<ul class="bullet">
																<li>판매자 지정택배사 : 
																<c:choose>
																	<c:when test="${not empty brand.svcHdryNm}">
																		<c:out value="${brand.svcHdryNm}"/>
																	</c:when>
																	<c:otherwise>
																		<c:out value="${cmpny.svcHdryNm}"/>
																	</c:otherwise>
																</c:choose>
																</li>
																<li>반품 배송비 :
																	<c:choose>
																		<c:when test="${not empty brand.rtngudDlvyPc}">
																			<fmt:formatNumber type="number" pattern="#,###" value="${brand.rtngudDlvyPc}"/><c:if test="${not empty brand.rtngudDlvyPc}">원</c:if>
																		</c:when>
																		<c:otherwise>
																			<fmt:formatNumber type="number" pattern="#,###" value="${cmpny.rtngudDlvyPc}"/><c:if test="${not empty cmpny.rtngudDlvyPc}">원</c:if>
																		</c:otherwise>
																	</c:choose>
																	<c:if test="${empty cmpny.rtngudDlvyPc and empty brand.rtngudDlvyPc}">판매자의 정책에 따름</c:if>
																</li>
																<li>교환 배송비 :
																	<c:choose>
																		<c:when test="${not empty brand.exchngDlvyPc}">
																			<fmt:formatNumber type="number" pattern="#,###" value="${brand.exchngDlvyPc}"/><c:if test="${not empty brand.exchngDlvyPc}">원</c:if>
																		</c:when>
																		<c:otherwise>
																			<fmt:formatNumber type="number" pattern="#,###" value="${cmpny.exchngDlvyPc}"/><c:if test="${not empty cmpny.exchngDlvyPc}">원</c:if>
																		</c:otherwise>
																	</c:choose>
																	<c:if test="${empty cmpny.exchngDlvyPc and empty brand.exchngDlvyPc}">판매자의 정책에 따름</c:if>
																</li>
																<li>보내실 곳 :
																<c:choose>
																	<c:when test="${not empty brand.svcAdres}">
																		<c:out value="${brand.svcAdres}"/>
																	</c:when>
																	<c:otherwise>
																		<c:out value="${cmpny.svcAdres}"/>
																	</c:otherwise>
																</c:choose></li>
															</ul>
														</li>
													</ol>
												</div>
											</li>
											<li>
												<cite>교환/반품 사유에 따른 요청 기간</cite>
												<div>
													<p>반품 시 먼저 판매자와 연락하셔서 반품사유, 택배사, 배송비, 반품지 주소 등을 협의하신 후 반품상품을 발송해 주시기 바랍니다.</p>
													<ul class="bullet">
														<li>
															구매자 단순변심 : 상품 수령 후 7일 이내 (구매자 <strong>반품배송비</strong> 부담)
														</li>
														<li>
															표시/광고와 상이, 상품하자 : 상품 수령 후 3개월 이내 혹은 표시/광고와 다른 사실을 안 날로부터 30일 이내 (판매자 반품배송비 부담) 둘 중 하나 경과 시 반품/교환 불가
														</li>
													</ul>
												</div>
											</li>
											<li>
												<cite>교환/반품 불가능 사유</cite>
												<div>
													<p>아래와 같은 경우 반품/교환이 불가능합니다.</p>
		
													<ol class="bullet-demical">
														<li>
															반품요청기간이 지난 경우
														</li>
														<li>
															구매자의 책임 있는 사유로 상품 등이 멸실 또는 훼손된 경우(단, 상품의 내용을 확인하기 위하여 포장 등을 훼손한 경우는 제외)
														</li>
														
														<li>
															구매자의 책임있는 사유로 포장이 훼손되어 상품 가치가 현저히 상실된 경우 (예: 식품, 화장품, 향수류, 음반 등)
														</li>
														
														<li>
															구매자의 사용 또는 일부 소비에 의하여 상품의 가치가 현저히 감소한 경우 (라벨이 떨어진 의류 또는 태그가 떨어진 명품관 상품인 경우)
														</li>
														
														<li>
															시간의 경과에 의하여 재판매가 곤란할 정도로 상품 등의 가치가 현저히 감소한 경우
														</li>
														
														<li>
															고객의 요청사항에 맞춰 제작에 들어가는 맞춤제작상품의 경우(판매자에게 회복불가능한 손해가 예상되고, 그러한 예정으로 청약철회권 행사가 불가하다는 사실을 서면 동의 받는 경우)
														</li>
														<li>
															복제가 가능한 상품 등의 포장을 훼손한 경우(CD/DVD/GAME/도서의 경우 포장 개봉 시)
														</li>
														
													</ol>
												</div>
											</li>
										</c:otherwise>
									</c:choose>
									
								</ul>
						</section>
					</div>
					<div class="product-buy-area">
						<div class="sticky">
						<c:choose>
							<c:when test="${goods.soldOutAt eq 'Y'}">
							<div class="toggle-area">
								<div class="info-area">
									<!--<a href="none" class="btn-link">델몬트</a>-->
									<h2><c:out value="${goods.goodsNm }"/></h2>
									<div class="price">
										<strong><span><c:if test="${goods.sbscrptCycleSeCode eq 'MONTH' }">월</c:if> <fmt:formatNumber type="number" pattern="#,###" value="${goods.goodsPc}"/></span> 원</strong>
									</div>
									<c:if test="${user.groupId ne 'GROUP_00000000000001'}">
									 <div class="info-fnc-area">
										<div class="layerpopup-sm-area share-area">
											<button type="button" class="btn-layerpopup-sm"><i class="ico-share"></i><span class="txt-hide">공유하기</span></button>
											<div class="layerpopup-sm">
												<!--<div class="pop-header">
													<h1>공유하기</h1>
												</div>-->
												<div class="pop-body">
													<div class="share">
														<button type="button" id="kakaoShare" data-title='${goods.goodsNm}' data-description='${goods.goodsIntrcn}' data-link='${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}' data-imageurl='${imageUrl}'><i class="ico-sns-kakao-spot lg"></i><span class="txt-hide">카카오톡</span></button>
														<%--<button type="button" id="facebookShare" data-title='${goods.goodsNm}' data-description='${goods.goodsIntrcn}' data-link='${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}' data-imageurl='${imageUrl}'><i class="ico-sns-facebook-spot lg"></i><span class="txt-hide">페이스북</span></button>--%>
														<!-- <button type="button"><i class="ico-sns-instagram-spot lg"></i><span class="txt-hide">인스타그램</span></button> -->
														<%--<button type="button" id="twitterShare" data-title='${goods.goodsNm}' data-description='${goods.goodsIntrcn}' data-link='${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}' data-imageurl='${imageUrl}'><i class="ico-sns-twitter-spot lg"></i><span class="txt-hide">트위터</span></button>--%>
														<%--<button type="button" id="naverShare" data-title='${goods.goodsNm}' data-description='${goods.goodsIntrcn}' data-link='${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}' data-imageurl='${imageUrl}'><i class="ico-sns-naverblog-spot lg"></i><span class="txt-hide">네이버블로그</span></button>--%>
														<button type="button" id="clipBoard" onclick="urlClipCopy('${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}');"><i class="ico-sns-url-spot lg"></i><span class="txt-hide">URL</span></button>
													</div>
												</div>
												<button type="button" class="btn-close">닫기</button>
											</div>
										</div>
									</div>
									</c:if>
								</div>
								<div class="fnc-area">
									<div class="info-box">
										<i class="ico-soldout"></i>
										<p>일시품절 입니다.</p>
									</div>
								</div>
							</div>
							</c:when>
							<c:when test="${adultCrtYn ne 'Y' && goods.adultCrtAt eq 'Y'}">
							<div class="toggle-area">
								<div class="info-area">
									<!--<a href="none" class="btn-link">델몬트</a>-->
									<h2><c:out value="${goods.goodsNm }"/></h2>
									<div class="price">
										<strong><span><c:if test="${goods.sbscrptCycleSeCode eq 'MONTH' }">월</c:if> <fmt:formatNumber type="number" pattern="#,###" value="${goods.goodsPc}"/></span> 원</strong>
									</div>
									 <div class="info-fnc-area">
										<div class="layerpopup-sm-area share-area">
											<button type="button" class="btn-layerpopup-sm"><i class="ico-share"></i><span class="txt-hide">공유하기</span></button>
											<div class="layerpopup-sm">
												<!--<div class="pop-header">
													<h1>공유하기</h1>
												</div>-->
												<div class="pop-body">
													<div class="share">
														<button type="button" id="kakaoShare" data-title='${goods.goodsNm}' data-description='${goods.goodsIntrcn}' data-link='${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}' data-imageurl='${imageUrl}'><i class="ico-sns-kakao-spot lg"></i><span class="txt-hide">카카오톡</span></button>
														<%--<button type="button" id="facebookShare" data-title='${goods.goodsNm}' data-description='${goods.goodsIntrcn}' data-link='${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}' data-imageurl='${imageUrl}'><i class="ico-sns-facebook-spot lg"></i><span class="txt-hide">페이스북</span></button>--%>
														<!-- <button type="button"><i class="ico-sns-instagram-spot lg"></i><span class="txt-hide">인스타그램</span></button> -->
														<%--<button type="button" id="twitterShare" data-title='${goods.goodsNm}' data-description='${goods.goodsIntrcn}' data-link='${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}' data-imageurl='${imageUrl}'><i class="ico-sns-twitter-spot lg"></i><span class="txt-hide">트위터</span></button>--%>
														<%--<button type="button" id="naverShare" data-title='${goods.goodsNm}' data-description='${goods.goodsIntrcn}' data-link='${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}' data-imageurl='${imageUrl}'><i class="ico-sns-naverblog-spot lg"></i><span class="txt-hide">네이버블로그</span></button>--%>
														<button type="button" id="clipBoard" onclick="urlClipCopy('${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}');"><i class="ico-sns-url-spot lg"></i><span class="txt-hide">URL</span></button>
													</div>
												</div>
												<button type="button" class="btn-close">닫기</button>
											</div>
										</div>
									</div>
								</div>
								  <div class="fnc-area">
									<div class="info-box">
										<i class="ico-adult vt"></i>
										<p>
											본 상품은 청소년 유해매체물로서 19세 미만의 청소년이 이용할 수 없습니다.<br />
											이용을 원하시면 (청소년보호법에 따라) 나이 및 본인 여부를 확인해 주시기 바랍니다.
										</p>
									</div>
									<ul class="bullet sm">
										<li>본인인증시 입력하신 모든 정보는 항상 암호화되어 처리되며, 본인확인 외에 다른 목적으로 사용되지 않습니다.</li>
										<li>고객님께서 입력하신 정보는 NICE신용평가정보(주)에 제공됩니다.</li>
									</ul>
								</div>
								</div>
								<button type="button" class="btn-option-toggle">옵션토글버튼</button>
								<div class="btn-area">
									<c:choose>
										<c:when test="${not empty USER_ID}">
											<button type="button" class="btn-lg spot adultCrtBtn">인증 후 구독하기 <i class="ico-arr-r sm back wh" aria-hidden="true"></i></button>
										</c:when>
										<c:otherwise>
											<button type="button"  onclick="popOpen('popupOrder')" class="btn-lg spot">인증 후 구독하기 <i class="ico-arr-r sm back wh" aria-hidden="true"></i></button>
										</c:otherwise>
									</c:choose>
								</div>
								</c:when>
								<c:otherwise>
								<div class="toggle-area">
									<div class="info-area">
										<!--<a href="none" class="btn-link">델몬트</a>-->
										<h2><c:out value="${goods.goodsNm }"/></h2>
										<div class="price">
											<c:choose>
												<c:when test="${empty USER_ID && not empty goods.mrktPc}">
													<strong><span><c:if test="${goods.sbscrptCycleSeCode eq 'MONTH' }">월</c:if> <fmt:formatNumber type="number" pattern="#,###" value="${goods.mrktPc}"/></span>원</strong>
												</c:when>
												<c:otherwise>
													<strong><span><c:if test="${goods.sbscrptCycleSeCode eq 'MONTH' }">월</c:if> <fmt:formatNumber type="number" pattern="#,###" value="${goods.goodsPc}"/></span>원</strong>
													<c:if test="${goods.mrktUseAt eq 'Y'}">
														<del><span><fmt:formatNumber type="number" pattern="#,###" value="${goods.mrktPc}"/></span>원</del>
													</c:if>
												</c:otherwise>
											</c:choose>
										</div>
										<c:if test="${user.groupId ne 'GROUP_00000000000001'}">
										 <div class="info-fnc-area">
											<div class="layerpopup-sm-area share-area">
												<button type="button" class="btn-layerpopup-sm"><i class="ico-share"></i><span class="txt-hide">공유하기</span></button>
												<div class="layerpopup-sm">
													<!--<div class="pop-header">
														<h1>공유하기</h1>
													</div>-->
													<div class="pop-body">
														<div class="share">
															<button type="button" id="kakaoShare" data-title='${goods.goodsNm}' data-description='${goods.goodsIntrcn}' data-link='${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}' data-imageurl='${imageUrl}'><i class="ico-sns-kakao-spot lg"></i><span class="txt-hide">카카오톡</span></button>
															<%--<button type="button" id="facebookShare" data-title='${goods.goodsNm}' data-description='${goods.goodsIntrcn}' data-link='${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}' data-imageurl='${imageUrl}'><i class="ico-sns-facebook-spot lg"></i><span class="txt-hide">페이스북</span></button>--%>
															<!-- <button type="button"><i class="ico-sns-instagram-spot lg"></i><span class="txt-hide">인스타그램</span></button> -->
															<%--<button type="button" id="twitterShare" data-title='${goods.goodsNm}' data-description='${goods.goodsIntrcn}' data-link='${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}' data-imageurl='${imageUrl}'><i class="ico-sns-twitter-spot lg"></i><span class="txt-hide">트위터</span></button>--%>
															<%--<button type="button" id="naverShare" data-title='${goods.goodsNm}' data-description='${goods.goodsIntrcn}' data-link='${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}' data-imageurl='${imageUrl}'><i class="ico-sns-naverblog-spot lg"></i><span class="txt-hide">네이버블로그</span></button>--%>
															<button type="button" id="clipBoard" onclick="urlClipCopy('${BASE_URL}/shop/goods/goodsView.do?goodsId=${goods.goodsId}');"><i class="ico-sns-url-spot lg"></i><span class="txt-hide">URL</span></button>
														</div>
													</div>
													<button type="button" class="btn-close">닫기</button>
												</div>
											</div>
										</div>
										</c:if>
									</div>
								<div class="fnc-area">
									<div class="option-check-area">
									<c:if test="${goods.exprnUseAt eq 'Y'}">
											<div class="option-check is-active">
												<button type="button" class="btn-option-check" data-buytype="subscribe"><span class="txt-hide">정기구독 선택</span></button>
												<span class="txt">정기구독</span>
											</div>
											<div class="option-check">
												<button type="button" class="btn-option-check" name="exprnUseAt" data-buytype="experience"><span class="txt-hide">1회 체험 선택</span></button>
												<!-- <label><input type="checkbox" name="exprnUseAt" value="Y" class="optioncheck"/></label> -->
												<span class="txt">1회 체험 구매</span>
												<div class="tooltip-area">
													<button type="button" class="btn-tooltip">
														<i class="ico-info"></i>
													</button>
													<div class="popup-tooltip">
														<div class="pop-header">
															<h1>1회 체험 구매</h1>
															<button type="button" class="btn-close">닫기</button>
														</div>
														<div class="pop-body">
															<p>
																1회 체험 구매를 선택하면 한 번만 결제가 이루어지며,
																구독상품을 체험해 보실 수 있습니다.
															</p>
														</div>
													</div>
												</div>
												<%-- <div class="price">
												<c:choose>
													<c:when test="${goods.exprnPc ge '0'}">
														+<fmt:formatNumber type="number" pattern="#,###" value="${goods.exprnPc}"/>원
													</c:when>
													<c:otherwise>
														<fmt:formatNumber type="number" pattern="#,###" value="${goods.exprnPc}"/>원
													</c:otherwise>
												</c:choose>
												</div> --%>
											</div>
										</c:if>
								</div>


							<div class="option-area">
								<ul class="option-list">
									<c:if test="${goods.chldrnnmUseAt eq 'Y'}">
										<li>
											<cite>자녀</cite>
											<select class="chdr" name="chdr.chdrId">
												<option value="0">선택</option>
											</select>
											<input type="text" class="chdrNm mt10" name="chdr.chdrNm" style="display: none;"/>
												<%--&lt;%&ndash;<span class="fs-sm fc-gr block">* 폭스러닝센터 상품일 경우, 자녀의 이름을 입력해주세요.</span>&ndash;%&gt;--%>
										</li>
									</c:if>

									<c:if test="${goods.optnUseAt eq 'Y' }">
										<c:if test="${goods.qOptnUseAt eq 'Y' and fn:length(goods.qGitemList) gt 0}">
											<li class="qOptionLi">
												<cite>업체 요청사항<span class="required"></span></cite>
												<c:forEach var="opt" items="${goods.qGitemList }" varStatus="status">
													<input type="hidden" class="qopt_${status.index}" value="${opt.gitemId }"/>
													<input type="text" class="p10 gitemAnswer" data-answerid="gitemAnswer_${status.index}" placeholder="${opt.gitemNm }"  />
												</c:forEach>
											</li>
										</c:if>
									</c:if>

									<c:if test="${goods.goodsKndCode eq 'SBS'}">
										<c:if test="${goods.fOptnUseAt eq 'Y' }">
											<li>
												<cite>첫구독옵션</cite>
												<select name="cartItemList[${orderItemNo }].gitemId" id="fOptOption" class="fOpt orderOption" title="옵션선택">
													<option value="">첫 구독 옵션을 선택하세요</option>
													<c:forEach var="opt" items="${goods.fGitemList }">
														<c:if test="${opt.gitemPc gt 0}">
															<c:set var="pc" value="(+${opt.gitemPc}원)"/>
														</c:if>
														<c:if test="${opt.gitemPc lt 0}">
															<c:set var="pc" value="(${opt.gitemPc}원)"/>
														</c:if>
														<c:if test="${opt.gitemPc eq 0}">
															<c:set var="pc" value=""/>
														</c:if>
														<c:choose>
															<c:when test="${opt.gitemSttusCode eq 'F'}">
																<option value="${opt.gitemId }" disabled="disabled">${opt.gitemNm }${pc}(품절)</option>
															</c:when>
															<c:otherwise>
																<option value="${opt.gitemId }" data-pc="${opt.gitemPc }">${opt.gitemNm }${pc}</option>
															</c:otherwise>
														</c:choose>
													</c:forEach>
												</select>
												<p class="msg">
													첫 구독옵션은 첫 주문시에만 결제,배송되며 2회차부터는 결제,배송되지 않습니다.
												</p>
											</li>
											<c:set var="orderItemNo" value="${orderItemNo + 1 }"/>
										</c:if>
										<c:choose>
											<c:when test="${goods.sbscrptCycleSeCode eq 'WEEK' }"> <%-- 주 구독 --%>
												<li>
													<cite>구독주기</cite>
													<select class="sbscrptWeekCycle" title="주기 선택">
														<c:if test="${fn:length(goods.sbscrptWeekCycleList) gt 1 }">
															<option value="">주기를 선택하세요.</option>
														</c:if>
														<c:forEach var="week" items="${goods.sbscrptWeekCycleList }">
															<option value="${week }">${week }주</option>
														</c:forEach>
													</select>
												</li>
												<li>
													<cite>정기결제요일</cite>
													<select class="sbscrptDlvyWd" title="정기결제요일 선택">
														<option>정기결제요일 선택하세요.</option>
														<c:forEach var="code" items="${wdCodeList }">
															<c:forEach var="wd" items="${goods.sbscrptDlvyWdList }">
																<c:if test="${code.code eq wd}">
																	<option value="${code.code }">${code.codeNm }</option>
																</c:if>
															</c:forEach>
														</c:forEach>
													</select>
												</li>
											</c:when>
											<c:when test="${goods.sbscrptCycleSeCode eq 'MONTH' }"> <%--월 구독 --%>
												<li>
													<cite>구독주기</cite>
													<select class="sbscrptMtCycle" title="주기를 선택">
														<c:if test="${fn:length(goods.sbscrptMtCycleList) gt 1 }">
															<option value="">주기를 선택하세요.</option>
														</c:if>
														<c:forEach var="month" items="${goods.sbscrptMtCycleList }">
															<option value="${month }">${month }개월</option>
														</c:forEach>
													</select>
												</li>
												<li class="">
													<cite>정기결제일</cite>
													<div class="datepicker-area">
														<c:choose>
															<c:when test="${not empty goods.sbscrptDlvyDay }">
																<c:choose>
																	<c:when test="${goods.sbscrptDlvyDay eq '0'}"> <%-- 결제일 기준 --%>
																		<input type="hidden" class="sbscrptDlvyDay" value="${today}"/>
																		<input type="text" disabled value="${today } 일"/>
																	</c:when>
																	<c:otherwise>
																		<input type="hidden" class="sbscrptDlvyDay" value="${goods.sbscrptDlvyDay }"/>
																		<input type="text"  disabled value="${goods.sbscrptDlvyDay } 일"/>
																	</c:otherwise>
																</c:choose>
															</c:when>
															<c:otherwise>
																<input type="text" class="datepicker-input sbscrptDlvyDay testday" placeholder="결제일을 선택하세요" title="결제일을 선택" readonly />
																<button class="btn-datepicker-toggle" type="button"><span class="text-hide"></span></button>
															</c:otherwise>
														</c:choose>
													</div>
												</li>
											</c:when>
										</c:choose>
									</c:if>

									<%--<c:if test="${(goods.optnUseAt eq 'N' or (goods.optnUseAt eq 'Y' and goods.dOptnUseAt eq 'N')) and goods.goodsKndCode eq 'GNR'}">
										<li>
											<cite>수량</cite>
											<div>
												<div class="count tempCount">
													<button type="button" class="btn-minus tempGoodsCo"><span class="txt-hide">빼기</span></button>
													<input type="number" id="orderCo"  class="goodsOrderCo inputNumber" min="1" max="9999"  value="1" disabled  title="수량 입력" maxlength="4" />
													<button type="button" class="btn-plus tempGoodsCo" ><span class="txt-hide">더하기</span></button>
												</div>
													&lt;%&ndash;<c:if test="${goods.compnoDscntUseAt eq 'Y'}">
														<p class="msg mt10">2개 이상 구매시 개당 ${-goods.compnoDscntPc}원이 할인됩니다.</p>
													</c:if>&ndash;%&gt;
											</div>
										</li>
									</c:if>--%>

									<%--<c:if test="${goods.optnUseAt eq 'N'}">
										<li>
											<cite>수량</cite>
											<div>
												<div class="count">
													<button type="button" class="btn-minus" disabled><span class="txt-hide">빼기</span></button>
													<input type="number" id="orderCo"  class="orderCo inputNumber" min="1" max="9999" disabled="${countDisabled}"  value="1"  title="수량 입력${goods.chldrnnmUseAt}" maxlength="4" />
													<button type="button" class="btn-plus" disabled="${countDisabled}"><span class="txt-hide">더하기</span></button>
												</div>
												<c:if test="${goods.compnoDscntUseAt eq 'Y'}">
													<p class="msg mt10">2개 이상 구매시 개당 ${-goods.compnoDscntPc}원이 할인됩니다.</p>
												</c:if>
											</div>
										</li>
									</c:if>--%>
									<c:if test="${goods.optnUseAt eq 'Y' }">
										<c:set var="orderItemNo" value="0"/>
										<c:if test="${goods.dOptnUseAt eq 'Y' }">
											<c:set var="optnList1" value="${fn:split(goods.optnComList[0].optnValue, ',')}"/>
											<c:set var="optnList2" value="${fn:split(goods.optnComList[1].optnValue, ',')}"/>
											<li>
												<cite>기본옵션</cite>
												<select name="cartItemList[${orderItemNo }].gitemId" id="orderOption1"  class="dOpt1 orderOption" title="옵션선택">
													<option value="">${goods.optnComList[0].optnName}</option>
													<c:choose>
														<c:when test="${not empty goods.optnComList[1].optnValue}">
															<c:forEach var="opt1" items="${optnList1}">
																<option value="${opt1}">${opt1 }</option>
															</c:forEach>
														</c:when>
														<c:otherwise>
															<c:forEach var="opt1" items="${goods.dGitemList}">
																<option value="${opt1.gitemId}" data-gitemnm="${opt1.gitemNm}" data-price="${opt1.gitemPc}" data-count="${goods.dOptnType eq 'A' ? goods.goodsCo : opt1.gitemCo}">${opt1.gitemNm }</option>
															</c:forEach>
														</c:otherwise>
													</c:choose>

												</select>
												<c:if test="${fn:length(goods.optnComList) > 1}">
													<select name="cartItemList[${orderItemNo }].gitemId" id="orderOption2"  class="dOpt2 orderOption" title="옵션선택">
														<option value="">${goods.optnComList[1].optnName}</option>
													</select>
												</c:if>
											</li>
											<c:set var="orderItemNo" value="${orderItemNo + 1 }"/>
										</c:if>

										<c:if test="${goods.aOptnUseAt eq 'Y' }">
											<li>
												<cite>추가옵션</cite>
												<select name="cartItemList[${orderItemNo }].gitemId" class="aOpt orderOption" title="옵션선택">
													<option value="">옵션을 선택하세요</option>
													<c:forEach var="opt" items="${goods.aGitemList }">
														<c:if test="${opt.gitemPc gt 0}">
															<c:set var="pc" value="(+${opt.gitemPc}원)"/>
														</c:if>
														<c:if test="${opt.gitemPc lt 0}">
															<c:set var="pc" value="(${opt.gitemPc}원)"/>
														</c:if>
														<c:if test="${opt.gitemPc eq 0}">
															<c:set var="pc" value=""/>
														</c:if>
														<c:choose>
															<c:when test="${opt.gitemSttusCode eq 'F'}">
																<option value="${opt.gitemId }" disabled="disabled">${opt.gitemNm }${pc}(품절)</option>
															</c:when>
															<c:otherwise>
																<option value="${opt.gitemId }" data-pc="${opt.gitemPc }">${opt.gitemNm }${pc}</option>
															</c:otherwise>
														</c:choose>
													</c:forEach>
												</select>
											</li>
											<c:set var="orderItemNo" value="${orderItemNo + 1 }"/>
										</c:if>
									</c:if>
								</ul>
							</div>
							<c:if test="${goods.sOptnUseAt eq 'Y' and goods.optnUseAt eq 'Y'}">
								<div class="option-area">
									<ul class="option-list">
										<li>
											<cite>추가상품</cite>
											<select name="cartItemList[${orderItemNo }].gitemId" class="sOpt orderOption" title="옵션선택">
												<option value="">옵션을 선택하세요</option>
												<c:forEach var="opt" items="${goods.sGitemList }">
													<c:if test="${opt.gitemPc gt 0}">
														<c:set var="pc" value="(+${opt.gitemPc}원)"/>
													</c:if>
													<c:if test="${opt.gitemPc lt 0}">
														<c:set var="pc" value="(${opt.gitemPc}원)"/>
													</c:if>
													<c:if test="${opt.gitemPc eq 0}">
														<c:set var="pc" value=""/>
													</c:if>
													<c:choose>
														<c:when test="${opt.gitemSttusCode eq 'F'}">
															<option value="${opt.gitemId }" disabled="disabled">${opt.gitemNm }${pc}(품절)</option>
														</c:when>
														<c:otherwise>
															<option value="${opt.gitemId }" data-pc="${opt.gitemPc }">${opt.gitemNm }${pc}</option>
														</c:otherwise>
													</c:choose>
												</c:forEach>
											</select>
										</li>
									</ul>
								</div>
							</c:if>
							<div class="bg-area">
								<ul class="option-select-area">
									<c:if test="${goods.optnUseAt eq 'N'  and (goods.goodsKndCode eq 'GNR' or goods.goodsKndCode eq 'CPN')}">
										<li class="goodsLi">
											<div class="count">
												<button type="button" class="btn-minus sm"><span class="txt-hide">빼기</span></button>
												<input type="number" value="1" class="orderCo inputNumber" min="1" max="" title="수량 입력" maxlength="4" readonly="">
												<button type="button" class="btn-plus sm"><span class="txt-hide">더하기</span></button>
											</div>
											<div class="price"><fmt:formatNumber type="number" pattern="#,###" value="${goods.goodsPc}"/>원</div>
										</li>
									</c:if>
								</ul>
								<div class="total-area">
									<cite>결제금액</cite>
									<div class="price">
										<strong><span class="totPrice">0</span> 원</strong>
									</div>
								</div>
							</div>
						</div>
					</div>
					<button type="button" class="btn-option-toggle">옵션토글버튼</button>
					<div class="btn-area">
						<c:choose>
							<c:when test="${fn:contains(USER_ROLE,'ROLE_SHOP') and not fn:contains(USER_ROLE, 'ROLE_EMPLOYEE')}">
								<button type="button" class="btn-lg spot2" disabled>장바구니 담기</button>
								<button type="button" class="btn-lg spot2 btnOrderText" disabled>
									<c:choose>
										<c:when test="${goods.goodsKndCode eq 'SBS'}">구독하기</c:when>
										<c:otherwise>구매하기</c:otherwise>
									</c:choose>
									<i class="ico-arr-r sm back wh" aria-hidden="true"></i></button>
							</c:when>
							<c:when test="${empty USER_ID }">
								<button type="button" class="btn-lg" data-popup-open="popupOrder" onclick="popOpen('popupOrder');">장바구니 담기</button>
								<button type="button" class="btn-lg spot btnOrderText" data-popup-open="popupOrder" onclick="popOpen('popupOrder');">
									<c:choose>
										<c:when test="${goods.goodsKndCode eq 'SBS'}">
											구독하기
										</c:when>
										<c:otherwise>
											구매하기
										</c:otherwise>
									</c:choose>
									<i class="ico-arr-r sm back wh" aria-hidden="true"></i></button>
							</c:when>
							<c:otherwise>
								<!--<label class="btn-zzim"><input type="checkbox" title="찜" /></label>-->
								<button type="button" class="btn-lg btnCart" data-order-mode="CART"  onclick="popOpen('popupCart');">장바구니 담기</button>
								<button type="button" class="btn-lg spot btnOrder btnOrderText" data-order-mode="SBS">
									<c:choose>
										<c:when test="${goods.goodsKndCode eq 'SBS'}">
											구독하기
										</c:when>
										<c:otherwise>
											구매하기
										</c:otherwise>
									</c:choose>
									<i class="ico-arr-r sm back wh" aria-hidden="true"></i></button>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
				</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
</div>

<div class="popup-alert" data-popup="popupOrder">
	<form id="goodsViewLoginForm" name="goodsViewLoginForm" method="get" action="${CTX_ROOT }/user/sign/loginUser.do">
		<input type="hidden" name="refUrl" value="${requestScope['javax.servlet.forward.request_uri']}?${requestScope['javax.servlet.forward.query_string']}"/>
		<div class="pop-body">
			로그인 후 이용이 가능합니다.
		</div>
		<div class="pop-footer">
			<button type="button" data-popup-close="popupOrder" onclick="popClose('popupOrder');">취소</button>
			<button type="submit" class="spot2">로그인</button>
		</div>
	</form>
</div>

<div class="popup-alert" data-popup="popupCart">
	<div class="pop-body">
		장바구니에 상품을 담겠습니까?
	</div>
	<div class="pop-footer">
		<button type="button" data-popup-close="popupCart" onclick="popClose('popupCart');">아니오</button>
		<button type="button" id="btnAddCart" class="spot2">예</button>
	</div>
</div>

<div class="popup-alert" data-popup="popupCartCmplt">
	<div class="pop-body">
		<p class="pop-message">장바구니에 상품이 담겼습니다.</p>
	</div>
	<div class="pop-footer">
		<button type="button" data-popup-close="popupCart" onclick="popClose('popupCartCmplt');">닫기</button>
		<button type="button" class="spot2" onclick="fnCartMove('${goods.goodsKndCode}')">장바구니로 이동</button>
	</div>
</div>

<!--성인인증정보-->
<c:if test="${not empty iniCertInfo and goods.adultCrtAt eq 'Y'}">
	<form name="reqfrm" id="reqfrm" method="post" action="https://cas.inicis.com/casapp/ui/cardauthreq" style="display: none;">
		<input type="hidden" id="mid" name="mid" value="${iniCertInfo.mid }">
		<input type="hidden" id="Siteurl" name="Siteurl" value="${iniCertInfo.siteurl }">
		<input type="hidden" id="Tradeid" name="Tradeid" value="${iniCertInfo.tradeid }">
		<input type="hidden" id="DI_CODE" name="DI_CODE" value="${iniCertInfo.diCode}">
		<input type="hidden" id="MSTR" name="MSTR" value="${iniCertInfo.mstr}">
		<input type="hidden" id="Closeurl" name="Closeurl" value="${iniCertInfo.closeUrl}">
		<input type="hidden" id="Okurl" name="Okurl" value="${iniCertInfo.okUrl}">
	</form>
</c:if>
</div>

<template>
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
</template>

<javascript>
	<script src="${CTX_ROOT }/resources/front/shop/goods/info/js/goodsView.js"></script>
	<script src="${CTX_ROOT }/resources/front/shop/goods/qna/js/qainfo.js"></script>
	<script src="${CTX_ROOT}/resources/front/shop/goods/comment/js/comment.js"></script>
	<script src="${CTX_ROOT}/resources/front/cmm/etc/js/kakaoApi.js"></script>
	<%-- <c:if test="${viewMode eq 'Y' }">
    <script>
        modooAlert('해당 상품은 등록대기 상품으로 구매 하실 수 없습니다.');
    </script>
    </c:if> --%>
</javascript>

</body>
</html>
