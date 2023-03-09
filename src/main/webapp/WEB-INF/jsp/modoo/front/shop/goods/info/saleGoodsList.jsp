<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/modoo/common/commonTagLibs.jsp"%>

<c:if test="${not empty resultList and fn:length(resultList) > 0}">
	<section class="mn-product" id="saleGoods">
	<div class="wrap">
		<div class="mn-tit-area">
			<h2 class="mn-tit">BEST 상품</h2>
			<p>폭스에서 추천하는 BEST</p>
		</div>
		<div class="product-swiper">
			<div class="swiper-container">
				<ul class="product-list swiper-wrapper">
					<c:forEach var="result" items="${resultList}" varStatus="status">
						<li class="swiper-slide">
							<a href="${CTX_ROOT }/shop/goods/goodsView.do?goodsId=${result.goodsId}">
								<div class="product-img-area">
									<img src="<c:out value="${result.goodsLrgeImagePath }"/>" alt="${result.goodsNm }" />
									<c:set var="mainLabelCnt" value="0"/>
									<c:if test="${not empty result.goodsMainLabelList}">
										<div class="label-area">
											<c:forEach var="labelItem" items="${result.goodsMainLabelList}" varStatus="status">
												<c:set var="mainLabelCnt" value="${mainLabelCnt+1}"/>
												<c:if test="${mainLabelCnt < 3}">
													<c:choose>
														<c:when test="${labelItem.labelTy eq 'IMG'}">
															<span class="label-img"><img src="${labelItem.labelImgPath}" alt=""></span>
														</c:when>
														<c:otherwise>
												<span class="label-r-lg" style="background-color: ${labelItem.labelColor}">
													<cite>${labelItem.labelCn}</cite>
													<strong>${labelItem.labelCn2}</strong>
												</span>
														</c:otherwise>
													</c:choose>
												</c:if>
											</c:forEach>
										</div>
									</c:if>
								<%--	<c:if test="${result.eventAt eq 'Y'}">
										<span class="label-event">이벤트</span>
									</c:if>--%>
								</div>
								<div class="product-txt-area">
									<%--<div class="type-area">
										<span class="label">구독상품</span>
										<span class="label">수강권</span>
									</div>--%>
									<h3><c:out value="${result.goodsNm }"/></h3>
									<div class="price">
										<c:choose>
											<c:when test="${empty USER_ID && not empty result.mrktPc}">
												<strong><span><c:if test="${result.sbscrptCycleSeCode eq 'MONTH' }">월</c:if> <fmt:formatNumber type="number" pattern="#,###" value="${result.mrktPc}"/></span>원</strong>
											</c:when>
											<c:otherwise>
												<strong><span><c:if test="${result.sbscrptCycleSeCode eq 'MONTH' }">월</c:if> <fmt:formatNumber type="number" pattern="#,###" value="${result.goodsPc}"/></span>원</strong>
												<c:if test="${result.mrktUseAt eq 'Y'}">
													<del><span><fmt:formatNumber type="number" pattern="#,###" value="${result.mrktPc}"/></span>원</del>
												</c:if>
											</c:otherwise>
										</c:choose>
									</div>
									<c:if test="${not empty result.goodsLabelList}">
										<div class="label-area">
											<c:forEach items="${result.goodsLabelList}" var="labelItem">
												<c:if test="${not empty labelItem.labelCn}">
													<span class="label-r spot3">${labelItem.labelCn} ${labelItem.labelCn2}</span>
												</c:if>
											</c:forEach>
										</div>
									</c:if>
								</div>
							</a>
						</li>
					</c:forEach>
				</ul>
			</div>
			<button type="button" class="swiper-button-next"></button>
			<button type="button" class="swiper-button-prev"></button>
			<div class="swiper-pagination"></div>
		</div>
	</div>
	</section>
