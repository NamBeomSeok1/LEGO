var goodsPc=0;
var totPc=0;
var dlvyPc=0;
var optPc=0;
var dscntPc=0;
var orderCo=0;
var cartNoList = {};

window.onload = function () {
	$('.selCart').attr('checked',false);
	$('.selCart').parent('label').removeClass('ui-state-active');
	clearPrice();
}



//주문하기
$(document).on('click','.orderBtn',function(){
	if($('.selCart:checked').length==0){
		modooAlert('주문할 상품을 선택해주세요.');
		return false;
	}
})
//장바구니 목록 개수
function showCartCnt(){

	$.ajax({
		url:'/shop/goods/selectCartList.json',
		type:'GET',
		success:function(result){
			if(result.success){
				$('#cartCnt').remove();
				$('#cart').append('<span id="cartCnt" class="label-notice">'+result.totCartCnt+'</span>');
			}
		}
	})
}

//탭이동
function fnCart(code){
	var form = $('<form></form>');
	form.attr('action', "/shop/goods/cart.do");
	form.attr('method', 'post');
	form.appendTo('body');
	form.append($('<input type="hidden" value="' + code + '" name="goodsKndCode">'));
	form.submit();
}


//초기화
function clearPrice() {


	$('.bassPc').text(0);
	$('.optPc').text(0);
	$('.dlvyPc').text(0);
	$('.totPc').text(0);
	$('.dscntPc').text(0);
	$('.orderCo').text(0);

	goodsPc=0;
	totPc=0;
	dlvyPc=0;
	dscntPc=0;
	optPc=0;
	orderCo=0;

	$('.selCart').attr('checked',false);
}


