<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/modoo/common/commonTagLibs.jsp"%>
<jsp:useBean id="today" class="java.util.Date" />

<!--주문정보변경-->
<javascript>
	<script src="${CTX_ROOT }/resources/front/shop/goods/info/js/goodsCartEdit.js?ver=${today}"></script>
</javascript>

<script>



	//옵션수정
$(document).on("click", '#editBtn', function(){
	var goodsId = $('#goodsId').val();
	var jsonData = '';
	var orderNo = $('#orderNo').val();
	var cartItemIdList = [];
	var orderItemList = [];
	var newCartList = [];
	var goodsJson = '';
	var exprnUseAt = 'N';
	var compnoDscntUseAtChk = 'N';

	if ($(".goodsLi").length == 0 && $(".option-select-area li[data-secode=D]").length == 0) {
		modooAlert('상품을 선택해 주세요.');
		popClose('popupCart');
		return false;
	} else {
		if(fnGoodsCountChk()){
				var orderCo = 1;
				var sbscrptCycleSeCode = $('#sbscrptCycleSeCode').val();

				jsonData = {
					'orderCo': orderCo,
					'goodsId': goodsId,
					'orderNo': orderNo,
					'orderKndCode': 'SBS',
					'sbscrptCycleSeCode': sbscrptCycleSeCode,
					'compnoDscntUseAt': compnoDscntUseAtChk,
					'orderItemList': null,
					'chldrnNm': null,
					'chldrnId': null,
					'cartVoList' : null,
					'dOptnType':$('#dOptnType').val(),
					'freeDlvyPc':$('#freeDlvyPc').val()
				}

				$(".option-select-area:eq(0) li").each(function () {
					goodsJson = {
						'orderKndCode': 'SBS',
						'goodsId': goodsId,
						'orderNo': orderNo,
						'orderItemList': null,
						'sbscrptCycleSeCode': sbscrptCycleSeCode,
						'sbscrptWeekCycle': null,
						'sbscrptDlvyWd': null,
						'sbscrptMtCycle': null,
						'sbscrptDlvyDay': null,
						'chldrnNm': null,
						'chldrnId': null,
						'exprnUseAt': exprnUseAt,
						'compnoDscntUseAt': compnoDscntUseAtChk
					}
					orderItemList = [];

					if (sbscrptCycleSeCode == 'WEEK') {
						goodsJson.sbscrptWeekCycle = $('#sbscrptWeekCycle option:selected').val();
						goodsJson.sbscrptDlvyWd = $('#sbscrptDlvyWd option:selected').val();
						jsonData.sbscrptWeekCycle = $('#sbscrptWeekCycle option:selected').val();
						jsonData.sbscrptDlvyWd = $('#sbscrptDlvyWd option:selected').val();
					} else {
						goodsJson.sbscrptMtCycle = $('#sbscrptMtCycle option:selected').val();
						goodsJson.sbscrptDlvyDay = $('#sbscrptDlvyDay').val();
						jsonData.sbscrptMtCycle = $('#sbscrptMtCycle option:selected').val();
						jsonData.sbscrptDlvyDay = $('#sbscrptDlvyDay').val();
					}

					if ($(this).find(".selectFopt").length != 0) {//첫구독 옵션
						cartItemIdList.push($(this).find(".selectFopt").val());
					}

					if ($(this).data("secode") == "D") {
						orderItemList.push({
							"gitemId": $(this).find(".liDopt").val(),
							"gitemCo": orderCo
						});
					}

					if ($(this).data("secode") == "S") {
						orderItemList.push({
							"gitemId": $(this).data("optid"),
							"gitemCo": $(this).find(".orderCo").val(),
							"gistemSeCode" : "S"
						})
					}

					if ($(this).find(".liChdrId").length != 0) {//자녀옵션
						goodsJson.chldrnNm = $(this).find(".liChdrNm").val();
						goodsJson.chldrnId = $(this).find(".liChdrId").val();
					}


				})

				jsonData.orderItemList = orderItemList;

				//쿠폰상품
			$.ajax({
				url: CTX_ROOT + '/shop/goods/updateOrder.json',
				data: JSON.stringify(jsonData),
				dataType: 'json',
				type: 'post',
				contentType: 'application/json',
				success: function (result) {
					popClose('optionEdit');
					if(result.success){
						modooAlert(result.message, '확인', function() {
							window.location.reload();
						});
					}else{
						modooAlert(result.message,'', function() {
							window.location.reload();
						});
					}
				}
			});
		}

	}
});

