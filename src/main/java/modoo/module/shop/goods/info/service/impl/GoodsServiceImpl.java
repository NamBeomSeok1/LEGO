package modoo.module.shop.goods.info.service.impl;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import modoo.module.event.service.impl.GoodsEventMapper;
import modoo.module.event.service.impl.GoodsEventVO;
import modoo.module.shop.goods.label.service.GoodsLabelVO;
import modoo.module.shop.goods.label.service.impl.GoodsLabelMapper;
import org.json.simple.JSONArray;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Service;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import modoo.module.shop.cmpny.service.PrtnrCmpnyVO;
import modoo.module.shop.cmpny.service.impl.PrtnrCmpnyMapper;
import modoo.module.shop.goods.image.service.GoodsImageVO;
import modoo.module.shop.goods.image.service.impl.GoodsImageMapper;
import modoo.module.shop.goods.info.service.GoodsCouponVO;
import modoo.module.shop.goods.info.service.GoodsItemVO;
import modoo.module.shop.goods.info.service.GoodsService;
import modoo.module.shop.goods.info.service.GoodsVO;
import modoo.module.shop.goods.keyword.service.GoodsKeywordVO;
import modoo.module.shop.goods.keyword.service.impl.GoodsKeywordMapper;
import modoo.module.shop.goods.recomend.service.GoodsRecomendVO;
import modoo.module.shop.goods.recomend.service.impl.GoodsRecomendMapper;

@Service("goodsService")
public class GoodsServiceImpl extends EgovAbstractServiceImpl implements GoodsService {

	@Resource(name = "goodsMapper")
	private GoodsMapper goodsMapper;

	@Resource(name = "goodsItemMapper")
	private GoodsItemMapper goodsItemMapper;

	@Resource(name = "goodsKeywordMapper")
	private GoodsKeywordMapper goodsKeywordMapper;

	@Resource(name = "goodsImageMapper")
	private GoodsImageMapper goodsImageMapper;

	@Resource(name = "goodsRecomendMapper")
	private GoodsRecomendMapper goodsRecomendMapper;

	@Resource(name = "goodsEventMapper")
	private GoodsEventMapper goodsEventMapper;

	@Resource(name = "prtnrCmpnyMapper")
	private PrtnrCmpnyMapper prtnrCmpnyMapper;

	@Resource(name = "goodsIdGnrService")
	private EgovIdGnrService goodsIdGnrService;

	@Resource(name = "goodsItemIdGnrService")
	private EgovIdGnrService goodsItemIdGnrService;

	@Resource(name = "goodsKeywordIdGnrService")
	private EgovIdGnrService goodsKeywordIdGnrService;

	@Resource(name = "goodsImageIdGnrService")
	private EgovIdGnrService goodsImageIdGnrService;

	@Resource(name = "goodsRecomendIdGnrService")
	private EgovIdGnrService goodsRecomendIdGnrService;

	@Resource(name = "goodsCouponMapper")
	private GoodsCouponMapper goodsCouponMapper;

	@Resource(name = "goodsMberMapngMapper")
	private GoodsMberMapngMapper goodsMberMapngMapper;

	@Resource(name = "goodsLabelMapper")
	private GoodsLabelMapper goodsLabelMapper;

	/**
	 * 상품 목록
	 */
	@Override
	public List<?> selectGoodsList(GoodsVO searchVO) throws Exception {
		List<?> resultList = goodsMapper.selectGoodsList(searchVO);

		for(EgovMap map : (List<EgovMap>)resultList){
			GoodsLabelVO labelVO = new GoodsLabelVO();
			labelVO.setGoodsId(String.valueOf(map.get("goodsId")));
			List<GoodsLabelVO> labelList = goodsLabelMapper.selectGoodsLabelList(labelVO);
			labelList.stream().filter(s -> s.getLabelMainChk() == "Y").forEach(a-> System.out.println(a));

			List<GoodsLabelVO> mainLabelList = labelList.stream()
					.filter(s->s.getLabelMainChk()!=null)
					.filter(s -> s.getLabelMainChk().equals("Y"))
					.collect(Collectors.toList());

			 labelList = labelList.stream()
					.filter(s->!"Y".equals(s.getLabelMainChk()))
					.collect(Collectors.toList());


			map.put("goodsLabelList",labelList);
			map.put("goodsMainLabelList",mainLabelList);
		};

		return resultList;
	}

	/**
	 * 상품 목록 카운트
	 */
	@Override
	public int selectGoodsListCnt(GoodsVO searchVO) throws Exception {
		return goodsMapper.selectGoodsListCnt(searchVO);
	}

