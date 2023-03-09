(function() {

	const grid = new tui.Grid({
		el: document.getElementById('data-grid'),
		columns: [
			{ header: 'No', name: '', width:100, align: 'center',
				formatter:function(item){
						return item.row.rowKey+1;
					}
				},
			{ header: '쿠폰 명', name: 'couponNm', width:300, align: 'center'},
			{ header: '쿠폰번호', name: 'couponNo', width:300, align: 'center'},
			{ header: '주문자명', name: 'ordrrNm', width:100, align: 'center'},
			{ header: '자녀이름', name: 'ordrrNm', width:100, align: 'center'},
			{ header: '쿠폰 코드', name: 'couponKndCode', width:100, align: 'center'
				, formatter: function(item) {
					if (item.value == 'BAS00') {
						return '베이직';
					} else if (item.value == 'PRM00') {
						return '주말';
					} else if(item.value=='WEK00'){
						return '주말';
					} else if(item.value=='ETC'){
						return '기타';
					} else if(item.value=='BHC'){
						return '조이마루BHC';
					} else{
						return '';
					}
				}
			},
			{ header: '쿠폰 상태', name: 'couponSttusCode', width:100, align: 'center'
				, formatter: function(item) {
					if (item.value == 'NOT') {
						return '미사용';
					} else if (item.value == 'USE') {
						return '사용';
					} else if(item.value=='CANCL'){
						return '취소';
					} else{
						return '';
					}
				}
			},

			{ header: '시작 일자', name: 'couponBeginPnttm', width:100, align: 'center'
				, formatter: function(item) {
					return moment(item.value, 'YYYYMMDD').format('YYYY-MM-DD');
				}},
			{ header: '종료 일자', name: 'couponEndPnttm', width:100, align: 'center'
				, formatter: function(item) {
					return moment(item.value, 'YYYYMMDD').format('YYYY-MM-DD');
				}},
			{ header: '관리', name: 'manage', width:100, align: 'center'
				, formatter: function(item) {
					if(item.row.couponSttusCode == 'NOT')
					return 	'<a href="#none" data-cpnno="'+item.row.couponNo+'" data-sttus="USE" class="btn btn-success chkCoupon" title="사용">'
						+ 		'사용</a>'
					else if(item.row.couponSttusCode == 'USE')
					return 	'<a href="#none" data-cpnno="'+item.row.couponNo+'" data-sttus="NOT" class="btn btn-danger chkCoupon" title="사용해제">'
						+ 		'사용해제</a>'
				}
			}
		],
		columnOptions: {
			frozenCount: 1,
			frozenBorderWidth: 1,
			resizable: true
		}
	});

	$(document).ready(function() {
		getDataList(1);
	});
	
	$(document).on('click', '#searchBtn', function() {
		getDataList(1);
	});

	tui.Grid.applyTheme('striped');
	
	var pagination = grid.getPagination();
	
	var pagination = new tui.Pagination(document.getElementById('data-grid-pagination'), {
		totalItems: 10,
		itemsPerPage: 10,
		visiblePages: 5,
		centerAlign: true
	});
	
	pagination.on('beforeMove', function(e) {
		getDataList(e.page);
	});

	getDataList = function(page) {
		if(isEmpty(page)) {
			page = $('#pageIndex').val();
		}else if(page > 0) {
			$('#pageIndex').val(page);
		}
		var paramKeyValue = {
			'pageIndex' :  $('#pageIndex').val()
			, 'searchCouponSttus' : $('select[name="searchCouponSttus"]').val()
			, 'searchCondition' : $('select[name="searchCondition"]').val()
			, 'searchKeyword' : $('input[name="searchKeyword"]').val()
			, 'searchCouponKndCode' : (isEmpty($('input[name="searchCouponKndCode"]').val())?'':$('input[name="searchCouponKndCode"]').val())
		};

		console.log(paramKeyValue);

		jsonResultAjax({
			url: CTX_ROOT + '/decms/shop/goods/couponList.json',
			method: 'get',
			data: paramKeyValue,
			callback: function(result) {
				if(result.success) {
					var paginationObj = result.data.paginationInfo;
					console.log(result);
					if(paginationObj.currentPageNo == 1) {
						pagination.setItemsPerPage(paginationObj.recordCountPerPage);
						pagination.reset(paginationObj.totalRecordCount);
					}
					
					grid.resetData(result.data.list);
					
				}
			}
			
		});
	};


	//쿠폰 사용 체크
	$(document).on('click','.chkCoupon',function(){
		var cpnNo = $(this).data('cpnno');
		var sttus = $(this).data('sttus');

		jsonResultAjax({
			url: CTX_ROOT + '/decms/shop/goods/modifyCouponSttus.json',
			method: 'get',
			data: {
					couponNo:cpnNo,
					couponSttusCode : sttus
					},
			callback: function(result) {
				if(result.success) {
					getDataList($('#pageIndex').val());
				}
			}
		});
	})
	
	// deleteEvent = function(eventNo) {
	//
	// 	var answer = confirm('삭제하시겠습니까?');
	// 	if (answer) {
	// 		jsonResultAjax({
	// 			url: CTX_ROOT + '/decms/event/deleteGoodsEvent.do',
	// 			method: 'get',
	// 			data: {'eventNo' : eventNo},
	// 			callback: function(result) {
	// 				if(result.success) {
	// 					getDataList(1);
	// 				}
	// 			}
	//
	// 		});
	// 	}
	//
	// }
})();