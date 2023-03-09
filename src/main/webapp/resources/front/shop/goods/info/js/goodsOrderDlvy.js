	var totalPc = Number($('.totAmount').data('totpc'));//총가격
	var islandDlvyPc = Number(0);//추가배송비용
	var $form = $('#sendOrderForm');
	var $dlvyDiv = $('#deliveryEdit2');
	var dpstryInfo = {};
	var dlvyInfo = {};


	$(document).ready(function (){

		dlvyInfo = {
			dlvyUserNm : $form.find('[name="dlvyInfo.dlvyUserNm"]').val()
			,dadresNo: $form.find('#dlvyNo').val()
			,dlvyAdresNm : $form.find('[name="dlvyInfo.dlvyAdresNm"]').val()
			,telno1 :  $form.find('[name="dlvyInfo.telno1"]').val()
			,telno2 :  $form.find('[name="dlvyInfo.telno2"]').val()
			,telno3 :  $form.find('[name="dlvyInfo.telno3"]').val()
			,dlvyZip : $form.find('[name="dlvyInfo.dlvyZip"]').val()
			,dlvyAdres :$form.find('[name="dlvyInfo.dlvyAdres"]').val()
			,dlvyAdresDetail :$form.find('[name="dlvyInfo.dlvyAdresDetail"]').val()
		}

		console.log(dlvyInfo);


	})
	/*픽업리스트관련*/
	$(document).on('change','.dpstry-select',function(){
		var sn =  $(this).data('sn');
		var $dpstryLi =  $('#dpstryInfo'+sn);

		var dpstryNm = $dpstryLi.find('#dpstryNm').val();
		var dpstryAdres = $dpstryLi.find('#dpstryAdres').val();
		var dpstryZip = $dpstryLi.find('#dpstryZip').val();
		var dpstryTelno1 = $dpstryLi.find('#dpstryTelno1').val();
		var dpstryTelno2 = $dpstryLi.find('#dpstryTelno2').val();
		var dpstryTelno3 = $dpstryLi.find('#dpstryTelno3').val();

		dpstryInfo = {
			dpstryNm:dpstryNm
			,dpstryAdres:dpstryAdres
			,dpstryZip:dpstryZip
			,dpstryTelno1:dpstryTelno1
			,dpstryTelno2:dpstryTelno2
			,dpstryTelno3:dpstryTelno3
		}
		insertDpstryInfoToForm(dpstryInfo);
	})
	
	//픽업 정보 폼에 넣기 
	insertDpstryInfoToForm = function(item){
		initFormDlvyInfo();
		if(!isEmpty(item)){
			$form.find('[name="dlvyInfo.dlvyAdresNm"]').val(item.dpstryNm);
			$form.find('[name="dlvyInfo.telno1"]').val(item.dpstryTelno1);
			$form.find('[name="dlvyInfo.telno2"]').val(item.dpstryTelno2);
			if(!isEmpty(item.dpstryTelno3))$form.find('[name="dlvyInfo.telno3"]').val(item.dpstryTelno3);
			$form.find('[name="dlvyInfo.dlvyZip"]').val(item.dpstryZip);
			$form.find('[name="dlvyInfo.dlvyAdres"]').val(item.dpstryAdres);
		}
	}

	//택배배송지 정보 폼에 넣기
	insertDlvyInfoToForm = function(item){
		initFormDlvyInfo();
		if(!isEmpty(item)) {
			$form.find('[name="dlvyInfo.dlvyUserNm"]').val(item.dlvyUserNm);
			$form.find('[name="dlvyInfo.dadresNo"]').val(item.dadresNo);
			$form.find('[name="dlvyInfo.dlvyAdresNm"]').val(item.dlvyAdresNm);
			$form.find('[name="dlvyInfo.telno1"]').val(item.telno1);
			$form.find('[name="dlvyInfo.telno2"]').val(item.telno2);
			$form.find('[name="dlvyInfo.telno3"]').val(item.telno3);
			$form.find('[name="dlvyInfo.dlvyZip"]').val(item.dlvyZip);
			$form.find('[name="dlvyInfo.dlvyAdres"]').val(item.dlvyAdres);
			$form.find('[name="dlvyInfo.dlvyAdresDetail"]').val(item.dlvyAdresDetail);

			dlvyInfo = {
				dlvyUserNm : item.dlvyUserNm
				,dadresNo: item.dadresNo
				,dlvyAdresNm : item.dlvyAdresNm
				,telno1 :  item.telno1
				,telno2 :  item.telno2
				,telno3 :  item.telno3
				,dlvyZip : item.dlvyZip
				,dlvyAdres :item.dlvyAdres
				,dlvyAdresDetail :item.dlvyAdresDetail
			}
		}
	}
	//폼에정보 초기화
	initFormDlvyInfo = function (){
		$form.find('[name="dlvyInfo.dlvyUserNm"]').val('');
		$form.find('[name="dlvyInfo.dlvyAdresNm"]').val('');
		$form.find('[name="dlvyInfo.telno1"]').val('');
		$form.find('[name="dlvyInfo.telno2"]').val('');
		$form.find('[name="dlvyInfo.telno3"]').val('');
		$form.find('[name="dlvyInfo.dlvyZip"]').val('');
		$form.find('[name="dlvyInfo.dlvyAdres"]').val('');
		$form.find('[name="dlvyInfo.dlvyAdresDetail"]').val('');
		$form.find('[name="dlvyInfo.dadresNo"]').val('');
		$form.find('#bassDlvyAt').val('N');
	}


	function validation() {
		if ($dlvyDiv.find('#dlvyUserNm').val().length == 0) {
			modooAlert('수령인을 입력하세요.');
			return false;
		}
		if ($dlvyDiv.find('#telno1').val().length == 0 || $dlvyDiv.find('#telno2').val().length == 0 || $dlvyDiv.find('#telno3').val().length == 0) {
			modooAlert('연락처를 입력하세요.');
			return false;
		}
		if ($dlvyDiv.find('#dlvyZip').val().length == 0 ) {
			modooAlert('배송주소를 입력하세요.');
			return false;
		}
		if (isEmpty($dlvyDiv.find('#dlvyAdresDetail').val())) {
			modooAlert('상세주소를 입력하세요.');
			return false;
		}
		return true;
	}

	registAddress = function () {
		var actionUrl = CTX_ROOT + '/shop/goods/user/registAddress.do';

		var dataJson = {
			'dlvyAdresNm': $dlvyDiv.find('#dlvyAdresNm').val()
			, 'dlvyZip': $dlvyDiv.find('#dlvyZip').val()
			, 'dlvyAdres': $dlvyDiv.find('#dlvyAdres').val()
			, 'dlvyAdresDetail': $dlvyDiv.find('#dlvyAdresDetail').val()
			, 'telno': $dlvyDiv.find('#telno1').val()+'-'+$dlvyDiv.find('#telno2').val()+'-'+$dlvyDiv.find('#telno3').val()
			, 'dlvyUserNm': $dlvyDiv.find('#dlvyUserNm').val()
			, 'bassDlvyAt' : $dlvyDiv.find('#bassDlvyAt').val()
		};

		if (validation()) {
			$.ajax({
				url:actionUrl,
				data:dataJson,
				dataType:'json',
				type:'POST',
				success:function(json){
					initFormDlvyInfo();
					if(json.message) {
						modooAlert(json.message, '확인', function() {
						});
					}
				}
				,complete:function(){
					getMyAddressList(0);
					$('#deliveryEdit1-tab').trigger("click");
				}
			});
			/*$form.find('[name="dlvyInfo.dlvyUserNm"]').val(data.dlvyUserNm);
			$form.find('[name="dlvyInfo.dlvyAdresNm"]').val(data.dlvyAdresNm);
			$form.find('[name="dlvyInfo.telno1"]').val(data.telno1);
			$form.find('[name="dlvyInfo.telno2"]').val(data.telno2);
			$form.find('[name="dlvyInfo.telno3"]').val(data.telno3);
			$form.find('[name="dlvyInfo.dlvyZip"]').val(data.dlvyZip);
			$form.find('[name="dlvyInfo.dlvyAdres"]').val(data.dlvyAdres);
			$form.find('[name="dlvyInfo.dlvyAdresDetail"]').val(data.dlvyAdresDetail);*/

		}
	}

	modifyBassAddress = function() {
		var dadresNo = $('input:radio[name="delivery"]:checked').val();
		modooConfirm('배송지를 변경하시겠습니까?' ,'확인', function(result) {
			if(result) {
				dlvyDetail(dadresNo)
			}
		});

	}

	$('.deliveryTab').on('click',function(){
		var activeTab = $(this).attr('href');

		if ( activeTab == '#delivery1'){
			insertDlvyInfoToForm(dlvyInfo);
			$('dpstry-select').attr('checked',false);
			$('dpstry-select').parent('label').removeClass('ui-state-active');
			$("input[type=radio]").checkboxradio();
		}else if(activeTab == '#delivery2'){
			insertDpstryInfoToForm(dpstryInfo);
		}
	})

	//저장 버튼
	$('#registAddress').on('click', function () {
		var activeTab = $('.ui-tabs-active a').attr('href');

		if ( activeTab == '#deliveryEdit1') {
			modifyBassAddress();
		} else if ( activeTab == '#deliveryEdit2') {
			registAddress();
		}
	});


	//기본,신규배송지 선택
	/*$(document).on('click','#deliveryTab',function(e){
		e.preventDefault();
		var type = $(this).data('type');
		$(this).parent('li').addClass('is-active');
		$(this).parent('li').siblings('li').removeClass('is-active');
		if(type=='exist'){
			$('#delivery2').hide();
			$('#delivery1').show();
			var adresNo=$('#dlvyNo').val();
			dlvyDetail(adresNo);

			$('input[name="dlvyInfo.bassDlvyAt"]').attr('checked',false);
			$('input[name="dlvyInfo.bassDlvyAt"]').val('exist');

			islandDlvyChk('00000');
		}else if(type='new'){
			$('#delivery1').hide();
			$('#delivery2').show();
			$form.find('[name="dlvyInfo.dlvyUserNm"]').val('');
			$form.find('[name="dlvyInfo.dlvyAdresNm"]').val('');
			$form.find('[name="dlvyInfo.telno1"]').val('');
			$form.find('[name="dlvyInfo.telno2"]').val('');
			$form.find('[name="dlvyInfo.telno3"]').val('');
			$form.find('[name="dlvyInfo.dlvyZip"]').val('');
			$form.find('[name="dlvyInfo.dlvyAdres"]').val('');
			$form.find('[name="dlvyInfo.dlvyAdresDetail"]').val('');
			$('#delivery2 [name="dlvyInfo.dlvyMssage"]').val('');
			$('input[name="dlvyInfo.bassDlvyAt"]').parent('label').removeClass('ui-state-active');
			$('input[name="dlvyInfo.bassDlvyAt"]').val('N');
			$('input[name="dlvyInfo.bassDlvyAt"]').attr('checked',false);
			islandDlvyChk('00000');
		}
	})
*/
	//배송지 지정
	/*$(document).on('change','input[name=delivery]',function(){
		var adresNo = $(this).data('id');
		dlvyDetail(adresNo);
	})*/


	$(document).on('click','.btn-del',function (){
		var slect = $(this).data('select');
		var dardesNo = $(this).data('dadresno');

		var actionUrl = CTX_ROOT + '/shop/goods/user/deleteAddress.do';
		var dataJson = {
			'dadresNo' : dardesNo
		};

		if(String(slect) == 'Y'){
			modooAlert('배송지를 변경 후 삭제해주세요.','확인',function (result){
			});
			return false;
		}

		modooConfirm('배송지를 삭제하시겠습니까?', '배송지 삭제',function(result) {
			if(result) {
				$.ajax({
					url:actionUrl,
					data:dataJson,
					dataType:'json',
					type:'POST',
					success:function(json){
						modooAlert(json.message, '확인', function() {
							getMyAddressList(0);
							$('#deliveryEdit1-tab').trigger("click");
						});
					}
				});
			}
		});
	})

	//배송지 상세	
	function dlvyDetail(adresNo){
		$.ajax({
			url:'/shop/goods/user/dlvyAdresDetail.json',
			data:{adresNo:adresNo},
			dataType:'json',
			success:function(result){
				initFormDlvyInfo();
				var item = result.data.dlvyInfo;
				var html = '';
				var telList = item.telno.split('-');
				insertDlvyInfoToForm(item);
				islandDlvyChk(item.dlvyZip);

				html+= item.dlvyUserNm+' '+'('+item.dlvyAdresNm+')</br>';
				html+= '('+item.dlvyZip+')' +item.dlvyAdres+', '+item.dlvyAdresDetail+'</br>';
				html+=  item.telno+'</br>';
				html+= '<button type="button" class="btn mt10" id="changeAddress" onclick="initAddressPop();">배송지 변경</button>'
				$('#dlvyInfo-area').empty();
				$('#dlvyInfo-area').prepend(html);
			},
			complete:function(){
				$('input[name="dlvyInfo.bassDlvyAt"]').val('exist');
				$('input[name="dlvyInfo.bassDlvyAt"]').attr('checked',true);
				popClose('deliveryEdit');
			}
		})
	}

	getMyAddressList = function(currentPageAddressPop) {
		var selectDlvyNo = dlvyInfo.dadresNo;
		var actionUrl = CTX_ROOT + '/shop/goods/user/dlvyAdresList.json';
		var dataJson = {
			'firstIndex' : currentPageAddressPop
		};

		$.ajax({
			url:actionUrl,
			data:dataJson,
			dataType:'json',
			type:'get',
			success:function(json){

				var list= json.resultList;
				var html='';

				if (list.length > 0) {
					//주문-리뷰 목록
					for(var i=0; i<list.length; i++){
						var slect = 'N';
						html += '<li>';
						html += '<label><input type="radio" name="delivery" value=' + list[i].dadresNo ;
						if (String(list[i].dadresNo) == selectDlvyNo) {
							html += ' checked';
							slect = 'Y';
						}
						html += ' /></label>';
						html += '<div class="txt-area">';
						html += '<strong>' + list[i].dlvyAdresNm + ' │ ' + list[i].dlvyUserNm;
						if (list[i].bassDlvyAt == 'Y') {
							html += '<span>[ 기본 배송지 ]</span>';
						}
						html += '</strong>';
						html += '<p>' + list[i].dlvyAdres + '</p>';
						html += '<p class="fc-gr">' + list[i].telno + '</p>';
						html += '</div>';
						html += '<button type="button" class="btn-del" data-select = "'+slect+'" data-dadresno = "'+list[i].dadresNo+'" ><span class="txt-hide">삭제</span></button>';
						html += '</li>';
					}
				} else {
					html += '<p class="none-txt">등록된 배송지가 없습니다.</p>';
				}

				$('#address-list').html(html);
				//console.log($('#deliveryEdit').height());
				/*popPosition($('#deliveryEdit'));*/
				//페이징
				pagingAddressPop($('#paging-review-todo'), json.paginationInfo.totalRecordCount, currentPageAddressPop);
			},
			complete: function() {
				/*popPosition($('#deliveryEdit'));*/
				$("input[type=radio]").checkboxradio();
			}
		})

	}

	// 페이징
	pagingAddressPop = function ($pagingSector, totalCount, currentPage){

		const totalPage = Math.ceil(totalCount/10); //총 페이지 수  - 전체 데이터 개수/한 페이지에 나타낼 데이타
		const pageGroup = Math.ceil(currentPage/5); //페이지 그룹 - 현재 페이지/한 페이지에 보여줄 페이지 수

		var last = pageGroup * 5; //화면에 보여질 마지막 번호
		if(last > totalPage){
			last = totalPage;
		}
		var first = last - 4; // 화면에 보여질 첫번째 번호
		if(first==0 || first<0){
			first=1;
		}

		const foreFront = 1;
		const prev = Number(currentPage)-1;
		const next = Number(currentPage)+1;
		const rearMost = totalPage;

		var htmlStr='';
		//처음으로,이전
		if(prev>0){
			if(first==foreFront){
				htmlStr +='';
			}
			htmlStr +='<li class="ppv"><a href="#none" onclick="movePageAddressPop('+foreFront+');" title="처음으로"><span class="txt-hide">처음으로</span></a></li>';
			htmlStr +='<li class="pv"><a href="#none" onclick="movePageAddressPop('+prev+');" title="이전"><span class="txt-hide">이전</span></a></li>';

		}
		//페이지 set
		for(var i=first; i<=last; i++){
			if(currentPage == i ){
				htmlStr += '<li class="is-active" id="currentPage" data-page="'+i+'"><a href="#none" onclick="movePageAddressPop('+i+');" title="to '+i+' page">'+i+'</a></li>';
			}else{
				htmlStr += '<li><a href="#none" onclick="movePageAddressPop('+i+');" title="to '+i+' page">'+i+'</a></li>'
			}
		}

		//마지막으로,다음
		if(last<totalPage){
			if(last==totalPage){
				htmlStr+='';
			}
			htmlStr += '<li class="fw"><a href="#none"  onclick="movePageAddressPop('+next+');" title="다음"><span class="txt-hide">다음</span></a></li>';
			htmlStr += '<li class="ffw"><a href="#none" onclick="movePageAddressPop('+rearMost+');"  title="끝으로"><span class="txt-hide">끝으로</span></a></li>';
		}

		$pagingSector.empty();
		$pagingSector.html(htmlStr);

	}

	//페이지 이동
	movePageAddressPop = function (currentPage){
		$('.review-list').empty();
		currentPageReviewTodo = currentPage;
		getMyCommentTodoList(currentPageReviewTodo);
	}


	initAddressPop = function() {
		popOpen('deliveryEdit');
		getMyAddressList(0);
	}

	//주소 적용
	$(document).on('click','#addChoice',function(e){
		e.preventDefault();
		var obj = $('[data-popup]').data('popup','adress');
		var $self = $(this);
		islandDlvyChk('00000');
		var zip = $self.data('zipno');
		var adress = $self.data('roadaddr');
		$dlvyDiv.find('#dlvyZip').val(zip);
		$dlvyDiv.find('#dlvyAdres').val(adress);
		popClose('adress');
		islandDlvyChk(zip);
	});
	//비용추가
	function islandDlvyInsert(isJeju){
		if(isJeju){
			$('#islandChk').val('jeju');
			$('.jejuDlvyPc').each(function(index,item){
				islandDlvyPc += Number($(item).val());
			})
		}else{
			$('#islandChk').val('island');
			$('.islandDlvyPc').each(function(index,item){
				islandDlvyPc += Number($(item).val());
			})
		}

		if(islandDlvyPc!=0){
			$('.price-info-list').append('<li class="islandPc"><cite>추가배송비</cite><div>'+islandDlvyPc+'원</div></li>');
			totalPc+=Number(islandDlvyPc);
			totalPcInsert();
		}
	}

	//도서산간 체크
	function islandDlvyChk(zipCode){
		var dataJson = {
			'zip' : zipCode
		};
		var isJeju = false;
		if(Number(zipCode)>=63000){
			isJeju=true;
		}
		$.ajax({
			url:CTX_ROOT + '/shop/goods/checkIdsrtsAt.do',
			type:'POST',
			data:dataJson,
			dataType:'json',
			success:function(result){
				if (result.data.count > 0) {
					$('.islandPc').remove();
					islandDlvyInsert(isJeju);
					/*if(Number(zipCode)>=63000){
                        $('#islandChk').val('jeju');
                    }else{
                        $('#islandChk').val('island');
                    }*/
				}else{
					$('.islandPc').remove();
					totalPc=Number(totalPc)-Number(islandDlvyPc);
					islandDlvyPc=Number(0);
					totalPcInsert();
					$('#islandChk').val('N');
					return false;
				}
			}
		});
	}

	//배송 메세지 선택 
	$(document).on('change','.dlvyMssage',function(){
		var msg = $(this).val();
		if(msg==0){
			$(this).next().show();
			$('[name="dlvyInfo.dlvyMssage"]').val('');
		}else{
			$(this).next().hide();
			$('[name="dlvyInfo.dlvyMssage"]').val(msg);
		}
	})


	$('#findAddress').on('click', function () {
		popOpen2('adress');
	});

	$(document).on('click','.closeBtn',function(e){
		popClose('deliveryEdit');
	})

	//주소 검색
	$(document).on('submit','#form',function(e){

		var obj = $('[data-popup]').data('popup','adress');
		e.preventDefault();
		// 적용예 (api 호출 전에 검색어 체크)
		if (!checkSearchedWord($(this).find('input[name="keyword"]').val())) {
			return ;
		}
		var $self = $('#form');

		$self.ajaxSubmit({
			url :"https://www.juso.go.kr/addrlink/addrLinkApiJsonp.do"  //인터넷망
			,type:"post"
			,data:$self.serialize()
			,dataType:"jsonp"
			,crossDomain:true
			,success:function(jsonStr){
				$(".border-list").html("");
				var errCode = jsonStr.results.common.errorCode;
				var errDesc = jsonStr.results.common.errorMessage;
				if(errCode != "0"){
					$('#message').show();
					$('#addTotalCnt').hide();
				}else{
					if(jsonStr != null){
						$('#message').hide();
						$('#addTotalCnt').show();
						$('#addTotalCnt').children('em').text(jsonStr.results.common.totalCount);
						makeListJson(jsonStr);
						if(jsonStr.results.common.totalCount != 0){
							paging(jsonStr.results.common.totalCount,jsonStr.results.common.currentPage);
						}
					}
				}
			}
			,error: function(xhr,status, error){
				modooAlert("에러발생");
			}
		});
	})

	//주소 목록 넣기
	function makeListJson(jsonStr){
		var obj = $('[data-popup]').data('popup','adress');
		var htmlStr = '';
		$(jsonStr.results.juso).each(function(){
			htmlStr += '<li>';
			htmlStr += '<p>['+this.zipNo+']'+this.jibunAddr+'</p>';
			htmlStr += '<p class="fs-sm fc-gr"><span class="label spot3 dlvyAddress">도로명</span> '+this.roadAddr+'</p>';
			htmlStr += '<button type="button" id="addChoice" class="btn-full" data-zipno="'+this.zipNo+'" data-roadaddr="'+this.roadAddr+'"><span class="txt-hide">주소선택</span></button></li>';
			htmlStr += '</li>';
		});
		$(".border-list").html(htmlStr);
		/*popPosition(obj);*/
	}

	//특수문자, 특정문자열(sql예약어의 앞뒤공백포함) 제거
	function checkSearchedWord(obj){
		console.log(typeof obj);
		if(obj.length >0){
			//특수문자 제거
			var expText = /[%=><]/ ;
			if(expText.test(obj.value) == true){
				modooAlert("특수문자를 입력 할수 없습니다.") ;
				obj.value = obj.value.split(expText).join("");
				return false;
			}

			//특정문자열(sql예약어의 앞뒤공백포함) 제거
			var sqlArray = new Array(
				//sql 예약어
				"OR", "SELECT", "INSERT", "DELETE", "UPDATE", "CREATE", "DROP", "EXEC",
				"UNION",  "FETCH", "DECLARE", "TRUNCATE"
			);

			var regex;
			for(var i=0; i<sqlArray.length; i++){
				regex = new RegExp( sqlArray[i] ,"gi") ;

				if (regex.test(obj.value) ) {
					alert("\"" + sqlArray[i]+"\"와(과) 같은 특정문자로 검색할 수 없습니다.");
					obj.value =obj.value.replace(regex, "");
					return false;
				}
			}
		}
		return true ;
	}

	function enterSearch(ev) {
		var evt_code = (window.netscape) ? ev.which : event.keyCode;
		if (evt_code == 13) {
			event.keyCode = 0;
			getAddr(); //jsonp사용시 enter검색
		}
	}


	//페이징처리
	function paging(totalCount,currentPage){

		const totalPage = Math.ceil(totalCount/5); //총 페이지 수
		const pageGroup = Math.ceil(currentPage/5); //페이지 그룹

		var last = pageGroup * 5; //화면에 보여질 마지막 번호
		if(last > totalPage){
			last = totalPage;

		}
		var first = last - 4; // 화면에 보여질 첫번째 번호
		if(first < 1){
			first=1;
		}

		const foreFront = 1;
		const prev = Number(currentPage)-1;
		const next = Number(currentPage)+1;
		const rearMost = totalPage;

		var htmlStr='';
		//처음으로,이전
		if(prev>0){
			if(first==foreFront){
				htmlStr +='';
			}
			htmlStr +='<li class="ppv"><a href="#none" onclick="movePageZipPop('+foreFront+');" title="처음으로"><span class="txt-hide">처음으로</span></a></li>';
			htmlStr +='<li class="pv"><a href="#none" onclick="movePageZipPop('+prev+');" title="이전"><span class="txt-hide">이전</span></a></li>';

		}
		//페이지 set
		for(var i=first; i<=last; i++){
			if(currentPage == i ){
				htmlStr += '<li class="is-active"><a href="#none" onclick="movePageZipPop('+i+');" title="to '+i+' page">'+i+'</a></li>';
			}else{
				htmlStr += '<li><a href="#none" onclick="movePageZipPop('+i+');" title="to '+i+' page">'+i+'</a></li>'
			}
		}

		//마지막으로,다음
		if(last<totalPage){
			if(last==totalPage){
				htmlStr+='';
			}
			htmlStr += '<li class="fw"><a href="#none"  onclick="movePageZipPop('+next+');" title="다음"><span class="txt-hide">다음</span></a></li>';
			htmlStr += '<li class="ffw"><a href="#none" onclick="movePageZipPop('+rearMost+');"  title="끝으로"><span class="txt-hide">끝으로</span></a></li>';
		}

		$('.paging').empty();
		$('.paging').html(htmlStr);
	}
	//페이지 이동
	function movePageZipPop(currentPage){
		$('input[name="currentPage"]').val(currentPage);
		$('#form').trigger('submit');

	}

	$('input[name="keyword"]').keyup(function(){
		$('input[name="currentPage"]').val(1);
	});