	/**
	 * 상품 저장
	 */
	@Override
	public void insertGoods(GoodsVO goods, JSONArray optArray) throws Exception {
		String goodsId = goodsIdGnrService.getNextStringId();
		goods.setGoodsId(goodsId);

		//판매가격 수수료에 따른 공급가 계산
		if(goods.getGoodsPc().equals(java.math.BigDecimal.ZERO)) {
			goods.setGoodsFeeRate(java.math.BigDecimal.ZERO);
			goods.setGoodsSplpc(java.math.BigDecimal.ZERO);
		}else {
			java.math.BigDecimal goodsSplpc = new java.math.BigDecimal(0);
			goodsSplpc = goods.getGoodsPc().subtract(goods.getGoodsPc().multiply(goods.getGoodsFeeRate().divide(new java.math.BigDecimal(100))));
			goods.setGoodsSplpc(goodsSplpc);
		}

		if("N".equals(goods.getfOptnUseAt())) { //첫구독옵션
			goods.setFrstOptnEssntlAt("N"); //첫구독옵션 필수여부
		}
		if(goods.getFrstOptnEssntlAt() == null) {
			goods.setFrstOptnEssntlAt("N");
		}

		if(!"SBS".equals(goods.getGoodsKndCode())){
			goods.setSbscrptWeekCycle(null);
			goods.setSbscrptDlvyWd(null);
			goods.setSbscrptMinUseWeek(null);
			goods.setSbscrptMtCycle(null);
			goods.setSbscrptMinUseMt(null);
			goods.setSbscrptDlvyDay(null);
			goods.setSbscrptCycleSeCode(null);
		}

		if(!"WEEK".equals(goods.getSbscrptCycleSeCode())) {
			goods.setSbscrptWeekCycle(null);
			goods.setSbscrptDlvyWd(null);
			goods.setSbscrptMinUseWeek(null);
		}else if(!"MONTH".equals(goods.getSbscrptCycleSeCode())) {
			goods.setSbscrptMtCycle(null);
			goods.setSbscrptMinUseMt(null);
			goods.setSbscrptDlvyDay(null);
		}

		goodsMapper.insertGoods(goods);



		if("Y".equals(goods.getOptnUseAt())) {

			//goodsMapper.insertGoodsItemInfo(goods);
			//insertOrUpdate(goods, goods.getdOptnUseAt(), "D", goods.getdGitemList());
			insertOrUpdate(goods, goods.getaOptnUseAt(), "A", goods.getaGitemList());
			insertOrUpdate(goods, goods.getfOptnUseAt(), "F", goods.getfGitemList());
			insertOrUpdate(goods, goods.getqOptnUseAt(), "Q", goods.getqGitemList());
			insertOrUpdate(goods, goods.getsOptnUseAt(), "S", goods.getsGitemList());

			if("Y".equals(goods.getdOptnUseAt())) { //기본 옵션 사용시 옵션 정보 등록
				insertOptInfo(goods, optArray);
			}
		}

		//키춰드 목록 저장
		if(goods.getGoodsKeywordList() != null) {
			for(GoodsKeywordVO goodsKeyword: goods.getGoodsKeywordList()) {
				java.math.BigDecimal no = goodsKeywordIdGnrService.getNextBigDecimalId();
				goodsKeyword.setGoodsKeywordNo(no);
				goodsKeyword.setGoodsId(goods.getGoodsId());
				goodsKeywordMapper.insertGoodsKeyword(goodsKeyword);
			}
		}

		if("Y".equals(goods.getLabelUseAt())&& goods.getGoodsLabelList()!=null){
			for(GoodsLabelVO label : goods.getGoodsLabelList()){
				label.setGoodsId(goods.getGoodsId());
				if(!"IMG".equals(label.getLabelTy()))label.setLabelImgPath(null);
				goodsLabelMapper.insertGoodsLabel(label);
			}
		}

		//상품 설명이미지 저장
		saveGoodsImage(goods.getGoodsId(), goods.getGdcImageList());
		saveGoodsImage(goods.getGoodsId(), goods.getGoodsImageList());
		//이벤트 이미지
		saveGoodsImage(goods.getGoodsId(), goods.getEvtImageList());
		//saveGoodsImage(goods.getGoodsId(), goods.getPcImageList());
		//saveGoodsImage(goods.getGoodsId(), goods.getMobImageList());
		//saveGoodsImage(goods.getGoodsId(), goods.getBanImageList());

		//추천상품
		if(goods.getGoodsRecomendList() != null) {
			for(GoodsRecomendVO recomend : goods.getGoodsRecomendList()) {
				recomend.setGoodsId( goods.getGoodsId() );
				java.math.BigDecimal no = goodsRecomendIdGnrService.getNextBigDecimalId();
				recomend.setGoodsRecomendNo(no);
				if(recomend.getRecomendGoodsSn() == null) recomend.setRecomendGoodsSn(0);
				goodsRecomendMapper.insertGoodsRecomend(recomend);
			}
		}

		//쿠폰상품일때>> 현재 사용하지 않음
		/*if("CPN".equals(goods.getGoodsKndCode())) {
			String uploadGroupId =  goods.getFrstRegisterId(); //(StringUtils.isEmpty(goods.getCmpnyId())?"SYSTEM":goods.getCmpnyId()) + goods.getFrstRegisterId();
			GoodsCouponVO goodsCoupon = new GoodsCouponVO();
			goodsCoupon.setUploadGroupId(uploadGroupId);
			goodsCoupon.setGoodsId(goods.getGoodsId());
			goodsCouponMapper.insertTmpCouponToGoodsCoupon(goodsCoupon);
		}*/

		//회원전용상품일때
		if("PRVUSE".equals(goods.getGoodsExpsrCode())){
			EgovMap map = new EgovMap();
			map.put("goodsId",goods.getGoodsId());

			List<String> mberList = Arrays.asList((goods.getGoodsMbers().split(",")));
			for(String s : mberList){
				if(StringUtils.isNotEmpty(s)){
					map.put("mberId",s);
					goodsMberMapngMapper.insertGoodsMberMapng(map);
				}
			}

		}
	}

