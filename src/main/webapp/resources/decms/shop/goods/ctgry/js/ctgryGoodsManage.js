$(function() {

    /** 컴포넌트 생성 **/
   /* //제휴사별 테이블 생성
    createTableDnd = function() {
        //var dataJson = {};
        $.ajax({
            url : CTX_ROOT + '/decms/shop/goods/goodsCtgrySubList.json',
            type : 'GET',
            dataType : 'json',
            success : function(json){
                for (var i=0; i<json.data.list.length; i++) {
                    $('#table-' + json.data.list[i].goodsCtgryId+'-tab').bootstrapTable({
                        onReorderRowsDrop: function (row) {
                            sortRowOrder();
                        }
                    });
                    // 제휴사별 데이터 load
                    loadTableData(json.data.list[i].goodsCtgryId);
                }
            }
        });
    }
    */
    createTableDnd = function() {
        $('#myTab li a').each(function(index,item){
            var id = $(this).data('ctgryid');
            $('#table-' +id+'-tab').bootstrapTable({
                onReorderRowsDrop: function (row) {
                    sortRowOrder();
                }
            });
            loadTableData(id);
        })

        $('#myTab2 li a').each(function(index,item){
            var id = $(this).data('ctgryid');
            $('#table-' +id+'-tab').bootstrapTable({
                onReorderRowsDrop: function (row) {
                    sortRowOrder();
                }
            });
            loadTableData(id);
        })

    }



    loadTableData = function(ctgryId) {

        var sortTable = $('#table-'+ctgryId+'-tab');
        var dataJson = {
            'ctgryId' : ctgryId
        };
        $.ajax({
            url : CTX_ROOT + '/decms/shop/goods/ctgryGoodsList.json',
            type : 'GET',
            data: dataJson,
            dataType : 'json',
            success : function(json){
                var data = json.data.list;
                console.log(data);
                $(sortTable).bootstrapTable('load',data);
                sortRowOrder();
            }
        });

    }

    createTableDnd();


    $(document).on('click','#myTab2 li a',function(){
        $('#myTab li a').removeClass('active');
        $('.save-btn').addClass('fade');
    });

    $(document).on('click','#myTab li a',function(){
        $('.save-btn').removeClass('fade');
        $('#myTab2 li a').removeClass('active');
    });

    saveSaleGoodsData = function() {
        var prtnrId = $('#myTab > li > a.active').attr('id').replace('-tab', '');
        var activeTableId = '#table-' + $('#myTab > li > a.active').attr('id');
        var tb_data = $(activeTableId).bootstrapTable('getData');

        var goodsArr = [];
        for (i = 0; i<tb_data.length; i++) {
                console.log(tb_data[i]);
                var row = tb_data[i];
                var rowItem = {
                    'ctgrySn' : row.ctgrySn,
                    'goodsId' : row.goodsId,
                };
                goodsArr.push(rowItem);
            }


            $.ajax({
                url:CTX_ROOT + '/decms/shop/goods/goodsCtgrySnModify.json',
                type:'POST',
                data:JSON.stringify(goodsArr),
                dataType:'json',
                cache: false,
                contentType:'application/json',
                success:function(result){
                    console.log(result);
                    alert(result.message);
                    /*location.reload(true);*/
                    /*loadTableData();*/
                    $('#myTab2 li a').each(function(index,item){
                        var id = $(this).data('ctgryid');
                        $('#table-' +id+'-tab').bootstrapTable({
                            onReorderRowsDrop: function (row) {
                                sortRowOrder();
                            }
                        });
                        loadTableData(id);
                    })
                }
            });
        }

    /** 이벤트 및 function **/
    sortRowOrder = function() {
        var activeTableId = '#table-' + $('#myTab > li > a.active').attr('id');
        var row_cnt = $(activeTableId).bootstrapTable('getData').length;
        for (var i=0; i < row_cnt; i++) {
            $(activeTableId).bootstrapTable('updateRow', {index: i, row: {
                    'ctgrySn' : i+1
                }});
        }

    }



    /*$(document).on('change','#selectCtgryId',function(){
        var val = $(this).val();
        console.log( $('#historyCtgryVal').val());
        if(!isEmpty($('#historyCtgryVal').val())){
            $('#table-'+$('#historyCtgryVal').val()).find('tr').remove();
        }
        $('#historyCtgryVal').val(val);
        console.log( $('#historyCtgryVal').val());
        $('.data-table').attr('id','table-'+val);

        // 제휴사별 데이터 load
        loadTableData(val);
    })*/

    $(document).on('change','#selectCtgryId',function(){
        var val = $(this).val();
        console.log( $('#historyCtgryVal').val());
        // 제휴사별 데이터 load
        loadTableData(val);
    })

    priceFormatter = function(value, row) {
        if (value) {
            return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
        } else {
            return '';
        }
    }

    sttusFormatter = function(value, row) {
        var sttus = {
            'A' : '처리중',
            'C' : '등록완료',
            'D' : '등록거부',
            'R' : '등록대기'
        }
        return sttus[value];
    }

    goodsKindFormatter = function(value, row) {
        var kind = {
            'SBS' : '구독',
            'GNR' : '일반',
            'CPN' : '쿠폰'
        }
        return kind[value];
    }

    imageFormatter = function(value, row) {
        return '<img src="' + value +'" style="width: 50px; height: 50px;">';
    }

})