function fnGoodsCountChk(){
	debugger;
	var chkArrD = [];
	var chkArrS = [];
	var tempCo = 0;
	var returnChk = true;
	var goodsIdList = [];
	$(".option-select-area li").each(function(){
		if($(this).data("secode") == "S"){
			chkArrS.push({"gitemId" : $(this).data("optid"), "gitemCo" : Number($(this).find(".orderCo").val())});
		}else if($(this).hasClass("goodsLi")){//일반상품(기본옵션 사용안하는 경우)
			tempCo =  Number($(this).find(".orderCo").val());
		}

		if($(this).data("secode") == "D"){
			if($("#dOptnType").val() == "A"){
				tempCo +=  Number($(this).find(".orderCo").val());
			}else{
				var tempId = $(this).find(".liDopt").length == 0 ? $(this).find("#tempGitemId").val() : $(this).find(".liDopt").val();
				chkArrD.push({"gitemId" : tempId, "gitemCo" : Number($(this).find(".orderCo").val())});
			}

		}
	});

	goodsIdList.push($("#goodsId").val());
	$.ajax({
		url:'/shop/goods/selectGoodsCount.json',
		data : {"goodsIdList" : goodsIdList},
		dataType:'json',
		type:'post',
		async: false,
		success:function(result){
			if(result.success) {
				var resultGoods = result.data.goods[0];
				if(resultGoods.soldOutAt == "Y"){
					modooAlert("해당 상품은 품절 되었습니다.",'확인');
					returnChk = false;
					return false;
				}else{
					if($("#dOptnType").val() == "A" || !!!$("#dOptnType").val()){
						if(tempCo > Number(resultGoods.goodsCo)){
							modooAlert("해당 상품은 "+Number(resultGoods.goodsCo+1) +"개 이상 구매 할 수 없습니다.",'확인');
							returnChk = false;
							return false;
						}
					}else{
						if(chkArrD.length != 0) {
							var dgitem = resultGoods.dGitemList;
							for (var j = 0; j < chkArrD.length; j++) {
								for (var i = 0; i < dgitem.length; i++) {
									if (dgitem[i].gitemId == chkArrD[j].gitemId) {
										if(dgitem[i].gitemSttusCode == "F"){
											modooAlert("옵션: " + dgitem[i].gitemNm + " 상품이 품절되었습니다. \n 다른옵션을 선택해 주시기 바랍니다.", '확인');
											returnChk = false;
											return false;
										}else if (Number(chkArrD[j].gitemCo) > Number(dgitem[i].gitemCo)) {
											modooAlert("옵션: " + dgitem[i].gitemNm + " " + Number(dgitem[i].gitemCo + 1) + "개 이상 구매 할 수 없습니다.", '확인');
											returnChk = false;
											return false;
										}
									}
								}
							}
						}
					}

					if(chkArrS.length != 0){
						var sgitem = resultGoods.sGitemList;
						for(var j = 0; j<chkArrS.length; j++){
							for(var i = 0; i<sgitem.length; i++) {
								if (sgitem[i].gitemId == chkArrS[j].gitemId) {
									if(sgitem[i].gitemSttusCode == "F"){
										modooAlert("추가상품: " + sgitem[i].gitemNm + " 이 품절되었습니다. \n 다른 추가상품을 선택해 주시기 바랍니다.", '확인');
										returnChk = false;
										return false;
									}else if (Number(chkArrS[j].gitemCo) > Number(sgitem[i].gitemCo)) {
										modooAlert("추가상품: " + sgitem[i].gitemNm + " " + Number(sgitem[i].gitemCo + 1) + "개 이상 구매 할 수 없습니다.", '확인');
										returnChk = false;
										return false;
									}
								}
							}
						}
					}
				}

			}
		}
	});
	return returnChk;
}