	private void saveGoodsImage(String goodsId, List<GoodsImageVO> imageList) throws Exception {
		if(imageList != null) {
			for(GoodsImageVO img : imageList) {
				img.setGoodsId(goodsId);
				if(img.getGoodsImageNo() == null) {
					java.math.BigDecimal no = goodsImageIdGnrService.getNextBigDecimalId();
					img.setGoodsImageNo(no);
					if(img.getGoodsImageSn() == null) img.setGoodsImageSn(0);
					goodsImageMapper.insertGoodsImage(img);
				}else {
					goodsImageMapper.updateGoodsImage(img);
				}
			}
		}
	}

	/**
	 * 상품 상세
	 */
	@Override
	public GoodsVO selectGoods(GoodsVO goods) throws Exception {

		GoodsVO vo = goodsMapper.selectGoods(goods);

		if(vo != null) {
			//이벤트 목록
			if("Y".equals(vo.getEventAt())){
				GoodsEventVO goodsEventVO = new GoodsEventVO();
				goodsEventVO.setSearchGoodsId(vo.getGoodsId());
				vo.setGoodsEventList((List<GoodsEventVO>)goodsEventMapper.selectGoodsMapngEventList(goodsEventVO));
			}

			//제휴사매핑목록
			EgovMap map = new EgovMap();
			map.put("goodsId",vo.getGoodsId());
			List<String> goodsMberList = goodsMberMapngMapper.selectGoodsMberMapngList(map);
			if(goodsMberList.size()>=1)vo.setGoodsMbers(goodsMberList.stream().map(String::valueOf).collect(Collectors.joining(",")));


			//제휴사매핑목록
			PrtnrCmpnyVO prtnrCmpny = new PrtnrCmpnyVO();
			prtnrCmpny.setCmpnyId(vo.getCmpnyId());
			List<PrtnrCmpnyVO> prtnrCmpnyList = prtnrCmpnyMapper.selectPrtnrCmpnyList(prtnrCmpny);
			vo.setPrtnrCmpnyList(prtnrCmpnyList);
			//prtnrCmpny.setCmpnyId(vo.getPcmapngId());


			//상품구성 목록
			GoodsItemVO goodsItem = new GoodsItemVO();
			goodsItem.setGoodsId(goods.getGoodsId());
			goodsItem.setAdminPageAt(goods.getAdminPageAt());

			List<GoodsItemVO> goodsItemList = goodsItemMapper.selectGoodsItemList(goodsItem);
			List<GoodsItemVO> dGitemList = new ArrayList<GoodsItemVO>();
			List<GoodsItemVO> aGitemList = new ArrayList<GoodsItemVO>();
			List<GoodsItemVO> fGitemList = new ArrayList<GoodsItemVO>();
			List<GoodsItemVO> qGitemList = new ArrayList<GoodsItemVO>();
			List<GoodsItemVO> sGitemList = new ArrayList<GoodsItemVO>();
			for(GoodsItemVO item : goodsItemList) {
				if("D".equals(item.getGitemSeCode())) {
					dGitemList.add(item);
				}else
				if("A".equals(item.getGitemSeCode())) {
					aGitemList.add(item);
				}else if("F".equals(item.getGitemSeCode())) {
					fGitemList.add(item);
				}else if("Q".equals(item.getGitemSeCode())) {
					qGitemList.add(item);
				}else if("S".equals(item.getGitemSeCode())) {
					sGitemList.add(item);
				}
			}
			vo.setdGitemList(dGitemList);
			vo.setaGitemList(aGitemList);
			vo.setfGitemList(fGitemList);
			vo.setqGitemList(qGitemList);
			vo.setsGitemList(sGitemList);

			List<EgovMap> optList = new ArrayList<EgovMap>();
			//vo.setOptnComList(goodsItemMapper.selectOptnComList(goodsItem));
			if(dGitemList.size() != 0 && "Y".equals(vo.getdOptnUseAt())){
				LinkedHashSet<String> tempVal1 = new LinkedHashSet<String>();
				LinkedHashSet<String> tempVal2 = new LinkedHashSet<String>();
				EgovMap ditem1 = new EgovMap();
				EgovMap ditem2 = new EgovMap();
				if(dGitemList.get(0).getGitemTitle() != null){
					for(int i = 0; i< dGitemList.size(); i++){
						if(dGitemList.get(0).getGitemTitle().contains(",")){
							tempVal1.add(dGitemList.get(i).getGitemNm().split(",")[0]);
							tempVal2.add(dGitemList.get(i).getGitemNm().split(",")[1]);
						}else{
							tempVal1.add(dGitemList.get(i).getGitemNm());
						}

						if(i == (dGitemList.size() - 1)){
							if(dGitemList.get(0).getGitemTitle().contains(",")){
								ditem1.put("optnName", dGitemList.get(0).getGitemTitle().split(",")[0]);
								ditem1.put("optnValue", Arrays.toString(tempVal1.toArray()).replace("[", "").replace("]", "").replaceAll(" ", ""));
								optList.add(ditem1);
								ditem2.put("optnName", dGitemList.get(0).getGitemTitle().split(",")[1]);
								ditem2.put("optnValue", Arrays.toString(tempVal2.toArray()).replace("[", "").replace("]", "").replaceAll(" ", ""));
								optList.add(ditem2);
							}else{
								ditem1.put("optnName", dGitemList.get(0).getGitemTitle());
								ditem1.put("optnValue", tempVal1.toString().replace("[", "").replace("]", "").replaceAll(" ", ""));
								optList.add(ditem1);
							}
						}
					}
				}
				vo.setOptnComList(optList);
			}



			/*List<GoodsItemVO> goodsItemList = goodsItemMapper.selectGoodsItemList(goodsItem);
			List<GoodsItemVO> dGitemList = new ArrayList<GoodsItemVO>();
			List<GoodsItemVO> aGitemList = new ArrayList<GoodsItemVO>();
			List<GoodsItemVO> fGitemList = new ArrayList<GoodsItemVO>();
			List<GoodsItemVO> qGitemList = new ArrayList<GoodsItemVO>();
			List<GoodsItemVO> sGitemList = new ArrayList<GoodsItemVO>();
			for(GoodsItemVO item : goodsItemList) {
				if("D".equals(item.getGitemSeCode())) {
				dGitemList.add(item);
			}else if("A".equals(item.getGitemSeCode())) {
				aGitemList.add(item);
			}else if("F".equals(item.getGitemSeCode())) {
				fGitemList.add(item);
			}else if("Q".equals(item.getGitemSeCode())) {
				qGitemList.add(item);
			}else if("S".equals(item.getGitemSeCode())) {
				sGitemList.add(item);
			}
		}
		vo.setdGitemList(dGitemList);
		vo.setaGitemList(aGitemList);
		vo.setfGitemList(fGitemList);
		vo.setqGitemList(qGitemList);
		vo.setsGitemList(sGitemList);*/

			//vo.setGoodsItemList(goodsItemList);

			//옵션 정보 조회
			/*if("Y".equals(vo.getOptnUseAt()) && "Y".equals(vo.getdOptnUseAt())){
				vo.setOptnComList(goodsItemMapper.selectOptnComList(goodsItem));
				vo.setOptnDetailList(goodsItemMapper.selectOptnDetailList(goodsItem));
			}*/

			//라벨 정보
			GoodsLabelVO goodsLabelVO = new GoodsLabelVO();
			goodsLabelVO.setGoodsId(goods.getGoodsId());

			List<GoodsLabelVO> labelList = goodsLabelMapper.selectGoodsLabelList(goodsLabelVO);
			if(labelList.size()>0)vo.setLabelUseAt("Y");
			vo.setGoodsLabelList(labelList);

			//썸네일 메인 라벨
			List<GoodsLabelVO> mainLabelList = labelList.stream()
					.filter(s->s.getLabelMainChk()!=null)
					.filter(s -> s.getLabelMainChk().equals("Y"))
					.collect(Collectors.toList());
			vo.setGoodsMainLabelList(mainLabelList);

			//키워드 목록
			List<GoodsKeywordVO> goodsKeywordList = goodsKeywordMapper.selectGoodsKeywordList(goods);
			vo.setGoodsKeywordList(goodsKeywordList);

			GoodsImageVO goodsImage = new GoodsImageVO();
			goodsImage.setGoodsId(goods.getGoodsId());
			goodsImage.setGoodsImageSeCode("GDC"); // 상품설명이미지
			List<GoodsImageVO> gdcImageList = goodsImageMapper.selectGoodsImageList(goodsImage);
			vo.setGdcImageList(gdcImageList);

			goodsImage.setGoodsImageSeCode("GNR"); // 상품 이미지
			List<GoodsImageVO> goodsImageList = goodsImageMapper.selectGoodsImageList(goodsImage);
			vo.setGoodsImageList(goodsImageList);

			goodsImage.setGoodsImageSeCode("EVT"); // 이벤트 이미지
			List<GoodsImageVO> evtImgList = goodsImageMapper.selectGoodsImageList(goodsImage);
			vo.setEvtImageList(evtImgList);

			//구독 주 주기 목록
			if(StringUtils.isNotEmpty(vo.getSbscrptWeekCycle())) {
				String[] sbscrptWeekCycleArray = vo.getSbscrptWeekCycle().split(",");
				vo.setSbscrptWeekCycleList(Arrays.asList(sbscrptWeekCycleArray));
			}
			//구독 주 배송요일 목록
			if(StringUtils.isNotEmpty(vo.getSbscrptDlvyWd())) {
				String[] sbscrptDlvyWdArray = vo.getSbscrptDlvyWd().split(",");
				vo.setSbscrptDlvyWdList(Arrays.asList(sbscrptDlvyWdArray));
			}
			//구독 월 주기 목록
			if(StringUtils.isNotEmpty(vo.getSbscrptMtCycle())) {
				String[] sbscrptMtCycleArray = vo.getSbscrptMtCycle().split(",");
				vo.setSbscrptMtCycleList(Arrays.asList(sbscrptMtCycleArray));
			}

			// 관련 추천상품(추천상품에서 -> 브랜드 상품으로)
			GoodsRecomendVO goodsRecomend = new GoodsRecomendVO();
			goodsRecomend.setGoodsId(goods.getGoodsId());
			List<GoodsRecomendVO> goodsRecomendList = goodsRecomendMapper.selectGoodsRecomendList(goodsRecomend);
			vo.setGoodsRecomendList(goodsRecomendList);

			/*if(vo.getBrandId()!=null){
				GoodsVO brandGoods = new GoodsVO();
				brandGoods.setSearchGoodsBrandId(vo.getBrandId());
				brandGoods.setSearchPrtnrId(vo.getPrtnrId());
				List<?> goodsRecomendList = goodsMapper.selectGoodsList(brandGoods);
				vo.setBrandGoodsRecomendList(goodsRecomendList);
			}*/
		}

		return vo;
	}