//주문변경
function modCart(groupCartNo) {

	$.ajax({
		url: '/shop/goods/selectGroupCart.json',
		type: 'get',
		data: {"groupCartNo": groupCartNo , "goodsKndCode" : $("#searchGoodsKndCode").val()},
		dataType: 'html',
		success: function (result) {
			$("[data-popup='optionEdit']").empty();
			$("[data-popup='optionEdit']").html(result);

		/*	if (chldrnnmUseAt == "Y") {
				selectChildList();
			}*/
			popOpen("optionEdit");
		}

	});
}
//주문정보변경
$(document).on('click','#modBtn',function(){
	var cartNo=Number($('#cartNo').val());
	var goodsKndCode=$('#goodsKndCode').val();
	var orderCo = Number($('#modOrderCo').val());
	var sbscrptCycleSeCode=$('#sbscrptCycleSeCode').val();
	var jsonData = '';
	var dOpt=$('#ditem option:selected').val();
	var fOpt=$('#fitem option:selected').val();
	var aOpt=$('#aitem option:selected').val();
	var compnoDscntUseAt = $('#compnoDscntUseAt').val();
	var gnrOrderOptions = [aOpt,dOpt,fOpt];
	if(gnrOrderOptions==','){
		gnrOrderOptions=null;
	}
	var sbsOrderOptions = [aOpt,dOpt,fOpt];
	if(sbsOrderOptions==', ,'){
		sbsOrderOptions=null;
	}

	if(orderCo>=2 && compnoDscntUseAt=='Y'){
		compnoDscntUseAt = 'Y';
	}else{
		compnoDscntUseAt = 'N';
	}

	if(goodsKndCode=='GNR'){
		jsonData={
			'cartNo':cartNo,
			'goodsKndCode':'GNR',
			'orderCo':orderCo,
			'cartItemIdList':gnrOrderOptions,
			'compnoDscntUseAt':compnoDscntUseAt
		}
	}else if(goodsKndCode=='SBS'){
		var sbscrptCycleSeCode = $('#sbscrptCycleSeCode').val();
		if(sbscrptCycleSeCode=='WEEK'){
			var sbscrptWeekCycle = Number($('#sbscrptWeekCycle option:selected').val());
			var sbscrptDlvyWd = Number($('#sbscrptDlvyWd option:selected').val());
			jsonData={
				'cartNo':cartNo,
				'orderCo':orderCo,
				'cartItemIdList':sbsOrderOptions,
				'goodsKndCode':'SBS',
				'sbscrptCycleSeCode':'WEEK',
				'sbscrptWeekCycle':sbscrptWeekCycle,
				'sbscrptDlvyWd':sbscrptDlvyWd,
				'compnoDscntUseAt':compnoDscntUseAt

			}
		}else if(sbscrptCycleSeCode=='MONTH'){
			var sbscrptMtCycle = Number($('#sbscrptMtCycle option:selected').val());
			var sbscrptDlvyDay = Number($('#sbscrptDlvyDay').val());
			jsonData={
				'cartNo':cartNo,
				'orderCo':orderCo,
				'goodsKndCode':'SBS',
				'sbscrptCycleSeCode':'MONTH',
				'cartItemIdList':sbsOrderOptions,
				'sbscrptMtCycle':sbscrptMtCycle,
				'sbscrptDlvyDay':sbscrptDlvyDay,
				'compnoDscntUseAt':compnoDscntUseAt
			}
		}
	}else if(goodsKndCode=='CPN'){
		jsonData={
			'cartNo':cartNo,
			'orderCo':orderCo,
			'goodsKndCode':'CPN',
			'compnoDscntUseAt':compnoDscntUseAt
		}
	}
	$.ajax({
		url:'/shop/goods/updateCart.json',
		data:JSON.stringify(jsonData),
		dataType:'json',
		type:'post',
		contentType: 'application/json',
		success:function(result){
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
	})

})

//장바구니 주문하기
$(document).on('submit','#sendOrder',function(){

	var selGoodsIdArr = [];

	$('.selCart:checked').each(function(index,item){
		selGoodsIdArr.push($(this).val());
	})

	const result = selGoodsIdArr.some(function(x){
		return selGoodsIdArr.indexOf(x) !== selGoodsIdArr.lastIndexOf(x);
	});

	if(result){
		modooAlert('같은 상품의 체험구독과 구독상품을 함께 주문 할 수 없습니다.');
		return false;
	}

	return fnCartGoodsCountChk();
})



//장바구니 전체선택
$(document).on('change','#allSelect',function(){
	$('.selCart').prop('checked',false);
	$('.selCart').parent('label').removeClass('ui-state-active');
	clearPrice();

	if($(this).is(':checked')){
		$('.selCart').each(function(index,item){
			$(this).click();
		})
	}

})

// 금액계산
function insertPrice(){

	$('.bassPc').text(totPc.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
	$('.optPc').text(optPc.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
	$('.dlvyPc').text(dlvyPc.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
	$('.totPc').text((dlvyPc+totPc).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
	$('.dscntPc').text(dscntPc.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
	$('.orderCo').text($('.selCart:checked').length);
}

//장바구니 선택
$(document).on('change','.selCart',function(){
	var cartChkCnt= $('.selCart').length;
	var i = $(this).data('selcartno');

	if($("#searchGoodsKndCode").val() == "GNR"){
		if($(this).is(':checked')){
			$(this).attr('checked',true);
			$(this).closest(".tbody").find("ul.option-info-list li").each(function(index,item){
				goodsPc+=Number($(item).find('.goodsPc').val());
				totPc+=Number($(item).find('.cartPc').val());
				dscntPc+=Number($(item).find('.dscntPc').val());
			});
			dlvyPc+=Number($(this).closest(".tbody").find('.dlvyPc').val());
		}else{
			$(this).attr('checked',false);
			$(this).closest(".tbody").find("ul.option-info-list li").each(function(index,item){
				goodsPc-=Number($(item).find('.goodsPc').val());
				totPc-=Number($(item).find('.cartPc').val());
				dscntPc-=Number($(item).find('.dscntPc').val());
			});
			dlvyPc-=Number($(this).closest(".tbody").find('.dlvyPc').val());
			/*delete cartNoList[$(this).data('cartid')];*/
		}
	}else{
		if($(this).is(':checked')){
			$(this).attr('checked',true);
			$(this).closest(".tbody").find("ul.option-info-list li").each(function(index,item){
				goodsPc=Number($(item).find('.goodsPc').val());
				totPc=Number($(item).find('.cartPc').val());
				dscntPc=Number($(item).find('.dscntPc').val());
			});
			dlvyPc=Number($(this).closest(".tbody").find('.dlvyPc').val());
		}
	}

	insertPrice();

	if($('.selCart:checked').length==cartChkCnt){
		$('#allSelect').prop('checked',true);
		$('#allSelect').parent('label').addClass('ui-state-active');
	}else{
		$('#allSelect').prop('checked',false);
		$('#allSelect').parent('label').removeClass('ui-state-active');
	}

})

//장바구니 삭제
function deleteCart(){

	//삭제 리스트
	var delCartGroupNoList = [];

	$('.selCart:checked').each(function(index,item){
		delCartGroupNoList.push($(item).data('cartid'));
	})
	if(delCartGroupNoList==''){
		modooAlert('삭제할 장바구니를 선택해주세요.');
		return false;
	}
	var jsonData = JSON.stringify(delCartGroupNoList);

	modooConfirm('삭제하시겠습니까?','장바구니 삭제',function(result){
		if(result){
			$.ajax({
				url:'/shop/goods/deleteCart.json',
				data:{delCartGroupNoList:delCartGroupNoList},
				traditional:true,
				type:'post',
				success:function(result){
					if(result.success){
						modooAlert('상품이 삭제되었습니다.', '확인', function() {
							window.location.reload();
						});
					}else{
						mdooAlert(result.message);
						return false;
					}
				}
			})
		}else{
			return false;
		}
	});

}

//정기결제 요일 변환
function transferDlvyWd (wdVal){
	switch (wdVal){
		case '1':
			return '일요일';
		case '2':
			return '월요일';
		case  '3':
			return '화요일';
		case '4':
			return '수요일';
		case '5':
			return '목요일';
		case '6':
			return '금요일';
		case '7':
			return '토요일';
	}
}

function fnCartGoodsCountChk(){
	var chkArrD = [];
	var chkArrS = [];

	var returnChk = true;
	var goodsArr = [];
	var goodsIdList = [];


	$('.selCart:checked').each(function(){
		var tempCo = 0;
		var goodsInfo = {
			"goodsId": $(this).data("goodsid"),
			"dOptnType" : $(this).closest(".tbody").find(".dOptnType").val(),
			"chkDgitem" : null,
			"chkSgitem" : null
		}
		goodsIdList.push($(this).data("goodsid"));
		$(this).closest(".tbody").find(".option-info-list li").each(function(index,item){
			if($(item).find(".gitemSeCode").val() == "S"){
				chkArrS.push({"gitemId" : $(item).find(".gitemId").val(), "gitemCo" : Number($(item).find(".gitemCo").val())});
			}

			if($(item).find(".gitemSeCode").val() == "D"){
				if($(this).closest(".tbody").find(".dOptnType").val() == "A"){
					tempCo +=  Number($(item).find(".gitemCo").val());
				}else{
					chkArrD.push({"gitemId" : $(item).find(".gitemId").val(), "gitemCo" : Number($(item).find(".gitemCo").val())});
				}

			}
		});
		if(chkArrD.length != 0){
			goodsInfo.chkDgitem = chkArrD;
		}
		if(chkArrS.length != 0){
			goodsInfo.chkSgitem = chkArrS;
		}
		goodsInfo.tempCo = tempCo;
		goodsArr.push(goodsInfo);
	});


	$.ajax({
		url:'/shop/goods/selectGoodsCount.json',
		data : {"goodsIdList" : goodsIdList},
		dataType:'json',
		type:'post',
		async: false,
		success:function(result){
			if(result.success) {
				var resultList = result.data.goods;

				for(var j = 0; j < goodsArr.length; j++){
					for(var i = 0; i < resultList.length; i++){
						if(goodsArr[j].goodsId == resultList[i].goodsId){
							if(resultList[i].soldOutAt == "Y"){
								modooAlert("해당 상품("+resultList[i].goodsNm+")은 품절 되었습니다.",'확인');
								returnChk = false;
								return false;
							}else{
								if(goodsArr[j].dOptnType == "A"){
									if(goodsArr[j].tempCo > Number(resultList[i].goodsCo)){
										modooAlert("해당 상품은("+resultList[i].goodsNm+") "+Number(resultList[i].goodsCo+1) +"개 이상 구매 할 수 없습니다.",'확인');
										returnChk = false;
										return false;
									}
								}else{
									if(goodsArr[j].chkDgitem != null) {
										var temp = goodsArr[j].chkDgitem;
										var dgitem = resultList[i].dGitemList;
										for (var t = 0; t < temp.length; t++) {
											for (var d = 0; d < dgitem.length; d++) {
												if (dgitem[d].gitemId == temp[t].gitemId) {
													if(dgitem[d].gitemSttusCode == "F"){
														modooAlert(resultList[i].goodsNm + " 옵션: " + dgitem[d].gitemNm + " 상품이 품절되었습니다. \n 다른옵션을 선택해 주시기 바랍니다.", '확인');
														returnChk = false;
														return false;
													}else if (Number(temp[j].gitemCo) > Number(dgitem[d].gitemCo)) {
														modooAlert(resultList[i].goodsNm+" 옵션: " + dgitem[d].gitemNm + " " + Number(dgitem[d].gitemCo + 1) + "개 이상 구매 할 수 없습니다.", '확인');
														returnChk = false;
														return false;
													}
												}
											}
										}
									}
								}

								if(goodsArr[j].chkSgitem != null){
									var sgitem = resultList[i].sGitemList;
									var temp = goodsArr[j].chkSgitem;
									for(var t = 0; t < temp.length; t++){
										for(var s = 0; s < sgitem.length; s++) {
											if (sgitem[s].gitemId == temp[j].gitemId) {
												if(sgitem[s].gitemSttusCode == "F"){
													modooAlert(resultList[i].goodsNm +" 추가상품: " + sgitem[s].gitemNm + " 이 품절되었습니다. \n 다른 추가상품을 선택해 주시기 바랍니다.", '확인');
													returnChk = false;
													return false;
												}else if (Number(temp[j].gitemCo) > Number(sgitem[s].gitemCo)) {
													modooAlert(resultList[i].goodsNm +" 추가상품: " + sgitem[s].gitemNm + " " + Number(sgitem[s].gitemCo + 1) + "개 이상 구매 할 수 없습니다.", '확인');
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
				}
			}
		}
	});
	return returnChk;
}
