(function() {

	var grid;
	var pagination;
	var pageIndex = 1;

	initGrid = function() {
		grid = new tui.Grid({
			el: document.getElementById('data-grid'),
			rowHeight: 'auto',
			//scrollX: false,
			//scrollY: false,
			columns: [
				{ header: '주문번호', name: 'orderNo', align: 'center', width: 160,
					formatter: function(item) {
						if(item.row.orderKndCode == 'GNR') {
							return item.value;
						}else if(item.row.orderKndCode == 'SBS') {
							return (item.value == '') ? item.value : '<a href="#none" onclick="initDlvyPop(\'' + item.value + '\')" >' + item.value + '</a>';
						}
					}
				},
				{ header: '구독회차',	name: 'orderOdr', align: 'center', width: 160 },
				{ header: '상품종류',	name: 'orderKndCode', align: 'center', width: 160 ,
					formatter:function (item){
						if(item.value=="SBS"){
							return "구독";
						}else if(item.value=="GNR"){
							return "일반";
						}
					}
				},
				{ header: '주문일', name: 'orderPnttm', align: 'center', width: 100
				, formatter: function(item) {
						return moment(item.row.orderPnttm).format('YYYY-MM-DD HH:mm:ss');
					}
				},
				{ header: '주문자',	name: 'ordrrNm', align: 'center', width: 160 },
				{ header: '상품명/카테고리', name: 'goodsNm', align: 'center', width: 300,
					formatter: function(item) {
						return (item.value == '') ? item.value : '<a href="#none" onclick="openGoodsPop(\'' + item.row.goodsId + '\')">' + item.value + '</a><br /><small class="text-secondary">'+item.row.goodsCtgryNm+'</small>';
					}
				},
				{ header: '모델명', name: 'modelNm', align: 'center', width: 100 },
				{ header: '판매자', name: 'brandNm', align: 'center', width: 100 },
				{ header: '판매가', name: 'sleAmount', align: 'right', width: 100,
					formatter: function(item) {
						return item.value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
					}
				},
				{ header: '배송료', name: 'dlvyAmount', align: 'right', width: 100,
					formatter: function(item) {
						return item.value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
					}
				},
				{ header: '결제상태',	name: 'setleSttusCodeNm', align: 'center', width: 80 },
				{ header: '실패이유',	name: 'setleResultMssage', align: 'center', width: 150 },
			],
			columnOptions: {
	        	resizable: true
	      }
		});

		pagination = new tui.Pagination(document.getElementById('data-grid-pagination'), {
			totalItems: 10,
			itemsPerPage: 10,
			visiblePages: 5,
			centerAlign: true
		});
		
		pagination.on('beforeMove', function(e) {
			getGridRowData(e.page);
		});
		
		getGridRowData(pageIndex);
	} // initGrid

	getGridRowData = function(pageIndex) {
		var searchCondition = $('select[name="searchCondition"]').val();
		var searchKeyword = $('input[name="searchKeyword"]').val();
		var searchOrderNo, searchOrdrrId, searchGoodsNm, searchGoodsId;
		
		if (searchCondition == "1") {
			searchOrderNo = searchKeyword;
		} else if (searchCondition == "2") {
			searchOrdrrId = searchKeyword;
		} else if (searchCondition == "3") {
			searchGoodsNm = searchKeyword;
		} else if (searchCondition == "4") {
			searchGoodsId = searchKeyword;
		}
		
		var dataJson = {
			'pageIndex' : pageIndex,
			'searchListType' : 'FAIL',
			'searchOrderNo' : searchOrderNo,
			'searchOrdrrNm' : searchOrdrrId,
			'searchGoodsNm' : searchGoodsNm,
			'searchGoodsId' : searchGoodsId
		};
		
		$.ajax({
			url: '/decms/shop/goods/getOrderReqList.json',
			type: 'POST',
			data: dataJson,
			dataType: 'json',
			success: function(result) {
				setDlvyStat(result);

				var paginationObj = result.data.paginationInfo;
				if (paginationObj.currentPageNo == 1) {
				
					pagination.setItemsPerPage(paginationObj.recordCountPerPage);
					pagination.reset(paginationObj.totalRecordCount);
				}
				grid.resetData(result.data.list);
	
			}
		});
	} // getGridRowData
	
	setDlvyStat = function(result) {
		var stopReq = parseInt(result.data.stopReq);
		var stopComplete = parseInt(result.data.stopComplete);
		var stopAll = result.data.paginationInfo.totalRecordCount;
					
		$('#p-cnt-1').text(stopAll.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') + '건');
		$('#p-cnt-2').text(stopReq.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') + '건');
		$('#p-cnt-3').text(stopComplete.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') + '건');
	}

	openGoodsPop = function(goodsId) {
		var name = '';
	    var option = 'width = ' + window.innerWidth + ', height = ' + window.innerHeight + ', top = 0, left = 0, location = no';
		window.open('/shop/goods/goodsView.do?goodsId=' + goodsId, name, option);
	}

	/** 이벤트 목록 */
	$(document).ready(function() {
		tui.Grid.applyTheme('clean');
		initGrid();
	});

	// 검색 submit
	$(document).on('click', '#searchOrderDlvyBtn', function(e) {
		e.preventDefault();
		getGridRowData(1);
	});

		initDlvyPop = function(orderNo) {
			var modal = $('#orderDlvyModal');
			modalShow('주문별 구독현황', modal);

			var html = '';
			html += '<p>주문번호 : ' + orderNo + '</p>';
			html += '<div id="data-grid-pop"></div>';
			html += '<div id="data-grid-pagination-pop" class="tui-pagination"></div>';

			$('#modal-body-large').html(html);

			gridPop = new tui.Grid({
				el: document.getElementById('data-grid-pop'),
				rowHeight: 'auto',
				scrollX: true,
				scrollY: true,
				columns: [
					{ header: '회차', name: 'orderOdr', align: 'center', width: 30 },
					{ header: '결제일', name: 'setlePnttm', align: 'center', width: 130,
						formatter: function(item) {
							if (item.row.setleSttusCode == 'R') {
								return moment(item.row.setlePnttm).format('YYYY-MM-DD');
							} else {
								return moment(item.row.setlePnttm).format('YYYY-MM-DD HH:mm:ss');
							}
						}
					},
					{ header: '결제상태', name: 'setleSttusCode', align: 'center', width: 70,
						formatter: function(item) {
							if (item.value == 'R') {
								return "결제예정";
							} else if(item.value=='F'){
								return "결제실패";
							}else if(item.value == 'T') {
								return "구독해지";
							}else if(item.value == 'P'){
								return "건너뛰기";
							}else{
								return "결제완료";
							}
						}
					},
					{ header: '결제실패이유',	name: 'setleResultMssage', align: 'center', width: 100,
						formatter:function(item){
							if(item.row.setleSttusCode != 'F'){
								return '-';
							}else{
								return item.value;
							}
						}
					},
					{ header: '총결제금액', name: 'setleTotAmount', align: 'right', width: 80,
						formatter: function(item) {
							if(!isEmpty(item.value)){
								return item.value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
							}else{
								return '-';
							}

						}
					},
					{ header: '수량', name: 'orderCo', align: 'center', width: 40 },
					{ header: '상품가격', name: 'goodsAmount', align: 'right', width: 80,
						formatter: function(item) {
							if(!isEmpty(item.value)){
								return item.value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
							}else{
								return '-';
							}
						}
					},
					{ header: '배송비', name: 'dlvyAmount', align: 'right', width: 80,
						formatter: function(item) {
							if(!isEmpty(item.value)){
								return item.value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
							}else{
								return '-';
							}
						}
					},
					{ header: '사용포인트', name: 'setlePoint', align: 'right', width: 80,
						formatter: function(item) {
							if(!isEmpty(item.value)){
								return item.value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
							}else{
								return '-';
							}
						}
					},
					{ header: '카드결제금액', name: 'setleCardAmount', align: 'right', width: 80,
						formatter: function(item) {
							if(!isEmpty(item.value)){
								return item.value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
							}else{
								return '-';
							}
						}
					},
					{ header: '상품명', name: 'goodsNm', align: 'center', width: 100 },
					{ header: '옵션', name: 'orderInfo', align: 'center', width: 150 },
					{ header: '상품 수령 장소', name: 'dlvyAdres', width:500,
						formatter: function(item) {
							return '(' + item.row.dlvyZip + ') ' + item.value + ' ' + item.row.dlvyAdresDetail;
						}
					},
					{ header: '배송주기', align: 'center', width: 60,
						formatter: function(item) {
							if(item.row.sbscrptCycleSeCode == 'WEEK') {
								return item.row.sbscrptWeekCycle + ' 주';
							}else if(item.row.sbscrptCycleSeCode == 'MONTH') {
								return item.row.sbscrptMtCycle + ' 개월';
							}
						}
					},
					{ header: '배송일', name: 'sbscrptDlvyDay', align: 'center', width: 60,
						formatter: function(item) {
							if(item.row.sbscrptCycleSeCode == 'WEEK') {
								return '<strong>' + item.row.sbscrptDlvyWdNm + '</strong> 요일';
							}else if(item.row.sbscrptCycleSeCode == 'MONTH') {
								return item.row.sbscrptDlvyDay + ' 일';
							}
						}
					},
					{ header: '배송현황',	name: 'dlvySttusCodeNm', align: 'center', width: 70 },
				],
				onGridMounted: function(ev) {
					getOrderDlvyHist(orderNo);
				},
				columnOptions: {
					resizable: true
				}
			});

			modal.on('shown.bs.modal',function(e) {
				gridPop.refreshLayout();
			});

		}

	getOrderDlvyHist = function(orderNo){

		var dataJson = {
			//"pageIndex" : $form.find('#pageIndex').val(),
			"orderNo" : orderNo
		};

		jsonResultAjax({
			url: CTX_ROOT + '/decms/shop/goods/getOrderDlvyHist.json',
			type: 'POST',
			data: dataJson,
			//dataType: 'json',
			callback: function(result) {
				console.log(result);
				gridPop.resetData(result.data.list);
			}
		});

	}

	getOrderOptions = function(grid) {
		var gridData = grid.getData();

		for (var i=0; i<grid.getRowCount(); i++) {
			var dataJson = {
				"orderNo" : gridData[i].orderNo
			};
			var options = '';

			$.ajax({
				url: CTX_ROOT + '/decms/shop/goods/getOrderItems.json',
				type: 'POST',
				dataType: 'json',
				data: dataJson,
				async: false,
				success: function(result) {
					//console.log(result.data.list);
					for (var j=0; j<result.data.list.length; j++) {
						options += '<div>' + result.data.list[j].gitemNm + '</div>';
					}

					grid.setValue(i, 'option', options, false);
				},
				complete: function() {

				}
			});
		}
	}

})();