	public List<GoodsVO> selectGoodsCount(EgovMap map) throws Exception {
		List<GoodsVO> voList = goodsMapper.selectChkGoodsList(map);
		if(voList.size() != 0) {
			for(GoodsVO vo : voList){
				GoodsItemVO goodsItem = new GoodsItemVO();
				goodsItem.setGoodsId(vo.getGoodsId());
				goodsItem.setAdminPageAt("Y");
				List<GoodsItemVO> goodsItemList = goodsItemMapper.selectGoodsItemList(goodsItem);
				List<GoodsItemVO> dGitemList = new ArrayList<GoodsItemVO>();
				List<GoodsItemVO> sGitemList = new ArrayList<GoodsItemVO>();
				for(GoodsItemVO item : goodsItemList) {
					if("D".equals(item.getGitemSeCode())) {
						dGitemList.add(item);
					}else if("S".equals(item.getGitemSeCode())) {
						sGitemList.add(item);
					}
				}
				vo.setdGitemList(dGitemList);
				vo.setsGitemList(sGitemList);
			}
		}
		return voList;
	}


	/**
	 * 상품 등록 및 수정 그리고 삭제 처리
	 * @param goods
	 * @param gitemType
	 * @param gitemList
	 * @throws Exception
	 */
	private void insertOrUpdate(GoodsVO goods, String useAt, String gitemType, List<GoodsItemVO> gitemList) throws Exception {
		if("Y".equals(useAt)) {
			// 기본옵션
			for(GoodsItemVO gitem: gitemList) {
				if(StringUtils.isNotEmpty(gitem.getGitemNm())) {
					//임시 강제 처리
					if(StringUtils.isEmpty(gitem.getGitemSttusCode())) gitem.setGitemSttusCode("T"); //재고있음
					gitem.setGitemSeCode(gitemType); //
					if(gitem.getGitemCo() == null) gitem.setGitemCo(0); //갯수
					gitem.setGoodsId(goods.getGoodsId());

					if(StringUtils.isEmpty(gitem.getGitemId())) {
						String gitemId = goodsItemIdGnrService.getNextStringId();
						gitem.setGitemId(gitemId);
						gitem.setFrstRegisterId(goods.getFrstRegisterId());
						goodsItemMapper.insertGoodsItem(gitem);
					}else {
						gitem.setLastUpdusrId(goods.getLastUpdusrId());
						goodsItemMapper.updateGoodsItem(gitem);
					}
				}
			}
		}else {
			GoodsItemVO gitem = new GoodsItemVO();
			gitem.setGoodsId(goods.getGoodsId());
			gitem.setGitemSeCode(gitemType);
			goodsItemMapper.deleteGoodsItemList(gitem);
		}
	}
	/**
	 * 상품 수정
	 */
	@Override
	public void updateGoods(GoodsVO goods, JSONArray optArray) throws Exception {

		if(!"SBS".equals(goods.getGoodsKndCode())){
			goods.setSbscrptWeekCycle(null);
			goods.setSbscrptDlvyWd(null);
			goods.setSbscrptMinUseWeek(null);
			goods.setSbscrptMtCycle(null);
			goods.setSbscrptMinUseMt(null);
			goods.setSbscrptDlvyDay(null);
			goods.setSbscrptCycleSeCode(null);
		}

		if(!"WEEK".equals(goods.getSbscrptCycleSeCode())) {
			goods.setSbscrptWeekCycle(null);
			goods.setSbscrptDlvyWd(null);
			goods.setSbscrptMinUseWeek(null);
		}else if(!"MONTH".equals(goods.getSbscrptCycleSeCode())) {
			goods.setSbscrptMtCycle(null);
			goods.setSbscrptMinUseMt(null);
			goods.setSbscrptDlvyDay(null);
		}

		if("Y".equals(goods.getOptnUseAt())) {
			//insertOrUpdate(goods, goods.getdOptnUseAt(), "D", goods.getdGitemList());
			insertOrUpdate(goods, goods.getaOptnUseAt(), "A", goods.getaGitemList());
			insertOrUpdate(goods, goods.getfOptnUseAt(), "F", goods.getfGitemList());
			insertOrUpdate(goods, goods.getqOptnUseAt(), "Q", goods.getqGitemList());
			insertOrUpdate(goods, goods.getsOptnUseAt(), "S", goods.getsGitemList());


			GoodsItemVO gitem = new GoodsItemVO();
			gitem.setGoodsId(goods.getGoodsId());
			gitem.setGitemSeCode("D");
			goodsItemMapper.deleteGoodsItemList(gitem);
			if("Y".equals(goods.getdOptnUseAt())) { //기본 옵션 사용시 옵션 정보 등록
				insertOptInfo(goods, optArray);
			}


		}else {
			// 전체 삭제처리
			GoodsItemVO gitem = new GoodsItemVO();
			gitem.setGoodsId(goods.getGoodsId());
			goodsItemMapper.deleteGoodsItemList(gitem);
		}




		if("N".equals(goods.getfOptnUseAt())) { //첫구독옵션
			goods.setFrstOptnEssntlAt("N"); //첫구독옵션 필수여부
		}
		if(goods.getFrstOptnEssntlAt() == null) {
			goods.setFrstOptnEssntlAt("N");
		}

		//키춰드 목록 저장
		if(goods.getGoodsKeywordList() != null) {
			for(GoodsKeywordVO goodsKeyword: goods.getGoodsKeywordList()) {
				goodsKeyword.setGoodsId(goods.getGoodsId());
				if(goodsKeyword.getGoodsKeywordNo() == null) {
					java.math.BigDecimal no = goodsKeywordIdGnrService.getNextBigDecimalId();
					goodsKeyword.setGoodsKeywordNo(no);
					goodsKeywordMapper.insertGoodsKeyword(goodsKeyword);
				}else {
					goodsKeywordMapper.updateGoodsKeyword(goodsKeyword);
				}
			}
		}

		GoodsLabelVO deleteLabel = new GoodsLabelVO();
		deleteLabel.setGoodsId(goods.getGoodsId());
		goodsLabelMapper.deleteGoodsLabel(deleteLabel);
		if("Y".equals(goods.getLabelUseAt())&& goods.getGoodsLabelList()!=null){
			for(GoodsLabelVO label : goods.getGoodsLabelList()){
				label.setGoodsId(goods.getGoodsId());
				if(!"IMG".equals(label.getLabelTy()))label.setLabelImgPath(null);
				goodsLabelMapper.insertGoodsLabel(label);
			}
		}

		//상품 설명이미지 저장
		saveGoodsImage(goods.getGoodsId(), goods.getGdcImageList());
		//상품 이미지
		saveGoodsImage(goods.getGoodsId(), goods.getGoodsImageList());
		//이벤트 이미지
		saveGoodsImage(goods.getGoodsId(), goods.getEvtImageList());

		//추천상품
		if(goods.getGoodsRecomendList() != null) {
			for(GoodsRecomendVO recomend : goods.getGoodsRecomendList()) {
				recomend.setGoodsId( goods.getGoodsId() );
				if(recomend.getGoodsRecomendNo() == null) {
					java.math.BigDecimal no = goodsRecomendIdGnrService.getNextBigDecimalId();
					recomend.setGoodsRecomendNo(no);
					if(recomend.getRecomendGoodsSn() == null) recomend.setRecomendGoodsSn(0);
					goodsRecomendMapper.insertGoodsRecomend(recomend);
				}else {
					goodsRecomendMapper.updateGoodsRecomend(recomend);
				}
			}
		}

		//회원전용상품일때
		EgovMap map = new EgovMap();
		map.put("goodsId",goods.getGoodsId());
		goodsMberMapngMapper.deleteGoodsMberMapngList(map);

		if("PRVUSE".equals(goods.getGoodsExpsrCode())){
			List<String> mberList = Arrays.asList((goods.getGoodsMbers().split(",")));
			for(String s : mberList){
				if(StringUtils.isNotEmpty(s)){
					map.put("mberId",s);
					goodsMberMapngMapper.insertGoodsMberMapng(map);
				}
			}
		}

		//판매가격 수수료에 따른 공급가 계산
		if(goods.getGoodsPc().equals(java.math.BigDecimal.ZERO)) {
			goods.setGoodsFeeRate(java.math.BigDecimal.ZERO);
			goods.setGoodsSplpc(java.math.BigDecimal.ZERO);
		}else {
			java.math.BigDecimal goodsSplpc = new java.math.BigDecimal(0); //수수료가 0 이면
			if(goods.getGoodsFeeRate() == null || goods.getGoodsFeeRate().equals(java.math.BigDecimal.ZERO)) {
				goods.setGoodsFeeRate(java.math.BigDecimal.ZERO);
				goodsSplpc = goods.getGoodsPc();
			}else {
				goodsSplpc = goods.getGoodsPc().subtract(goods.getGoodsPc().multiply(goods.getGoodsFeeRate().divide(new java.math.BigDecimal(100))));
			}
			goods.setGoodsSplpc(goodsSplpc);
		}

		goodsMapper.updateGoods(goods);
		//goodsMapper.insertGoodsItemInfo(goods);
	}