</script>

	<input type="hidden" id="goodsId" name="goodsId" value="${goods.goodsId }"/>
	<input type="hidden" id="goodsKndCode" name="goodsKndCode" value="${goods.goodsKndCode}"/>
	<input type="hidden" id="sbscrptCycleSeCode" name="sbscrptCycleSeCode" value="${goods.sbscrptCycleSeCode }"/>
	<input type="hidden" id="orderMode" name="orderMode" value="SBS"/> <%--CART :장바구니, SBS: 구독 --%>
	<input type="hidden" id="dOptnType"  value="${goods.dOptnType }"/>
	<input type="hidden" id="dOptnUseAt"  value="${goods.dOptnUseAt }"/>
	<input type="hidden" id="orderNo"  value="${result.orderNo}"/>
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

	<div class="pop-header">
		<h1>주문정보 변경</h1>
		<button type="button" class="btn-pop-close" onclick="popClose('optionEdit')">닫기</button>
	</div>
	<div class="pop-body">

		<div class="option-area">
			<ul class="option-list">
				<c:if test="${goods.chldrnnmUseAt eq 'Y'}">
					<li>
						<cite>자녀</cite>
						<select class="chdr" name="chdr.chdrId">
							<option value="0">선택</option>
						</select>
						<input type="text" class="chdrNm" name="chdr.chdrNm" style="display: none;"/>
							<%--&lt;%&ndash;<span class="fs-sm fc-gr block">* 폭스러닝센터 상품일 경우, 자녀의 이름을 입력해주세요.</span>&ndash;%&gt;--%>
					</li>
				</c:if>
				<c:if test="${goods.optnUseAt eq 'Y' }">
					<c:if test="${goods.qOptnUseAt eq 'Y' }">
						<li class="qOptionLi">
							<cite>업체 요청사항(필수정보입력)</cite>
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
							<select name="orderItemList[${orderItemNo }].gitemId" id="fOptOption" class="fOpt orderOption" title="옵션선택">
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
								<select id="sbscrptWeekCycle" name="sbscrptWeekCycle" class="sbscrptWeekCycle" title="주기 선택">
									<c:if test="${fn:length(goods.sbscrptWeekCycleList) gt 1 }">
										<option value="">주기를 선택하세요.</option>
									</c:if>
									<c:forEach var="week" items="${goods.sbscrptWeekCycleList }">
										<option value="${week }">${week }주</option>
									</c:forEach>
								</select>
							</li>
							<li>
								<cite>정기결제요일</cite> <%--구독요일을 정기결제일, 배송요일을 정기결제 요일 변경 10.28 --%>
								<select id="sbscrptDlvyWd" name="sbscrptDlvyWd" class="sbscrptDlvyWd" title="정기결제요일 선택">
									<option value="">정기결제 요일을 선택하세요.</option>
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
								<select id="sbscrptMtCycle" name="sbscrptMtCycle" class="sbscrptMtCycle" title="구독주기 선택">
									<c:if test="${fn:length(goods.sbscrptMtCycleList) gt 1 }">
										<option value="">주기를 선택하세요.</option>
									</c:if>
									<c:forEach var="month" items="${goods.sbscrptMtCycleList }">
										<option value="${month }">${month }개월</option>
									</c:forEach>
								</select>
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
													<input type="hidden" id="sbscrptDlvyDay" name="sbscrptDlvyDay" class="sbscrptDlvyDay" value="${today}"/>
													<input type="text" disabled value="${today } 일"/>
												</c:when>
												<c:otherwise>
													<input type="hidden" id="sbscrptDlvyDay" name="sbscrptDlvyDay" class="sbscrptDlvyDay" value="${goods.sbscrptDlvyDay}"/>
													<input type="text" disabled value="${goods.sbscrptDlvyDay } 일"/>
												</c:otherwise>
											</c:choose>
										</c:when>
										<c:otherwise>
											<select name="sbscrptDlvyDay" id="sbscrptDlvyDay" class="sbscrptDlvyDay" value="${result.sbscrptDlvyDay}" title="정기결제일 선택" style="width: 100%">
												<c:forEach var = "i" begin = "1" end = "31">
													<option value="${i}">
															${i}
													</option>
												</c:forEach>
											</select>
										<%--	<input type="text" name="sbscrptDlvyDay" id="sbscrptDlvyDay" class="datepicker-input sbscrptDlvyDay" placeholder="결제일을 선택하세요" title="결제일을 선택" readonly="true" />
											<button class="btn-datepicker-toggle" type="button"><span class="text-hide"></span></button>--%>
										</c:otherwise>
									</c:choose>
								</div>
							</li>
						</c:when>
					</c:choose>
				</c:if>

				<%--<c:if test="${goods.optnUseAt eq 'N' }">
                    <li>
                        <cite>수량</cite>
                        <div>
                            <div class="count">
                                <c:set var="countDisabled" value=""/>
                                <c:if test="${goods.goodsKndCode eq 'SBS' || (not empty goods.vchCode && not empty goods.vchValidPd) || goods.chldrnnmUseAt eq 'Y'}">
                                    <c:set var="countDisabled" value="true"/>
                                </c:if>
                                <button type="button" class="btn-minus" disabled><span class="txt-hide">빼기</span></button>
                                <form:input type="number" path="orderCo" class="orderCo inputNumber"   min="1" max="9999"  value="${orderInfo.orderCo}" disabled="${countDisabled}"  title="수량 입력" maxlength="4"/>
                                <button type="button" class="btn-plus" disabled="${countDisabled}"><span class="txt-hide">더하기</span></button>
                            </div>
                            <c:if test="${goods.compnoDscntUseAt eq 'Y'}">
                                <p class="msg mt10">2개 이상 구매시 개당 ${-goods.compnoDscntPc}원이 할인됩니다.</p>
                            </c:if>
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
							<select name="orderItemList[${orderItemNo }].gitemId" id="orderOption1"  class="dOpt1 orderOption" title="옵션선택">
								<option value="">${goods.optnComList[0].optnName}</option>
								<c:choose>
									<c:when test="${not empty goods.optnComList[1].optnValue}">
										<c:forEach var="opt1" items="${optnList1}">
											<option value="${opt1}">${opt1 }${optnList2}</option>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<c:forEach var="opt1" items="${goods.dGitemList}">
											<option value="${opt1.gitemId}" data-gitemnm="${opt1.gitemNm}" data-price="${opt1.gitemPc}">${opt1.gitemNm }</option>
										</c:forEach>
									</c:otherwise>
								</c:choose>
							</select>
							<c:if test="${fn:length(goods.optnComList) > 1}">
								<select name="orderItemList[${orderItemNo }].gitemId" id="orderOption2"  class="dOpt2 orderOption" title="옵션선택">
									<option value="">${goods.optnComList[1].optnName}</option>
								</select>
							</c:if>
						</li>
						<c:set var="orderItemNo" value="${orderItemNo + 1 }"/>
					</c:if>
					<c:if test="${goods.aOptnUseAt eq 'Y' }">
						<li>
							<cite>추가옵션</cite>
							<select name="orderItemList[${orderItemNo }].gitemId" class="aOpt orderOption" title="옵션선택">
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
		<c:if test="${goods.sOptnUseAt eq 'Y'  and goods.optnUseAt eq 'Y'}">
			<div class="option-area">
				<ul class="option-list">
					<li>
						<cite>추가상품</cite>
						<select name="orderItemList[${orderItemNo }].gitemId" class="sOpt orderOption" title="옵션선택">
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
				<c:if test="${not empty result}">
						<c:set var="tempText" value=""/>
						<c:set var="tempGistemSeCode" value=""/>
						<c:set var="tempCo" value=""/>
						<c:set var="tempPc" value=""/>
						<c:set var="tempGitemId" value=""/>


					<c:if test="${result.orderKndCode eq 'SBS'}">
						<c:choose>
							<c:when test="${result.sbscrptCycleSeCode eq 'WEEK' }">
								<c:set var="tempText" value="${tempText} 구독주기 : ${result.sbscrptWeekCycle }주"/>
							</c:when>
							<c:when test="${result.sbscrptCycleSeCode eq 'MONTH' }">
								<c:set var="tempText" value="${tempText}  구독주기 : ${result.sbscrptMtCycle }월"/>
							</c:when>
							<c:otherwise>  </c:otherwise>
						</c:choose>
						<c:choose>
							<c:when test="${result.sbscrptCycleSeCode eq 'WEEK' }">
								<c:set var="wdNm" value=""/>
								<c:choose>
									<c:when test="${result.sbscrptDlvyWd eq '1' }"><c:set var="wdNm" value="일"/></c:when>
									<c:when test="${result.sbscrptDlvyWd eq '2' }"><c:set var="wdNm" value="월"/></c:when>
									<c:when test="${result.sbscrptDlvyWd eq '3' }"><c:set var="wdNm" value="화"/></c:when>
									<c:when test="${result.sbscrptDlvyWd eq '4' }"><c:set var="wdNm" value="수"/></c:when>
									<c:when test="${result.sbscrptDlvyWd eq '5' }"><c:set var="wdNm" value="목"/></c:when>
									<c:when test="${result.sbscrptDlvyWd eq '6' }"><c:set var="wdNm" value="금"/></c:when>
									<c:when test="${result.sbscrptDlvyWd eq '7' }"><c:set var="wdNm" value="토"/></c:when>
								</c:choose>
								<c:set var="tempText" value="${tempText}/정기결제요일:${wdNm}요일"/>
							</c:when>
							<c:when test="${result.sbscrptCycleSeCode eq 'MONTH' }">
								<c:set var="tempText" value="${tempText}/정기결제일:${result.sbscrptDlvyDay }일"/>
							</c:when>
							<c:otherwise> </c:otherwise>
						</c:choose>
					</c:if>

					<c:set var="tempCo" value="${result.orderCo}"/>
					<c:set var="tempPc" value="${goods.goodsPc}"/>

						<c:forEach items="${result.orderItemList}" var="item" varStatus="itemStatus">
							<c:choose>
								<c:when test="${item.gistemSeCode eq 'Q'}">
									<c:set var="tempText" value="${tempText} / ${item.gitemAnswer} "/>
								</c:when>
								<c:when test="${item.gistemSeCode eq 'D'}">
									<c:set var="tempText" value="${tempText}/${fn:replace(item.gitemNm, ',' ,'/')}"/>
									<c:set var="tempGistemSeCode" value="${item.gistemSeCode}"/>
									<c:set var="tempCo" value="${item.gitemCo}"/>
									<c:if test="${result.orderKndCode eq 'SBS'}">
										<c:set var="tempCo" value="${result.orderCo}"/>
									</c:if>
									<c:set var="tempPc" value="${empty item.gitemPc ? goods.goodsPc : item.gitemPc}"/>
									<c:set var="tempGitemId" value="${item.gitemId}"/>
								</c:when>
								<c:when test="${item.gistemSeCode eq 'S'}">
									<c:set var="tempText" value="${item.gitemNm}"/>
									<c:set var="tempGistemSeCode" value="${item.gistemSeCode}"/>
									<c:set var="tempCo" value="${item.gitemCo}"/>
									<c:set var="tempPc" value="${item.gitemPc}"/>
									<c:set var="tempGitemId" value="${item.gitemId}"/>
								</c:when>
								<c:otherwise>
								</c:otherwise>
							</c:choose>
						</c:forEach>

						<c:if test="${not empty result.chldrnId and tempGistemSeCode ne 'S'}">
							<c:set var="tempText" value="${tempText}/자녀: ${result.chldrnNm}"/>
							<c:if test="${result.chldrnId ne 'FOXUSER_999999999999'}">
								<c:set var="tempChlNm" value="_${result.chldrnNm}"/>
							</c:if>
							<c:set var="tempChlId" value="_${result.chldrnId}"/>
						</c:if>
					<li data-secode="${tempGistemSeCode}" data-cartid="${result.cartNo}" data-optid="${tempGitemId}${tempChlId}${tempChlNm}">
						<p>${fn:substring(tempText,0, 1) eq '/' ? fn:substring(tempText,1, fn:length(tempText)) : tempText}</p>
						<c:choose>
							<c:when test="${goods.goodsKndCode eq 'SBS'}">
								<input type="hidden" value="1" class="orderCo inputNumber"/>
							</c:when>
							<c:otherwise>
								<div class="count">
									<button type="button" class="btn-minus sm" ${tempCo > 1 ? '' : 'disabled'}><span class="txt-hide">빼기</span></button>
									<input type="number" value="${tempCo}" class="orderCo inputNumber" min="1" max="9999" title="수량 입력" maxlength="4" readonly />
									<button type="button" class="btn-plus sm" ><span class="txt-hide">더하기</span></button>
								</div>
							</c:otherwise>
						</c:choose>
						<div class="price"><fmt:formatNumber type="number" pattern="#,###" value="${tempPc}"/>원</div>
						<button class="btn-del-r"><span class="txt-hide">삭제</span></button>
						<input type="hidden" id="tempChlNm" value="${tempChlNm}"/>
						<input type="hidden" id="tempChlId" value="${tempChlId}"/>
						<input type="hidden" id="tempGitemId" value="${tempGitemId}"/>
					</li>
					<c:set var="tempTotal" value="${tempTotal + (tempPc * tempCo)}"/>
				</c:if>

			</ul>
			<div class="total-area">
				<cite>결제금액</cite>
				<div class="price">
					<strong><span class="totPrice">${tempTotal}</span> 원</strong>
				</div>
			</div>
		</div>
		<div class="btn-table-area">
			<button type="button" class="btn-lg" onclick="popClose('optionEdit')">취소</button>
			<button type="button" class="btn-lg spot" id="editBtn">변경하기</button>
		</div>
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