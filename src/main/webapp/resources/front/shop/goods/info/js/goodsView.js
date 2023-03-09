(function() {
	var exprnUseAt = 'N';
	var compnoDscntUseAtChk = 'N';
	var evtGoodsOrderChkAt = 'N';
	var compnoDscntUseAt = $('#compnoDscntUseAt').val();
	var contents;
	var interval;
	var chldrnnmUseAt = $("#chldrnnmUseAt").val();
	var sbsOpt ;
	var goodsKndCode = $('#goodsKndCode').val();


	if(chldrnnmUseAt == "Y"){
		selectChildList();
	}


	//성인인증여부
	cardCertResult = function (result) {
		if(result == true){
			modooAlert('본인 인증 되었습니다.','',function(){
				window.location.reload();
			});
		}else if(result == false){
			modooAlert('본인 인증이 실패하였습니다.','',function(){
				window.location.reload();
			});
		}else{
			$('.site-body').remove('.loading');
			$('.loading').hide();
		}
	};

	//클립보드 복사
	urlClipCopy = function(url) {
		var textarea = document.createElement('textarea');
		textarea.value = url;

		document.body.appendChild(textarea);
		textarea.select();
		textarea.setSelectionRange(0,9999);//추가

		document.execCommand('copy');
		document.body.removeChild(textarea);
		toast('URL이 복사되었습니다.');
	}

	//카카오 공유하기 버튼
	$(document).on('click','#kakaoShare',function(){

		var title=$(this).data('title');
		var description=$(this).data('description');
		var link=$(this).data('link');
		var imageUrl=$(this).data('imageurl');

		kakaoShare(title,description,link,imageUrl);
	})



	//네이버 공유하기
	$(document).on('click','#naverShare',function(){

		var title=$(this).data('title');
		var link=$(this).data('link');
		var encUrl = encodeURI(link);
		var encTit = encodeURI(title);

		window.open('https://share.naver.com/web/shareView.nhn?url='+encUrl+'&title='+encTit,'네이버 공유하기','window=800,height=700,toolbar=no,menubar=no,scrollbars=no,resizable=yes');

	})

	//페이스북 공유하기
	$(document).on('click','#facebookShare',function(){

		var title=$(this).data('title');
		var link=$(this).data('link');
		var encUrl = encodeURI(link);
		var encTit = encodeURI(title);

		window.open( 'https://www.facebook.com/sharer/sharer.php?u=' + encUrl+'&t='+encTit ,'페이스북공유하기','window=800,height=700,toolbar=no,menubar=no,scrollbars=no,resizable=yes');

	})

	//트위터 공유하기
	$(document).on('click','#twitterShare',function(){

		var title=$(this).data('title');
		var link=$(this).data('link');
		var encUrl = encodeURIComponent(link);
		var encTit = encodeURIComponent(title);

		window.open( 'https://twitter.com/intent/tweet?text='+encTit+'&url=' + encUrl,'트위터공유하기','window=800,height=700,toolbar=no,menubar=no,scrollbars=no,resizable=yes');

	})

	//성인인증
	$(document).on('click','.adultCrtBtn',function(e){
		e.preventDefault();
		var OpenOption = 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=420,height=800,top=100';

		contents = window.open("", "contents", OpenOption);

		document.reqfrm.target = "contents";
		document.reqfrm.submit();
		$('.loading').show();
		var windowInterval = setInterval(function(){

			if(contents.closed){
				$('.site-body').remove('.loading');
				$('.loading').hide();
				clearInterval(windowInterval);
			}

		},100)
	})



	// 총상품금액
	function setTotalPrice() {
		/*var goodsPc = Number($('#goodsPrice').val());
		var orderCo = $(this).find(".orderCo").length == 0 ? 1 : Number($(this).find(".orderCo").val());*/
		var orderCo = 0;
		var exprnPc = Number($('#exprnPc').val());
		var compnoDscntPc = Number($('#compnoDscntPc').val());
		var optPc = 0;

		$(".option-select-area:eq(0) li").each(function(){
			orderCo = $(this).find(".orderCo").val();
			if($(this).data("secode") == "D") {
				if (goodsKndCode == "SBS") {
					orderCo = 1;
				}
			}
			optPc += Number($(this).find(".price").text().replaceAll("원", "").replaceAll(",","")) *  orderCo;
			console.log(optPc);
		});

		/*if($(".tempCount").length != 0){
			optPc += Number($("#goodsPrice").val() * $(".tempCount:eq(0)").find(".goodsOrderCo").val());
		}*/


		/*	$('#goodsOrderForm .orderOption').each(function(index) {
                var $select = $(this).find('option:selected');
                if(!isEmpty($select.val())) {
                    optPc = optPc + Number($select.data('pc'));
                    debug(optPc);
                }
            });*/



		//사용하지 않음(1회체험)
		//var compnoDscntVal = Number(0);
		/*if(orderCo>=2 && compnoDscntUseAt=='Y'){
			$('.total-info-list').show();
			compnoDscntUseAtChk='Y';
			totalPc = goodsPc * orderCo + optPc+(compnoDscntPc*orderCo);
			var compnoDscntVal = Number(compnoDscntPc*orderCo);
			$('.compnoDscntPc-area').parent('li').show();
		}else{
			compnoDscntUseAtChk='N';
			$('.compnoDscntPc-area').parent('li').hide();
		}
		$('.compnoDscntPc-area').text(compnoDscntVal.toString().replace(/\B(?=(\d{3})+(?!\d))/g,",")+"원");*/

		/*if(exprnUseAt == 'Y'){
			var compnoDscntVal = 0;

			$('.total-info-list').show();

			if(orderCo>=2 && compnoDscntUseAt=='Y'){
				totalPc = goodsPc * orderCo + optPc+(exprnPc*orderCo)+(compnoDscntPc*orderCo);
			}else{
				totalPc = goodsPc * orderCo + optPc+(exprnPc*orderCo);
			}
			$('.exprnPc-area').text((goodsPc * orderCo + optPc+(exprnPc*orderCo)).toString().replace(/\B(?=(\d{3})+(?!\d))/g,",")+"원");
		}*/

		/*if(exprnUseAt == 'N' && compnoDscntUseAtChk=='N'){
               $('.total-info-list').hide();
        }*/


		//var numberFormatTotalPc = new Intl.NumberFormat('en-IN', { maximumSignificantDigits: 3 }).format(totalPc);
		$('.total-area .totPrice').text(optPc.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
	}

	//이벤트상품주문 체크
	function evtGoodsOrderChk(goodsId){
		$.ajax({
			url:CTX_ROOT+'/shop/goods/evtGoodsOrderChk.json',
			data:{'goodsId':goodsId},
			type:'POST',
			async: false,
			dataType:'json',
			success:function(result){
				if(result.success){
					evtGoodsOrderChkAt = 'Y';
				}else{
					modooAlert(result.message,'확인');
					evtGoodsOrderChkAt = 'N';
				}
			}
		})
	};

	// 유효성 검사
	function validate($form) {
		var goodsId = $('#goodsId').val();

		evtGoodsOrderChk(goodsId);
		if(evtGoodsOrderChkAt=='N'){
			return false;
		}


		if (goodsKndCode != 'GNR' && goodsKndCode != 'CPN') {
			var sbscrptCycleSeCode = $('#sbscrptCycleSeCode').val();
			if(sbscrptCycleSeCode == 'WEEK') {
				var sbscrptWeekCycle = $('#sbscrptWeekCycle option:selected').val();
				if(isEmpty(sbscrptWeekCycle)) {
					modooAlert('구독주기를 선택하세요!');
					return false;
				}
				var sbscrptDlvyWd = $('#sbscrptDlvyWd option:selected').val();
				if(isEmpty(sbscrptDlvyWd)) {
					modooAlert('정기결제 요일을 선택하세요!');
					return false;
				}

			}else if(sbscrptCycleSeCode == 'MONTH') {
				var sbscrptMtCycle = $('#sbscrptMtCycle option:selected').val();
				if(isEmpty(sbscrptMtCycle)) {
					modooAlert('구독주기를 선택하세요!');
					return false;
				}
				var sbscrptDlvyDay = $('#sbscrptDlvyDay').val();
				if(isEmpty(sbscrptDlvyDay)) {
					modooAlert('정기 결제일을 선택하세요!');
					return false;
				}
			}
		}

		if($('#orderOption').length > 0){
			var dopt = $('#orderOption option:selected').val();
			if(isEmpty(dopt)){
				modooAlert('기본 옵션은 필수 선택입니다.');
				return false;
			}
		}

		if(exprnUseAt != 'Y'){
			if($('#frstOptnEssntlAt').val() == 'Y' && isEmpty($('#fOptOption option:selected').val())) {
				modooAlert('첫 구독옵션은 필수 선택입니다.');
				return false;
			}
		}

		var orderCo = $('#orderCo').val();
		if(isEmpty(orderCo) || orderCo == '0') {
			modooAlert('수량을 선택하세요!');
			return false;
		}
		return true;
	}

	//장바구니에 담기
	$(document).on('click', '#btnAddCart', function(e) {
		var $form = $('#goodsOrderForm');
		e.preventDefault();
		popClose('popupCart');
		if ($(".goodsLi").length == 0 && $(".option-select-area:eq(0) li[data-secode=D]").length == 0) {
			modooAlert('상품을 선택해 주세요.');
			popClose('popupCart');
			return false;
		}else if(fnGoodsCountChk()){
			addCart();
		}
		//addCart();
		//수량체크

		/*if(validate($form)){
			//네이버 전환스크립트
			/!* var _nasa={};
             if (window.wcs) _nasa["cnv"] = wcs.cnv("3",1);*!/
			addCart();
		}*/
	});

	//장바구니에 담기
	function addCart() {
		var goodsId = $('#goodsId').val();
		var jsonData = '';
		var cartItemIdList = [];
		var cartItemList = [];
		var cartList = [];
		var goodsJson = '';


		if (goodsKndCode == 'GNR') {
			jsonData = {
				'goodsKndCode': 'GNR',
				'goodsId': goodsId,
				'cartItemList': null,
				'exprnUseAt': exprnUseAt,
				'compnoDscntUseAt': compnoDscntUseAtChk,
				'chldrnNm': null,
				'chldrnId': null,
				'cartList': null,
				'cartVoList' : null,
				'dOptnType' : $("#dOptnType").val()
			}

			$(".option-select-area:eq(0) li").each(function () {
				goodsJson = {
					'goodsKndCode': 'GNR',
					'goodsId': goodsId,
					'cartItemList': null,
					'exprnUseAt': exprnUseAt,
					'compnoDscntUseAt': compnoDscntUseAtChk,
					'chldrnNm': null,
					'chldrnId': null
				}
				cartItemList = [];

				if ($(this).data("secode") == "D") {
					cartItemList.push({
						"gitemId": $(this).find(".liDopt").val(),
						"gitemCo": $(this).find(".orderCo").val()
					});

					if ($(this).find(".liChdrId").length != 0) {//자녀이름
						goodsJson.chldrnNm = $(this).find(".liChdrNm").val();
						goodsJson.chldrnId = $(this).find(".liChdrId").val();
					}

					if ($("#qGitemListSize").val() != 0) {
						for (var i = 0; i < Number($("#qGitemListSize").val()); i++) {
							cartItemList.push({
								"gitemId": $(this).find("#qId_" + i).val(),
								"gitemAnswer": $(this).find("#qAnswer_" + i).val()
							});
						}
					}

				} else if ($(this).data("secode") == "S") {
					cartItemList.push({
						"gitemId": $(this).data("optid"),
						"gitemCo": $(this).find(".orderCo").val()
					})
				} else if($(this).hasClass("goodsLi")){
					goodsJson.orderCo = $(this).find(".orderCo").val();
				}

				goodsJson.cartItemList = cartItemList
				cartList.push(goodsJson)
			})

			jsonData.cartVoList = cartList;


			//구매상품
		} else if (goodsKndCode == 'SBS') {
			var orderCo = 1;
			var sbscrptCycleSeCode = $('#sbscrptCycleSeCode').val();

			jsonData = {
				'orderCo': orderCo,
				'goodsId': goodsId,
				'goodsKndCode': 'SBS',
				'sbscrptCycleSeCode': sbscrptCycleSeCode,
				'compnoDscntUseAt': compnoDscntUseAtChk,
				'cartItemList': null,
				'chldrnNm': null,
				'chldrnId': null,
				'cartVoList' : null,
				'dOptnType' : $("#dOptnType").val()
			}

			$(".option-select-area:eq(0) li").each(function () {
				goodsJson = {
					'goodsKndCode': 'SBS',
					'goodsId': goodsId,
					'cartItemList': null,
					'sbscrptCycleSeCode': sbscrptCycleSeCode,
					'sbscrptWeekCycle': null,
					'sbscrptDlvyWd': null,
					'sbscrptMtCycle': null,
					'sbscrptDlvyDay': null,
					'chldrnNm': null,
					'chldrnId': null,
					'exprnUseAt': exprnUseAt,
					'compnoDscntUseAt': compnoDscntUseAtChk,
				}
				cartItemList = [];

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
					cartItemList.push({
						"gitemId": $(this).find(".liDopt").val(),
						"gitemCo": orderCo
					});
				}

				if ($(this).data("secode") == "S") {
					cartItemList.push({
						"gitemId": $(this).data("optid"),
						"gitemCo": $(this).find(".orderCo").val(),
						"gistemSeCode" : "S"
					})
				}

				if ($(this).find(".liChdrId").length != 0) {//자녀옵션
					goodsJson.chldrnNm = $(this).find(".liChdrNm").val();
					goodsJson.chldrnId = $(this).find(".liChdrId").val();
				}

				goodsJson.cartItemList = cartItemList;
				cartList.push(goodsJson)

			})

			jsonData.cartVoList = cartList;

			/*if (cartItemIdList.length != 0) {
				jsonData.cartItemIdList = cartItemIdList;
			}

			if (cartItemList.length != 0) {
				jsonData.cartItemList = cartItemList;
			}*/


			//쿠폰상품
		} else if (goodsKndCode == 'CPN') {
			jsonData = {
				'orderCo': orderCo,
				'goodsId': goodsId,
				'goodsKndCode': 'CPN',
				'compnoDscntUseAt': compnoDscntUseAtChk,
				'dOptnType' : $("#dOptnType").val()
			}
		}
		$.ajax({
			url:CTX_ROOT+'/shop/goods/insertCart.json',
			data:JSON.stringify(jsonData),
			dataType:'json',
			type:'post',
			contentType: 'application/json',
			success:function(result){
				popClose('popupCart');
				if(result.redirectUrl!=null){
					window.location.href = result.redirectUrl;
				}
				if(result.message) {
					$('[data-popup="popupCartCmplt"]').find('.pop-message').html(result.message);
					popOpen('popupCartCmplt');
				}

				if(result.success){
					$('#cartCnt').remove();
					$('#cart').append('<span id="cartCnt" class="label-notice">'+result.data.cartCnt+'</span>');
				}
			}
		});
	}

	// 주문하기 or 구독하기 요청
	$(document).on('click', '.btnOrder', function(e) {
		var goodsId = $('#goodsId').val();
		var jsonData = '';
		var cartItemIdList = [];
		var cartItemList = [];
		var cartList = [];
		var goodsJson = '';

		if ($(".goodsLi").length == 0 && $(".option-select-area:eq(0) li[data-secode=D]").length == 0) {
			modooAlert('상품을 선택해 주세요.');
			popClose('popupCart');
			return false;
		} else if(fnGoodsCountChk()){

			if (goodsKndCode == 'GNR') {
				jsonData = {
					'goodsKndCode': 'GNR',
					'goodsId': goodsId,
					'cartItemList': null,
					'exprnUseAt': exprnUseAt,
					'compnoDscntUseAt': compnoDscntUseAtChk,
					'chldrnNm': null,
					'chldrnId': null,
					'cartList': null,
					'cartVoList' : null,
					'dOptnType' : $("#dOptnType").val()
				}

				$(".option-select-area:eq(0) li").each(function () {
					goodsJson = {
						'goodsKndCode': 'GNR',
						'goodsId': goodsId,
						'cartItemList': null,
						'exprnUseAt': exprnUseAt,
						'compnoDscntUseAt': compnoDscntUseAtChk,
						'chldrnNm': null,
						'chldrnId': null
					}
					cartItemList = [];

					if ($(this).data("secode") == "D") {
						cartItemList.push({
							"gitemId": $(this).find(".liDopt").val(),
							"gitemCo": $(this).find(".orderCo").val()
						});

						if ($(this).find(".liChdrId").length != 0) {//첫구독 옵션
							goodsJson.chldrnNm = $(this).find(".liChdrNm").val();
							goodsJson.chldrnId = $(this).find(".liChdrId").val();
						}

						if ($("#qGitemListSize").val() != 0) {
							for (var i = 0; i < Number($("#qGitemListSize").val()); i++) {
								cartItemList.push({
									"gitemId": $(this).find("#qId_" + i).val(),
									"gitemAnswer": $(this).find("#qAnswer_" + i).val()
								});
							}
						}

					} else if ($(this).data("secode") == "S") {
						cartItemList.push({
							"gitemId": $(this).data("optid"),
							"gitemCo": $(this).find(".orderCo").val()
						})
					}else if($(this).hasClass("goodsLi")){
						goodsJson.orderCo = $(this).find(".orderCo").val();
					}

					goodsJson.cartItemList = cartItemList
					cartList.push(goodsJson)
				})

				jsonData.cartVoList = cartList;

				//구매상품
			} else if (goodsKndCode == 'SBS') {
				var orderCo = 1;
				var sbscrptCycleSeCode = $('#sbscrptCycleSeCode').val();

				jsonData = {
					'orderCo': orderCo,
					'goodsId': goodsId,
					'goodsKndCode': 'SBS',
					'sbscrptCycleSeCode': sbscrptCycleSeCode,
					'compnoDscntUseAt': compnoDscntUseAtChk,
					'sbscrptWeekCycle': null,
					'sbscrptDlvyWd': null,
					'sbscrptMtCycle': null,
					'sbscrptDlvyDay': null,
					'cartItemList': null,
					'chldrnNm': null,
					'chldrnId': null,
					'cartVoList' : null,
					'dOptnType' : $("#dOptnType").val()
				}

				$(".option-select-area:eq(0) li").each(function () {
					goodsJson = {
						'goodsKndCode': 'SBS',
						'goodsId': goodsId,
						'cartItemList': null,
						'sbscrptCycleSeCode': sbscrptCycleSeCode,
						'sbscrptWeekCycle': null,
						'sbscrptDlvyWd': null,
						'sbscrptMtCycle': null,
						'sbscrptDlvyDay': null,
						'exprnUseAt': exprnUseAt,
						'chldrnNm': null,
						'chldrnId': null,
						'compnoDscntUseAt': compnoDscntUseAtChk
					}
					cartItemList = [];

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
						cartItemList.push({
							"gitemId": $(this).find(".liDopt").val(),
							"gitemCo": orderCo
						});
					}

					if ($(this).data("secode") == "S") {
						cartItemList.push({
							"gitemId": $(this).data("optid"),
							"gitemCo": $(this).find(".orderCo").val(),
							"gistemSeCode" : "S"
						})
					}

					if ($(this).find(".liChdrId").length != 0) {//자녀옵션
						goodsJson.chldrnNm = $(this).find(".liChdrNm").val();
						goodsJson.chldrnId = $(this).find(".liChdrId").val();
					}

					goodsJson.cartItemList = cartItemList;
					cartList.push(goodsJson)

				})


				jsonData.cartVoList = cartList;

				/*if (cartItemIdList.length != 0) {
					jsonData.cartItemIdList = cartItemIdList;
				}

				if (cartItemList.length != 0) {
					jsonData.cartItemList = cartItemList;
				}*/

				//쿠폰상품
			} else if (goodsKndCode == 'CPN') {
				jsonData = {
					'orderCo': orderCo,
					'goodsId': goodsId,
					'goodsKndCode': 'CPN',
					'compnoDscntUseAt': compnoDscntUseAtChk,
					'dOptnType' : $("#dOptnType").val()
				}
			}

			$.ajax({
				url:CTX_ROOT+'/shop/goods/insertCart2.json',
				data:JSON.stringify(jsonData),
				dataType:'json',
				type:'post',
				contentType: 'application/json',
				success:function(result){
					if(result.success){
						location.href = "/shop/goods/goodsOrder.do?cartGroupNo="+result.data.cartGroupNo+"&searchGoodsKndCode="+goodsKndCode;
					}
					if(!isEmpty(result.message))modooAlert(result.message);
				}
			});
		}



		/*
                //일반,체험구매
                $.ajax({
                    url:CTX_ROOT+'/shop/goods/insertCart2.json',
                    data:JSON.stringify(jsonData),
                    dataType:'json',
                    type:'post',
                    contentType: 'application/json',
                    success:function(result){
                        popClose('popupCart');
                        if(result.redirectUrl!=null){
                            window.location.href = result.redirectUrl;
                        }
                        if(result.message) {
                            $('[data-popup="popupCartCmplt"]').find('.pop-message').html(result.message);
                            popOpen('popupCartCmplt');
                        }

                        if(result.success){
                            $('#cartCnt').remove();
                            $('#cart').append('<span id="cartCnt" class="label-notice">'+result.data.cartCnt+'</span>');
                        }
                    }
                });*/

		//sendOrderData(orderMode);
	});

	// 주문하기 or 구독하기 요청
	/*function sendOrderData(orderMode) {
		var $form = $('#goodsOrderForm');

		if(orderMode == 'SBS') {
			$form.attr('action', CTX_ROOT + '/shop/goods/order.do');
			$form.submit();
		}
	}

	// 주문(장바구니 or 구독하기) Submit;
	$(document).on('submit', '#goodsOrderForm', function(e) {
		if(!validate($(this))) {
			e.preventDefault();
		}
	});*/

	// 업체요청사항 Keypress
	$(document).on('keypress', '.gitemAnswer', function(e) {
		if(e.keycode == '13') return false;
	});

	// 수량 변경
	/*$(document).on('change', '.orderCo', function(e) {
		var orderCo = $(this).val();
		if(isEmpty(orderCo)) {
			$('.orderCo').val('1');
		}
		$('.orderCo').not(this).val(orderCo);

		setTotalPrice();
	});*/

	// 수량(+ or -) 변경 Click
	$(document).on('click', '.btn-minus, .btn-plus', function(e) {
		var orderCo =  Number($(this).closest("li").find(".orderCo").val());;

		if($(this).closest("li").hasClass("goodsLi")){
			if($(this).hasClass('btn-minus')) {
				orderCo = orderCo - 1;
				if(orderCo < 1) {
					$(".goodsLi").find(".btn-minus").attr('disabled', true);
					$(".goodsLi").find(".orderCo").val('1');
					return;
				}
			}else {
				orderCo = orderCo + 1;
				$(".goodsLi").find(".btn-minus").attr('disabled', false);
			}
			$(".goodsLi").find(".orderCo").val(orderCo);
		}else{
			var liId = $(this).closest("li").data("optid");
			if($(this).hasClass('btn-minus')) {
				orderCo = orderCo - 1;

				if(orderCo < 1) {
					$("ul.option-select-area").find("[data-optid='"+liId+"']").find(".btn-minus").attr('disabled', true);
					$("ul.option-select-area").find("[data-optid='"+liId+"']").find(".orderCo").val('1');
					return;
				}
			}else {
				orderCo = orderCo + 1;
				$("ul.option-select-area").find("[data-optid='"+liId+"']").find(".btn-minus").attr('disabled', false);
			}
			$("ul.option-select-area").find("[data-optid='"+liId+"']").find(".orderCo").val(orderCo);
		}


		/*if($(this).hasClass("tempGoodsCo")){
			orderCo = Number($(".goodsOrderCo").val());
			if($(this).hasClass('btn-minus')) {
				orderCo = orderCo - 1;

				if(orderCo < 1) {
					$(".tempCount").find(".btn-minus").attr('disabled', true);
					$(".tempCount").find(".goodsOrderCo").val('1');
					return;
				}
			}else {
				orderCo = orderCo + 1;
				$(".tempCount").find(".btn-minus").attr('disabled', false);
			}
			$(".tempCount").find(".goodsOrderCo").val(orderCo);
		}else{
			var liId = $(this).closest("li").data("optid");

			orderCo = Number($(this).closest("li").find(".orderCo").val());
			if($(this).hasClass('btn-minus')) {
				orderCo = orderCo - 1;

				if(orderCo < 1) {
					$("ul.option-select-area").find("[data-optid='"+liId+"']").find(".btn-minus").attr('disabled', true);
					$("ul.option-select-area").find("[data-optid='"+liId+"']").find(".orderCo").val('1');
					return;
				}
			}else {
				orderCo = orderCo + 1;
				$("ul.option-select-area").find("[data-optid='"+liId+"']").find(".btn-minus").attr('disabled', false);
			}
			$("ul.option-select-area").find("[data-optid='"+liId+"']").find(".orderCo").val(orderCo);
		}*/

		setTotalPrice();
	});

	// 옵션 Change(기존)
	/*$(document).on('change', '.orderOption', function(e) {
		setTotalPrice();
	});*/

	// 구매 옵션 처리
	$(document).on('change', '.sbscrptWeekCycle', function(e) {
		var week = $(this).val();
		$('.sbscrptWeekCycle').not(this).val(week);
	});
	$(document).on('change', '.sbscrptDlvyWd', function(e) {
		var week = $(this).val();
		$('.sbscrptDlvyWd').not(this).val(week);
		sbsOpt = $(this).closest(".option-list").find(".sbscrptDlvyWd");
		sbsValidation(this);
	});
	$(document).on('change', '.sbscrptMtCycle', function(e) {
		var week = $(this).val();
		$('.sbscrptMtCycle').not(this).val(week);
		sbsValidation(this);
	});
	$(document).on('change', '.sbscrptDlvyDay', function(e) {
		var week = $(this).val();
		$('.sbscrptDlvyDay').not(this).val(week);
		sbsValidation(this);
	});
	$(document).on('click', '.btn-datepicker-toggle', function(e) {
		sbsOpt = $(this).closest(".option-list").find(".sbscrptDlvyDay");
	});

	$(document).on('click', '.layer-datepicker button', function(e) {
		sbsValidation(sbsOpt);
	});

	$(document).on('change', '.fOpt', function(e) { //첫구독
		var week = $(this).val();
		$('.fOpt').not(this).val(week);
		setTotalPrice();
	});
	/*$(document).on('change', '.aOpt', function(e) { //추가옵션
		var week = $(this).val();
		$('.aOpt').not(this).val(week);
		setTotalPrice();
	});*/

	$(document).on('change', '.sOpt', function(e) {
		var obj = $(this);
		var opt = $(this).val();
		//$(".sOpt").not(this).val($(this).val());
		$('.sOpt').not(this).val(opt);
		if($(this).val() != 0){
			fnOptionArea(obj, "sOpt");
		}
	});

	$(document).on('change', '.dOpt1', function(e) {
		var opt = $(this).val();
		var optClass = $(this).attr("class");
		//$("select[class='"+optClass+"']").not(this).val(opt);
		if(opt != ""){
			$('.dOpt1').not(this).val(opt);
			if($(".dOpt2").length == 0){
				fnOptionArea(this , "dOpt");
			}
		}


	});

	$(document).on('change', '.dOpt2 ', function(e) {
		var opt = $(this).val();
		var optClass = $(this).attr("class");

		$('.dOpt2').not(this).val(opt);
		//$("select[class='"+optClass+"']").not(this).val(opt);
		if (opt != "" && $(".dOpt1").val() != "") {
			fnOptionArea(this, "dOpt");
		}

	});

	if(chldrnnmUseAt=='Y'){
		$(document).on('change', '.chdr', function(e) {

			if(goodsKndCode == "SBS"){
				if($(this).val()=="FOXUSER_999999999998"){
					$('.chdrNm').val('');
					$('.chdrNm').show();
				}else{
					$('.chdrNm').hide();
					$('.chdrNm').val($('.chdr option:selected').text());
					sbsValidation(this);
				}
				$(".chdr").not(this).val($(this).val());
			}else{
				if($(this).val()=="FOXUSER_999999999998"){
					$(this).closest("li").find('.chdrNm').val('');
					$(this).closest("li").find('.chdrNm').show();
				}else{
					$(this).closest("li").find('.chdrNm').hide();
					$(this).closest("li").find('.chdrNm').val($('.chdr option:selected').text());
					sbsValidation(this);
				}
			}
		});

	}



	if(goodsKndCode == "SBS") {
		$(document).on('blur', '.chdrNm, .qOptionLi input', function(e) {
            var obj = $(this);
            if($(this).hasClass("gitemAnswer")){
                $("[data-answerid="+$(this).data("answerid")+"]").not(this).val($(this).val());
            }else{
                $("."+$(this).attr("class")).not(this).val($(this).val());
            }
			sbsValidation(this);
        });
	}
	/*function fnOptChk(object){
		var goodsId = $('#goodsId').val();


		evtGoodsOrderChk(goodsId);
		if(evtGoodsOrderChkAt=='N'){
			//modooAlert('본 상품은 1회만 구매가능합니다.!');
			return false;
		}

		if (goodsKndCode != 'GNR' && goodsKndCode != 'CPN') {
			var sbscrptCycleSeCode = $('#sbscrptCycleSeCode').val();
			if(sbscrptCycleSeCode == 'WEEK') {
				var sbscrptWeekCycle = $('#sbscrptWeekCycle option:selected').val();
				if(isEmpty(sbscrptWeekCycle)) {
					//modooAlert('구독주기를 선택하세요!');
					return false;
				}
				var sbscrptDlvyWd = $('#sbscrptDlvyWd option:selected').val();
				if(isEmpty(sbscrptDlvyWd)) {
					//modooAlert('정기결제 요일을 선택하세요!');
					return false;
				}

			}else if(sbscrptCycleSeCode == 'MONTH') {
				var sbscrptMtCycle = $('#sbscrptMtCycle option:selected').val();
				if(isEmpty(sbscrptMtCycle)) {
					//modooAlert('구독주기를 선택하세요!');
					return false;
				}
				var sbscrptDlvyDay = $('#sbscrptDlvyDay').val();
				if(isEmpty(sbscrptDlvyDay)) {
					//modooAlert('정기 결제일을 선택하세요!');
					return false;
				}
			}

			if($("#frstOptnEssntlAt").val() == "Y"){
				if(isEmpty($(".fOpt").val())){
					//modooAlert('첫구독 옵션을 선택하세요!');
					return false;
				}
			}
		}if (goodsKndCode == 'GNR'){
			if($(".qOptionLi").length != 0){
				$(object).closest("ul").find('.qOptionLi .gitemAnswer').each(function(){
					if(!!!$(this).val()){
						return false;
					}
				});
			}
		}

		if($(".chdr").length != 0){
			if($(object).closest("ul").find(".chdr").val() == "0" || ("FOXUSER_999999999998" == $(object).closest("ul").find(".chdr").val() && !!!$(object).closest("ul").find(".chdrNm").val())){
				return false;
			}
		}
		return true;
	}*/

	function fnOptionArea(object, type){
		var goodsId = $('#goodsId').val();
		//기본옵션 체크확인

		if(type != "sOpt"){
			/*evtGoodsOrderChk(goodsId);
			if(evtGoodsOrderChkAt=='N'){
				modooAlert('본 상품은 1회만 구매가능합니다.!');
				return false;
			}*/

			/*if (goodsKndCode != 'GNR' && goodsKndCode != 'CPN') {
				var sbscrptCycleSeCode = $('#sbscrptCycleSeCode').val();

				if($("#frstOptnEssntlAt").val() == "Y"){
					if(isEmpty($(".fOpt").val())){
						modooAlert('첫구독 옵션을 선택하세요!');
						return false;
					}
				}

				if(sbscrptCycleSeCode == 'WEEK') {
					var sbscrptWeekCycle = $('#sbscrptWeekCycle option:selected').val();
					if(isEmpty(sbscrptWeekCycle)) {
						modooAlert('구독주기를 선택하세요!');
						return false;
					}
					var sbscrptDlvyWd = $('#sbscrptDlvyWd option:selected').val();
					if(isEmpty(sbscrptDlvyWd)) {
						modooAlert('정기결제 요일을 선택하세요!');
						return false;
					}

				}else if(sbscrptCycleSeCode == 'MONTH') {
					var sbscrptMtCycle = $('#sbscrptMtCycle option:selected').val();
					if(isEmpty(sbscrptMtCycle)) {
						modooAlert('구독주기를 선택하세요!');
						return false;
					}
					var sbscrptDlvyDay = $('#sbscrptDlvyDay').val();
					if(isEmpty(sbscrptDlvyDay)) {
						modooAlert('정기 결제일을 선택하세요!');
						return false;
					}
				}

			}*/if(goodsKndCode == 'GNR'){
				var returnChk = true;
				if($(".qOptionLi").length != 0){
					$(object).closest("ul").find('.qOptionLi .gitemAnswer').each(function(){
						if(!!!$(this).val()){
							modooAlert('요청사항을 입력해주세요!');
							returnChk = false
							return false;
						}
					});

					if(returnChk == false){
						return false;
					}
				}
			}

			if($(".chdr").length != 0){
				if($(object).closest("ul").find(".chdr").val() == "0" || ("FOXUSER_999999999998" == $(object).closest("ul").find(".chdr").val() && !!!$(object).closest("ul").find(".chdrNm").val())){
					modooAlert('자녀를 입력하세요!');
					return false;
				}
			}
		}



		var chkArr = $.makeArray($(".option-select-area li").map(function(){
			return $(this).data("optid");
		}));

		chkArr = Array.from(new Set(chkArr));

		var optId = "";
		var tempPrice = "";
		var tempTextVal = [];
		var tempText = "";
		var tempQanswer = "";
		var tempQid = "";
		var tempHtml = "";
		var limitCnt = "";

		if(type == "sOpt"){//추가상품
			tempPrice = Number($(object).find("option:selected").data("pc")).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
			tempTextVal.push($(object).find("option:selected").text());
			optId = $(object).find("option:selected").val();
		}else if(type == "dOpt" ) {

			if (goodsKndCode == "SBS") {
				tempHtml = "<input type=\"hidden\" class=\"liDopt\" value=\""+$(object).find("option:selected").val()+"\" />";

				tempPrice = Number($("#goodsPrice").val()).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");

				if ($("#dOptnType").val() == "B") {
					var optnPrice = "";
					optnPrice = Number($('.dOpt1 option:selected').data('price'));


					if($('.dOpt2').length != 0)optnPrice = Number($('.dOpt2 option:selected').data('price'));

					tempPrice = optnPrice.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
				}
				/*tempPrice = Number($("#goodsPrice").val()).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");*/
				if($('#sbscrptCycleSeCode').val() == "WEEK"){
					tempTextVal.push("구독주기: " + $(object).closest("ul").find(".sbscrptWeekCycle").find("option:selected").text());
					tempTextVal.push("정기결제요일: " + transferDlvyWd($(object).closest("ul").find(".sbscrptDlvyWd").val()));
					optId = $(object).closest("ul").find(".sbscrptWeekCycle").find("option:selected").text();
					optId += "_"+$(object).closest("ul").find(".sbscrptDlvyWd").val();
					tempHtml += "<input type=\"hidden\" class=\"sbsCycle\" value=\""+$(object).closest("ul").find(".sbscrptWeekCycle").find("option:selected").val()+"\" />"
					tempHtml += "<input type=\"hidden\" class=\"sbsDay\" value=\""+$(object).closest("ul").find(".sbscrptDlvyDay").val()+"\" />"
				}else{
					tempTextVal.push("구독주기: " + $(object).closest("ul").find(".sbscrptMtCycle").find("option:selected").text());
					tempTextVal.push("정기결제일: " + $(object).closest("ul").find(".sbscrptDlvyDay").val());
					optId = $(object).closest("ul").find(".sbscrptMtCycle").find("option:selected").text();
					optId += "_"+$(object).closest("ul").find(".sbscrptDlvyDay").val();
					tempHtml += "<input type=\"hidden\" class=\"sbsCycle\" value=\""+$(object).closest("ul").find(".sbscrptMtCycle").find("option:selected").val()+"\" />"
					tempHtml += "<input type=\"hidden\" class=\"sbsDay\" value=\""+$(object).closest("ul").find(".sbscrptDlvyDay").val()+"\" />"
				}


				if(!isEmpty($(".fOpt").val())){
					tempTextVal.push("첫구독 옵션: " + $(object).closest("ul").find(".fOpt").find("option:selected").text());
					optId += "_"+$(object).closest("ul").find(".fOpt").val();
					tempHtml += "<input type=\"hidden\" class=\"selectFopt\" value=\""+$(object).closest("ul").find(".fOpt").val()+"\" />"
				}

				if(!isEmpty($(object).closest("ul").find(".dOpt1").val())) {
					tempTextVal.push($(object).closest("ul").find(".dOpt1 option:selected").data("gitemnm"));
				}

				if(!isEmpty($(object).closest("ul").find(".dOpt2").val())) {
					tempTextVal.push($(object).closest('ul').find(".dOpt2 option:selected").data("gitemnm").replaceAll(",", " / "));
				}

			} else {
				optId = $(object).find("option:selected").val();
				tempHtml = "<input type=\"hidden\" class=\"liDopt\" value=\""+$(object).find("option:selected").val()+"\" />";
				limitCnt = Number($(object).find("option:selected").data("count"));

				if ($("#dOptnType").val() == "A") {
					tempPrice = Number($("#goodsPrice").val()).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
				} else {
					tempPrice = Number($(object).find("option:selected").data("price")).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
				}

				if ($(".qOptionLi").length != 0) {
					var idIndex = 0;
					var answerIndex = 0;
					$(object).closest("ul").find('.qOptionLi input').each(function () {
						if ($(this).hasClass("gitemAnswer")) {
							tempTextVal.push($(this).val());
							tempQanswer += "<input type=\"hidden\" id=\"qAnswer_" + (answerIndex++) + "\" value=\"" + $(this).val() + "\" />";
						} else {
							optId += "_" + $(this).val();
							tempQid += "<input type=\"hidden\" id=\"qId_" + (idIndex++) + "\" value=\"" + $(this).val() + "\" />";
						}
					});
				}
				if($(object).hasClass("dOpt1")) {
					tempTextVal.push($(object).find("option:selected").data("gitemnm"));
				}else if($(object).hasClass("dOpt2")) {
					tempTextVal.push($(object).find("option:selected").data("gitemnm").replaceAll(",", " / "));
				}

			}

			if($(".chdr").length != 0){
				if($(object).closest("ul").find(".chdr").val() != "FOXUSER_999999999999"){
					if($(object).closest("ul").find(".chdr").val() == "FOXUSER_999999999998"){
						tempTextVal.push("자녀: "+$(object).closest("ul").find(".chdrNm").val());
						optId += "_"+$(object).closest("ul").find(".chdrNm").val();
						tempHtml += "<input type=\"hidden\" class=\"liChdrNm\" value=\""+$(object).closest("ul").find(".chdrNm").val()+"\" />";
						tempHtml += "<input type=\"hidden\" class=\"liChdrId\" value=\"FOXUSER_999999999998\" />";
					}else{
						tempTextVal.push("자녀: "+$(object).closest("ul").find(".chdr").find("option:selected").text());
						optId += "_"+$(object).closest("ul").find(".chdr").val();
						tempHtml += "<input type=\"hidden\" class=\"liChdrNm\" value=\""+$(object).closest("ul").find(".chdr").find("option:selected").text()+"\" />";
						tempHtml += "<input type=\"hidden\" class=\"liChdrId\" value=\""+$(object).closest("ul").find(".chdr").val()+"\" />";
					}
				}else if($(object).closest("ul").find(".chdr").val() == "FOXUSER_999999999999"){
					tempTextVal.push("자녀: "+$(object).closest("ul").find(".chdr").find("option:selected").text());
					optId += "_"+$(object).closest("ul").find(".chdr").val();
					tempHtml += "<input type=\"hidden\" class=\"liChdrNm\" value=\""+$(object).closest("ul").find(".chdr").find("option:selected").text()+"\" />";
					tempHtml += "<input type=\"hidden\" class=\"liChdrId\" value=\""+$(object).closest("ul").find(".chdr").val()+"\" />";

				}
			}

		}


		tempText = tempTextVal.toString().replaceAll(",", "/ ");

		if($.inArray(optId, chkArr) != -1){
			modooAlert('이미 추가되어 있습니다.','',function(){
				return false;
			});
		}else {
			var tempCode = type == "dOpt" ? "D" : type == "sOpt" ? "S" : "";
			var html = "";
			html += "<li data-optid=\"" + optId + "\" data-secode=\"" + tempCode + "\">";
			html += "<p>" + tempText + "</p>";
			html += "<div class=\"count\">";

			html += "<button type=\"button\" class=\"btn-minus sm\" disabled><span class=\"txt-hide\">빼기</span></button>";
			html += "<input type=\"number\" value=\"1\" class=\"orderCo inputNumber\" min=\"1\" max=\""+limitCnt+"\" title=\"수량 입력\" maxLength=\"4\" readOnly/>";
			if(goodsKndCode == "SBS" && type == "dOpt"){
				html += "<button type=\"button\" class=\"btn-plus sm\" disabled><span class=\"txt-hide\">더하기</span></button>";
			}else{
				html += "<button type=\"button\" class=\"btn-plus sm\"><span class=\"txt-hide\">더하기</span></button>";
			}

			html += "</div>";
			html += "<div class=\"price\">" + tempPrice + "원</div>";
			html += "<button class=\"btn-del-r\"><span class=\"txt-hide\">삭제</span></button>";
			if (type == "dOpt"){
				html += tempQanswer + tempQid + tempHtml;
			}
			html += "</li>";

			$(".option-select-area").prepend(html);
			setTotalPrice();
		}
	}



	$(document).ready(function() {
		setTotalPrice();
	});

	var payInfoText = $('.payInfo-text').html();


	//정기결제 validation
	function sbsValidation(object){

		var sbscrptCycleSeCode = $('#sbscrptCycleSeCode').val();

		if($("#frstOptnEssntlAt").val() == "Y"){
			if(isEmpty($(".fOpt").val())){
				return false;
			}
		}

		if(sbscrptCycleSeCode == 'WEEK') {
			console.log(sbscrptCycleSeCode);
			var sbscrptWeekCycle = $('#sbscrptWeekCycle option:selected').val();
			if(isEmpty(sbscrptWeekCycle)) {
				return false;
			}
			var sbscrptDlvyWd = $('#sbscrptDlvyWd option:selected').val();
			if(isEmpty(sbscrptDlvyWd)) {
				return false;
			}

		}
		if(sbscrptCycleSeCode == 'MONTH') {
			var sbscrptMtCycle = $('#sbscrptMtCycle option:selected').val();
			if(isEmpty(sbscrptMtCycle)) {
				return false;
			}

			var sbscrptDlvyDay = $('#sbscrptDlvyDay').val();

			if(isEmpty(sbscrptDlvyDay)) {
				return false;
			}
		}

		if(chldrnnmUseAt=='Y') {
			if((isEmpty($('.chdr').val() || $('.chdr').val()=='FOXUSER_999999999998' && isEmpty($('.chdrNm').val())))){
				return false;
			}
		}

		if(($(".dOpt1").length != 0 && isEmpty($(".dOpt1").val()))
			|| $(".dOpt2").length != 0 && isEmpty($(".dOpt2").val())){
			return false;
		}

		if($(".option-select-area:eq(0)").find("[data-secode=D]").length != 0){
			modooAlert('이미 상품을 추가하셨습니다!');
			return false;
		}

		fnOptionArea(object,'dOpt');
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

	//정기구독 관련
	$('.btn-option-check').on('click', function () {
		$('.option-check, .option-check .tooltip-area').removeClass('is-active');
		$type = $(this).data('buytype');
		$el = $('[data-buytype="' + $type + '"]');

		if($type=='experience'){
			$('#goodsKndCode').val('GNR');
			$('.sbscrptWeekCycle').parent('li').hide();
			$('.sbscrptWeekCycle').val(null);
			$('.sbscrptDlvyWd').parent('li').hide();
			$('.sbscrptDlvyWd').val(null);
			$('.sbscrptMtCycle').parent('li').hide();
			$('.sbscrptMtCycle').val(null);
			$('.sbscrptDlvyDay').parent('div').parent('li').hide();
			$('.fOpt').parent('li').hide();
			$('.fOpt').val(null);
			$('.fOpt').next('.msg').hide();
			$('#exprnUseAt').val('Y');
			exprnUseAt = 'Y';
			$('.btnOrderText').text('구매하기');
			$('.exprnPc-area').parent('li').show();
			$('.payInfo-text').text('1회 체험으로 구매하시면, 주문 시 1회 결제만 이루어집니다.');
			$('.dlvyInfo-text').text('결제 후, 2~3일 이내 배송됩니다.');
			setTotalPrice();
		}else{
			$('#goodsKndCode').val('SBS');
			$('.sbscrptWeekCycle').parent('li').show();
			$('.sbscrptWeekCycle').val($('.sbscrptWeekCycle').children('option').first().val());
			$('.sbscrptDlvyWd').parent('li').show();
			$('.sbscrptDlvyWd').val($('.sbscrptDlvyWd').children('option').first().val());
			$('.sbscrptMtCycle').parent('li').show();
			$('.sbscrptMtCycle').val($('.sbscrptMtCycle').children('option').first().val());
			$('.sbscrptDlvyDay').parent('div').parent('li').show();
			$('.btnOrderText').text('구독하기');
			$('.btnOrderText').append('<i class="ico-arr-r sm back wh" aria-hidden="true"></i>');
			$('.fOpt').parent('li').show();
			$('.fOpt').next('.msg').show();
			$('.total-info-list').hide();
			$('.exprnPc-area').parent('li').hide();
			$('.exprnPc-area').text(0);
			$('#exprnUseAt').val('N');
			$('.payInfo-text').html(payInfoText);
			$('.dlvyInfo-text').text('정기결제 후, 2~3일 이내 배송됩니다.');
			exprnUseAt = 'N';
			setTotalPrice();
		}

		$el.parent().addClass('is-active');
	});

	/*//1회체험
	$(document).on('click','.optioncheck',function(){

		    toggleCommonFunc({
		        obj: $('.option-check-area'),
		        className: 'is-active',
		        hasClass: function () {
		        	$('.optioncheck').prop('checked',true).button("refresh");
					$('#goodsKndCode').val('GNR');
					$('.sbscrptWeekCycle').parent('li').hide();
					$('.sbscrptWeekCycle').val(null);
					$('.sbscrptDlvyWd').parent('li').hide();
					$('.sbscrptDlvyWd').val(null);
					$('.sbscrptMtCycle').parent('li').hide();
					$('.sbscrptMtCycle').val(null);
					$('.sbscrptDlvyDay').parent('div').parent('li').hide();
					$('.fOpt').parent('li').hide();
					$('.fOpt').val(null);
					$('.fOpt').next('.msg').hide();
					exprnUseAt = 'Y';
					$('.btnOrderText').text('구매하기');
					$('.exprnPc-area').parent('li').show();
					setTotalPrice();
		        },
		        noneClass: function () {
		        	$('.optioncheck').prop('checked',false).button("refresh");
					$('#goodsKndCode').val('SBS');
					$('.sbscrptWeekCycle').parent('li').show();
					$('.sbscrptWeekCycle').val($('.sbscrptWeekCycle').children('option').first().val());
					$('.sbscrptDlvyWd').parent('li').show();
					$('.sbscrptDlvyWd').val($('.sbscrptDlvyWd').children('option').first().val());
					$('.sbscrptMtCycle').parent('li').show();
					$('.sbscrptMtCycle').val($('.sbscrptMtCycle').children('option').first().val());
					$('.sbscrptDlvyDay').parent('div').parent('li').show();
					exprnUseAt = 'N';
					$('.btnOrderText').text('구독하기');
					$('.btnOrderText').append('<i class="ico-arr-r sm back wh" aria-hidden="true"></i>');
					$('.fOpt').parent('li').show();
					$('.fOpt').next('.msg').show();
					$('.total-info-list').hide();
					$('.exprnPc-area').parent('li').hide();
					$('.exprnPc-area').text(0);
					exprnUseAt = 'N';
					setTotalPrice();
		        }
		    })
	})*/

	$(document).on('click', '.btn-del-r', function(e) {
		var tempData = $(this).closest("li").data("optid");
		$("ul.option-select-area").find("[data-optid='"+tempData+"']").remove();
		setTotalPrice();
	});

	$(document).on('change', '.dOpt1', function(e) {
		var optVal = $(this).val();

		if($(".dOpt2 ").length != 0){
			$(".dOpt2").find(":not(option:eq(0))").remove();
			if(optVal != "" && $("#orderOption2").length != 0){
				optVal += ",";
				$.ajax({
					url:'/shop/goods/secondOptValues.json',
					data:{"opt1": optVal , "goodsId" : $('#goodsId').val(), },
					dataType:'json',
					type:'get',
					contentType: 'application/json',
					success:function(result){
						var html = "";
						if(result.success){
							var resultList = result.data.resultList;
							for(var i=0; i<resultList.length; i++){
								var tempNm = resultList[i].gitemNm.replace(optVal, "");
								html += "<option value=\""+resultList[i].gitemId+"\" data-gitemnm=\""+resultList[i].gitemNm+"\" data-price=\""+resultList[i].gitemPc+"\">"+tempNm+"</option>";
							}
							$(".dOpt2").append(html);
						}
					}
				});
			}
		}else{
			return false;
		}
	});


	//자녀여부
	function selectChildList(){
		var html = '';
		$.ajax({
			url:'/api/selectChildList.json',
			dataType:'json',
			type:'GET',
			success:function(result){
				var chdrArr = result.data.chdrArray;
				if(chdrArr.length>1){
					for(let i = 0; i<chdrArr.length;i++){
						html += '<option value="'+chdrArr[i].childEsntlId+'">'+chdrArr[i].childNm+'</option>';
					}
				}
			},
			complete:function(){
				html += '<option value="FOXUSER_999999999999">없음</option>';
				html += '<option value="FOXUSER_999999999998">직접입력</option>';
				$('.chdr').append(html);
			}
		});
	}

	function fnGoodsCountChk(){
		var chkArrD = [];
		var chkArrS = [];
		var tempCo = 0;
		var returnChk = true;
		var goodsIdList = [];
		$(".option-select-area:eq(0) li").each(function(){
			if($(this).data("secode") == "S"){
				chkArrS.push({"gitemId" : $(this).data("optid"), "gitemCo" : Number($(this).find(".orderCo").val())});
			}

			if($(this).data("secode") == "D"){
				if($("#dOptnType").val() == "A"){
					tempCo +=  Number($(this).find(".orderCo").val());
				}else{
					chkArrD.push({"gitemId" : $(this).find(".liDopt").val(), "gitemCo" : Number($(this).find(".orderCo").val())});
				}

			}else if($(this).hasClass("goodsLi")){//일반상품(기본옵션 사용안하는 경우)
				tempCo =  Number($(this).find(".orderCo").val());
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
										if (Number(chkArrD[j].gitemCo) > Number(dgitem[i].gitemCo)) {
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
									if (Number(chkArrS[j].gitemCo) > Number(sgitem[i].gitemCo)) {
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
		});

		return returnChk;

	}
})();

function fnCartMove(goodsKndCode){
	var form = $('<form></form>');
	form.attr('action', "/shop/goods/cart.do");
	form.attr('method', 'post');
	form.appendTo('body');
	form.append($('<input type="hidden" value="' + goodsKndCode + '" name="goodsKndCode">'));
	form.submit();
};