	/**
	 * 상품 조회수 증분
	 */
	@Override
	public void updateGoodsRdcnt(GoodsVO goods) throws Exception {
		goodsMapper.updateGoodsRdcnt(goods);
	}

	/**
	 * 상품 카테고리 순서 변경
	 * */
	@Override
	public void updateGoodsCtgrySn(List<GoodsVO> goodsList) throws Exception {

		for(GoodsVO g: goodsList){
			goodsMapper.updateGoodsCtgrySn(g);
		}

	}

	/**
	 * 상품 삭제
	 */
	@Override
	public void deleteGoods(GoodsVO goods) throws Exception {
		goodsMapper.deleteGoods(goods);
	}

	/**
	 * 상품 상태 카운트
	 */
	@Override
	public EgovMap selectGoodsSttusCnt(GoodsVO searchVO) throws Exception {
		return goodsMapper.selectGoodsSttusCnt(searchVO);
	}

	/**
	 * 베스트 상품 목록
	 */
	@Override
	public List<?> selectBestGoodsList(GoodsVO searchVO) throws Exception {
		return goodsMapper.selectBestGoodsList(searchVO);
	}

	/**
	 * 베스트 상품 목록 카운트
	 */
	@Override
	public int selectBestGoodsListCnt(GoodsVO searchVO) throws Exception {
		return goodsMapper.selectBestGoodsListCnt(searchVO);
	}

