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


	//이벤트상품주문 체크
	function evtGoodsOrderChk(goodsId){
		$.ajax({
			url:CTX_ROOT+'/shop/goods/evtGoodsOrderChk.json',
			data:{'goodsId':goodsId},
			type:'POST',
			async: false,
			dataType:'json',
			success:function(result){
				console.log(result);
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

	// 업체요청사항 Keypress
	$(document).on('keypress', '.gitemAnswer', function(e) {
		if(e.keycode == '13') return false;
	});


	// 수량(+ or -) 변경 Click
	$(document).off().on('click', '.btn-minus, .btn-plus', function(e) {
		var orderCo = Number($(this).closest("li").find(".orderCo").val());
		if($(this).hasClass('btn-minus')) {
			orderCo = orderCo - 1;

			if(orderCo < 1) {
				$(this).closest("li").find(".btn-minus").attr('disabled', true);
				$(this).closest("li").find(".orderCo").val('1');
				return;
			}
		}else {
			orderCo = orderCo + 1;
			$(this).closest("li").find(".btn-minus").attr('disabled', false);
		}
		$(this).closest("li").find(".orderCo").val(orderCo);
		setTotalPrice();
	});


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
	});
	$(document).on('change', '.sbscrptDlvyDay', function(e) {
		var week = $(this).val();
		$('.sbscrptDlvyDay').not(this).val(week);
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
		//$(".sOpt").not(this).val($(this).val());
		if($(this).val() != 0){
			fnOptionArea(obj, "sOpt");
		}
	});

	$(document).on('change', '.dOpt1', function(e) {
		var opt = $(this).val();
		var optClass = $(this).attr("class");
		//$("select[class='"+optClass+"']").not(this).val(opt);

		if(opt != ""){
			if($(".dOpt2").length == 0){
				fnOptionArea(this , "dOpt");
			}
		}


	});

	$(document).on('change', '.dOpt2 ', function(e) {
		var opt = $(this).val();
		var optClass = $(this).attr("class");
		//$("select[class='"+optClass+"']").not(this).val(opt);
		if(opt != "" && $(".dOpt1").val() != ""){
			fnOptionArea(this , "dOpt");
		}

	});

	$(document).on('blur', '.chdrNm, .qOptionLi input', function(e) {
		var obj = $(this);
		if($(this).hasClass("gitemAnswer")){
			$("[data-answerid="+$(this).data("answerid")+"]").not(this).val($(this).val());
		}else{
			$("."+$(this).attr("class")).not(this).val($(this).val());
		}
		sbsValidation(this);
	});

	//정기결제 validation
	function sbsValidation(object){

		var sbscrptCycleSeCode = $('#sbscrptCycleSeCode').val();

		if($("#frstOptnEssntlAt").val() == "Y"){
			if(isEmpty($(".fOpt").val())){
				return false;
			}
		}

		if(sbscrptCycleSeCode == 'WEEK') {
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

		/*if($(".option-select-area:eq(0)").find("[data-secode=D]").length != 0){
			$(".option-select-area:eq(0)").find("[data-secode=D]").remove();
		}*/

		fnOptionArea(object,'dOpt');
	}


	function fnOptionArea(object, type){
		var goodsId = $('#goodsId').val();
		//기본옵션 체크확인

		if(type != "sOpt"){
			evtGoodsOrderChk(goodsId);
			if(evtGoodsOrderChkAt=='N'){
				modooAlert('본 상품은 1회만 구매가능합니다.!');
				return false;
			}

			if (goodsKndCode != 'GNR' && goodsKndCode != 'CPN') {
				var sbscrptCycleSeCode = $('#sbscrptCycleSeCode').val();

			/*	if($("#frstOptnEssntlAt").val() == "Y"){
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
				}*/


			}if (goodsKndCode == 'GNR'){
				if($(".qOptionLi").length != 0){
					var eachReturn = false;
					$(object).closest("ul").find('.qOptionLi .gitemAnswer').each(function(){
						if(!!!$(this).val()){
							modooAlert('요청사항을 입력해주세요!');
							eachReturn = true;
							return false;
						}
					});
					if(eachReturn){
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

		var optId = "";
		var tempPrice = "";
		var tempTextVal = [];
		var tempText = "";
		var tempQanswer = "";
		var tempQid = "";
		var tempHtml = "";

		if(type == "sOpt"){//추가상품
			tempPrice = $(object).find("option:selected").data("pc");
			tempTextVal.push($(object).find("option:selected").text());
			optId = $(object).find("option:selected").val();
		}else if(type == "dOpt" ) {

			if (goodsKndCode == "SBS") {

				var dOptnId = '';
				if(!isEmpty($(object).closest("ul").find(".dOpt1").val())) {
					tempTextVal.push($(object).closest("ul").find(".dOpt1 option:selected").data("gitemnm"));
					dOptnId = $(object).closest('ul').find('.dOpt1').val();
				}

				if(!isEmpty($(object).closest("ul").find(".dOpt2").val())) {
					tempTextVal.push($(object).closest('ul').find(".dOpt2 option:selected").data("gitemnm").replaceAll(",", " / "));
					dOptnId = $(object).closest('ul').find('.dOpt2').val();
				}
				tempHtml = "<input type=\"hidden\" class=\"liDopt\" value=\""+dOptnId+"\" />";
				tempPrice = Number($("#goodsPrice").val()).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");

				if ($("#dOptnType").val() == "B") {
					var optnPrice = 0;
					console.log($('.dOpt1 option:selected').data('price'));
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

				/*if(!isEmpty($(object).closest("ul").find(".dOpt1").val())) {
					tempTextVal.push($(object).closest("ul").find(".dOpt1 option:selected").data("gitemnm"));
				}

				if(!isEmpty($(object).closest("ul").find(".dOpt2").val())) {
					tempTextVal.push($(object).closest('ul').find(".dOpt2 option:selected").data("gitemnm").replaceAll(",", " / "));
				}*/
			} else {
				optId = $(object).find("option:selected").val();
				tempHtml = "<input type=\"hidden\" class=\"liDopt\" value=\""+$(object).find("option:selected").val()+"\" />";

				if ($("#dOptnType").val() == "A") {
					tempPrice = $("#goodsPrice").val();
				} else {
					tempPrice = $(object).find("option:selected").data("price");
				}

				if ($(".qOptionLi").length != 0) {
					var idIndex = 0;
					var answerIndex = 0;
					$(object).closest("ul").find('.qOptionLi input').each(function () {
						if ($(this).hasClass("gitemAnswer")) {
							tempTextVal.push($(this).val());
							tempQanswer += "<input type=\"hidden\" id=\"qAnswer_" + (answerIndex++) + "\" value=\"" + $(this).val() + "\" />";
						} else {
							//optId += "_" + $(this).val();
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
						optId += "_"+$(object).closest("ul").find(".chdr").val()+"_"+$(object).closest("ul").find(".chdrNm").val();
						tempHtml += "<input type=\"hidden\" class=\"liChdrNm\" value=\""+$(object).closest("ul").find(".chdrNm").val()+"\" />";
						tempHtml += "<input type=\"hidden\" class=\"liChdrId\" value=\"FOXUSER_999999999998\" />";
					}else{
						tempTextVal.push("자녀: "+$(object).closest("ul").find(".chdr").find("option:selected").text());
						optId += "_"+$(object).closest("ul").find(".chdr").val()+"_"+$(object).closest("ul").find(".chdrNm").val();
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

		if($(".option-select-area li").length != 0 && goodsKndCode=='SBS'){
			$(".option-select-area li").remove();
		}

		var chkArr = $.makeArray($(".option-select-area li").map(function(){
			return $(this).data("optid");
		}));

		chkArr = Array.from(new Set(chkArr));

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
			if ((type == "dOpt" && goodsKndCode != "SBS") || type == "sOpt") {
				html += "<button type=\"button\" class=\"btn-minus sm\" disabled><span class=\"txt-hide\">빼기</span></button>";
				html += "<input type=\"number\" value=\"1\" class=\"orderCo inputNumber\" min=\"1\" max=\"9999\" title=\"수량 입력\" maxLength=\"4\" readOnly/>";
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



	var payInfoText = $('.payInfo-text').html();

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
		}

		$el.parent().addClass('is-active');
	});


	$(document).on('click', '.btn-del-r', function(e) {
		$(this).closest("li").remove();
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
						console.log(html);
					}
				}
			},
			complete:function(){
				html += '<option value="FOXUSER_999999999999">없음</option>';
				html += '<option value="FOXUSER_999999999998">직접입력</option>';
				console.log(html);
				$('.chdr').append(html);
			}
		});
	}

	// 총상품금액
	function setTotalPrice() {
		/*var goodsPc = Number($('#goodsPrice').val());
        var orderCo = $(this).find(".orderCo").length == 0 ? 1 : Number($(this).find(".orderCo").val());*/
		var orderCo = 0;
		var optPc = 0;

		$(".option-select-area li").each(function(){
			orderCo = $(this).find(".orderCo").val();
			if($(this).data("secode") == "D") {
				if (goodsKndCode == "SBS") {
					orderCo = 1;
				}
			}

			optPc += Number($(this).find(".price").text().replaceAll("원", "").replaceAll(",", "")) *  orderCo;
		});


		$('.total-area .totPrice').text(optPc.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
	}

})();

//#sourceURL=cartEdit.js