<%--
<c:choose>
	<c:when test="${empty param.listMode  }">
		<input type="hidden" id="totalCount" value="${paginationInfo.totalRecordCount }"/>
		<div class="mn-tit-area">
			<h2 class="mn-tit">폭스구독권</h2>
            <p>FOX LEARNING CENTER 구독권</p>
		</div>



		<ul class="product-list col3">
			<c:forEach var="result" items="${resultList }" varStatus="status">
				<li>
	                <a href="${CTX_ROOT }/shop/goods/goodsView.do?goodsId=${result.goodsId}">
	                    <div class="product-img-area">
	                        <img src="<c:out value="${result.goodsLrgeImagePath }"/>" alt="${result.goodsNm }" />
	                        <c:choose>
								<c:when test="${result.goodsKndCode eq 'SBS' }">
									<div class="label-info">
										<cite>구독상품 </cite>
										<span>구독주기</span>
										<strong>
											<c:choose>
												<c:when test="${result.sbscrptCycleSeCode eq 'WEEK' }">주단위</c:when>
												<c:when test="${result.sbscrptCycleSeCode eq 'MONTH' }">월단위</c:when>
											</c:choose>
										</strong>
									</div>
								</c:when>
								<c:when test="${result.goodsKndCode eq 'GNR' }">
									<div class="label-info">
										<c:choose>
											<c:when test="${result.prtnrId eq 'PRTNR_0001' }"><cite>체험구독</cite></c:when> 
											<c:otherwise><cite>일반상품</cite></c:otherwise>
										</c:choose>
									</div>
								</c:when>
							</c:choose>
	                    </div>
	                    <div class="product-txt-area">
	                        <h3><c:out value="${result.goodsNm }"/></h3>
	                        <div class="price">
	                            <strong><span><fmt:formatNumber type="number" pattern="#,###" value="${result.goodsPc}"/></span>원</strong>
								<c:if test="${result.mrktUseAt eq 'Y'}">
									<del><span><fmt:formatNumber type="number" pattern="#,###" value="${result.mrktPc}"/></span>원</del>
								</c:if>
	                        </div>
	                    </div>
	                </a>
	            </li>
			</c:forEach>
        </ul>
       &lt;%&ndash;
		<c:if test="${fn:length(resultList) ge paginationInfo.recordCountPerPage }">
			<div class="btn-area">
				<button id="btnBestMore" class="btn-lg width spot2" data-src="${CTX_ROOT }/embed/shop/goods/bestGoodsList.do" data-next-page="${searchVO.pageIndex + 1}">
					더보기<i class="ico-arr-b sm back" aria-hidden="true"></i>
				</button>
			</div>
		</c:if>
		&ndash;%&gt;
	</c:when>
	<c:when test="${param.listMode eq 'list' }">
		<c:if test="${not empty resultList }">
			<c:forEach var="result" items="${resultList }" varStatus="status">
				<li class="goods-item">
					<a href="${CTX_ROOT }/shop/goods/goodsView.do?goodsId=${result.goodsId}">
						<div class="product-img-area">
							<img src="<c:out value="${result.goodsLrgeImagePath }"/>" alt="${result.goodsNm }" />
							&lt;%&ndash; <c:choose>
							<c:when test="${result.goodsKndCode eq 'SBS' }">
								<div class="label-info">
									<cite>구독상품 </cite>
									<span>배송주기</span>
									<strong>
										<c:choose>
											<c:when test="${result.sbscrptCycleSeCode eq 'WEEK' }">주단위</c:when>
											<c:when test="${result.sbscrptCycleSeCode eq 'MONTH' }">월단위</c:when>
										</c:choose>
									</strong>
								</div>
							</c:when>
							<c:when test="${result.goodsKndCode eq 'GNR' }">
								<div class="label-info">
									<c:choose>
										<c:when test="${result.prtnrId eq 'PRTNR_0000' }"><cite>일반상품</cite></c:when> B2C 
										<c:when test="${result.prtnrId eq 'PRTNR_0001' }"><cite>체험구독</cite></c:when> EZWEL 
									</c:choose>
								</div>
							</c:when>
							</c:choose> &ndash;%&gt;
							<c:if test="${result.eventAt eq 'Y'}">
								<div class="label-event">이벤트</div>
							</c:if>
						</div>
						<div class="product-txt-area">
							<cite>
								<c:choose>
									<c:when test="${not empty result.brandNm }"> <c:out value="${result.brandNm }"/> </c:when>
									<c:otherwise> <c:out value="${result.cmpnyNm }"/> </c:otherwise>
								</c:choose>
							</cite>
							<h3><c:out value="${result.goodsNm }"/></h3>
							<div class="price">
								<strong><span><fmt:formatNumber type="number" pattern="#,###" value="${result.goodsPc}"/></span>원</strong>
								<c:if test="${result.mrktUseAt eq 'Y'}">
									<del><span><fmt:formatNumber type="number" pattern="#,###" value="${result.mrktPc}"/></span>원</del>
								</c:if>
							</div>
							<!-- <div class="label-area">
								<span class="label spot">HOT</span>
							</div> -->
							<c:if test="${result.dlvySeCode eq 'DS03' || result.dlvyPc eq 0 }">
							<div class="label-area">
									<span class="label spot3">무료배송</span>
								</div>	
							</c:if>
						</div>
					</a>
					<!-- <label class="btn-zzim"><input type="checkbox" title="찜" /></label> -->
				</li>
			</c:forEach>
		</c:if>
	</c:when>
</c:choose>--%>

</c:if>