	/**
	 * 제휴사매핑에 연결된 상품갯수
	 */
	@Override
	public int selectPrtnrCmpnyGoodsListCnt(GoodsVO searchVO) throws Exception {
		return goodsMapper.selectPrtnrCmpnyGoodsListCnt(searchVO);
	}
	/**
	 * 상품 등록 상태 일괄 변경
	 */
	@Override
	public void updateGoodsRegistSttus(GoodsVO goods) {
		goodsMapper.updateGoodsRegistSttus(goods);
	}

	/**
	 * 메인 상품 목록
	 */
	@Override
	public List<?> selectMainGoodsList(GoodsVO searchVO) throws Exception {

		List<?> resultList = goodsMapper.selectMainGoodsList(searchVO);

		for(EgovMap map : (List<EgovMap>)resultList){
			GoodsLabelVO labelVO = new GoodsLabelVO();
			labelVO.setGoodsId(String.valueOf(map.get("goodsId")));
			List<GoodsLabelVO> labelList = goodsLabelMapper.selectGoodsLabelList(labelVO);

			List<GoodsLabelVO> mainLabelList = labelList.stream()
					.filter(s->s.getLabelMainChk()!=null)
					.filter(s -> s.getLabelMainChk().equals("Y"))
							.collect(Collectors.toList());

			labelList = labelList.stream()
					.filter(s->!"Y".equals(s.getLabelMainChk()))
					.collect(Collectors.toList());


			map.put("goodsLabelList",labelList);
			map.put("goodsMainLabelList",mainLabelList);
		};

		return resultList;
	}

	@Override
	public List<?> selectPrvuseGoodsList(String mberId) throws Exception {
		return goodsMapper.selectPrvuseGoodsList(mberId);
	}

	/**
	 * 메인 상품 순서 최대값
	 */
	@Override
	public int selectMainGoodsMaxSn(GoodsVO searchVO) throws Exception {
		return goodsMapper.selectMainGoodsMaxSn(searchVO);
	}

	/**
	 * 메인 상품 목록 카운트
	 */
	@Override
	public int selectMainGoodsListCnt(GoodsVO searchVO) throws Exception {
		return goodsMapper.selectMainGoodsListCnt(searchVO);
	}

	private void insertOptInfo(GoodsVO goods, JSONArray optArray) throws Exception {
		EgovMap tempOPtMap = new EgovMap();
		/*String gOptnId = goodsOptnIdGnrService.getNextStringId();
		goods.setGoptnId(gOptnId);
		goodsItemMapper.insertGoodsOptMaster(goods);

		if(goods.getOptnNames().length != 0){
			List<EgovMap> tempList = new ArrayList<EgovMap>();

			for(int i = 0; i < goods.getOptnNames().length; i++){
				EgovMap tempMap = new EgovMap();
				tempMap.put("optnOrder", i);
				tempMap.put("optnName", goods.getOptnNames()[i]);
				tempMap.put("optnValue", goods.getOptnValues()[i]);
				tempList.add(tempMap);
			}
			tempOPtMap.put("optList", tempList);
			tempOPtMap.put("goodsId", goods.getGoodsId());
			goodsItemMapper.insertGoodsOptCom(tempOPtMap);
		}

		tempOPtMap.clear();*/
		/*if("Y".equals(useAt)) {
			// 기본옵션
			for(GoodsItemVO gitem: gitemList) {
				if(StringUtils.isNotEmpty(gitem.getGitemNm())) {
					//임시 강제 처리
					if(StringUtils.isEmpty(gitem.getGitemSttusCode())) gitem.setGitemSttusCode("T"); //재고있음
					gitem.setGitemSeCode(gitemType); //
					if(gitem.getGitemCo() == null) gitem.setGitemCo(0); //갯수
					gitem.setGoodsId(goods.getGoodsId());

					if(StringUtils.isEmpty(gitem.getGitemId())) {
						String gitemId = goodsItemIdGnrService.getNextStringId();
						gitem.setGitemId(gitemId);
						goodsItemMapper.insertGoodsItem(gitem);
					}else {
						goodsItemMapper.updateGoodsItem(gitem);
					}
				}
			}
		}else {
			GoodsItemVO gitem = new GoodsItemVO();
			gitem.setGoodsId(goods.getGoodsId());
			gitem.setGitemSeCode(gitemType);
			goodsItemMapper.deleteGoodsItemList(gitem);
		}*/


		List<GoodsItemVO> itemList = new ArrayList<GoodsItemVO>();
		//List<EgovMap> itemList = new ArrayList<EgovMap>();
		for(int i = 0; i < optArray.size();i++){
			JSONObject obj = (JSONObject) optArray.get(i);
			System.out.println(">>>>>>>>"+obj.get("optnPc"));
			System.out.println(">>>"+ optArray.get(i).toString());
			if(obj.get("optnPc") == null){
				obj.put("optnPc", 0);
			}
			if(obj.get("optnCo") == null){
				obj.put("optnCo", 0);
			}

			if(obj.get("optnSoldOutAt") == null){
				obj.put("optnSoldOutAt", "N");
			}

			GoodsItemVO itemMap = new GoodsItemVO();
			String gitemId = goodsItemIdGnrService.getNextStringId();
			itemMap.setGitemId(gitemId);
			itemMap.setGoodsId(goods.getGoodsId());
			itemMap.setGitemSn(i);
			itemMap.setGitemSeCode("D");
			itemMap.setFrstRegisterId(goods.getFrstRegisterId());

			itemMap.setGitemTitle(String.join(",", goods.getOptnNames()));
			itemMap.setGitemNm(obj.get("opt1").toString());
			if( obj.get("opt2") != null){
				itemMap.setGitemNm(obj.get("opt1").toString() + "," + obj.get("opt2").toString());
			}else{
				itemMap.setGitemNm(obj.get("opt1").toString());
			}

			if("B".equals(goods.getdOptnType())){
				itemMap.setGitemPc(BigDecimal.valueOf(Integer.parseInt(obj.get("optnPc").toString())));
				itemMap.setGitemCo(Integer.parseInt(obj.get("optnCo").toString()));
			}else{
				itemMap.setGitemCo(0);
			}
			itemMap.setGitemSttusCode("Y".equals(obj.get("optnSoldOutAt").toString())
					|| ("A".equals(goods.getdOptnType()) && obj.get("optnCo").toString()  == "0") ? "F" : "T");

			goodsItemMapper.insertGoodsItem(itemMap);
		}
	}
}
